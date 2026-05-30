---
name: inspect
description: This skill should be used when the user asks to "inspect code", "review code", "review this PR", "check my code", or invokes "/inspect". Applies Shokunin mindset — craftsman-level inspection of correctness, clarity, and maintainability.
version: 1.0.0
---
# Inspect (Code Review)

## Plugin Integration

**solo-flow** — เจอ issue ระหว่าง review ที่ไม่ใช่ blocker → `/solo:capture` เก็บเป็น follow-up task
Shokunin ตั้งมาตรฐาน — solo-flow ตามรอย improvement ที่ยังไม่ได้ทำ

## พื้นฐาน Mindset
**Shokunin** — เข้าหาในฐานะช่างฝีมือผู้เชี่ยวชาญตัดสินงาน ทุกชื่อ ทุกโครงสร้าง
ทุกการตัดสินใจสะท้อนความใส่ใจหรือการขาดมัน
**Kaizen** — ระบุสิ่งที่ปรับปรุงเล็กๆ ที่จะทิ้ง code นี้ไว้ดีกว่าตอนที่มาถึง

## กระบวนการ
1. **ตรวจสอบจุดมุ่งหมาย** (Ikigai): การเปลี่ยนแปลงนี้มี "ทำไม" ที่ชัดเจนไหม?
   PR description อธิบาย intent ได้โดยไม่ต้องอ่านทุกบรรทัดไหม?

2. **ความถูกต้อง**: ทำสิ่งที่อ้างได้จริงไหม? Edge cases ครอบคลุมไหม?
   failure modes จัดการหรือยอมรับอย่างชัดเจนไหม?

3. **Craftsmanship** (Shokunin):
   - ชื่อชัดเจนและสื่อ intent โดยไม่ต้องตีความไหม?
   - โครงสร้างเรียบง่าย หรือมี accidental complexity?
   - มีอะไรขาดที่จะทำให้ developer คนต่อไปสับสนไหม?
   - Developer ที่ไม่รู้จัก area นี้จะเข้าใจโดยไม่มี comment ไหม?

4. **โอกาสปรับปรุง** (Kaizen): การเปลี่ยนแปลงอะไรหนึ่งอย่างที่จะทิ้ง code นี้ไว้
   ดีขึ้นอย่างมีนัยสำคัญ? (ระบุให้ชัดเจน ไม่ใช่แบบ general)

5. **ความซื่อสัตย์เรื่อง tradeoff** (Wabi-Sabi): ข้อจำกัดที่รู้แต่ละอย่าง — document ไว้ไหม?
   เป็น blocker หรือ tracked improvement?

## รูปแบบ Output
สำหรับแต่ละ area ที่ review:
- **Blockers** (`must:`): ปัญหาที่ต้องแก้ก่อน merge
- **Suggestions** (`nit:` / `suggest:`): การปรับปรุงที่ไม่บังคับ
- **สิ่งที่ทำได้ดี**: ระบุชัดเจนว่าอะไรที่งานฝีมือดี — เจาะจง ไม่ใช่แบบ generic
- **สรุปคำตัดสิน**: Approve / Request changes พร้อม rationale หนึ่งบรรทัด
