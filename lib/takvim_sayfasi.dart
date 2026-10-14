import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakvimSayfasi extends StatefulWidget {
  final List<dynamic> ilaclar;

  const TakvimSayfasi({super.key, required this.ilaclar});

  @override
  State<TakvimSayfasi> createState() => _TakvimSayfasiState();
}

class _TakvimSayfasiState extends State<TakvimSayfasi> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  int _suMiktariMl = 0;
  final int _suHedefiMl = 2000;
  int _suSerisiGun = 0;

  String _bugunkuMood = '';
  final List<Map<String, String>> _moodListesi = const [
    {'emoji': '😊', 'etiket': 'Harika'},
    {'emoji': '🙂', 'etiket': 'İyi'},
    {'emoji': '😐', 'etiket': 'Normal'},
    {'emoji': '😔', 'etiket': 'Yorgun'},
    {'emoji': '🤒', 'etiket': 'Hasta'},
  ];

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  String _tarihAnahtari(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _verileriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _tarihAnahtari(_selectedDay ?? DateTime.now());

    setState(() {
      _suMiktariMl = prefs.getInt('su_ml_$key') ?? 0;
      _bugunkuMood = prefs.getString('mood_$key') ?? '';
      _suSerisiGun = prefs.getInt('su_serisi') ?? 0;
    });
  }

  Future<void> _suEkle(int ml) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _tarihAnahtari(_selectedDay ?? DateTime.now());
    
    setState(() {
      _suMiktariMl += ml;
    });
    
    await prefs.setInt('su_ml_$key', _suMiktariMl);

    if (_suMiktariMl >= _suHedefiMl && (_suMiktariMl - ml) < _suHedefiMl) {
      _suSerisiGun++;
      await prefs.setInt('su_serisi', _suSerisiGun);
      _odulGoster();
    }
  }

  void _odulGoster() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("🏆 TEBRİKLER!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
            const SizedBox(height: 10),
            Text(
              "Günlük 2000 ml Su Hedefine Ulaştınız!\nSu İçme Seriniz: $_suSerisiGun Gün 🎯",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Harika!"),
          ),
        ],
      ),
    );
  }

  Future<void> _suSifirla() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _tarihAnahtari(_selectedDay ?? DateTime.now());
    setState(() {
      _suMiktariMl = 0;
    });
    await prefs.setInt('su_ml_$key', 0);
  }

  void _ozelSuEkleDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("İçilen Su Miktarını Girin (ml)"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Örn: 250, 500, 1500",
            suffixText: "ml",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              final girilen = int.tryParse(controller.text);
              if (girilen != null && girilen > 0) {
                _suEkle(girilen);
              }
              Navigator.pop(ctx);
            },
            child: const Text("Ekle"),
          ),
        ],
      ),
    );
  }

  Future<void> _moodSec(String moodEmoji) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _tarihAnahtari(_selectedDay ?? DateTime.now());
    setState(() {
      _bugunkuMood = moodEmoji;
    });
    await prefs.setString('mood_$key', moodEmoji);
  }

  String _rozetGetir() {
    if (_suSerisiGun >= 7) return "🥇 Altın Hidrasyon Rozeti";
    if (_suSerisiGun >= 3) return "🥈 Gümüş Hidrasyon Rozeti";
    if (_suSerisiGun >= 1) return "🥉 Bronz Başlangıç Rozeti";
    return "🎗 Henüz Rozet Yok";
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sağlık & Takvim Takibi'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _verileriYukle();
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.teal.shade200,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "😊 Bugünkü Ruh Haliniz",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _moodListesi.map((m) {
                        final isSelected = _bugunkuMood == m['emoji'];
                        return GestureDetector(
                          onTap: () => _moodSec(m['emoji']!),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.teal.withValues(alpha: 0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.teal : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(m['emoji']!, style: const TextStyle(fontSize: 28)),
                                const SizedBox(height: 4),
                                Text(m['etiket']!, style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              color: isDarkMode ? Colors.blueGrey.shade900 : Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "💧 Su Takibi ($_suMiktariMl / $_suHedefiMl ml)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.lightBlueAccent : Colors.blue.shade900,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.grey),
                          onPressed: _suSifirla,
                          tooltip: 'Sıfırla',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Başarım: ${_rozetGetir()} (Seri: $_suSerisiGun Gün)",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.amber),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_suMiktariMl / _suHedefiMl).clamp(0.0, 1.0),
                      backgroundColor: Colors.blue.shade100,
                      color: Colors.blue,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _suEkle(250),
                            icon: const Icon(Icons.local_drink),
                            label: const Text("+250 ml"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _ozelSuEkleDialog,
                            icon: const Icon(Icons.edit),
                            label: const Text("Özel (ml)"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}