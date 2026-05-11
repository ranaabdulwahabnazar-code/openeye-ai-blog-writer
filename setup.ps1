# Create all directories
New-Item -ItemType Directory -Force -Path lib
New-Item -ItemType Directory -Force -Path app/api/auth/register
New-Item -ItemType Directory -Force -Path app/api/auth/login
New-Item -ItemType Directory -Force -Path app/api/posts
New-Item -ItemType Directory -Force -Path app/api/ai/generate
New-Item -ItemType Directory -Force -Path app/register
New-Item -ItemType Directory -Force -Path app/login
New-Item -ItemType Directory -Force -Path app/write
New-Item -ItemType Directory -Force -Path app/blog/[id]

# lib/db.ts
@'
import { Pool } from 'pg'
const pool = new Pool({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } })
export default pool
'@ | Set-Content lib/db.ts

# app/api/auth/register/route.ts
@'
import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'
import bcrypt from 'bcryptjs'

export async function POST(request: NextRequest) {
  try {
    const { name, email, password } = await request.json()
    if (!name || !email || !password) return NextResponse.json({ error: 'Sab fields bharo' }, { status: 400 })
    const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email])
    if (existing.rows.length > 0) return NextResponse.json({ error: 'Email pehle se registered hai' }, { status: 400 })
    const hashedPassword = await bcrypt.hash(password, 12)
    const result = await pool.query('INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id, name, email', [name, email, hashedPassword])
    return NextResponse.json({ message: 'Account ban gaya!', user: result.rows[0] })
  } catch (error) {
    return NextResponse.json({ error: 'Kuch gadbad ho gayi' }, { status: 500 })
  }
}
'@ | Set-Content app/api/auth/register/route.ts

# app/api/auth/login/route.ts
@'
import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'
import bcrypt from 'bcryptjs'

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json()
    if (!email || !password) return NextResponse.json({ error: 'Email aur password chahiye' }, { status: 400 })
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email])
    if (result.rows.length === 0) return NextResponse.json({ error: 'Email ya password galat hai' }, { status: 401 })
    const user = result.rows[0]
    const isValid = await bcrypt.compare(password, user.password)
    if (!isValid) return NextResponse.json({ error: 'Email ya password galat hai' }, { status: 401 })
    return NextResponse.json({ message: 'Login ho gaye!', user: { id: user.id, name: user.name, email: user.email } })
  } catch (error) {
    return NextResponse.json({ error: 'Kuch gadbad ho gayi' }, { status: 500 })
  }
}
'@ | Set-Content app/api/auth/login/route.ts

# app/api/posts/route.ts
@'
import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'

export async function GET() {
  try {
    const result = await pool.query('SELECT posts.*, users.name as author_name FROM posts JOIN users ON posts.author_id = users.id WHERE posts.published = true ORDER BY posts.created_at DESC')
    return NextResponse.json(result.rows)
  } catch (error) {
    return NextResponse.json({ error: 'Posts nahi mile' }, { status: 500 })
  }
}

export async function POST(request: NextRequest) {
  try {
    const { title, content, authorId, aiGenerated, published } = await request.json()
    if (!title || !content || !authorId) return NextResponse.json({ error: 'Title, content aur authorId chahiye' }, { status: 400 })
    const result = await pool.query('INSERT INTO posts (title, content, author_id, ai_generated, published) VALUES ($1, $2, $3, $4, $5) RETURNING *', [title, content, authorId, aiGenerated || false, published || false])
    return NextResponse.json(result.rows[0])
  } catch (error) {
    return NextResponse.json({ error: 'Post save nahi hua' }, { status: 500 })
  }
}
'@ | Set-Content app/api/posts/route.ts

# app/api/ai/generate/route.ts
@'
import { NextRequest, NextResponse } from 'next/server'
import Anthropic from '@anthropic-ai/sdk'

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

export async function POST(request: NextRequest) {
  try {
    const { topic, tone, length } = await request.json()
    if (!topic) return NextResponse.json({ error: 'Topic dena zaroori hai' }, { status: 400 })
    const wordCount = length === 'short' ? '300' : length === 'long' ? '1000' : '600'
    const message = await client.messages.create({
      model: 'claude-opus-4-5',
      max_tokens: 2000,
      messages: [{ role: 'user', content: `Ek blog post likho is topic par: "${topic}"\nTone: ${tone || 'professional'}\nLength: ${wordCount} words\nFormat: Title, Introduction, 3-4 sections with headings, Conclusion\nSirf blog content likho.` }]
    })
    const content = message.content[0].type === 'text' ? message.content[0].text : ''
    return NextResponse.json({ content })
  } catch (error) {
    return NextResponse.json({ error: 'AI content generate nahi hua' }, { status: 500 })
  }
}
'@ | Set-Content app/api/ai/generate/route.ts

