# b2nkuu-spirit

Mindset และ skills หลักสำหรับพัฒนา software อ้างอิงปรัชญาการทำงานแบบญี่ปุ่น
ใช้ร่วมกับ [Claude Code](https://claude.ai/code)

---

## ติดตั้ง

### Global — active ทุก project (one-time setup)

```bash
git clone https://github.com/b2nkuu/b2nkuu-spirit.git
cd b2nkuu-spirit
bash install.sh
```

**อัปเดต:** `git pull && bash install.sh`

---

### Per-project — version ต่างกันได้แต่ละ project (submodule)

```bash
# เพิ่มครั้งแรก
git submodule add https://github.com/b2nkuu/b2nkuu-spirit.git .spirit
bash .spirit/link.sh

# อัปเดต
git submodule update --remote .spirit && bash .spirit/link.sh
```

`link.sh` สร้าง symlink `.claude/skills`, เพิ่ม `@import` ใน `CLAUDE.md`
และ configure hooks ใน `.claude/settings.json` ทั้งหมดอยู่ใน project ไม่แตะ `~/.claude/`

---

## ใช้ร่วมกับ Superpowers

b2nkuu-spirit ออกแบบให้ทำงานคู่กับ [Superpowers](https://github.com/obra/superpowers):

| b2nkuu-spirit | Superpowers | รวมกัน |
|--------------|-------------|--------|
| Gaman (ทำไมต้องอดทน) | `systematic-debugging` (วิธีทำ) | debug อย่างมีสติ |
| Ikigai (ทำไมต้องสร้าง) | `writing-plans` (วิธีวางแผน) | plan ที่มีจุดมุ่งหมาย |
| Shokunin (มาตรฐานงานฝีมือ) | `requesting-code-review` (กระบวนการ) | review ที่ลึกและมีระบบ |
| Kaizen (ทัศนคติปรับปรุง) | `test-driven-development` (วิธีทำให้ปลอดภัย) | refactor อย่างมั่นใจ |

**ติดตั้งทั้งสอง:**
```bash
# Superpowers — methodology (HOW)
/plugin install superpowers@claude-plugins-official

# b2nkuu-spirit — philosophy (WHY)
bash install.sh
```

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
| `route-mindset.sh` | `UserPromptSubmit` | Detect keyword → inject mindset context อัตโนมัติ |
| `kaizen-reflect.sh` | `Stop` | แสดง reflection 3 ข้อหลัง session จบ |

**Keyword mapping:**
- `debug` / `error` / `bug` / `fix` → **Gaman**
- `review` / `quality` / `check` → **Shokunin**
- `refactor` / `improve` / `clean` → **Kaizen**
- `plan` / `design` / `architect` → **Ikigai**

---

## โครงสร้าง

```
b2nkuu-spirit/
├── install.sh                  # ติดตั้ง / อัปเดต
├── CLAUDE.md                   # Context สำหรับ Claude Code
├── mindset/
│   ├── ikigai.md
│   ├── kaizen.md
│   ├── shokunin.md
│   ├── wabi-sabi.md
│   └── gaman.md
└── .claude/
    ├── settings.json           # Hook configuration
    ├── skills/
    │   ├── review.md           # /review
    │   ├── refactor.md         # /refactor
    │   ├── debug.md            # /debug
    │   └── plan.md             # /plan
    └── hooks/
        ├── route-mindset.sh    # UserPromptSubmit
        └── kaizen-reflect.sh   # Stop
```
