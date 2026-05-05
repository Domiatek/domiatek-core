import json, os, subprocess, datetime

today = datetime.date.today().isoformat()

# Check if daily issue already exists
result = subprocess.run(
    ['gh', 'issue', 'list', '--repo', 'Domiatek/domiatek-core',
     '--label', 'daily-plan', '--state', 'open', '--json', 'number', '--jq', '.[0].number'],
    capture_output=True, text=True
)
existing = result.stdout.strip()
if existing:
    print(f"Daily issue already exists: #{existing}")
    exit(0)

with open('roadmap.json') as f:
    roadmap = json.load(f)

sprint_items = [i for i in roadmap['items']
                if i['status'] in ('queued', 'scheduled', 'in_progress')]

body_lines = [
    f"## Plan del dia -- {today}",
    "",
    "Comenta tu eleccion antes de las **07:00 AM**. Sin respuesta el agente trabaja en la tarea de mayor prioridad.",
    "",
    "- [ ] 0. Nuevo proyecto",
]
for i, item in enumerate(sprint_items[:5], 1):
    body_lines.append(f"- [ ] {i}. [{item['id']}] {item['title']} ({item['repo']})")

body_lines += [
    "",
    "> Para nuevo proyecto comenta: `0: descripcion del proyecto`"
]

body = "\n".join(body_lines)

subprocess.run(
    ['gh', 'issue', 'create',
     '--repo', 'Domiatek/domiatek-core',
     '--title', f'[daily] {today}',
     '--label', 'daily-plan',
     '--body', body],
    check=True
)
print(f"Daily issue created for {today}")
