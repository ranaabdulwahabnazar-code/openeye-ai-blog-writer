import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'
import bcrypt from 'bcryptjs'

export async function POST(request: NextRequest) {
  try {
    const { name, email, password } = await request.json()
    if (!name || !email || !password) return NextResponse.json({ error: 'Sab fields bharo' }, { status: 400 })
    const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email])
    if (existing.rows.length > 0) return NextResponse.json({ error: 'Email pehle se registered hai' }, { status: 400 })
    const hashedPassword = await bcrypt.hash(password, 12)
    const result = await pool.query('INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id, name, email', [name, email, hashedPassword])
    return NextResponse.json({ message: 'Account ban gaya!', user: result.rows[0] })
  } catch (error) {
    return NextResponse.json({ error: 'Kuch gadbad ho gayi' }, { status: 500 })
  }
}