# app/layout.tsx
@'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'AI Blog Writer',
  description: 'AI se blog likhne ka platform',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <nav style={{ backgroundColor: '#1e293b', padding: '1rem 2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <a href="/" style={{ color: 'white', fontWeight: 'bold', fontSize: '1.25rem', textDecoration: 'none' }}>✍️ AI Blog Writer</a>
          <div style={{ display: 'flex', gap: '1rem' }}>
            <a href="/blog" style={{ color: '#94a3b8', textDecoration: 'none' }}>Blog</a>
            <a href="/write" style={{ color: '#94a3b8', textDecoration: 'none' }}>Likho</a>
            <a href="/login" style={{ color: '#94a3b8', textDecoration: 'none' }}>Login</a>
            <a href="/register" style={{ color: 'white', backgroundColor: '#6366f1', padding: '0.4rem 1rem', borderRadius: '6px', textDecoration: 'none' }}>Register</a>
          </div>
        </nav>
        <main style={{ minHeight: 'calc(100vh - 64px)' }}>{children}</main>
      </body>
    </html>
  )
}
'@ | Set-Content app/layout.tsx

# app/page.tsx
@'
export default function Home() {
  return (
    <div style={{ maxWidth: '800px', margin: '0 auto', padding: '4rem 2rem', textAlign: 'center' }}>
      <h1 style={{ fontSize: '3rem', fontWeight: 'bold', color: '#1e293b', marginBottom: '1rem' }}>AI se Blog Likhna Ab Asaan Hai</h1>
      <p style={{ fontSize: '1.25rem', color: '#64748b', marginBottom: '2rem', lineHeight: '1.8' }}>Apna topic do — Claude AI poora blog likh dega.</p>
      <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center' }}>
        <a href="/write" style={{ backgroundColor: '#6366f1', color: 'white', padding: '0.75rem 2rem', borderRadius: '8px', textDecoration: 'none', fontSize: '1.1rem' }}>Likhna Shuru Karo</a>
        <a href="/blog" style={{ backgroundColor: 'white', color: '#1e293b', padding: '0.75rem 2rem', borderRadius: '8px', textDecoration: 'none', fontSize: '1.1rem', border: '1px solid #e2e8f0' }}>Blogs Dekho</a>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1.5rem', marginTop: '4rem' }}>
        <div style={{ backgroundColor: 'white', padding: '1.5rem', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
          <div style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>🤖</div>
          <h3 style={{ fontWeight: '600', marginBottom: '0.5rem' }}>AI Content</h3>
          <p style={{ color: '#64748b', fontSize: '0.9rem' }}>Claude AI aapke liye professional blog likhta hai</p>
        </div>
        <div style={{ backgroundColor: 'white', padding: '1.5rem', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
          <div style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>💾</div>
          <h3 style={{ fontWeight: '600', marginBottom: '0.5rem' }}>Database</h3>
          <p style={{ color: '#64748b', fontSize: '0.9rem' }}>Sab posts PostgreSQL mein save hote hain</p>
        </div>
        <div style={{ backgroundColor: 'white', padding: '1.5rem', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
          <div style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>✏️</div>
          <h3 style={{ fontWeight: '600', marginBottom: '0.5rem' }}>Edit Karo</h3>
          <p style={{ color: '#64748b', fontSize: '0.9rem' }}>AI ke content ko apne hisaab se edit karo</p>
        </div>
      </div>
    </div>
  )
}
'@ | Set-Content app/page.tsx

# app/register/page.tsx
@'
"use client"
import { useState } from "react"
import { useRouter } from "next/navigation"

export default function RegisterPage() {
  const router = useRouter()
  const [form, setForm] = useState({ name: "", email: "", password: "" })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState("")

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError("")
    try {
      const res = await fetch("/api/auth/register", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(form) })
      const data = await res.json()
      if (!res.ok) { setError(data.error); return }
      alert("Account ban gaya! Ab login karo.")
      router.push("/login")
    } catch { setError("Kuch gadbad ho gayi") } finally { setLoading(false) }
  }

  return (
    <div style={{ display: "flex", justifyContent: "center", alignItems: "center", minHeight: "80vh" }}>
      <div style={{ backgroundColor: "white", padding: "2rem", borderRadius: "12px", border: "1px solid #e2e8f0", width: "100%", maxWidth: "400px" }}>
        <h1 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1.5rem" }}>Account Banao</h1>
        {error && <div style={{ backgroundColor: "#fee2e2", color: "#dc2626", padding: "0.75rem", borderRadius: "8px", marginBottom: "1rem" }}>{error}</div>}
        <form onSubmit={handleSubmit}>
          <div style={{ marginBottom: "1rem" }}>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500" }}>Naam</label>
            <input type="text" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} required style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem" }} />
          </div>
          <div style={{ marginBottom: "1rem" }}>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500" }}>Email</label>
            <input type="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} required style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem" }} />
          </div>
          <div style={{ marginBottom: "1.5rem" }}>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500" }}>Password</label>
            <input type="password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} required style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem" }} />
          </div>
          <button type="submit" disabled={loading} style={{ width: "100%", padding: "0.75rem", backgroundColor: loading ? "#a5b4fc" : "#6366f1", color: "white", border: "none", borderRadius: "8px", fontSize: "1rem", cursor: loading ? "not-allowed" : "pointer" }}>
            {loading ? "Ban raha hai..." : "Account Banao"}
          </button>
        </form>
        <p style={{ textAlign: "center", marginTop: "1rem", color: "#64748b", fontSize: "0.9rem" }}>Pehle se account hai? <a href="/login" style={{ color: "#6366f1", textDecoration: "none" }}>Login karo</a></p>
      </div>
    </div>
  )
}
'@ | Set-Content app/register/page.tsx

