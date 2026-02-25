# 🦦 Rheo

**"Kod Okuma için Duolingo"** — Gamified kod öğrenme platformu. Mobil uygulama + Web Journey.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-61DAFB?style=flat&logo=react&logoColor=black)](https://react.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com)

🔗 **Live Demo:** [rheo-mvp-2026.web.app](https://rheo-mvp-2026.web.app)

---

## 🎮 Özellikler

### Oyun Modları
- 🗺️ **Learning Journey** — Duolingo-tarzı interaktif öğrenme yolu (10 chapter, 42+ node)
- 📚 **Output Prediction** — Kod çıktısını tahmin et
- 🐛 **Bug Hunter** — Hatalı satırı bul
- ⚡ **Time Attack** — Zamana karşı yarış

### Journey Egzersiz Türleri (12 tip)
- 🔍 **Read & Trace** — Kodu satır satır takip et
- 🐞 **Debug It** — Hatalı kodu bul ve düzelt
- 🧩 **Code Scramble** — Karışık satırları sırala
- 🔗 **Pair Match** — Kod-çıktı eşleştir
- ✏️ **Fill the Gap** — Eksik kodu tamamla
- 🌍 **Real World** — Gerçek dünya senaryoları
- 🎥 **Watch & Learn** — Video dersler
- 🏆 **Boss Battle** — Chapter sonu sınavları
- 🎁 **Treasure Chest** — Ödül sandıkları
- ⭐ **Daily Challenge** — Günlük görevler

### Gamification
- 🏆 **XP & Streak** — Deneyim puanı ve günlük seri
- 💎 **Gems & Hearts** — Oyun içi para birimi
- 🏅 **Achievements** — 10+ rozet
- 📊 **Leaderboard** — Sıralama tablosu
- 🦦 **Otter Mascot** — Dinamik ifadeli maskot

### Desteklenen Programlama Dilleri
- 🐍 Python
- 🌐 JavaScript
- ☕ Java

### Çoklu Dil Desteği
- 🇹🇷 Türkçe
- 🇬🇧 English

---

## 🛠️ Kurulum

### Flutter Uygulaması (Mobil + Web Ana Sayfa)
```bash
cd rheo_app
flutter pub get
flutter run
```

### Web Journey (React)
```bash
cd rheo-web
npm install
npm run dev
```

### Backend (Python Soru Üretici)
```bash
cd backend
python main.py
```

### Firebase Deploy
```bash
cd rheo_app
flutter build web --release --no-tree-shake-icons
cd ../rheo-web && npm run build
mkdir -p ../rheo_app/build/web/journey
cp -r dist/* ../rheo_app/build/web/journey/
cd ../rheo_app && firebase deploy --only hosting
```

---

## 🏗️ Proje Yapısı

```
Rheo-MVP/
├── backend/              # Python soru üretici
│   ├── generator/        # Soru generator modülleri
│   └── main.py
│
├── rheo-web/             # React Web Journey
│   ├── src/
│   │   ├── components/   # JourneyView, JourneyPath, LessonScreen...
│   │   ├── data.js       # 42 node, 183 egzersiz, 10 chapter
│   │   └── App.jsx       # Ana uygulama
│   └── vite.config.js
│
└── rheo_app/             # Flutter mobil uygulama
    ├── lib/
    │   ├── data/         # Journey data, progress, strings
    │   ├── logic/        # AI service, storage, language
    │   └── ui/           # Screens & widgets
    ├── assets/           # Soru JSON, maskot görselleri
    └── firebase.json     # Hosting config
```

---

## 🚀 Teknolojiler

| Kategori | Teknoloji |
|----------|-----------|
| Mobil | Flutter (Dart) |
| Web Journey | React + Vite + TailwindCSS |
| Animasyon | Framer Motion |
| Backend | Python |
| AI | Gemini API |
| Hosting | Firebase Hosting |
| Yerel DB | Hive |
| UI | Glassmorphism, Dark/Neon |

---

## 📊 Durum

- [x] MVP tamamlandı
- [x] 183 egzersiz, 12 farklı tip
- [x] Gamification sistemi (XP, streak, gems, hearts)
- [x] Learning Journey (10 chapter, 42+ node)
- [x] Çoklu dil desteği (TR/EN)
- [x] Firebase Hosting deployment
- [x] Web + Mobil entegrasyonu
- [ ] Alpha test
- [ ] App Store yayını

---

## 👥 Katkıda Bulunma

Pull request'ler memnuniyetle karşılanır!

---

**Rheo — Learning for Coding** 🦦

*"Kodları okumak, yazmak kadar önemlidir."*
