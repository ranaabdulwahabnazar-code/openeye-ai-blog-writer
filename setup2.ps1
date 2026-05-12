# app/layout.tsx
@'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'OpenEye AI Blog Writer',
  description: 'AI-powered blog writing platform by OpenEye',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <nav style={{ backgroundColor: '#0f172a', padding: '1rem 2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderBottom: '1px solid #1e293b' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <span style={{ fontSize: '1.5rem' }}>👁️</span>
            <div>
              <span style={{ color: 'white', fontWeight: 'bold', fontSize: '1.1rem' }}>OpenEye</span>
              <span style={{ color: '#6366f1', fontWeight: 'bold', fontSize: '1.1rem' }}> AI Blog Writer</span>
            </div>
          </div>
          <div style={{ display: 'flex', gap: '1.5rem', alignItems: 'center' }}>
            <a href="/" style={{ color: '#94a3b8', textDecoration: 'none', fontSize: '0.95rem' }}>Home</a>
            <a href="/blog" style={{ color: '#94a3b8', textDecoration: 'none', fontSize: '0.95rem' }}>Blogs</a>
            <a href="/write" style={{ color: '#94a3b8', textDecoration: 'none', fontSize: '0.95rem' }}>Write</a>
            <a href="/login" style={{ color: '#94a3b8', textDecoration: 'none', fontSize: '0.95rem' }}>Login</a>
            <a href="/register" style={{ color: 'white', backgroundColor: '#6366f1', padding: '0.4rem 1rem', borderRadius: '6px', textDecoration: 'none', fontSize: '0.95rem' }}>Sign Up</a>
          </div>
        </nav>
        <main style={{ minHeight: 'calc(100vh - 120px)' }}>{children}</main>
        <footer style={{ backgroundColor: '#0f172a', borderTop: '1px solid #1e293b', padding: '1.5rem 2rem', textAlign: 'center' }}>
          <p style={{ color: '#475569', fontSize: '0.85rem', margin: 0 }}>
            © 2025 <span style={{ color: '#6366f1' }}>OpenEye AI Blog Writer</span> — Developed by <span style={{ color: 'white' }}>Rana Abdul Wahab Nazar</span>
          </p>
        </footer>
      </body>
    </html>
  )
}
'@ | Set-Content app/layout.tsx

