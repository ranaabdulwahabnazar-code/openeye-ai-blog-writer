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
