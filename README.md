# Deprem Bilgilendirme Uygulaması

Bu proje, akademik bir mobil programlama dersi kapsamında geliştirilmiştir. AFAD üzerinden alınan son deprem verilerini listeler ve offline olarak saklayabilir.

## Not
> **Harita görselleştirmesi API gereksinimleri nedeniyle demo sürümde placeholder olarak bırakılmıştır. Uygulamanın temel işlevleri olan veri entegrasyonu, arama ve offline destek eksiksizdir.**

## Özellikler
- **Son Depremler:** AFAD API'sinden çekilen gerçek zamanlı veriler.
- **Offline Mod:** İnternet yoksa en son kaydedilen verileri gösterir (SQLite).
- **Arama:** Şehir ve ilçe bazlı, Türkçe karakter duyarlı arama.
- **Clean Architecture:** MVVM + Repository deseni.
- **State Management:** Riverpod.

## Kurulum
1. `flutter pub get`
2. `flutter run`
