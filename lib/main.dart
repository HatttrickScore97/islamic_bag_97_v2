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
      home: const PrayerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  PrayerTimes? prayerTimes;

  @override
  void initState() {
    super.initState();
    final coordinates = Coordinates(33.3152, 44.3661);
    final params = CalculationMethod.muslimWorldLeague().getParameters();
    params.madhab = Madhab.shafi;
    prayerTimes = PrayerTimes.today(coordinates, params);
  }

  String format(DateTime? t) {
    if (t == null) return '--:--';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة - بغداد')),
      body: prayerTimes == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(title: const Text('الفجر'), trailing: Text(format(prayerTimes!.fajr), style: const TextStyle(fontSize: 20))),
                ListTile(title: const Text('الشروق'), trailing: Text(format(prayerTimes!.sunrise), style: const TextStyle(fontSize: 20))),
                ListTile(title: const Text('الظهر'), trailing: Text(format(prayerTimes!.dhuhr), style: const TextStyle(fontSize: 20))),
                ListTile(title: const Text('العصر'), trailing: Text(format(prayerTimes!.asr), style: const TextStyle(fontSize: 20))),
                ListTile(title: const Text('المغرب'), trailing: Text(format(prayerTimes!.maghrib), style: const TextStyle(fontSize: 20))),
                ListTile(title: const Text('العشاء'), trailing: Text(format(prayerTimes!.isha), style: const TextStyle(fontSize: 20))),
              ],
            ),
    );
  }
}