# app/page.tsx
@'
export default function Home() {
  return (
    <div>
      <div style={{ background: 'linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%)', padding: '5rem 2rem', textAlign: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.75rem', marginBottom: '1.5rem' }}>
          <span style={{ fontSize: '3rem' }}>👁️</span>
          <h1 style={{ fontSize: '3rem', fontWeight: 'bold', color: 'white', margin: 0 }}>
            OpenEye <span style={{ color: '#6366f1' }}>AI Blog Writer</span>
          </h1>
        </div>
        <p style={{ fontSize: '1.25rem', color: '#94a3b8', marginBottom: '0.5rem' }}>Write stunning blogs in 10 languages with the power of AI</p>
        <p style={{ fontSize: '0.9rem', color: '#475569', marginBottom: '2.5rem' }}>by Rana Abdul Wahab Nazar</p>
        <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
          <a href="/write" style={{ backgroundColor: '#6366f1', color: 'white', padding: '0.85rem 2rem', borderRadius: '8px', textDecoration: 'none', fontSize: '1.1rem', fontWeight: '600' }}>Start Writing Free</a>
          <a href="/blog" style={{ backgroundColor: 'transparent', color: 'white', padding: '0.85rem 2rem', borderRadius: '8px', textDecoration: 'none', fontSize: '1.1rem', border: '1px solid #334155' }}>Read Blogs</a>
        </div>
      </div>

      <div style={{ maxWidth: '1100px', margin: '0 auto', padding: '4rem 2rem' }}>
        <h2 style={{ textAlign: 'center', fontSize: '2rem', fontWeight: 'bold', marginBottom: '3rem', color: '#1e293b' }}>Why OpenEye AI Blog Writer?</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '1.5rem' }}>
          {[
            { icon: '🤖', title: 'AI-Powered Writing', desc: 'Groq AI writes professional blogs in seconds on any topic' },
            { icon: '🌍', title: '10 Languages', desc: 'Write in English, Urdu, Hindi, Arabic, French, Spanish, German, Chinese, Japanese, Turkish' },
            { icon: '💾', title: 'Auto Save', desc: 'Your blogs are saved securely in PostgreSQL database' },
            { icon: '📂', title: 'Categories', desc: 'Organize blogs by Tech, Health, Business, Sports, Education' },
            { icon: '✏️', title: 'Edit Anytime', desc: 'Edit and update your published blogs anytime' },
            { icon: '🚀', title: 'Publish Instantly', desc: 'One click to publish your blog to the world' },
          ].map((f, i) => (
            <div key={i} style={{ backgroundColor: 'white', padding: '1.5rem', borderRadius: '12px', border: '1px solid #e2e8f0', textAlign: 'center' }}>
              <div style={{ fontSize: '2.5rem', marginBottom: '0.75rem' }}>{f.icon}</div>
              <h3 style={{ fontWeight: '600', marginBottom: '0.5rem', color: '#1e293b' }}>{f.title}</h3>
              <p style={{ color: '#64748b', fontSize: '0.9rem', lineHeight: '1.6' }}>{f.desc}</p>
            </div>
          ))}
        </div>
      </div>

      <div style={{ backgroundColor: '#f8fafc', padding: '3rem 2rem', textAlign: 'center' }}>
        <h2 style={{ fontSize: '1.75rem', fontWeight: 'bold', marginBottom: '1rem', color: '#1e293b' }}>Ready to write your first AI blog?</h2>
        <a href="/register" style={{ backgroundColor: '#6366f1', color: 'white', padding: '0.85rem 2.5rem', borderRadius: '8px', textDecoration: 'none', fontSize: '1.1rem', fontWeight: '600' }}>Get Started Free</a>
      </div>
    </div>
  )
}
'@ | Set-Content app/page.tsx

# app/write/page.tsx - with 10 languages and categories
@'
"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"

const LANGUAGES = [
  { code: "english", label: "English" },
  { code: "urdu", label: "Urdu (اردو)" },
  { code: "hindi", label: "Hindi (हिंदी)" },
  { code: "arabic", label: "Arabic (العربية)" },
  { code: "french", label: "French (Français)" },
  { code: "spanish", label: "Spanish (Español)" },
  { code: "german", label: "German (Deutsch)" },
  { code: "chinese", label: "Chinese (中文)" },
  { code: "japanese", label: "Japanese (日本語)" },
  { code: "turkish", label: "Turkish (Türkçe)" },
]

const CATEGORIES = ["Technology", "Health", "Business", "Sports", "Education", "Lifestyle", "Science", "Politics"]

