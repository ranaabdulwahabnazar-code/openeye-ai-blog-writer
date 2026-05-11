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
