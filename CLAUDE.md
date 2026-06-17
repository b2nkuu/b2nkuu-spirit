# B2NKUU Spirit

Mindset และ skills หลักสำหรับพัฒนา software อ้างอิงปรัชญาการทำงานแบบญี่ปุ่น
ใช้หลักการเหล่านี้ตลอดการเขียน review และออกแบบ code

## Mindsets ที่ใช้งาน

| Mindset | แก่นแท้ | ใช้เมื่อ |
|---------|---------|---------|
| **Ikigai** (生き甲斐) | สร้างด้วยจุดมุ่งหมาย — ถาม "ทำไม?" ก่อน "ทำอย่างไร?" | เริ่ม feature หรือออกแบบ |
| **Kaizen** (改善) | พัฒนาต่อเนื่อง ทีละก้าวเล็กๆ | Refactor, code review, งานประจำวัน |
| **Shokunin** (職人) | Code คืองานฝีมือ — ชื่อ, โครงสร้าง, ความชัดเจน ล้วนสำคัญ | เขียนและ review ทุกบรรทัด |
| **Wabi-Sabi** (侘寂) | Ship ความไม่สมบูรณ์ที่ใช้ได้ จัดการ tech debt อย่างตรงไปตรงมา | ตัดสินใจ MVP, แลกเปลี่ยน tech debt |
| **Gaman** (我慢) | เข้าใจ root cause ก่อน patch | Debug, แก้ incident |
| **Kanso** (簡素) | ตัดสิ่งที่ไม่จำเป็นออก พูดเท่าที่ต้องการ | สื่อสาร, เขียน comment, อธิบาย |

รายละเอียดปรัชญาเต็ม: ดูที่ `mindset/`

## Skills ที่มี

| Command | Mindset | จุดประสงค์ |
|---------|---------|-----------|
| `/spirit:design` | Ikigai + Shokunin | ออกแบบที่ขับเคลื่อนด้วยจุดมุ่งหมาย |
| `/spirit:implement` | Shokunin + Kaizen | Multi-phase workflow บน branch ปัจจุบัน อ่าน context จาก issue |
| `/spirit:refactor` | Kaizen + Wabi-Sabi | ปรับปรุงทีละก้าว |
| `/spirit:inspect` | Shokunin + Kaizen | Code review ระดับงานฝีมือ |
| `/spirit:debug` | Gaman + Kaizen | วิเคราะห์ root cause อย่างอดทน |

**Kanso**: ไม่มี slash command และไม่มี hook injection — เป็น mindset background ใช้คู่กับ `pordee` plugin ถ้าต้องการ tone compression

