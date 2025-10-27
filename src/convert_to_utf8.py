import os
import chardet

# Укажите корень проекта
root = "C:/Path/To/Your/DelphiProject"

# Какие расширения перекодировать
extensions = (".pas", ".dfm", ".dpr", ".inc", ".rc")

def convert_file(filepath):
    with open(filepath, "rb") as f:
        raw = f.read()

    # Определяем кодировку
    detect = chardet.detect(raw)
    enc = detect["encoding"]

    if not enc:
        print(f"[?] Не удалось определить кодировку: {filepath}")
        return

    # Если уже UTF-8 — пропускаем
    if enc.lower().startswith("utf"):
        return

    try:
        text = raw.decode(enc)
        with open(filepath, "w", encoding="utf-8-sig") as f:
            f.write(text)
        print(f"[+] Перекодирован: {filepath} ({enc} → UTF-8)")
    except Exception as e:
        print(f"[!] Ошибка {filepath}: {e}")

for dirpath, _, files in os.walk(root):
    for name in files:
        if name.lower().endswith(extensions):
            convert_file(os.path.join(dirpath, name))
