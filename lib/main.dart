import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:quran/quran.dart' as quran;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مواقيت الصلاة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Cairo',
      ),
      home: const PrayerTimesScreen(),
    );
  }
}

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  PrayerTimes getPrayerTimes() {
    // 1. احداثيات بغداد
    final coordinates = Coordinates(33.3152, 44.3661);
    
    // 2. طريقة الحساب
    final params = CalculationMethod.muslimWorldLeague();
    params.madhab = Madhab.shafi;
    
    // 3. تاريخ اليوم - الطريقة الجديدة الصحيحة
    final dateComponents = DateComponents.from(DateTime.now());
    
    // 4. حساب الاوقات - 3 باراميتر فقط، مو 7
    return PrayerTimes(
      coordinates: coordinates,
      dateComponents: dateComponents,
      calculationParameters: params,
    );
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('hh:mm a', 'ar').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final prayerTimes = getPrayerTimes();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة - بغداد'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPrayerCard('الفجر', prayerTimes.fajr),
            _buildPrayerCard('الشروق', prayerTimes.sunrise),
            _buildPrayerCard('الظهر', prayerTimes.dhuhr),
            _buildPrayerCard('العصر', prayerTimes.asr),
            _buildPrayerCard('المغرب', prayerTimes.maghrib),
            _buildPrayerCard('العشاء', prayerTimes.isha),
            const SizedBox(height: 40),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  quran.getVerse(1, 1),
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerCard(String name, DateTime? time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.access_time),
        title: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        trailing: Text(
          formatTime(time),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
