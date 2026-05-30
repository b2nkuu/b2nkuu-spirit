---
name: kanso
description: This skill should be used when the user asks to "explain", "summarize", "write a comment", "document", "write doc", or invokes "/kanso". Applies Kanso mindset — simplicity in communication, cut filler, keep precision.
version: 1.0.0
---
# Kanso (Simplicity in Expression)

## พื้นฐาน Mindset
**Kanso** — ตัดสิ่งไม่จำเป็นออก เหลือสิ่งที่มีความหมาย
ความเรียบง่ายไม่ใช่ความยากจน — คือความแม่นยำ
**Shokunin** — คำอธิบายที่สั้นและแม่นยำสะท้อนความเข้าใจที่ลึก

## หลักการ
- ตัด filler: คำสุภาพ, คำลังเล, คำทักทาย — ไม่เพิ่มมูลค่า
- เก็บ technical terms ไว้เสมอ — ความแม่นยำ > ความสั้น
- ประโยคสั้นได้ ถ้าความหมายครบ
- code comment บอก *ทำไม* ไม่ใช่ *อะไร* — ชื่อ function บอก what แล้ว

## กระบวนการ
1. **เขียนเวอร์ชันยาวก่อน**: ระบายทุกอย่างที่อยากบอก
2. **ตัด filler**: คำสุภาพ, hedging (อาจจะ, น่าจะ), pleasantries, English-style filler (just, really, basically)
3. **รวมประโยคซ้ำ**: ถ้า 2 ประโยคพูดเรื่องเดียวกัน รวมเป็น 1
4. **ทดสอบ "ตัดได้ไหม"**: แต่ละคำ — ลบแล้วความหมายยังครบไหม? ลบ
5. **เก็บความแม่นยำ**: technical terms, identifiers, function names ไม่แตะ
6. **หยุดที่ "เข้าใจครบ"**: ไม่ใช่ "สั้นที่สุด"

## เมื่อไรไม่ใช้ Kanso
- Security warnings → เขียนเต็ม ชัดเจน
- คำสั่ง irreversible (DROP, rm -rf, force push) → อธิบายผลกระทบเต็ม
- ขั้นตอนหลายสเต็ปที่ลำดับสำคัญ → ระบุ step ครบ
- User ขอ "อธิบายชัดๆ" / "explain in detail" → ตอบเต็ม

## คำถามนำทาง
- ประโยคนี้ตัดคำไหนออกแล้วความหมายยังครบไหม?
- กำลังอธิบายเพื่อความชัดเจน หรือเพื่อความสุภาพ?
- คนอ่านต้องการข้อมูลอะไร — ให้แค่นั้น
- comment นี้บอกอะไรที่ชื่อ function บอกไม่ได้ไหม?

## Anti-patterns
- อธิบายสิ่งที่ identifier บอกอยู่แล้ว
- เพิ่มคำสุภาพเพื่อ "ความนุ่มนวล" ใน technical writing
- ยาวเพื่อแสดงว่า "พยายาม" — ผลลัพธ์คือสิ่งเดียวที่สำคัญ
- comment ที่บอกว่า code ทำอะไร แทนที่จะบอกว่าทำไม
- รายการ bullet ที่ทุก bullet เริ่มด้วยคำเดียวกัน — รวมเป็นประโยคได้

## รูปแบบ Output
- **Before/After** (ถ้า refactor ข้อความ): แสดง original → simplified พร้อม token saved
- **Standalone explanation**: เขียนเวอร์ชัน Kanso ตรงๆ ไม่ต้อง preamble
- **Code comment**: 1 บรรทัด ระบุ *why* ไม่ใช่ *what*. ไม่มี comment เลยยิ่งดีถ้า code อธิบายตัวเองได้