export default function WritePage() {
  const router = useRouter()
  const [user, setUser] = useState<{ id: string; name: string } | null>(null)
  const [topic, setTopic] = useState("")
  const [tone, setTone] = useState("professional")
  const [length, setLength] = useState("medium")
  const [language, setLanguage] = useState("english")
  const [category, setCategory] = useState("Technology")
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
    if (!topic.trim()) { setMessage("Please enter a topic first!"); return }
    setGenerating(true)
    setMessage("")
    try {
      const res = await fetch("/api/ai/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ topic, tone, length, language })
      })
      const data = await res.json()
      if (!res.ok) { setMessage("Error: " + data.error); return }
      setContent(data.content)
      if (!title) setTitle(topic)
      setMessage("AI has written your blog! You can edit it now.")
    } catch { setMessage("Could not connect to AI. Please try again.") }
    finally { setGenerating(false) }
  }

  const savePost = async (publish: boolean) => {
    if (!title.trim() || !content.trim()) { setMessage("Title and content are required!"); return }
    if (!user) { router.push("/login"); return }
    setSaving(true)
    setMessage("")
    try {
      const res = await fetch("/api/posts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title, content, authorId: user.id, aiGenerated: true, published: publish, category, language })
      })
      const data = await res.json()
      if (!res.ok) { setMessage("Error: " + data.error); return }
      setMessage(publish ? "Blog published successfully!" : "Draft saved successfully!")
      if (publish) setTimeout(() => router.push("/blog"), 1500)
    } catch { setMessage("Could not save. Please try again.") }
    finally { setSaving(false) }
  }

  const copyContent = () => {
    navigator.clipboard.writeText(content)
    setMessage("Content copied to clipboard!")
  }

  if (!user) return null

  return (
    <div style={{ maxWidth: "960px", margin: "0 auto", padding: "2rem" }}>
      <div style={{ marginBottom: "2rem" }}>
        <h1 style={{ fontSize: "2rem", fontWeight: "bold", color: "#1e293b", marginBottom: "0.25rem" }}>✍️ AI Blog Writer</h1>
        <p style={{ color: "#64748b" }}>Welcome, {user.name}! Enter a topic and let AI write for you.</p>
      </div>

      <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem", marginBottom: "1.5rem" }}>
        <h2 style={{ fontWeight: "600", marginBottom: "1rem", color: "#1e293b" }}>🤖 AI Content Generator</h2>

        <div style={{ marginBottom: "1rem" }}>
          <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500", color: "#374151" }}>Blog Topic *</label>
          <input value={topic} onChange={(e) => setTopic(e.target.value)} placeholder="e.g. The Future of AI in Pakistan, Benefits of Exercise..." style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem" }} />
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(180px, 1fr))", gap: "1rem", marginBottom: "1rem" }}>
          <div>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500", color: "#374151" }}>Language</label>
            <select value={language} onChange={(e) => setLanguage(e.target.value)} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", backgroundColor: "white" }}>
              {LANGUAGES.map(l => <option key={l.code} value={l.code}>{l.label}</option>)}
            </select>
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500", color: "#374151" }}>Category</label>
            <select value={category} onChange={(e) => setCategory(e.target.value)} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", backgroundColor: "white" }}>
              {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500", color: "#374151" }}>Tone</label>
            <select value={tone} onChange={(e) => setTone(e.target.value)} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", backgroundColor: "white" }}>
              <option value="professional">Professional</option>
              <option value="casual">Casual</option>
              <option value="informative">Informative</option>
              <option value="motivational">Motivational</option>
              <option value="humorous">Humorous</option>
            </select>
          </div>
          <div>
            <label style={{ display: "block", marginBottom: "0.5rem", fontWeight: "500", color: "#374151" }}>Length</label>
            <select value={length} onChange={(e) => setLength(e.target.value)} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", backgroundColor: "white" }}>
              <option value="short">Short (~300 words)</option>
              <option value="medium">Medium (~600 words)</option>
              <option value="long">Long (~1000 words)</option>
            </select>
          </div>
        </div>

        <button onClick={generateContent} disabled={generating} style={{ padding: "0.75rem 2rem", backgroundColor: generating ? "#a5b4fc" : "#6366f1", color: "white", border: "none", borderRadius: "8px", fontSize: "1rem", fontWeight: "600", cursor: generating ? "not-allowed" : "pointer" }}>
          {generating ? "⏳ AI is Writing..." : "🚀 Generate with AI"}
        </button>
      </div>

      {message && (
        <div style={{ padding: "0.75rem 1rem", borderRadius: "8px", marginBottom: "1rem", backgroundColor: message.includes("Error") || message.includes("Could not") ? "#fee2e2" : "#dcfce7", color: message.includes("Error") || message.includes("Could not") ? "#dc2626" : "#16a34a", fontSize: "0.9rem" }}>
          {message}
        </div>
      )}

      <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem", marginBottom: "1.5rem" }}>
        <h2 style={{ fontWeight: "600", marginBottom: "1rem", color: "#1e293b" }}>📝 Editor</h2>
        <input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Blog title..." style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1.15rem", marginBottom: "1rem", fontWeight: "600" }} />
        <textarea value={content} onChange={(e) => setContent(e.target.value)} placeholder="Your blog content will appear here after AI generation. You can also write manually..." rows={22} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", resize: "vertical", lineHeight: "1.7", fontFamily: "inherit" }} />
      </div>

      <div style={{ display: "flex", gap: "1rem", flexWrap: "wrap" }}>
        <button onClick={copyContent} disabled={!content} style={{ padding: "0.75rem 1.5rem", backgroundColor: "white", color: "#1e293b", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", cursor: content ? "pointer" : "not-allowed" }}>📋 Copy Content</button>
        <button onClick={() => savePost(false)} disabled={saving} style={{ padding: "0.75rem 1.5rem", backgroundColor: "white", color: "#1e293b", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", cursor: saving ? "not-allowed" : "pointer" }}>💾 Save Draft</button>
        <button onClick={() => savePost(true)} disabled={saving} style={{ padding: "0.75rem 1.5rem", backgroundColor: saving ? "#86efac" : "#16a34a", color: "white", border: "none", borderRadius: "8px", fontSize: "0.95rem", fontWeight: "600", cursor: saving ? "not-allowed" : "pointer" }}>🌍 Publish Blog</button>
      </div>
    </div>
  )
}
'@ | Set-Content app/write/page.tsx

# app/api/ai/generate/route.ts - with language support
@'
import { NextRequest, NextResponse } from "next/server"
import Groq from "groq-sdk"

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY })

