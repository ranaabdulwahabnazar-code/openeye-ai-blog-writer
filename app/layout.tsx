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
