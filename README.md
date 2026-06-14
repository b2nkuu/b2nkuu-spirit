# spirit

Mindset และ skills หลักสำหรับพัฒนา software อ้างอิงปรัชญาการทำงานแบบญี่ปุ่น
ใช้ร่วมกับ [Claude Code](https://claude.ai/code)

---

## Prerequisites

| Requirement | หมายเหตุ |
|-------------|---------|
| [Claude Code](https://claude.ai/code) | required |
| Python 3 | required — hooks ใช้สำหรับ JSON parsing และ plugin detection |
| [solo](https://github.com/b2nkuu/solo) | optional — task management ผ่าน GitHub Issues, จับคู่กับ Kaizen/Ikigai |

## ติดตั้ง

```bash
/plugin install github:b2nkuu/spirit
```

---

## ใช้ร่วมกับ Plugins อื่น

spirit ออกแบบให้ทำงานคู่กับ:

| Plugin | spirit | รวมกัน |
|--------|--------------|--------|
| [solo](https://github.com/b2nkuu/solo) `/solo:plan` | Ikigai (ทำไมต้องทำ) | จัด inbox ด้วยจุดมุ่งหมาย |
| [solo](https://github.com/b2nkuu/solo) `/solo:capture` `/solo:done` `/solo:week` | Kaizen (ก้าวเล็ก + สะท้อน) | task ทีละก้าว, close loop, review 7 วัน |
| [solo](https://github.com/b2nkuu/solo) `/solo:capture` (tech debt) | Wabi-Sabi (ship + track debt) | ยอมรับความไม่สมบูรณ์ เก็บ debt อย่างซื่อสัตย์ |
| [solo](https://github.com/b2nkuu/solo) `/solo:today` `/solo:start` | Kanso (focus 1 task) | ตัด noise เหลือสิ่งที่ต้องทำ |

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
| **Kanso** | 簡素 | ตัดสิ่งไม่จำเป็นออก พูดเท่าที่ต้องการ ความสั้นคือความแม่นยำ |

รายละเอียดเต็ม: [`mindset/`](mindset/)

---

## Skills (Slash Commands)

| Command | Mindset | จุดประสงค์ |
|---------|---------|-----------|
| `/spirit:init` | — | Setup ครั้งเดียวต่อ repo: เพิ่ม `.spirit/` ใน `.gitignore` + สร้าง `.spirit/reflections/` |
| `/spirit:design` | Ikigai + Shokunin | ออกแบบ feature จากจุดมุ่งหมาย |
| `/spirit:refactor` | Kaizen + Wabi-Sabi | ปรับปรุงทีละก้าว ไม่ rewrite |
| `/spirit:inspect` | Shokunin + Kaizen | Code review ระดับงานฝีมือ |
| `/spirit:debug` | Gaman + Kaizen | วิเคราะห์ root cause อย่างอดทน |

> **Kanso** ไม่มี skill และไม่มี hook injection — เป็น mindset background ใช้คู่กับ [pordee](https://github.com/b2nkuu/pordee) plugin ถ้าต้องการ tone compression ระดับ session

---

## Hooks

| Hook | Event | พฤติกรรม |
|------|-------|---------|
| `route-mindset.sh` | `UserPromptSubmit` | Detect keyword → inject mindset + plugin reference อัตโนมัติ |
| `kaizen-reflect.sh` | `Stop` | แสดง reflection 3 ข้อหลัง session จบ |

**Keyword mapping:**
- `debug` / `error` / `bug` / `พัง` / `บั๊ก` → **Gaman**
- `inspect` / `review` / `quality` / `รีวิว` / `ตรวจ` → **Shokunin**
- `refactor` / `improve` / `ปรับปรุง` → **Kaizen**
- `design` / `plan` / `feature` / `architect` / `ออกแบบ` / `วางแผน` → **Ikigai**

---

## References & Credits

- [b2nkuu/solo](https://github.com/b2nkuu/solo) — solopreneur task management via GitHub Issues, pairs with Kaizen incremental flow

---

## โครงสร้าง

```
spirit/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── CLAUDE.md               # Mindset context สำหรับ Claude
├── mindset/
│   ├── ikigai.md
│   ├── kaizen.md
│   ├── shokunin.md
│   ├── wabi-sabi.md
│   ├── gaman.md
│   └── kanso.md
├── skills/
│   ├── init/               # /spirit:init
│   ├── design/             # /spirit:design
│   ├── refactor/           # /spirit:refactor
│   ├── inspect/            # /spirit:inspect
│   └── debug/              # /spirit:debug
└── hooks/
    ├── hooks.json          # Hook event configuration
    ├── route-mindset.sh    # UserPromptSubmit
    └── kaizen-reflect.sh   # Stop
```
