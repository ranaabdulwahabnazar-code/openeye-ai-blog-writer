import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'
import bcrypt from 'bcryptjs'

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json()
    if (!email || !password) return NextResponse.json({ error: 'Email aur password chahiye' }, { status: 400 })
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email])
    if (result.rows.length === 0) return NextResponse.json({ error: 'Email ya password galat hai' }, { status: 401 })
    const user = result.rows[0]
    const isValid = await bcrypt.compare(password, user.password)
    if (!isValid) return NextResponse.json({ error: 'Email ya password galat hai' }, { status: 401 })
    return NextResponse.json({ message: 'Login ho gaye!', user: { id: user.id, name: user.name, email: user.email } })
  } catch (error) {
    return NextResponse.json({ error: 'Kuch gadbad ho gayi' }, { status: 500 })
  }
}
