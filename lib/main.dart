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
      theme: ThemeData(primarySwatch: Colors.green),
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
    final coordinates = Coordinates(33.3152, 44.3661);
    final params = CalculationMethod.muslimWorldLeague().getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimesToday = PrayerTimes.today(coordinates, params);
    setState(() {
      prayerTimes = prayerTimesToday;
    });
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget buildPrayerCard(String name, DateTime? time) {
    return Card(
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 20)),
        trailing: Text(formatTime(time), style: const TextStyle(fontSize: 22)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة - بغداد')),
      body: prayerTimes == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                buildPrayerCard('الفجر', prayerTimes!.fajr),
                buildPrayerCard('الشروق', prayerTimes!.sunrise),
                buildPrayerCard('الظهر', prayerTimes!.dhuhr),
                buildPrayerCard('العصر', prayerTimes!.asr),
                buildPrayerCard('المغرب', prayerTimes!.maghrib),
                buildPrayerCard('العشاء', prayerTimes!.isha),
              ],
            ),
    );
  }
}
