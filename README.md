# b2nkuu-spirit

Mindset และ skills หลักสำหรับพัฒนา software อ้างอิงปรัชญาการทำงานแบบญี่ปุ่น
ใช้ร่วมกับ [Claude Code](https://claude.ai/code)

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

---

## ติดตั้ง Global

```bash
# Clone repo
git clone https://github.com/b2nkuu/b2nkuu-spirit.git

# Skills
cp .claude/skills/*.md ~/.claude/skills/

# Hooks
mkdir -p ~/.claude/hooks
cp .claude/hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Settings — merge hooks section เข้า ~/.claude/settings.json
```

หลังติดตั้ง skills และ hooks จะ active ในทุก Claude Code session
