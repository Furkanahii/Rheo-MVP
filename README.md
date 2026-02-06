# Rheo 🌊

**"Kod Okuma için Duolingo"** - Mobil kod tracing ve output tahmini oyunu.

## Proje Yapısı

```
rheo_project/
├── backend/         # Python soru üretici
│   ├── generator/   # Soru generator modülleri
│   ├── output/      # questions.json çıktısı
│   └── main.py      # Ana çalıştırıcı
│
└── rheo_app/        # Flutter mobil uygulama
```

## Başlangıç

### Backend (Soru Üretimi)
```bash
cd backend
python main.py
```

### Frontend (Flutter)
```bash
cd rheo_app
flutter run
```

## Teknolojiler
- **Backend:** Python 3.x
- **Frontend:** Flutter (Dart)
- **Local DB:** Hive
