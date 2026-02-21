message = "Hello there.My name is John."

message = message.upper()  # Tüm harfleri büyük yapar
message = message.lower()  # Tüm harfleri küçük yapar
message = message.title()  # Her kelimenin ilk harfini büyük yapar
meesage = message.capitalize()  # İlk harfi büyük yapar, diğer harfleri küçük yapar
message = message.strip()  # Başındaki ve sonundaki boşlukları kaldırır
message = message.replace("John", "Jane")  # "John" kelimesini "Jane" ile değiştirir
message = message.split()  # Kelimeleri listeye ayırır
message = message.split(".")  # Noktaya göre ayırır
message = " ".join(message)  # Listeyi birleştirir

index = message.find("Jane")  # "Jane" kelimesinin başlangıç indeksini bulur
print(index)

isFound = message.startswith("B") # "B" ile başlayıp başlamadığını kontrol eder

message = message.center()  # Metni ortalar
