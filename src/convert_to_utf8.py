import os
import chardet

# Текущая папка как корень
root = os.getcwd()

# Какие расширения обрабатывать
extensions = (".pas", ".dfm", ".dpr", ".inc", ".rc")

# Счётчики
total = 0
converted = 0
skipped = 0
failed = 0

print(f"🔍 Начинаю обход из: {root}\n")

def convert_file(filepath):
    global total, converted, skipped, failed
    total += 1

    try:
        with open(filepath, "rb") as f:
            raw = f.read()

        detect = chardet.detect(raw)
        enc = (detect["encoding"] or "").lower()

        if not enc:
            print(f"[?] Не удалось определить кодировку: {filepath}")
            failed += 1
            return

        # Уже UTF → пропускаем
        if enc.startswith("utf"):
            skipped += 1
            return

        text = raw.decode(enc)
        with open(filepath, "w", encoding="utf-8-sig") as f:
            f.write(text)
        print(f"[+] Перекодирован: {filepath} ({enc} → UTF-8)")
        converted += 1

    except Exception as e:
        print(f"[!] Ошибка: {filepath} — {e}")
        failed += 1


for dirpath, _, files in os.walk(root):
    for name in files:
        if name.lower().endswith(extensions):
            convert_file(os.path.join(dirpath, name))

print("\n✅ Готово!")
print(f"Всего файлов: {total}")
print(f"Перекодировано: {converted}")
print(f"Пропущено (уже UTF-8): {skipped}")
print(f"Ошибок: {failed}")
