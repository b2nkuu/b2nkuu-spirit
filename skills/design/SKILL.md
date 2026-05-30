---
name: design
description: This skill should be used when the user asks to "design a feature", "plan an approach", "architect", "what should we build", or invokes "/design". Applies Ikigai mindset — start with purpose before implementation.
version: 1.0.0
---
# Design

## Plugin Integration

**solo** — หลังกำหนด "ทำไม" แล้ว ใช้ `/solo:plan` จัด inbox และ `/solo:capture` แตก design เป็น task บน GitHub Issues
Ikigai กำหนดจุดมุ่งหมาย — solo แตกจุดมุ่งหมายเป็นก้าวเล็กๆ ที่ track ได้

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
