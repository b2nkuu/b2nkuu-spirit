---
description: วางแผน feature แบบ Ikigai — เริ่มจากจุดมุ่งหมาย ออกแบบด้วยงานฝีมือ
---
# Plan

## Superpowers Integration
ถ้าติดตั้ง Superpowers แล้ว: apply Ikigai mindset ด้านล่างก่อน แล้วใช้ `writing-plans` skill
Ikigai คือ *ทำไม* ต้องถามก่อนสร้าง — `writing-plans` คือ *วิธี* เขียน plan ที่ subagent ทำตามได้

## พื้นฐาน Mindset
**Ikigai** — ทุก feature ต้องมี "ทำไม" ที่ชัดเจนก่อน "อย่างไร"
จุดมุ่งหมายที่ขาดความชัดเจนสร้างของเสีย ความชัดเจนที่ขาดจุดมุ่งหมายสร้างสิ่งผิด
**Shokunin** — การตัดสินใจด้านการออกแบบสมควรได้รับความใส่ใจเท่ากับการ implement
Interface ที่ออกแบบดีมีคุณค่ากว่า implementation ที่สวยงามของ API ที่ผิด

## กระบวนการ
1. **กำหนด "ทำไม"** (Ikigai):
   - สำหรับใครโดยเฉพาะ?
   - แก้ปัญหาอะไรในวันนี้ — ไม่ใช่สมมุติฐาน?
   - success ดูเป็นอย่างไร วัดได้?
   - เกิดอะไรขึ้นถ้าไม่สร้างสิ่งนี้?

2. **กำหนด scope ที่เล็กที่สุดที่มีประโยชน์** (Wabi-Sabi):
   อะไรคือขั้นต่ำที่ส่งมอบคุณค่าจริงให้ user จริง?
   ระบุชัดเจนว่าอะไร out of scope และทำไม

3. **Map dependencies**:
   code, ระบบ หรือ services ที่มีอยู่แล้วอะไรที่สิ่งนี้แตะ?
   อะไรอาจพัง? อะไรต้อง migrate?

4. **ออกแบบ interface ก่อน** (Shokunin):
   รูปร่าง API, data model หรือ user flow — ก่อนรายละเอียดการ implement
   Interface คือ contract มันเปลี่ยนยากกว่า internals

5. **ระบุความเสี่ยง**:
   อะไรอาจผิดพลาด? อะไร reversible เทียบกับ irreversible?
   สมมุติฐานอะไรที่ถ้าผิดจะทำให้การออกแบบใช้ไม่ได้?

6. **กำหนด done**:
   test, metric หรือพฤติกรรมอะไรที่ยืนยันว่า complete?
   เกณฑ์ done ที่เขียนก่อนเริ่ม work ป้องกัน scope drift

## รูปแบบ Output
- **จุดมุ่งหมาย**: หนึ่งประโยค — ใครได้ประโยชน์และอย่างไร
- **Scope**: อะไรอยู่ใน / อะไร out อย่างชัดเจน
- **Interface design**: API signatures หลัก, data shapes หรือ user flows
- **Dependencies**: ระบบและ code ที่สิ่งนี้แตะ
- **ความเสี่ยง**: ความเสี่ยง 2-3 อันดับแรกพร้อม mitigation
- **Definition of done**: acceptance criteria ที่ test ได้ (ไม่ใช่เป้าหมายที่คลุมเครือ)
