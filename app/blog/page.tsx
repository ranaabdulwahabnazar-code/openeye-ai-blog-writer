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
