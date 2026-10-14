import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcilDurumSayfasi extends StatefulWidget {
  const AcilDurumSayfasi({super.key});

  @override
  State<AcilDurumSayfasi> createState() => _AcilDurumSayfasiState();
}

class _AcilDurumSayfasiState extends State<AcilDurumSayfasi> {
  final _adController = TextEditingController();
  final _kanGrubuController = TextEditingController();
  final _hastaliklarController = TextEditingController();
  final _alerjilerController = TextEditingController();
  final _yakinKisiController = TextEditingController();
  final _yakinTelefonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bilgileriYukle();
  }

  Future<void> _bilgileriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adController.text = prefs.getString('ice_ad') ?? '';
      _kanGrubuController.text = prefs.getString('ice_kan') ?? '';
      _hastaliklarController.text = prefs.getString('ice_hastalik') ?? '';
      _alerjilerController.text = prefs.getString('ice_alerji') ?? '';
      _yakinKisiController.text = prefs.getString('ice_yakin_kisi') ?? '';
      _yakinTelefonController.text = prefs.getString('ice_yakin_tel') ?? '';
    });
  }

  Future<void> _kaydet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ice_ad', _adController.text);
    await prefs.setString('ice_kan', _kanGrubuController.text);
    await prefs.setString('ice_hastalik', _hastaliklarController.text);
    await prefs.setString('ice_alerji', _alerjilerController.text);
    await prefs.setString('ice_yakin_kisi', _yakinKisiController.text);
    await prefs.setString('ice_yakin_tel', _yakinTelefonController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acil durum bilgileri kaydedildi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acil Durum (ICE) Kartı'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.red.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Bu bilgiler acil durumlarda sağlık ekipleri için hayati önem taşır.",
                        style: TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _adController,
              decoration: const InputDecoration(labelText: 'Ad Soyad', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _kanGrubuController,
              decoration: const InputDecoration(labelText: 'Kan Grubu (Örn: 0 Rh+)', prefixIcon: Icon(Icons.bloodtype), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hastaliklarController,
              decoration: const InputDecoration(labelText: 'Kronik Hastalıklar', prefixIcon: Icon(Icons.healing), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _alerjilerController,
              decoration: const InputDecoration(labelText: 'Alerjiler', prefixIcon: Icon(Icons.warning), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _yakinKisiController,
              decoration: const InputDecoration(labelText: 'Acil Durum Yakını', prefixIcon: Icon(Icons.contact_phone), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _yakinTelefonController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Acil Durum Yakını Telefonu', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _kaydet,
                icon: const Icon(Icons.save),
                label: const Text('Bilgileri Kaydet', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}