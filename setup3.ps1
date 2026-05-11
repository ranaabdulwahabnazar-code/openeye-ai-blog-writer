# Edit Post API
New-Item -ItemType Directory -Force -Path "app/api/posts/[id]"
@'
import { NextRequest, NextResponse } from "next/server"
import pool from "@/lib/db"

export async function PUT(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { title, content, category } = await request.json()
    const result = await pool.query(
      "UPDATE posts SET title = $1, content = $2, category = $3, updated_at = NOW() WHERE id = $4 RETURNING *",
      [title, content, category, params.id]
    )
    return NextResponse.json(result.rows[0])
  } catch (error) {
    return NextResponse.json({ error: "Could not update post" }, { status: 500 })
  }
}

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    await pool.query("DELETE FROM posts WHERE id = $1", [params.id])
    return NextResponse.json({ message: "Post deleted successfully" })
  } catch (error) {
    return NextResponse.json({ error: "Could not delete post" }, { status: 500 })
  }
}
'@ | Set-Content "app/api/posts/[id]/route.ts"

# User Profile API
New-Item -ItemType Directory -Force -Path "app/api/user/posts"
@'
import { NextRequest, NextResponse } from "next/server"
import pool from "@/lib/db"

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const authorId = searchParams.get("authorId")
    const result = await pool.query(
      "SELECT * FROM posts WHERE author_id = $1 ORDER BY created_at DESC",
      [authorId]
    )
    return NextResponse.json(result.rows)
  } catch (error) {
    return NextResponse.json({ error: "Could not fetch posts" }, { status: 500 })
  }
}
'@ | Set-Content "app/api/user/posts/route.ts"

# Dashboard Page
New-Item -ItemType Directory -Force -Path "app/dashboard"
@'
"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import Link from "next/link"