export async function POST(request: NextRequest) {
  try {
    const { topic, tone, length, language } = await request.json()
    if (!topic) return NextResponse.json({ error: "Topic is required" }, { status: 400 })

    const wordCount = length === "short" ? "300" : length === "long" ? "1000" : "600"

    const languageInstruction = language && language !== "english"
      ? `Write the entire blog post in ${language} language.`
      : "Write in English."

    const completion = await groq.chat.completions.create({
      model: "llama-3.3-70b-versatile",
      messages: [{
        role: "user",
        content: `Write a blog post about: "${topic}"
${languageInstruction}
Tone: ${tone || "professional"}
Length: approximately ${wordCount} words
Format: Start with a title, then introduction, 3-4 sections with headings, then conclusion.
Write only the blog content, nothing else.`
      }],
      max_tokens: 2000
    })

    const content = completion.choices[0].message.content || ""
    return NextResponse.json({ content })

  } catch (error) {
    return NextResponse.json({ error: "AI content generation failed" }, { status: 500 })
  }
}
'@ | Set-Content app/api/ai/generate/route.ts

# Update posts API to support category and language
@'
import { NextRequest, NextResponse } from "next/server"
import pool from "@/lib/db"

export async function GET() {
  try {
    const result = await pool.query("SELECT posts.*, users.name as author_name FROM posts JOIN users ON posts.author_id = users.id WHERE posts.published = true ORDER BY posts.created_at DESC")
    return NextResponse.json(result.rows)
  } catch (error) {
    return NextResponse.json({ error: "Could not fetch posts" }, { status: 500 })
  }
}

export async function POST(request: NextRequest) {
  try {
    const { title, content, authorId, aiGenerated, published, category, language } = await request.json()
    if (!title || !content || !authorId) return NextResponse.json({ error: "Title, content and authorId are required" }, { status: 400 })
    const result = await pool.query(
      "INSERT INTO posts (title, content, author_id, ai_generated, published, category, language) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *",
      [title, content, authorId, aiGenerated || false, published || false, category || "General", language || "english"]
    )
    return NextResponse.json(result.rows[0])
  } catch (error) {
    return NextResponse.json({ error: "Could not save post" }, { status: 500 })
  }
}
'@ | Set-Content app/api/posts/route.ts

# app/blog/page.tsx - updated with categories filter
@'
"use client"
import { useState, useEffect } from "react"
import Link from "next/link"

const CATEGORIES = ["All", "Technology", "Health", "Business", "Sports", "Education", "Lifestyle", "Science", "Politics"]