# app/login/page.tsx
@'
"use client"
import { useState } from "react"
import { useRouter } from "next/navigation"

export default function LoginPage() {
  const router = useRouter()
  const [form, setForm] = useState({ email: "", password: "" })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState("")

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError("")
    try {
      const res = await fetch("/api/auth/login", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(form) })
      const data = await res.json()
      if (!res.ok) { setError(data.error); return }
      localStorage.setItem("user", JSON.stringify(data.user))
      router.push("/write")
    } catch { setError("Kuch gadbad ho gayi") } finally { setLoading(false) }
  }

  return (
    <div style={{ display: "flex", justifyContent: "center", alignItems: "center", minHeight: "80vh" }}>
      <div style={{ backgroundColor: "white", padding: "2rem", borderRadius: "12px", border: "1px solid #e2e8f0", width: "100%", maxWidth: "400px" }}>
        <h1 style={{ fontSize: "1.5rem", fontWeight: "bold", marginBottom: "1.5rem" }}>Login Karo</h1>
        {error && <div style={{ backgroundColor: "#fee2e2", color: "#dc2626", padding: "0.75rem", borderRadius: "8px", marginBottom: "1rem" }}>{error}</div>}
        <form onSubmit={handleSubmit}>
          <div style={{ marginBottom: "1rem" }}>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500" }}>Email</label>
            <input type="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} required style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem" }} />
          </div>
          <div style={{ marginBottom: "1.5rem" }}>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500" }}>Password</label>
            <input type="password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} required style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem" }} />
          </div>
          <button type="submit" disabled={loading} style={{ width: "100%", padding: "0.75rem", backgroundColor: loading ? "#a5b4fc" : "#6366f1", color: "white", border: "none", borderRadius: "8px", fontSize: "1rem", cursor: loading ? "not-allowed" : "pointer" }}>
            {loading ? "Login ho raha hai..." : "Login Karo"}
          </button>
        </form>
        <p style={{ textAlign: "center", marginTop: "1rem", color: "#64748b", fontSize: "0.9rem" }}>Account nahi hai? <a href="/register" style={{ color: "#6366f1", textDecoration: "none" }}>Banao</a></p>
      </div>
    </div>
  )
}
'@ | Set-Content app/login/page.tsx

# app/write/page.tsx
@'
"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"

