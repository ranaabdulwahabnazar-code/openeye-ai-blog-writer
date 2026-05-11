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
