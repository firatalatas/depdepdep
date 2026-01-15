import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hakkında")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Uygulama Amacı",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bu proje, Türkiye'de meydana gelen son depremleri liste, harita ve arama özellikleri üzerinden hızlı ve anlaşılır bir şekilde sunmayı amaçlamaktadır.\n\nAkademik bir mobil programlama dersi projesi olarak geliştirilmiştir.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "Veri Kaynağı",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Veriler AFAD (Afet ve Acil Durum Yönetimi Başkanlığı) REST API üzerinden temin edilmektedir.",
              style: TextStyle(fontSize: 16),
            ),
             const SizedBox(height: 24),
            const Text(
              "Özellikler",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem("Koyu Tema ve Modern Arayüz"),
            _buildFeatureItem("Harita Üzerinde Görselleştirme"),
            _buildFeatureItem("Şehir/İlçe Bazlı Arama"),
            _buildFeatureItem("Offline Çalışma Desteği (SQLite)"),
            
            const Spacer(),
            const Center(
              child: Text(
                "v1.0.0",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
