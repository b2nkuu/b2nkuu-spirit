# b2nkuu-spirit

Mindset และ skills หลักสำหรับพัฒนา software อ้างอิงปรัชญาการทำงานแบบญี่ปุ่น
ใช้ร่วมกับ [Claude Code](https://claude.ai/code)

---

## ติดตั้ง

```bash
/plugin install b2nkuu-spirit@b2nkuu-marketplace
```

---

## ใช้ร่วมกับ Plugins อื่น

b2nkuu-spirit ออกแบบให้ทำงานคู่กับ:

| Plugin | b2nkuu-spirit | รวมกัน |
|--------|--------------|--------|
| [Superpowers](https://github.com/obra/superpowers) `systematic-debugging` | Gaman (ทำไมต้องอดทน) | debug อย่างมีสติ |
| [Superpowers](https://github.com/obra/superpowers) `writing-plans` | Ikigai (ทำไมต้องสร้าง) | plan ที่มีจุดมุ่งหมาย |
| [Superpowers](https://github.com/obra/superpowers) `requesting-code-review` | Shokunin (มาตรฐาน) | review ที่ลึกและมีระบบ |
| [Superpowers](https://github.com/obra/superpowers) `test-driven-development` | Kaizen (ทัศนคติ) | refactor อย่างมั่นใจ |
| [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) Phase 1, 3 | Ikigai | Discovery ที่มีจุดมุ่งหมาย |
| [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) Phase 4 | Shokunin | Architecture ระดับงานฝีมือ |
| [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) Phase 6 | Shokunin + Kaizen | Quality Review ที่สร้างสรรค์ |

Hook `route-mindset.sh` ตรวจ plugins ที่ติดตั้งอัตโนมัติ และ inject skill reference ที่เหมาะสม

---

## Mindsets

| Mindset | ภาษาญี่ปุ่น | แก่นแท้ |
|---------|------------|---------|
| **Ikigai** | 生き甲斐 | สร้างด้วยจุดมุ่งหมาย — ถาม "ทำไม?" ก่อน "อย่างไร?" |
| **Kaizen** | 改善 | พัฒนาต่อเนื่องทีละก้าว ทิ้ง codebase ไว้ดีกว่าตอนรับมาเสมอ |
| **Shokunin** | 職人 | Code คืองานฝีมือ ทุกชื่อ ทุกโครงสร้าง ล้วนสำคัญ |
| **Wabi-Sabi** | 侘寂 | Ship ความไม่สมบูรณ์ที่ใช้ได้ จัดการ tech debt อย่างตรงไปตรงมา |
| **Gaman** | 我慢 | เข้าใจ root cause ก่อน patch อดทนคือพลัง |

รายละเอียดเต็ม: [`mindset/`](mindset/)

---

## Skills (Slash Commands)

| Command | Mindset | จุดประสงค์ |
|---------|---------|-----------|
| `/review` | Shokunin + Kaizen | Code review ระดับงานฝีมือ |
| `/refactor` | Kaizen + Wabi-Sabi | ปรับปรุงทีละก้าว ไม่ rewrite |
| `/debug` | Gaman + Kaizen | วิเคราะห์ root cause อย่างอดทน |
| `/plan` | Ikigai + Shokunin | วางแผน feature จากจุดมุ่งหมาย |

---

## Hooks

| Hook | Event | พฤติกรรม |
|------|-------|---------|
| `route-mindset.sh` | `UserPromptSubmit` | Detect keyword → inject mindset + plugin reference อัตโนมัติ |
| `kaizen-reflect.sh` | `Stop` | แสดง reflection 3 ข้อหลัง session จบ |

**Keyword mapping:**
- `debug` / `error` / `bug` / `พัง` / `บั๊ก` → **Gaman**
- `review` / `quality` / `รีวิว` → **Shokunin**
- `refactor` / `improve` / `ปรับปรุง` → **Kaizen**
- `plan` / `feature` / `design` / `วางแผน` → **Ikigai**

---

## โครงสร้าง

```
b2nkuu-spirit/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── CLAUDE.md               # Mindset context สำหรับ Claude
├── mindset/
│   ├── ikigai.md
│   ├── kaizen.md
│   ├── shokunin.md
│   ├── wabi-sabi.md
│   └── gaman.md
├── skills/
│   ├── review.md           # /review
│   ├── refactor.md         # /refactor
│   ├── debug.md            # /debug
│   └── plan.md             # /plan
└── hooks/
    ├── hooks.json          # Hook event configuration
    ├── route-mindset.sh    # UserPromptSubmit
    └── kaizen-reflect.sh   # Stop
```
