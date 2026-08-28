import 'package:flutter/material.dart';

void main() {
  runApp(const ZHJApp());
}

class ZHJApp extends StatelessWidget {
  const ZHJApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZHJ - المحاويل',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Cairo',
      ),
      home: const WelcomeAndHomeScreen(),
    );
  }
}

class WelcomeAndHomeScreen extends StatefulWidget {
  const WelcomeAndHomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeAndHomeScreen> createState() => _WelcomeAndHomeScreenState();
}

class _WelcomeAndHomeScreenState extends State<WelcomeAndHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
          ),
          title: const Column(
            children: [
              Text(
                '👑 ZHJ 👑',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'أهلاً وسهلاً بكم في تطبيق ZHJ',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
              'يا هلا بـ أهل الجود والكرامة، أهل المحاويل الأكارم.\n\n'
              'يسعدنا ويشرفنا انضمامكم لتطبيق ZHJ، المنصة التي صُممت بكل فخامة لتليق بأهل هذه الأرض الطيبة وناسها المنظورين بالخير والنخوة.\n\n'
              'صممنا هذا التطبيق ليكون خياركم الملكي الأسهل لطلب وجباتكم المفضلة من أفضل مطاعم المحاويل مباشرة إلى باب منزلكم.',
              style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14, height: 1.5),
              textAlign: TextAlign.right,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'تصفح التطبيق الان',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 2,
        title: const Text(
          '📍 مطاعم المحاويل',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFFD4AF37)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // التصحيح هنا
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ابحث عن مطعم أو وجبة في المحاويل...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFAA771C)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '✨ عروض حصريّة وفاخرة لأهل المحاويل اليوم! ✨',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'مطاعم المحاويل ⭐',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF333333)),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFD4AF37),
                  child: Icon(Icons.restaurant, color: Colors.black),
                ),
                title: const Text(
                  'قائمة المطاعم تضاف لاحقاً',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'توصيل مباشر من المطعم • المحاويل',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: const Text(
                  '⭐ 5.0',
                  style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