export default function BlogPage() {
  const [posts, setPosts] = useState<any[]>([])
  const [filtered, setFiltered] = useState<any[]>([])
  const [activeCategory, setActiveCategory] = useState("All")
  const [search, setSearch] = useState("")
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetch("/api/posts").then(r => r.json()).then(data => { setPosts(data); setFiltered(data); setLoading(false) })
  }, [])

  useEffect(() => {
    let result = posts
    if (activeCategory !== "All") result = result.filter((p: any) => p.category === activeCategory)
    if (search) result = result.filter((p: any) => p.title.toLowerCase().includes(search.toLowerCase()))
    setFiltered(result)
  }, [activeCategory, search, posts])

  const readingTime = (content: string) => Math.max(1, Math.ceil(content.split(" ").length / 200))

  return (
    <div style={{ maxWidth: "1000px", margin: "0 auto", padding: "2rem" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "1.5rem" }}>
        <h1 style={{ fontSize: "2rem", fontWeight: "bold", color: "#1e293b" }}>📚 All Blogs</h1>
        <Link href="/write" style={{ backgroundColor: "#6366f1", color: "white", padding: "0.6rem 1.2rem", borderRadius: "8px", textDecoration: "none", fontWeight: "500" }}>+ Write New</Link>
      </div>

      <input value={search} onChange={(e) => setSearch(e.target.value)} placeholder="🔍 Search blogs..." style={{ width: "100%", padding: "0.75rem 1rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem", marginBottom: "1rem" }} />

      <div style={{ display: "flex", gap: "0.5rem", flexWrap: "wrap", marginBottom: "1.5rem" }}>
        {CATEGORIES.map(cat => (
          <button key={cat} onClick={() => setActiveCategory(cat)} style={{ padding: "0.4rem 1rem", borderRadius: "20px", border: "1px solid #e2e8f0", backgroundColor: activeCategory === cat ? "#6366f1" : "white", color: activeCategory === cat ? "white" : "#64748b", cursor: "pointer", fontSize: "0.85rem", fontWeight: "500" }}>
            {cat}
          </button>
        ))}
      </div>

      {loading ? (
        <p style={{ textAlign: "center", color: "#64748b", padding: "3rem" }}>Loading blogs...</p>
      ) : filtered.length === 0 ? (
        <div style={{ textAlign: "center", padding: "4rem", color: "#64748b" }}>
          <div style={{ fontSize: "3rem", marginBottom: "1rem" }}>📝</div>
          <p>No blogs found.</p>
          <Link href="/write" style={{ color: "#6366f1" }}>Write the first one!</Link>
        </div>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
          {filtered.map((post: any) => (
            <Link key={post.id} href={`/blog/${post.id}`} style={{ textDecoration: "none" }}>
              <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem", transition: "box-shadow 0.2s" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "0.5rem" }}>
                  <h2 style={{ fontSize: "1.2rem", fontWeight: "600", color: "#1e293b", flex: 1 }}>{post.title}</h2>
                  <div style={{ display: "flex", gap: "0.5rem", marginLeft: "1rem", flexShrink: 0 }}>
                    {post.ai_generated && <span style={{ backgroundColor: "#ede9fe", color: "#6366f1", padding: "0.2rem 0.6rem", borderRadius: "20px", fontSize: "0.75rem" }}>🤖 AI</span>}
                    {post.category && <span style={{ backgroundColor: "#f0fdf4", color: "#16a34a", padding: "0.2rem 0.6rem", borderRadius: "20px", fontSize: "0.75rem" }}>{post.category}</span>}
                  </div>
                </div>
                <p style={{ color: "#64748b", fontSize: "0.85rem", marginBottom: "0.75rem" }}>
                  By {post.author_name} • {new Date(post.created_at).toLocaleDateString()} • {readingTime(post.content)} min read
                  {post.language && post.language !== "english" && <span style={{ marginLeft: "0.5rem", backgroundColor: "#fef3c7", color: "#d97706", padding: "0.1rem 0.5rem", borderRadius: "10px", fontSize: "0.75rem" }}>{post.language}</span>}
                </p>
                <p style={{ color: "#475569", fontSize: "0.95rem", lineHeight: "1.6" }}>{post.content.substring(0, 160)}...</p>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
'@ | Set-Content app/blog/page.tsx

Write-Host "All files updated successfully!" -ForegroundColor Green.\setup2.ps1