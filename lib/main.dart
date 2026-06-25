 import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:quran/quran.dart' as quran;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الحقيبة الاسلامية 97',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PrayerTimes? prayerTimes;
  String currentSurah = '';
  int currentVerse = 1;

  @override
  void initState() {
    super.initState();
    calculatePrayerTimes();
    loadQuran();
  }

  void calculatePrayerTimes() {
    final coordinates = Coordinates(33.3152, 44.3661); // بغداد
    final params = CalculationMethod.muslimWorldLeague();
    params.madhab = Madhab.shafi;
    
    final date = DateTime.now();
    final dateComponents = DateComponents(date.year, date.month, date.day);
    
    setState(() {
      prayerTimes = PrayerTimes(coordinates: coordinates, dateComponents: dateComponents, calculationParameters: params);
    });
  }

  void loadQuran() {
    setState(() {
      currentSurah = quran.getSurahNameArabic(1);
    });
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الحقيبة الاسلامية 97'),
        centerTitle: true,
      ),
      body: prayerTimes == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('مواقيت الصلاة - بغداد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          PrayerTimeRow('الفجر', formatTime(prayerTimes!.fajr)),
                          PrayerTimeRow('الشروق', formatTime(prayerTimes!.sunrise)),
                          PrayerTimeRow('الظهر', formatTime(prayerTimes!.dhuhr)),
                          PrayerTimeRow('العصر', formatTime(prayerTimes!.asr)),
                          PrayerTimeRow('المغرب', formatTime(prayerTimes!.maghrib)),
                          PrayerTimeRow('العشاء', formatTime(prayerTimes!.isha)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('القرآن الكريم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Text('سورة $currentSurah', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                          Text(
                            quran.getVerse(1, currentVerse, verseEndSymbol: true),
                            style: TextStyle(fontSize: 22, fontFamily: 'Amiri'),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Row(
 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: currentVerse > 1 ? () {
                                  setState(() { currentVerse--; });
                                } : null,
                                child: Text('السابق'),
                              ),
                              ElevatedButton(
                                onPressed: currentVerse < quran.getVerseCount(1) ? () {
                                  setState(() { currentVerse++; });
                                } : null,
                                child: Text('التالي'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class PrayerTimeRow extends StatelessWidget {
  final String name;
  final String time;

  PrayerTimeRow(this.name, this.time);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 18)),
          Text(time, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
