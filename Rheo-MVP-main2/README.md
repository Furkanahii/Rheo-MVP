# 🦦 Rheo

**"Kod Okuma için Duolingo"** - Mobil kod tracing ve output tahmini oyunu.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![Status](https://img.shields.io/badge/Status-Beta%20Ready-green)]()

---

## 🎮 Özellikler

### Oyun Modları
- 📚 **Quiz** - Kod çıktısını tahmin et
- 🐛 **Bug Hunt** - Hatalı satırı bul
- ⚡ **Time Attack** - Zamana karşı yarış

### Gamification
- 🏆 **ELO Sistemi** - Dinamik puan hesaplama
- 🔥 **Streak** - Günlük seri takibi
- 🏅 **Achievements** - 10+ rozet
- 📊 **Leaderboard** - Sıralama tablosu

### Desteklenen Diller
- 🐍 Python
- 🌐 JavaScript
- ☕ Java

---

## 🛠️ Kurulum

### Flutter Uygulaması
```bash
cd rheo_app
flutter pub get
flutter run
```

### Soru Generator (Backend)
```bash
cd backend
python main.py
```

---

## 📱 Ekran Görüntüleri

| Ana Sayfa | Quiz | Leaderboard |
|:---------:|:----:|:-----------:|
| 🏠 | 📝 | 🏆 |

---

## 🏗️ Proje Yapısı

```
rheo_project/
├── backend/            # Python soru üretici
│   ├── generator/      # Soru generator modülleri
│   └── main.py
│
└── rheo_app/           # Flutter mobil uygulama
    ├── lib/
    │   ├── data/       # Modeller
    │   ├── logic/      # Servisler
    │   └── ui/         # Ekranlar
    └── assets/         # Soru JSON, maskot
```

---

## 🚀 Teknolojiler

| Kategori | Teknoloji |
|----------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Python |
| Yerel DB | Hive |
| Animasyon | Shimmer, StaggeredFade |
| UI | Glassmorphism, Dark/Neon |

---

## 📊 Durum

- [x] MVP tamamlandı
- [x] 150+ soru içeriği
- [x] Gamification sistemi
- [x] Pre-beta polish
- [ ] Alpha test
- [ ] App Store yayını

---

## 👥 Katkıda Bulunma

Pull request'ler memnuniyetle karşılanır!

---

**Rheo - Learning for Coding** 🦦

*"Kodları okumak, yazmak kadar önemlidir."*
