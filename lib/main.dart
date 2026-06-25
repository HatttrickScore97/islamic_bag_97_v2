import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مواقيت الصلاة',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Cairo',
      ),
      home: const PrayerTimesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  PrayerTimes? prayerTimes;

  @override
  void initState() {
    super.initState();
    calculatePrayerTimes();
  }

  void calculatePrayerTimes() {
    // احداثيات بغداد - غيرها لمدينتك
    final coordinates = Coordinates(33.3152, 44.3661);

    // طريقة الحساب: رابطة العالم الإسلامي
    final params = CalculationMethod.muslimWorldLeague().getParameters();
    params.madhab = Madhab.shafi; // شافعي. اذا تريد حنفي: Madhab.hanafi

    // حساب اوقات اليوم
    final prayerTimesToday = PrayerTimes.today(coordinates, params);

    setState(() {
      prayerTimes = prayerTimesToday;
    });
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget buildPrayerCard(String name, DateTime? time) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.mosque, color: Colors.green, size: 32),
        title: Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          formatTime(time),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة - بغداد'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: prayerTimes == null
         ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                calculatePrayerTimes();
              },
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  buildPrayerCard('الفجر', prayerTimes!.fajr),
                  buildPrayerCard('الشروق', prayerTimes!.sunrise),
                  buildPrayerCard('الظهر', prayerTimes!.dhuhr),
                  buildPrayerCard('العصر', prayerTimes!.asr),
                  buildPrayerCard('المغرب', prayerTimes!.maghrib),
                  buildPrayerCard('العشاء', prayerTimes!.isha),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'اسحب للاسفل للتحديث',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
