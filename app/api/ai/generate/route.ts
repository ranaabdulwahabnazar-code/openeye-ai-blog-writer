import { NextRequest, NextResponse } from "next/server"
import Groq from "groq-sdk"

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY })

export async function POST(request: NextRequest) {
  try {
    const { topic, tone, length, language } = await request.json()
    if (!topic) return NextResponse.json({ error: "Topic is required" }, { status: 400 })

    const wordCount = length === "short" ? "300" : length === "long" ? "1000" : "600"

    const languageInstruction = language && language !== "english"
      ? `Write the entire blog post in ${language} language.`
      : "Write in English."

    const completion = await groq.chat.completions.create({
      model: "llama-3.3-70b-versatile",
      messages: [{
        role: "user",
        content: `Write a blog post about: "${topic}"
${languageInstruction}
Tone: ${tone || "professional"}
Length: approximately ${wordCount} words
Format: Start with a title, then introduction, 3-4 sections with headings, then conclusion.
Write only the blog content, nothing else.`
      }],
      max_tokens: 2000
    })

    const content = completion.choices[0].message.content || ""
    return NextResponse.json({ content })

  } catch (error) {
    return NextResponse.json({ error: "AI content generation failed" }, { status: 500 })
  }
}
