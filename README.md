# ⏰ Sağlık Saatim — Akıllı İlaç ve Sağlık Takip Uygulaması

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Local%20Notifications-FF6F00?style=for-the-badge&logo=firebase&logoColor=white" alt="Notifications" />
  <img src="https://img.shields.io/badge/PDF%20Export-E53935?style=for-the-badge&logo=adobeacrobatreader&logoColor=white" alt="PDF" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge" alt="Platforms" />
</p>

---

## 🌟 Proje Özeti (Overview)

**Sağlık Saatim**, kullanıcıların düzenli ilaç kullanım alışkanlığı kazanmasını sağlayan, doz atlamalarını engelleyen ve acil sağlık ihtiyaçlarına tek ekrandan çözüm sunan kapsamlı bir **Flutter** mobil sağlık asistanıdır.

Uygulama; saatinde çalan akıllı bildirimler, interaktif ilaç takvimi, nöbetçi eczane listesi, tek dokunuşla acil arama ve doktor kontrolleri için **PDF sağlık raporu oluşturma** özellikleriyle donatılmıştır.

---

## ✨ Temel Özellikler (Key Features)

- 🔔 **Akıllı Alarm ve Bildirim Sistemi:** İlaç saatlerinizi asla kaçırmayın. `flutter_local_notifications` ve zaman dilimi (timezone) desteği ile internet bağlantısı gerektirmeden kesin zamanlı alarmlar kurar.
- 📅 **İnteraktif İlaç Takvimi:** Hangi ilacı hangi gün ve saatte almanız gerektiğini görsel bir takvim üzerinden takip edin; dilerseniz cihazınızın kendi yerel takvimine otomatik senkronize edin.
- 💊 **Stok & Doz Takibi:** Kalan hap miktarını takip eder, ilacınız bitmeye yaklaştığında sizi uyarır.
- 🏥 **Nöbetçi Eczaneler:** En yakın nöbetçi eczaneleri hızlıca listeleyin ve doğrudan arama yapın.
- 🚨 **Acil Durum Paneli:** Acil durumlarda 112 Acil, Zehir Danışma ve tanımlı acil yakınlarınıza tek tıkla doğrudan arama başlatın.
- 📄 **Doktor İçin PDF Sağlık Raporu:** İlaç kullanım geçmişinizi, uyum oranınızı ve sağlık istatistiklerinizi tek tıkla şık bir PDF dokümanına dönüştürün veya yazdırın.
- 📊 **Kullanım İstatistikleri:** İlaçlarınızı zamanında alma başarınızı ve düzenlilik yüzdenizi grafiklerle görüntüleyin.

---

## 🛠️ Kullanılan Teknolojiler (Tech Stack)

| Kategori | Paket / Teknoloji | Açıklama |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev/) | Çapraz platform yüksek performanslı mobil arayüz geliştirme |
| **Dil** | [Dart](https://dart.dev/) | Tip güvenli modern programlama dili |
| **Bildirim & Alarm** | [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) & [timezone](https://pub.dev/packages/timezone) | Yerel, çevrimdışı ve tam zamanlı alarm/bildirim yönetimi |
| **Takvim & Etkinlik** | [table_calendar](https://pub.dev/packages/table_calendar) & [add_2_calendar](https://pub.dev/packages/add_2_calendar) | Takvim görünümü ve yerel telefon takvimi entegrasyonu |
| **Belge & Raporlama** | [pdf](https://pub.dev/packages/pdf) & [printing](https://pub.dev/packages/printing) | Vektörel PDF üretimi ve doğrudan kablosuz yazdırma |
| **Arama & Yönlendirme** | [url_launcher](https://pub.dev/packages/url_launcher) | Acil çağrılar ve harita/web yönlendirmeleri |
| **Yerel Depolama** | [shared_preferences](https://pub.dev/packages/shared_preferences) | Kullanıcı ayarları ve ilaç listelerinin cihazda saklanması |

---

## 🚀 Kurulum ve Çalıştırma (Getting Started)

Projeyi kendi ortamınızda test etmek için:

### Gereksinimler
- Flutter SDK (>= 3.0.0)
- Android Studio / VS Code
- Bir fiziksel cihaz veya emülatör

### Adımlar

1. **Repoyu Klonlayın:**
   ```bash
   git clone https://github.com/efekkoc/ilac-hatirlatici.git
   cd ilac-hatirlatici
   ```

2. **Paketleri Yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Uygulamayı Çalıştırın:**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Geliştirici (Author)

**Turgut Efekan Koç**
- GitHub: [@efekkoc](https://github.com/efekkoc)

---

## 📄 Lisans (License)
Bu proje eğitim ve kişisel portfolyo amacıyla geliştirilmiştir. Tüm hakları saklıdır.
