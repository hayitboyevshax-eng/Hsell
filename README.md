# HSELL — Onlayn bozor (Flutter)

## Ishga tushirish
```bash
flutter create --platforms=android,ios .   # platforma papkalarini yaratadi (lib/ va pubspec.yaml o'zgarmaydi)
flutter pub get
flutter run
```
Eslatma: `flutter create .` lib/main.dart ni almashtirib yuborsa, zipdagi asl main.dart ni qayta joylang.

## APK
```bash
flutter build apk --release --split-per-abi
```

## GitHub Actions
`.github/workflows/build.yml` — push/PR da APK yig'adi (Artifacts).
`git tag v1.0.0 && git push origin v1.0.0` — GitHub Release yaratadi.

## Tuzilma
- lib/main.dart — kirish nuqtasi
- lib/theme.dart — ranglar va tipografiya
- lib/data.dart — modellar, mahsulotlar, holat (savat, sevimlilar)
- lib/ui.dart — umumiy vidjetlar (tugma, yurakcha, karta, grid)
- lib/screens/ — welcome, shell, home, category, detail, cart, profile
