---
name: refactor
description: This skill should be used when the user asks to "refactor", "clean up code", "improve this", "simplify", or invokes "/refactor". Applies Kaizen mindset — incremental improvement, one step at a time.
version: 1.0.0
---
# Refactor

## solo Integration
ถ้าติดตั้ง solo แล้ว: เจอ improvement ที่ไม่อยู่ใน scope ปัจจุบัน → `/solo:capture` เก็บเป็น task ไว้ทำทีหลัง
Kaizen คือก้าวเล็กๆ สะสม — solo ช่วยให้ก้าวเล็กๆ ไม่หล่นหาย

## พื้นฐาน Mindset
**Kaizen** — ปรับปรุงทีละก้าว ทุกก้าวเล็กๆ สะสมเป็นผลใหญ่ตามเวลา
**Wabi-Sabi** — ดีขึ้นและใช้งานได้คือเป้าหมาย ไม่ต้องรอให้สมบูรณ์แบบ

## กระบวนการ
1. **เข้าใจก่อนแตะ**: อ่าน code ทั้งหมด มันทำอะไร? dependencies คืออะไร?
   พฤติกรรมอะไรที่ต้องรักษาไว้?

2. **เขียน test ก่อน** (ถ้ายังไม่มี): Lock พฤติกรรมปัจจุบันไว้ก่อนเปลี่ยนอะไร
   Test ที่ผ่านก่อนและหลังคือหลักฐานว่าพฤติกรรมยังคงอยู่

3. **ระบุการปรับปรุงที่มีคุณค่าสูงสุด**: อย่าแก้ทุกอย่าง — แก้สิ่งที่มี
   อัตราส่วน friction ต่อ risk สูงที่สุด ระบุชัดเจน

4. **เปลี่ยนทีละอย่าง**: Commit ที่มี concern เดียว แต่ละขั้นต้องไม่ทำให้ test พัง
   ถ้าอยากเปลี่ยนสองอย่าง ให้แยก work

5. **ตั้งชื่อการปรับปรุง**: ใน commit message หรือ PR description ระบุว่าอะไรเปลี่ยน
   และทำไมมันดีขึ้น (ไม่ใช่แค่อะไรเปลี่ยน)

6. **หยุดที่ "ดีกว่า" ไม่ใช่ "สมบูรณ์แบบ"**: Ship การปรับปรุง แล้วค่อย kaizen อีกครั้งครั้งหน้า

## รูปแบบ Output
- **สิ่งที่เปลี่ยน**: files และ functions ที่ได้รับผลกระทบ
- **สิ่งที่ไม่เปลี่ยน**: ระบุชัดเจนว่าอะไร out of scope ใน pass นี้ (และทำไม)
- **การปรับปรุง** (เรียงตาม value/risk ratio):
  - อะไรเปลี่ยน ทำไมดีขึ้น test อะไรครอบคลุม
- **แผน commit**: ลำดับ atomic commit ที่แนะนำ
