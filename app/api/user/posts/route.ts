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