export default function DashboardPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [posts, setPosts] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [deleting, setDeleting] = useState<string | null>(null)

  useEffect(() => {
    const savedUser = localStorage.getItem("user")
    if (!savedUser) { router.push("/login"); return }
    const u = JSON.parse(savedUser)
    setUser(u)
    fetch(`/api/user/posts?authorId=${u.id}`)
      .then(r => r.json())
      .then(data => { setPosts(data); setLoading(false) })
  }, [router])

  const deletePost = async (id: string) => {
    if (!confirm("Are you sure you want to delete this blog?")) return
    setDeleting(id)
    await fetch(`/api/posts/${id}`, { method: "DELETE" })
    setPosts(posts.filter(p => p.id !== id))
    setDeleting(null)
  }

  const published = posts.filter(p => p.published)
  const drafts = posts.filter(p => !p.published)
  const aiPosts = posts.filter(p => p.ai_generated)
  const readingTime = (content: string) => Math.max(1, Math.ceil(content.split(" ").length / 200))

  if (!user) return null

  return (
    <div style={{ maxWidth: "1000px", margin: "0 auto", padding: "2rem" }}>
      <div style={{ marginBottom: "2rem" }}>
        <h1 style={{ fontSize: "2rem", fontWeight: "bold", color: "#1e293b" }}>📊 My Dashboard</h1>
        <p style={{ color: "#64748b" }}>Welcome back, {user.name}!</p>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "1rem", marginBottom: "2rem" }}>
        {[
          { label: "Total Blogs", value: posts.length, icon: "📝", color: "#6366f1" },
          { label: "Published", value: published.length, icon: "🌍", color: "#16a34a" },
          { label: "Drafts", value: drafts.length, icon: "💾", color: "#d97706" },
          { label: "AI Written", value: aiPosts.length, icon: "🤖", color: "#7c3aed" },
        ].map((stat, i) => (
          <div key={i} style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem", textAlign: "center" }}>
            <div style={{ fontSize: "2rem", marginBottom: "0.5rem" }}>{stat.icon}</div>
            <div style={{ fontSize: "2rem", fontWeight: "bold", color: stat.color }}>{stat.value}</div>
            <div style={{ color: "#64748b", fontSize: "0.9rem" }}>{stat.label}</div>
          </div>
        ))}
      </div>

      <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "1.5rem" }}>
          <h2 style={{ fontWeight: "600", fontSize: "1.25rem", color: "#1e293b" }}>My Blogs</h2>
          <Link href="/write" style={{ backgroundColor: "#6366f1", color: "white", padding: "0.5rem 1rem", borderRadius: "8px", textDecoration: "none", fontSize: "0.9rem" }}>+ New Blog</Link>
        </div>

        {loading ? <p style={{ color: "#64748b" }}>Loading...</p> : posts.length === 0 ? (
          <p style={{ color: "#64748b", textAlign: "center", padding: "2rem" }}>No blogs yet. <Link href="/write" style={{ color: "#6366f1" }}>Write your first one!</Link></p>
        ) : (
          <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
            {posts.map((post: any) => (
              <div key={post.id} style={{ border: "1px solid #e2e8f0", borderRadius: "10px", padding: "1.25rem", display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                <div style={{ flex: 1 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", marginBottom: "0.4rem" }}>
                    <h3 style={{ fontWeight: "600", color: "#1e293b", fontSize: "1rem" }}>{post.title}</h3>
                    <span style={{ padding: "0.15rem 0.5rem", borderRadius: "10px", fontSize: "0.7rem", backgroundColor: post.published ? "#dcfce7" : "#fef3c7", color: post.published ? "#16a34a" : "#d97706" }}>
                      {post.published ? "Published" : "Draft"}
                    </span>
                    {post.ai_generated && <span style={{ padding: "0.15rem 0.5rem", borderRadius: "10px", fontSize: "0.7rem", backgroundColor: "#ede9fe", color: "#6366f1" }}>🤖 AI</span>}
                  </div>
                  <p style={{ color: "#64748b", fontSize: "0.8rem" }}>
                    {new Date(post.created_at).toLocaleDateString()} • {readingTime(post.content)} min read • {post.category || "General"}
                  </p>
                </div>
                <div style={{ display: "flex", gap: "0.5rem", marginLeft: "1rem" }}>
                  <Link href={`/blog/${post.id}`} style={{ padding: "0.4rem 0.8rem", backgroundColor: "#f8fafc", border: "1px solid #e2e8f0", borderRadius: "6px", textDecoration: "none", color: "#475569", fontSize: "0.8rem" }}>View</Link>
                  <Link href={`/edit/${post.id}`} style={{ padding: "0.4rem 0.8rem", backgroundColor: "#eff6ff", border: "1px solid #bfdbfe", borderRadius: "6px", textDecoration: "none", color: "#2563eb", fontSize: "0.8rem" }}>Edit</Link>
                  <button onClick={() => deletePost(post.id)} disabled={deleting === post.id} style={{ padding: "0.4rem 0.8rem", backgroundColor: "#fef2f2", border: "1px solid #fecaca", borderRadius: "6px", color: "#dc2626", fontSize: "0.8rem", cursor: "pointer" }}>
                    {deleting === post.id ? "..." : "Delete"}
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
'@ | Set-Content "app/dashboard/page.tsx"

# Edit Post Page
New-Item -ItemType Directory -Force -Path "app/edit/[id]"
@'
"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"

const CATEGORIES = ["Technology", "Health", "Business", "Sports", "Education", "Lifestyle", "Science", "Politics"]

export default function EditPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const [title, setTitle] = useState("")
  const [content, setContent] = useState("")
  const [category, setCategory] = useState("Technology")
  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState("")

  useEffect(() => {
    const user = localStorage.getItem("user")
    if (!user) { router.push("/login"); return }
    fetch(`/api/posts/${params.id}`).then(r => r.json()).then(data => {
      setTitle(data.title || "")
      setContent(data.content || "")
      setCategory(data.category || "Technology")
    })
  }, [params.id, router])

  const saveEdit = async () => {
    setSaving(true)
    const res = await fetch(`/api/posts/${params.id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ title, content, category })
    })
    if (res.ok) {
      setMessage("Blog updated successfully!")
      setTimeout(() => router.push("/dashboard"), 1500)
    } else {
      setMessage("Could not update blog.")
    }
    setSaving(false)
  }

  return (
    <div style={{ maxWidth: "900px", margin: "0 auto", padding: "2rem" }}>
      <h1 style={{ fontSize: "2rem", fontWeight: "bold", marginBottom: "2rem", color: "#1e293b" }}>✏️ Edit Blog</h1>
      {message && <div style={{ padding: "0.75rem", borderRadius: "8px", marginBottom: "1rem", backgroundColor: message.includes("success") ? "#dcfce7" : "#fee2e2", color: message.includes("success") ? "#16a34a" : "#dc2626" }}>{message}</div>}
      <div style={{ backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "12px", padding: "1.5rem", marginBottom: "1rem" }}>
        <div style={{ marginBottom: "1rem" }}>
          <label style={{ display: "block", fontWeight: "500", marginBottom: "0.5rem" }}>Title</label>
          <input value={title} onChange={e => setTitle(e.target.value)} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem" }} />
        </div>
        <div style={{ marginBottom: "1rem" }}>
          <label style={{ display: "block", fontWeight: "500", marginBottom: "0.5rem" }}>Category</label>
          <select value={category} onChange={e => setCategory(e.target.value)} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "1rem", backgroundColor: "white" }}>
            {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
        </div>
        <div>
          <label style={{ display: "block", fontWeight: "500", marginBottom: "0.5rem" }}>Content</label>
          <textarea value={content} onChange={e => setContent(e.target.value)} rows={20} style={{ width: "100%", padding: "0.75rem", border: "1px solid #e2e8f0", borderRadius: "8px", fontSize: "0.95rem", resize: "vertical", lineHeight: "1.7", fontFamily: "inherit" }} />
        </div>
      </div>
      <div style={{ display: "flex", gap: "1rem" }}>
        <button onClick={() => router.back()} style={{ padding: "0.75rem 1.5rem", backgroundColor: "white", border: "1px solid #e2e8f0", borderRadius: "8px", cursor: "pointer" }}>Cancel</button>
        <button onClick={saveEdit} disabled={saving} style={{ padding: "0.75rem 1.5rem", backgroundColor: saving ? "#a5b4fc" : "#6366f1", color: "white", border: "none", borderRadius: "8px", fontWeight: "600", cursor: saving ? "not-allowed" : "pointer" }}>
          {saving ? "Saving..." : "Save Changes"}
        </button>
      </div>
    </div>
  )
}
'@ | Set-Content "app/edit/[id]/page.tsx"

# Get single post API
@'
import { NextRequest, NextResponse } from "next/server"
import pool from "@/lib/db"

export async function GET(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const result = await pool.query(
      "SELECT posts.*, users.name as author_name FROM posts JOIN users ON posts.author_id = users.id WHERE posts.id = $1",
      [params.id]
    )
    if (result.rows.length === 0) return NextResponse.json({ error: "Post not found" }, { status: 404 })
    return NextResponse.json(result.rows[0])
  } catch (error) {
    return NextResponse.json({ error: "Could not fetch post" }, { status: 500 })
  }
}

export async function PUT(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { title, content, category } = await request.json()
    const result = await pool.query(
      "UPDATE posts SET title = $1, content = $2, category = $3, updated_at = NOW() WHERE id = $4 RETURNING *",
      [title, content, category, params.id]
    )
    return NextResponse.json(result.rows[0])
  } catch (error) {
    return NextResponse.json({ error: "Could not update post" }, { status: 500 })
  }
}

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    await pool.query("DELETE FROM posts WHERE id = $1", [params.id])
    return NextResponse.json({ message: "Post deleted" })
  } catch (error) {
    return NextResponse.json({ error: "Could not delete post" }, { status: 500 })
  }
}
'@ | Set-Content "app/api/posts/[id]/route.ts"

# Update layout with dashboard link
@'
import type { Metadata } from "next"
import "./globals.css"

export const metadata: Metadata = {
  title: "OpenEye AI Blog Writer",
  description: "AI-powered blog writing platform by OpenEye",
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body style={{ margin: 0, fontFamily: "-apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif", backgroundColor: "#f8fafc" }}>
        <nav style={{ backgroundColor: "#0f172a", padding: "1rem 2rem", display: "flex", justifyContent: "space-between", alignItems: "center", borderBottom: "1px solid #1e293b" }}>
          <a href="/" style={{ display: "flex", alignItems: "center", gap: "0.5rem", textDecoration: "none" }}>
            <span style={{ fontSize: "1.5rem" }}>👁️</span>
            <span style={{ color: "white", fontWeight: "bold", fontSize: "1.1rem" }}>OpenEye</span>
            <span style={{ color: "#6366f1", fontWeight: "bold", fontSize: "1.1rem" }}>AI Blog Writer</span>
          </a>
          <div style={{ display: "flex", gap: "1.5rem", alignItems: "center" }}>
            <a href="/" style={{ color: "#94a3b8", textDecoration: "none", fontSize: "0.95rem" }}>Home</a>
            <a href="/blog" style={{ color: "#94a3b8", textDecoration: "none", fontSize: "0.95rem" }}>Blogs</a>
            <a href="/write" style={{ color: "#94a3b8", textDecoration: "none", fontSize: "0.95rem" }}>Write</a>
            <a href="/dashboard" style={{ color: "#94a3b8", textDecoration: "none", fontSize: "0.95rem" }}>Dashboard</a>
            <a href="/login" style={{ color: "#94a3b8", textDecoration: "none", fontSize: "0.95rem" }}>Login</a>
            <a href="/register" style={{ color: "white", backgroundColor: "#6366f1", padding: "0.4rem 1rem", borderRadius: "6px", textDecoration: "none", fontSize: "0.95rem" }}>Sign Up</a>
          </div>
        </nav>
        <main style={{ minHeight: "calc(100vh - 120px)" }}>{children}</main>
        <footer style={{ backgroundColor: "#0f172a", borderTop: "1px solid #1e293b", padding: "1.5rem 2rem", textAlign: "center" }}>
          <p style={{ color: "#475569", fontSize: "0.85rem", margin: 0 }}>
            © 2025 <span style={{ color: "#6366f1" }}>OpenEye AI Blog Writer</span> — Developed by <span style={{ color: "white" }}>Rana Abdul Wahab Nazar</span>
          </p>
        </footer>
      </body>
    </html>
  )
}
'@ | Set-Content "app/layout.tsx"

Write-Host "All features added successfully!" -ForegroundColor Green