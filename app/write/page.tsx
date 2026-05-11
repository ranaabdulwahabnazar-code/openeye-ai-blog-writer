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
