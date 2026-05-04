import json, os, urllib.request, urllib.parse

with open('roadmap.json') as f:
    roadmap = json.load(f)

queued = [i for i in roadmap['items'] if i['status'] == 'queued']
in_progress = [i for i in roadmap['items'] if i['status'] == 'in_progress']

lines = ["Domiatek Agent -- Buenos dias Dario!\n"]

if in_progress:
    lines.append("En progreso:")
    for item in in_progress:
        lines.append(f"  * [{item['id']}] {item['title']}")
    lines.append("")

if queued:
    lines.append("Selecciona proyecto para hoy:")
    lines.append("  0. Nuevo proyecto")
    for i, item in enumerate(queued[:5], 1):
        repo = item['repo'].split('/')[-1]
        score = item.get('priority_score', '?')
        lines.append(f"  {i}. [{item['id']}] {item['title']} ({repo}, score:{score})")
    lines.append("")
    lines.append("Comenta tu eleccion en el daily issue antes de las 07:00 AM.")
    lines.append("Sin respuesta: trabajare en el proyecto #1 automaticamente.")
    queued[0]['status'] = 'scheduled'
    with open('roadmap.json', 'w') as f:
        json.dump(roadmap, f, indent=2, ensure_ascii=False)
else:
    lines.append("Sin tareas en cola. Roadmap al dia!")

message = "\n".join(lines)
print(message)

bot = os.environ.get('TELEGRAM_BOT_TOKEN', '')
chat = os.environ.get('TELEGRAM_CHAT_ID', '')

if bot and chat:
    data = urllib.parse.urlencode({'chat_id': chat, 'text': message}).encode()
    req = urllib.request.Request(
        f'https://api.telegram.org/bot{bot}/sendMessage',
        data=data
    )
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read())
            print("Telegram sent OK" if result.get('ok') else f"Telegram error: {result}")
    except Exception as e:
        print(f"Telegram error: {e}")
else:
    print("Telegram secrets not set -- skipping")

if queued:
    print(f"Default scheduled: {queued[0]['id']}")
