import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const ZakiFoodApp());
}

Color primaryAppColor = const Color(0xFFE5293E);

class ZakiFoodApp extends StatefulWidget {
  const ZakiFoodApp({super.key});

  static _ZakiFoodAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_ZakiFoodAppState>()!;

  @override
  State<ZakiFoodApp> createState() => _ZakiFoodAppState();
}

class _ZakiFoodAppState extends State<ZakiFoodApp> {
  void changeThemeColor(Color newColor) {
    setState(() {
      primaryAppColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'زكي - Zaki',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryAppColor,
          primary: primaryAppColor,
          secondary: const Color(0xFFFFB800),
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController(text: "1973");
  String _aiResponse = "";
  bool _isLoading = false;

  Future<void> _askZakiAI() async {
    if (_promptController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = "";
    });

    try {
      final apiKey = _apiKeyController.text.trim();
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final prompt = "أنت زكي، مساعد مطاعم عراقي لطيف. اقترح وجبة بناءً على: ${_promptController.text}";
      final response = await model.generateContent([Content.text(prompt)]);

      setState(() {
        _aiResponse = response.text ?? "لم يتم استلام رد، حاول مرة أخرى.";
      });
    } catch (e) {
      setState(() {
        _aiResponse = "تنبيه: تأكد من إدخال مفتاح API صحيح الخاص بـ Google Gemini.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تطبيق زكي',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryAppColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // خانة مفتاح الذكاء الاصطناعي
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'رمز/مفتاح API',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // خانة طلب/سؤال الأطعمة
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'ماذا تريد أن تأكل اليوم؟ اسأل زكي...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _askZakiAI,
              icon: const Icon(Icons.auto_awesome),
              label: Text(_isLoading ? 'جاري الاستشارة...' : 'اطلب اقتراح زكي'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryAppColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_aiResponse.isNotEmpty)
              Card(
                color: Colors.amber[50],
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _aiResponse,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