export default function WritePage() {
  const router = useRouter()
  const [user, setUser] = useState<{ id: string; name: string } | null>(null)
  const [topic, setTopic] = useState("")
  const [tone, setTone] = useState("professional")
  const [length, setLength] = useState("medium")
  const [title, setTitle] = useState("")
  const [content, setContent] = useState("")
  const [generating, setGenerating] = useState(false)
  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState("")

  useEffect(() => {
    const savedUser = localStorage.getItem("user")
    if (!savedUser) { router.push("/login"); return }
    setUser(JSON.parse(savedUser))
  }, [router])

  const generateContent = async () => {
    if (!topic.trim()) { setMessage("Topic zaroor likho!"); return }
    setGenerating(true)
    setMessage("")
    try {
      const res = await fetch("/api/ai/generate", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ topic, tone, length }) })
      const data = await res.json()
      if (!res.ok) { setMessage("Error: " + data.error); return }
      setContent(data.content)
      if (!title) setTitle(topic)
      setMessage("AI ne content likh diya! Ab edit kar sakte ho.")
    } catch { setMessage("AI se connect nahi hua.") } finally { setGenerating(false) }
  }

  const savePost = async (publish: boolean) => {
    if (!title.trim() || !content.trim()) { setMessage("Title aur content chahiye!"); return }
    if (!user) { router.push("/login"); return }
    setSaving(true)
    setMessage("")
    try {
      const res = await fetch("/api/posts", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ title, content, authorId: user.id, aiGenerated: true, published: publish }) })
      const data = await res.json()
      if (!res.ok) { setMessage("Error: " + data.error); return }
      setMessage(publish ? "Post publish ho gayi!" : "Draft save ho gaya!")
      if (publish) setTimeout(() => router.push("/blog"), 1500)
    } catch { setMessage("Save nahi hua.") } finally { setSaving(false) }
  }

  if (!user) return null

  return (
    <div style={{ maxWidth: "900px", margin: "0 auto", padding: "2rem" }}>
      <h1 style={{ fontSize: "2rem", fontWeight: "bold", marginBottom: "0.5rem" }}>✍️ AI Blog Writer</h1>
      <p style={{ color: "#64748b", marginBottom: "2rem" }}>Namaste {user.name}! Topic do, AI likhega.</p>
      <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem", marginBottom: "1.5rem" }}>
        <h2 style={{ fontWeight: "600", marginBottom: "1rem" }}>🤖 AI se Content Generate Karo</h2>
        <input value={topic} onChange={(e) => setTopic(e.target.value)} placeholder="Topic likho..." style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem", marginBottom: "1rem" }} />
        <div style={{ display: "flex", gap: "1rem", marginBottom: "1rem" }}>
          <select value={tone} onChange={(e) => setTone(e.target.value)} style={{ flex: 1, padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem", backgroundColor: "white" }}>
            <option value="professional">Professional</option>
            <option value="casual">Casual</option>
            <option value="informative">Informative</option>
            <option value="motivational">Motivational</option>
          </select>
          <select value={length} onChange={(e) => setLength(e.target.value)} style={{ flex: 1, padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem", backgroundColor: "white" }}>
            <option value="short">Short (~300 words)</option>
            <option value="medium">Medium (~600 words)</option>
            <option value="long">Long (~1000 words)</option>
          </select>
        </div>
        <button onClick={generateContent} disabled={generating} style={{ padding: "0.75rem 1.5rem", backgroundColor: generating ? "#a5b4fc" : "#6366f1", color: "white", border: "none", borderRadius: "8px", fontSize: "1rem", cursor: generating ? "not-allowed" : "pointer" }}>
          {generating ? "⏳ AI Likh Raha Hai..." : "🚀 AI se Likhwao"}
        </button>
      </div>
      {message && <div style={{ padding: "0.75rem", borderRadius: "8px", marginBottom: "1rem", backgroundColor: message.includes("Error") ? "#fee2e2" : "#dcfce7", color: message.includes("Error") ? "#dc2626" : "#16a34a" }}>{message}</div>}
      <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem", marginBottom: "1.5rem" }}>
        <h2 style={{ fontWeight: "600", marginBottom: "1rem" }}>📝 Editor</h2>
        <input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Blog ka title..." style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1.1rem", marginBottom: "1rem", fontWeight: "500" }} />
        <textarea value={content} onChange={(e) => setContent(e.target.value)} placeholder="Yahan likho ya AI se generate karo..." rows={20} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", resize: "vertical", lineHeight: "1.6", fontFamily: "inherit" }} />
      </div>
      <div style={{ display: "flex", gap: "1rem" }}>
        <button onClick={() => savePost(false)} disabled={saving} style={{ padding: "0.75rem 1.5rem", backgroundColor: "white", color: "#1e293b", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem", cursor: saving ? "not-allowed" : "pointer" }}>💾 Draft Save Karo</button>
        <button onClick={() => savePost(true)} disabled={saving} style={{ padding: "0.75rem 1.5rem", backgroundColor: saving ? "#86efac" : "#16a34a", color: "white", border: "none", borderRadius: "8px", fontSize: "1rem", cursor: saving ? "not-allowed" : "pointer" }}>🌍 Publish Karo</button>
      </div>
    </div>
  )
}
'@ | Set-Content app/write/page.tsx

# app/blog/page.tsx
@'
import Link from "next/link"
import pool from "@/lib/db"

export default async function BlogPage() {
  const result = await pool.query("SELECT posts.*, users.name as author_name FROM posts JOIN users ON posts.author_id = users.id WHERE posts.published = true ORDER BY posts.created_at DESC")
  const posts = result.rows

  return (
    <div style={{ maxWidth: "800px", margin: "0 auto", padding: "2rem" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "2rem" }}>
        <h1 style={{ fontSize: "2rem", fontWeight: "bold" }}>📚 Sab Blog Posts</h1>
        <Link href="/write" style={{ backgroundColor: "#6366f1", color: "white", padding: "0.6rem 1.2rem", borderRadius: "8px", textDecoration: "none" }}>+ Naya Post</Link>
      </div>
      {posts.length === 0 ? (
        <div style={{ textAlign: "center", padding: "4rem", color: "#64748b" }}>
          <div style={{ fontSize: "3rem", marginBottom: "1rem" }}>📝</div>
          <p>Abhi koi post nahi.</p>
          <Link href="/write" style={{ color: "#6366f1" }}>Pehla post likho!</Link>
        </div>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
          {posts.map((post: any) => (
            <Link key={post.id} href={`/blog/${post.id}`} style={{ textDecoration: "none" }}>
              <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "0.5rem" }}>
                  <h2 style={{ fontSize: "1.25rem", fontWeight: "600", color: "#1e293b" }}>{post.title}</h2>
                  {post.ai_generated && <span style={{ backgroundColor: "#ede9fe", color: "#6366f1", padding: "0.2rem 0.6rem", borderRadius: "20px", fontSize: "0.75rem", whiteSpace: "nowrap", marginLeft: "1rem" }}>🤖 AI</span>}
                </div>
                <p style={{ color: "#64748b", fontSize: "0.85rem", marginBottom: "0.75rem" }}>By {post.author_name} • {new Date(post.created_at).toLocaleDateString()}</p>
                <p style={{ color: "#475569", fontSize: "0.95rem", lineHeight: "1.6" }}>{post.content.substring(0, 150)}...</p>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
'@ | Set-Content app/blog/page.tsx

# app/blog/[id]/page.tsx
@'
import pool from "@/lib/db"
import { notFound } from "next/navigation"
import Link from "next/link"

export default async function PostPage({ params }: { params: { id: string } }) {
  const result = await pool.query("SELECT posts.*, users.name as author_name FROM posts JOIN users ON posts.author_id = users.id WHERE posts.id = $1", [params.id])
  if (result.rows.length === 0) notFound()
  const post = result.rows[0]

  return (
    <div style={{ maxWidth: "750px", margin: "0 auto", padding: "2rem" }}>
      <Link href="/blog" style={{ color: "#6366f1", textDecoration: "none", display: "inline-block", marginBottom: "2rem" }}>← Wapas Jao</Link>
      {post.ai_generated && <span style={{ backgroundColor: "#ede9fe", color: "#6366f1", padding: "0.2rem 0.6rem", borderRadius: "20px", fontSize: "0.8rem", display: "inline-block", marginBottom: "1rem" }}>🤖 AI Generated</span>}
      <h1 style={{ fontSize: "2.5rem", fontWeight: "bold", color: "#1e293b", marginBottom: "1rem", lineHeight: "1.3" }}>{post.title}</h1>
      <p style={{ color: "#64748b", fontSize: "0.9rem", marginBottom: "2rem", paddingBottom: "1rem", borderBottom: "1px solid #e2e8f0" }}>By <strong>{post.author_name}</strong> • {new Date(post.created_at).toLocaleDateString()}</p>
      <div style={{ lineHeight: "1.9", fontSize: "1.05rem", color: "#334155", whiteSpace: "pre-wrap" }}>{post.content}</div>
    </div>
  )
}
'@ | Set-Content "app/blog/[id]/page.tsx"

Write-Host "✅ Sab files ban gayi! Ab npm run dev chalao." -ForegroundColor Green