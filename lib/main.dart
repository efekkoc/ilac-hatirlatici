import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/ilac_model.dart';
import 'services/notification_service.dart';
import 'ilac_ekle_modal.dart';
import 'takvim_sayfasi.dart';
import 'istatistik_sayfasi.dart';
import 'acil_durum_sayfasi.dart';
import 'nobetci_eczane_sayfasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initNotification();
  runApp(const IlacHatirlaticiApp());
}

class IlacHatirlaticiApp extends StatefulWidget {
  const IlacHatirlaticiApp({super.key});

  @override
  State<IlacHatirlaticiApp> createState() => _IlacHatirlaticiAppState();
}

class _IlacHatirlaticiAppState extends State<IlacHatirlaticiApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sağlık Saatim',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
          primary: const Color(0xFF0F766E),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14B8A6),
          brightness: Brightness.dark,
          primary: const Color(0xFF14B8A6),
        ),
        useMaterial3: true,
      ),
      home: AnaSayfa(onThemeToggle: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const AnaSayfa({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<Ilac> _ilaclar = [];

  @override
  void initState() {
    super.initState();
    _ilaclariYukle();
  }

  Future<void> _ilaclariYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ilaclarJson = prefs.getString('ilaclar');
    if (ilaclarJson != null) {
      final List<dynamic> decoded = json.decode(ilaclarJson);
      setState(() {
        _ilaclar = decoded.map((item) => Ilac.fromMap(item)).toList();
      });
    }
  }

  Future<void> _ilaclariKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_ilaclar.map((i) => i.toMap()).toList());
    await prefs.setString('ilaclar', encoded);
  }

  void _ilacEkle(Ilac ilac) {
    setState(() {
      _ilaclar.add(ilac);
    });
    _ilaclariKaydet();

    final timeParts = ilac.saat.split(':');
    final int saat = int.parse(timeParts[0]);
    final int dakika = int.parse(timeParts[1]);

    NotificationService.bildirimKur(
      id: int.parse(ilac.id.substring(ilac.id.length - 6)),
      baslik: 'Sağlık Saatim: ${ilac.isim}',
      icerik: 'Doz: ${ilac.doz} (${ilac.tokLaria})',
      saat: saat,
      dakika: dakika,
    );
  }

  void _ilacSil(int index) {
    final ilac = _ilaclar[index];
    NotificationService.bildirimIptal(int.parse(ilac.id.substring(ilac.id.length - 6)));

    setState(() {
      _ilaclar.removeAt(index);
    });
    _ilaclariKaydet();
  }

  void _durumDegistir(int index) {
    setState(() {
      final ilac = _ilaclar[index];
      ilac.alindiMi = !ilac.alindiMi;

      if (ilac.alindiMi) {
        if (ilac.stokMiktari > 0) {
          ilac.stokMiktari--;
        }
        if (ilac.stokMiktari <= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚠️ ${ilac.isim} stoğu azalıyor! Kalan: ${ilac.stokMiktari} adet'),
              backgroundColor: Colors.orange.shade900,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        ilac.stokMiktari++;
      }
    });
    _ilaclariKaydet();
  }

  void _modalAc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => IlacEkleModal(ilacEkleCallback: _ilacEkle),
    );
  }

  @override
  Widget build(BuildContext context) {
    int alinan = _ilaclar.where((i) => i.alindiMi).length;
    int toplam = _ilaclar.length;
    double oran = toplam == 0 ? 0 : alinan / toplam;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF14B8A6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.health_and_safety, color: Colors.white, size: 32),
                            SizedBox(width: 10),
                            Text(
                              "Sağlık Saatim",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: Colors.white,
                          ),
                          onPressed: widget.onThemeToggle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 54,
                                height: 54,
                                child: CircularProgressIndicator(
                                  value: oran,
                                  strokeWidth: 6,
                                  color: Colors.white,
                                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              Text(
                                "%${(oran * 100).round()}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Günlük İlaç Takibi",
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  toplam == 0
                                      ? "Henüz ilaç eklenmedi"
                                      : "$toplam İlaçtan $alinan İlaç Tamamlandı",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _hizliEylemKarti(
                      icon: Icons.local_pharmacy_rounded,
                      baslik: "Nöbetçi Eczane",
                      renk: Colors.teal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NobetciEczaneSayfasi()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _hizliEylemKarti(
                      icon: Icons.emergency_rounded,
                      baslik: "Acil Kart (ICE)",
                      renk: Colors.redAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AcilDurumSayfasi()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _hizliEylemKarti(
                      icon: Icons.bar_chart_rounded,
                      baslik: "Rapor (PDF)",
                      renk: Colors.indigo,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => IstatistikSayfasi(ilaclar: _ilaclar)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _hizliEylemKarti(
                      icon: Icons.calendar_month_rounded,
                      baslik: "Takvim & Su",
                      renk: Colors.amber.shade800,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TakvimSayfasi(ilaclar: _ilaclar)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  "Bugünkü İlaçlarım",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _ilaclar.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.medication_liquid_rounded, size: 64, color: Colors.teal),
                          SizedBox(height: 12),
                          Text(
                            "Henüz Eklenmiş İlaç Yok",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Aşağıdaki '+' butonuna basarak ilk ilacınızı ekleyin.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ilac = _ilaclar[index];
                        final stokAzMi = ilac.stokMiktari <= 5;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: ilac.alindiMi ? Colors.green : Colors.teal,
                                    width: 6,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: GestureDetector(
                                  onTap: () => _durumDegistir(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: ilac.alindiMi
                                          ? Colors.green.withValues(alpha: 0.15)
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      ilac.alindiMi ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: ilac.alindiMi ? Colors.green : Colors.grey.shade600,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  ilac.isim,
                                  style: TextStyle(
                                    decoration: ilac.alindiMi ? TextDecoration.lineThrough : null,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      _rozetteks("${ilac.saat} ⏰", Colors.teal),
                                      _rozetteks(ilac.doz, Colors.blue),
                                      _rozetteks(ilac.tokLaria, Colors.purple),
                                      _rozetteks(
                                        "Stok: ${ilac.stokMiktari}",
                                        stokAzMi ? Colors.red : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                  onPressed: () => _ilacSil(index),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _ilaclar.length,
                    ),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _modalAc,
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_rounded, size: 28),
        label: const Text("Yeni İlaç", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }

  Widget _hizliEylemKarti({
    required IconData icon,
    required String baslik,
    required Color renk,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: renk.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: renk, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                baslik,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rozetteks(String metin, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: renk.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Text(
        metin,
        style: TextStyle(color: renk, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}