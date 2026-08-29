import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const GoldAnalysisApp());
}

class GoldAnalysisApp extends StatelessWidget {
  const GoldAnalysisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'محلل الذهب الذكي',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const GoldHomeScreen(),
    );
  }
}

class GoldHomeScreen extends StatefulWidget {
  const GoldHomeScreen({super.key});

  @override
  State<GoldHomeScreen> createState() => _GoldHomeScreenState();
}

class _GoldHomeScreenState extends State<GoldHomeScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _analysisResult = null;
      });
    }
  }

  Future<void> _analyzeChart() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      // استبدل هذا السطر بمفتاح الـ API الخاص بك من Google AI Studio
      const apiKey = 'AQ.Ab8RN6KOupu7R9vKfLgomfU0RJhDMeZRYM1dXlZ_OEgpRmhomQ';
      const url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": '''Analyze this XAU/USD chart strictly using Price Action logic.
Return ONLY valid JSON with structure:
{"trend": "Bullish/Bearish/Sideways", "pattern_detected": "", "key_levels": {"support": "", "resistance": ""}, "trade_scenario": {"action": "BUY/SELL/WAIT", "entry_price": "", "take_profit_1": "", "take_profit_2": "", "stop_loss": ""}, "brief_summary": "شرح مختصر باللغة العربية"}.'''
                },
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": base64Image
                  }
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String rawText = data['candidates'][0]['content']['parts'][0]['text'];
        final cleanJson = rawText.replaceAll('```json', '').replaceAll('```', '').trim();

        setState(() {
          _analysisResult = jsonDecode(cleanJson);
        });
      } else {
        _showError('حدث خطأ أثناء معالجة الصورة، تأكد من مفتاح الـ API.');
      }
    } catch (e) {
      _showError('خطأ في الاتصال: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محلل الذهب والشركات الذكي'),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade700, width: 1.5),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_photo_alternate, size: 50, color: Colors.amber),
                          SizedBox(height: 10),
                          Text('اضغط هنا لاختيار صورة الشارت من الاستوديو'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading || _selectedImage == null ? null : _analyzeChart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('تحليل الشارت الآن', style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            const SizedBox(height: 20),
            if (_analysisResult != null) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final scenario = _analysisResult!['trade_scenario'];
    final levels = _analysisResult!['key_levels'];
    final isBuy = scenario['action'] == 'BUY';

    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التوصية: ${scenario['action']}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isBuy ? Colors.green : Colors.red,
                  ),
                ),
                Chip(
                  label: Text(_analysisResult!['trend'] ?? ''),
                  backgroundColor: Colors.amber.shade900,
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Text('النمط المكتشف: ${_analysisResult!['pattern_detected']}'),
            const SizedBox(height: 8),
            Text('الملخص: ${_analysisResult!['brief_summary']}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _priceRow('نقطة الدخول:', scenario['entry_price']),
                  _priceRow('الهدف الأول (TP1):', scenario['take_profit_1']),
                  _priceRow('الهدف الثاني (TP2):', scenario['take_profit_2']),
                  _priceRow('وقف الخسارة (SL):', scenario['stop_loss']),
                  const Divider(color: Colors.grey),
                  _priceRow('الدعم:', levels['support']),
                  _priceRow('المقاومة:', levels['resistance']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
