import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NobetciEczaneSayfasi extends StatelessWidget {
  const NobetciEczaneSayfasi({super.key});

  Future<void> _eczaciOdasinaGit(BuildContext context) async {
    final targetUrl = Uri.parse('https://www.istanbuleczaciodasi.org.tr/nobetci-eczane/');

    if (await canLaunchUrl(targetUrl)) {
      await launchUrl(targetUrl, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nöbetçi eczane sayfası açılamadı.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nöbetçi Eczaneler', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              shadowColor: Colors.teal.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade300, Colors.teal.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.health_and_safety_rounded, size: 56, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "İstanbul Eczacı Odası Resmi Verileri",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Resmi ve anlık nöbetçi eczane listesi doğrudan İstanbul Eczacı Odası portalından açılır.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _eczaciOdasinaGit(context),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text(
                          "Eczacı Odası Nöbetçi Listesini Aç",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}