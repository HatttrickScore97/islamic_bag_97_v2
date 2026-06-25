import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:adhan_dart/adhan_dart.dart';
import 'package:intl/intl.dart';

void main() { runApp(const MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الحقيبة الإسلامية 97',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF0D1B2A),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF1B263B), foregroundColor: Color(0xFFFFD700)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    Coordinates coords = Coordinates(33.3152, 44.3661); // بغداد
    PrayerTimes prayers = PrayerTimes(coords, DateTime.now(), CalculationMethod.umm_al_qura());
    
    return Scaffold(
      appBar: AppBar(title: Text('الحقيبة الإسلامية 97'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(color: Color(0xFF1B263B), child: ListTile(
            title: Text('سورة الفاتحة', style: TextStyle(color: Color(0xFFFFD700), fontSize: 20)),
            subtitle: Text(quran.getVerse(1, 1), style: TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.right),
          )),
          SizedBox(height: 12),
          Card(color: Color(0xFF1B263B), child: ListTile(
            title: Text('الفجر', style: TextStyle(color: Color(0xFFFFD700))),
            trailing: Text(DateFormat('hh:mm a').format(prayers.fajr!), style: TextStyle(color: Colors.white, fontSize: 18)),
          )),
          Card(color: Color(0xFF1B263B), child: ListTile(
            title: Text('الظهر', style: TextStyle(color: Color(0xFFFFD700))),
            trailing: Text(DateFormat('hh:mm a').format(prayers.dhuhr!), style: TextStyle(color: Colors.white, fontSize: 18)),
          )),
          Card(color: Color(0xFF1B263B), child: ListTile(
            title: Text('العصر', style: TextStyle(color: Color(0xFFFFD700))),
            trailing: Text(DateFormat('hh:mm a').format(prayers.asr!), style: TextStyle(color: Colors.white, fontSize: 18)),
          )),
          Card(color: Color(0xFF1B263B), child: ListTile(
            title: Text('المغرب', style: TextStyle(color: Color(0xFFFFD700))),
            trailing: Text(DateFormat('hh:mm a').format(prayers.maghrib!), style: TextStyle(color: Colors.white, fontSize: 18)),
          )),
          Card(color: Color(0xFF1B263B), child: ListTile(
            title: Text('العشاء', style: TextStyle(color: Color(0xFFFFD700))),
            trailing: Text(DateFormat('hh:mm a').format(prayers.isha!), style: TextStyle(color: Colors.white, fontSize: 18)),
          )),
        ],
      ),
    );
  }
}
