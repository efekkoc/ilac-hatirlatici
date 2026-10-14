import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'models/ilac_model.dart';

class IlacEkleModal extends StatefulWidget {
  final Function(Ilac) ilacEkleCallback;

  const IlacEkleModal({super.key, required this.ilacEkleCallback});

  @override
  State<IlacEkleModal> createState() => _IlacEkleModalState();
}

class _IlacEkleModalState extends State<IlacEkleModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _dozController = TextEditingController();
  final TextEditingController _stokController = TextEditingController(text: '0'); // Varsayılan 0 yapıldı

  TimeOfDay _secilenSaat = TimeOfDay.now();
  String _tokLaria = 'Tok';
  final String _tekrarTipi = 'Her Gün';

  static const List<String> _ilacVeritabani = [
    'Aferin', 'Aferin Forte', 'Aferin Sinüs', 'Aktivil', 'Aprol', 'Apranax', 'Apranax Forte', 'Apranax Plus',
    'Arveles', 'Aspirin', 'Aspirin Complex', 'Advil', 'Advil Liqui-Gels', 'Anestol', 'Autodol', 'Brufen',
    'Cataflam', 'Coraspin', 'Dexpass', 'Dexfort', 'Dexalgin', 'Dolorex', 'Dolphin', 'Ecopirin', 'Etol',
    'Etol Fort', 'Fastum', 'Flexo', 'Geralgine', 'Geralgine PB', 'Geralgine Plus', 'Ibucold', 'Ibucold C',
    'Ibuprofen', 'Katarin', 'Katarin Forte', 'Katanol', 'Majezik', 'Majezik Duo', 'Minoset', 'Minoset Plus',
    'Muscoril', 'Nurofen', 'Nurofen Cold', 'Nurofen Plus', 'Panadol', 'Panadol Extra', 'Parol', 'Parol Plus',
    'Passiflora', 'Ponstan', 'Rantudil', 'Rantudil Forte', 'Sirdalud', 'Theragran', 'Theragran M', 'Tylol',
    'Tylolhot', 'Tylolhot D', 'Voltaren', 'Voltaren SR', 'Vermidon', 'Xefo', 'Xefo Rapid',
    'Alfoxil', 'Alfasilin', 'Amoklavin', 'Amoklavin BID', 'Augmentin', 'Augmentin BID', 'Azitro', 'Bactrim',
    'Bactrim Forte', 'Biteral', 'Cefaks', 'Cefatin', 'Ceftinex', 'Cefzil', 'Cipro', 'Ciprasid', 'Croxilex',
    'Croxilex BID', 'Duocid', 'Enfecto', 'Flagyl', 'Funit', 'Infex', 'Klamoks', 'Klamoks BID', 'Klacid',
    'Klimocin', 'Largopen', 'Macropen', 'Monurol', 'Nidazol', 'Ospamox', 'PenOS', 'Rulid', 'Sulcid',
    'Tavanic', 'Tetra', 'Valtrex', 'Zovirax', 'Zmax', 'Zithromax',
    'Antepsin', 'Buscopan', 'Buscopan Plus', 'Debridat', 'Dicetel', 'Emedur', 'Famodin', 'Gaviscon',
    'Gaviscon Double Action', 'Lansor', 'Lansoprol', 'Meteospasmyl', 'Metpamid', 'Motilium', 'Nexium',
    'Omeprol', 'Panto', 'Pantpas', 'Paragon', 'Pulzet', 'Rennie', 'Rennie Duo', 'Rennie Spearmint',
    'Rabelis', 'Stafine', 'Talcid', 'Tribudat', 'Ulcuran', 'Ursofalk', 'Zantac',
    'Adalat', 'Adalat Crono', 'Amlocard', 'Ator', 'Beloc', 'Beloc ZOK', 'Cardura', 'Cozaar', 'Coveram',
    'Crestor', 'Delix', 'Delix Plus', 'Diovan', 'Diovan HCT', 'Diltizem', 'Ecotrin', 'Exforge', 'Fludex',
    'Fludex SR', 'Hyzaar', 'Karvea', 'Karvezide', 'Lipitor', 'Lopresor', 'Micardis', 'Norvasc', 'Olmetec',
    'Plavix', 'Pingel', 'Rytmonorm', 'Saneloc', 'Tarka', 'Vasoxen', 'Vasoxen Plus', 'Zestril',
    'Aldactone', 'Amaryl', 'Androcur', 'Diaformin', 'Euthyrox', 'Forxiga', 'Galvus', 'Galvus Met',
    'Glucophage', 'Glucobay', 'Janumet', 'Jardiance', 'Levotiron', 'Matofin', 'Propycil', 'Rybelsus',
    'Tefor', 'Thyrozol', 'Victoza',
    'Anfranil', 'Ativan', 'Cedrina', 'Cipralex', 'Concerta', 'Depakin', 'Depakin Chrono', 'Desyrel',
    'Efexor XR', 'Gyrex', 'Lustral', 'Lyrica', 'Medikinet', 'Misol', 'Neurontin', 'Paxil', 'Prozac',
    'Redepra', 'Ritalin', 'Rivotril', 'Selectra', 'Seroquel', 'Seroquel XR', 'Tegretol', 'Tegretol CR',
    'Trileptal', 'Xanax', 'Zedprex', 'Zyprexa',
    'Aerius', 'Aircomb', 'Airsalb', 'Allerset', 'Avamys', 'Crebros', 'Deloday', 'Fixdef', 'Flixonase',
    'Foradil', 'Illordin', 'Mometix', 'Nasonex', 'Otrivin', 'Pulmicort', 'Rhinocort', 'Singulair',
    'Spiriva', 'Symbicort', 'Ventolin', 'Zyrtec',
    'Benexol B12', 'Befol', 'Calciprine', 'Calcimax', 'CoQ10', 'D-Colefor', 'Devit-3', 'Dodex',
    'Ferinject', 'Ferrum Hausmann', 'Ferrous Sanol', 'Gynoferon', 'Imunex', 'Magnesie Calcinee',
    'Magnorm', 'Ocean Balık Yağı', 'Osteocare', 'Pharmaton', 'Santafer', 'Santafer Fort', 'Solgar D3',
    'Supradyn', 'Venum Fort', 'Zinco'
  ];

  Future<void> _saatSec() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _secilenSaat,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _secilenSaat = picked;
      });
    }
  }

  // Takvim ekleme işlemi asenkron yapıldı ki arayüzü donmaya zorlamasın
  Future<void> _telefonaTakvimEtkinligiEkle(String ilacIsmi, String doz, String tokLaria) async {
    try {
      final now = DateTime.now();
      final Event event = Event(
        title: '💊 Sağlık Saatim: $ilacIsmi',
        description: 'Doz: $doz | Kullanım: $tokLaria',
        location: 'Sağlık Saatim Uygulaması',
        startDate: DateTime(now.year, now.month, now.day, _secilenSaat.hour, _secilenSaat.minute),
        endDate: DateTime(now.year, now.month, now.day, _secilenSaat.hour, _secilenSaat.minute + 15),
        iosParams: const IOSParams(reminder: Duration(minutes: 5)),
        androidParams: const AndroidParams(emailInvites: []),
      );

      await Add2Calendar.addEvent2Cal(event);
    } catch (_) {
      // Takvim ekleme desteklenmiyorsa veya iptal edildiyse hata fırlatıp uygulamayı dondurmasın
    }
  }

  void _kaydet() {
    if (_formKey.currentState!.validate()) {
      final formattedSaat =
          '${_secilenSaat.hour.toString().padLeft(2, '0')}:${_secilenSaat.minute.toString().padLeft(2, '0')}';

      final yeniIlac = Ilac(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isim: _isimController.text.trim(),
        doz: _dozController.text.trim(),
        saat: formattedSaat,
        tokLaria: _tokLaria,
        tekrarTipi: _tekrarTipi,
        stokMiktari: int.tryParse(_stokController.text) ?? 0,
        secilenGunler: const [],
        alindiMi: false,
        alinmaTarihleri: const [],
      );

      // 1. Önce ilacı kaydet
      widget.ilacEkleCallback(yeniIlac);

      // 2. Modalı anında kapat
      Navigator.pop(context);

      // 3. Takvim etkinliğini arka planda dene (Arayüzü dondurmaması için)
      _telefonaTakvimEtkinligiEkle(
        _isimController.text.trim(),
        _dozController.text.trim(),
        _tokLaria,
      );
    }
  }

  @override
  void dispose() {
    _isimController.dispose();
    _dozController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedSaatStr =
        '${_secilenSaat.hour.toString().padLeft(2, '0')}:${_secilenSaat.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Yeni İlaç Ekle",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              RawAutocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return _ilacVeritabani.where((String option) {
                    return option
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _isimController.text = selection;
                },
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                  textEditingController.addListener(() {
                    _isimController.text = textEditingController.text;
                  });
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: "İlaç Adı (Aramak için yazın...)",
                      prefixIcon: Icon(Icons.medication),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Lütfen ilaç adı girin" : null,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 180),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return ListTile(
                                leading: const Icon(Icons.search, size: 18),
                                title: Text(option),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dozController,
                      decoration: const InputDecoration(
                        labelText: "Doz (örn: 1 hap)",
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Doz girin" : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Kutu Stoğu (Adet)",
                        prefixIcon: Icon(Icons.inventory_2),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Stok girin" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                leading: const Icon(Icons.access_time),
                title: Text("Saat: $formattedSaatStr"),
                trailing: TextButton(
                  onPressed: _saatSec,
                  child: const Text("Saat Seç (24h)"),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _tokLaria,
                decoration: const InputDecoration(
                  labelText: "Açlık / Tokluk",
                  prefixIcon: Icon(Icons.restaurant),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Aç', child: Text('Aç Karnına')),
                  DropdownMenuItem(value: 'Tok', child: Text('Tok Karnına')),
                  DropdownMenuItem(value: 'Fark Etmez', child: Text('Fark Etmez')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _tokLaria = value);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _kaydet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("İlacı Kaydet", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}