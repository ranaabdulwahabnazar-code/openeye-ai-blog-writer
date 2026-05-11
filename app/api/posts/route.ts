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
