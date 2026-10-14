// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'models/ilac_model.dart';

class IstatistikSayfasi extends StatelessWidget {
  final List<Ilac> ilaclar;

  const IstatistikSayfasi({super.key, required this.ilaclar});

  Future<void> _pdfRaporuOlusturVePaylas(BuildContext context) async {
    final pdf = pw.Document();

    int toplamIlac = ilaclar.length;
    int alinanIlac = ilaclar.where((i) => i.alindiMi).length;
    double oran = toplamIlac == 0 ? 0.0 : (alinanIlac / toplamIlac) * 100;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('SAGLIK SAATIM - DOKTOR OZETI VE RAPORU',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text(DateTime.now().toString().substring(0, 10)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Text('Genel Ilac Uyum Orani: %${oran.round()}',
                    style: pw.TextStyle(
                        fontSize: 13, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text('Toplam Takip Edilen Ilac: $toplamIlac'),
                pw.Text('Bugun Icinen Ilac: $alinanIlac'),
                pw.SizedBox(height: 15),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text('Aktif Ilac Listesi ve Stok Durumlari:',
                    style: pw.TextStyle(
                        fontSize: 13, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  headers: ['Ilac Adi', 'Saat', 'Doz', 'Kullanim', 'Kalan Stok'],
                  data: ilaclar.map((ilac) {
                    return [
                      ilac.isim,
                      ilac.saat,
                      ilac.doz,
                      ilac.tokLaria,
                      '${ilac.stokMiktari} Adet'
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 25),
                pw.Text(
                    '* Bu rapor Saglik Saatim uygulamasi tarafindan otomatik olusturulmustur.',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'saglik_saatim_doktor_raporu.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    int toplamIlac = ilaclar.length;
    int alinanIlac = ilaclar.where((i) => i.alindiMi).length;
    double oran = toplamIlac == 0 ? 0.0 : (alinanIlac / toplamIlac);

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlaç İstatistikleri'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _pdfRaporuOlusturVePaylas(context),
            tooltip: 'PDF Raporu İndir',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Bugünkü Uyum Oranı",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: oran,
                            strokeWidth: 12,
                            backgroundColor: Colors.teal.shade100,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          "%${(oran * 100).round()}",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem("Toplam İlaç", "$toplamIlac", Colors.blue),
                        _statItem("İçilen", "$alinanIlac", Colors.green),
                        _statItem(
                            "Kalan", "${toplamIlac - alinanIlac}", Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pdfRaporuOlusturVePaylas(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Doktor Raporu Oluştur (PDF)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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

  Widget _statItem(String baslik, String deger, Color renk) {
    return Column(
      children: [
        Text(baslik, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(deger,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: renk)),
      ],
    );
  }
}