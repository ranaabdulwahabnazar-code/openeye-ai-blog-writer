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