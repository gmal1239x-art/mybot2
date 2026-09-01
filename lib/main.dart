import 'package:flutter/material.dart';

void main() {
  runApp(const CashClipApp());
}

class CashClipApp extends StatelessWidget {
  const CashClipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashClip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121212),
        brightness: Brightness.dark,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _userPoints = 1250;
  double _userBalance = 12.50; // كل 100 نقطة = 1 دولار (كمثال)

  void _watchAdAndEarn() {
    // محاكاة مشاهدة إعلان وحساب النقاط
    setState(() {
      _userPoints += 50;
      _userBalance = _userPoints / 100;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت مشاهدة الإعلان! أضيفت 50 نقطة لرصيدك 🎉'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CashClip - كاش كليب', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black26,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // كارت الرصيد والنقاط
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('رصيدك الحالي', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text('\$$_userBalance', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                    const Divider(color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.stars, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text('$_userPoints نقطة', style: const TextStyle(fontSize: 20)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // زر مشاهدة الإعلانات
            ElevatedButton.icon(
              onPressed: _watchAdAndEarn,
              icon: const Icon(Icons.play_circle_fill, size: 30),
              label: const Text('شاهد إعلان واكسب نقاط', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),

            // زر المحفظة والسحب
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('حد السحب الأدنى هو 50\$')),
                );
              },
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text('سحب الأرباح (Wallet)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
