import 'dart:convert';

class Ilac {
  final String id;
  final String isim;
  final String saat;
  final String doz;
  final String tokLaria;
  final String tekrarTipi;
  final List<String> secilenGunler;
  bool alindiMi;
  List<String> alinmaTarihleri;
  int stokMiktari;

  Ilac({
    required this.id,
    required this.isim,
    required this.saat,
    required this.doz,
    required this.tokLaria,
    this.tekrarTipi = 'Her Gün',
    this.secilenGunler = const [],
    this.alindiMi = false,
    this.alinmaTarihleri = const [],
    this.stokMiktari = 30,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isim': isim,
      'saat': saat,
      'doz': doz,
      'tokLaria': tokLaria,
      'tekrarTipi': tekrarTipi,
      'secilenGunler': secilenGunler,
      'alindiMi': alindiMi,
      'alinmaTarihleri': alinmaTarihleri,
      'stokMiktari': stokMiktari,
    };
  }

  factory Ilac.fromMap(Map<String, dynamic> map) {
    return Ilac(
      id: map['id'] ?? '',
      isim: map['isim'] ?? '',
      saat: map['saat'] ?? '',
      doz: map['doz'] ?? '',
      tokLaria: map['tokLaria'] ?? '',
      tekrarTipi: map['tekrarTipi'] ?? 'Her Gün',
      secilenGunler: List<String>.from(map['secilenGunler'] ?? []),
      alindiMi: map['alindiMi'] ?? false,
      alinmaTarihleri: List<String>.from(map['alinmaTarihleri'] ?? []),
      stokMiktari: map['stokMiktari'] ?? 30,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ilac.fromJson(String source) => Ilac.fromMap(json.decode(source));
}