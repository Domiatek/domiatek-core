import json, os, urllib.request, urllib.parse, subprocess, datetime

with open('roadmap.json') as f:
    roadmap = json.load(f)

queued     = [i for i in roadmap['items'] if i['status'] == 'queued']
in_prog    = [i for i in roadmap['items'] if i['status'] == 'in_progress']
scheduled  = [i for i in roadmap['items'] if i['status'] == 'scheduled']

lines = ["Domiatek Agent -- Buenos dias Dario!"]
lines.append("")

if in_prog:
    lines.append("En progreso:")
    for item in in_prog:
        lines.append(f"  >> [{item['id']}] {item['title']}")
    lines.append("")

if scheduled:
    lines.append("Programado hoy:")
    for item in scheduled:
        lines.append(f"  [] [{item['id']}] {item['title']}")
    lines.append("")

if queued:
    lines.append("Selecciona proyecto (comenta en el daily issue antes 07:00 AM):")
    lines.append("  0. Nuevo proyecto")
    for i, item in enumerate(queued[:5], 1):
        repo = item['repo'].split('/')[-1]
        lines.append(f"  {i}. [{item['id']}] {item['title']} ({repo})")
    lines.append("")
    lines.append("Sin respuesta: trabajare en el #1 automaticamente.")
    # Mark top queued as scheduled
    queued[0]['status'] = 'scheduled'
    roadmap['updated_at'] = datetime.datetime.utcnow().isoformat() + 'Z'
    with open('roadmap.json', 'w') as f:
        json.dump(roadmap, f, indent=2, ensure_ascii=False)
    print(f"Scheduled: {queued[0]['id']}")
else:
    lines.append("Sin tareas en cola. Sprint completado!")

message = "\n".join(lines)
print("--- MESSAGE ---")
print(message)
print("--- END ---")

bot  = os.environ.get('TELEGRAM_BOT_TOKEN', '')
chat = os.environ.get('TELEGRAM_CHAT_ID', '')

if bot and chat:
    data = urllib.parse.urlencode({'chat_id': chat, 'text': message}).encode()
    req  = urllib.request.Request(
        f'https://api.telegram.org/bot{bot}/sendMessage', data=data)
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read())
            print("Telegram OK" if result.get('ok') else f"Telegram error: {result}")
    except Exception as e:
        print(f"Telegram error: {e}")
else:
    print("WARN: Telegram secrets not set")
