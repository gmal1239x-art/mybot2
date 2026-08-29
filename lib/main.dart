import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ChartAnalysisApp());
}

class ChartAnalysisApp extends StatelessWidget {
  const ChartAnalysisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تحليل الشارت',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF59E0B),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
        ),
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

      const apiKey = 'AQ.Ab8RN6LGfwZzaZWZTXikto-QQH2oxW4yJVoL6a2tgrTmzREt1Q'; 
      const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Analyze this chart strictly using Price Action logic. Return ONLY valid JSON with structure: {\"trend\": \"Bullish/Bearish/Sideways\", \"pattern_detected\": \"\", \"key_levels\": {\"support\": \"\", \"resistance\": \"\"}, \"trade_setup\": {\"signal\": \"BUY/SELL/WAIT\", \"confidence_percentage\": \"85%\", \"entry\": \"\", \"stop_loss\": \"\", \"take_profit\": \"\"}, \"analysis_summary\": \"ARABIC SUMMARY\"}"
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
        final String textResult = data['candidates'][0]['content']['parts'][0]['text'];
        final cleanJson = textResult.replaceAll('```json', '').replaceAll('```', '').trim();
        setState(() {
          _analysisResult = jsonDecode(cleanJson);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ من الـ API: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء معالجة الصورة: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة فتح تطبيق MetaTrader 5 على الموبايل
  Future<void> _openMT5App() async {
    final Uri url = Uri.parse('metatrader5://');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تطبيق MetaTrader 5 غير مثبت على هذا الجهاز.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى فتح تطبيق MT5 يدويًا.')),
      );
    }
  }

  // دالة نسخ تفاصيل الصفقة
  void _copyTradeDetails() {
    if (_analysisResult == null) return;
    final setup = _analysisResult!['trade_setup'];
    final textToCopy = "إشارة: ${setup['signal']}\nالدخول: ${setup['entry']}\nالهدف (TP): ${setup['take_profit']}\nالوقف (SL): ${setup['stop_loss']}";
    
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ تفاصيل الصفقة إلى الحافظة!')),
    );
  }

  Color _getSignalColor(String? signal) {
    if (signal == 'BUY') return const Color(0xFF10B981);
    if (signal == 'SELL') return const Color(0xFFEF4444);
    return const Color(0xFFF59E0B);
  }

  IconData _getSignalIcon(String? signal) {
    if (signal == 'BUY') return Icons.trending_up_rounded;
    if (signal == 'SELL') return Icons.trending_down_rounded;
    return Icons.remove_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final signal = _analysisResult?['trade_setup']?['signal'];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_graph_rounded, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('تحليل الشارت', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF334155), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                            ),
                            child: const Icon(Icons.add_photo_alternate_rounded, size: 48, color: Color(0xFFF59E0B)),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'إدراج صورة الشارت للتحليل',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'يدعم منصات TradingView و MT4 و MT5',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeChart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.psychology_rounded, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'تحليل الشارت بواسطة AI',
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),

            if (_analysisResult != null) ...[
              Card(
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: _getSignalColor(signal), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(_getSignalIcon(signal), color: _getSignalColor(signal), size: 30),
                              const SizedBox(width: 8),
                              Text(
                                'القرار: ${signal ?? 'WAIT'}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: _getSignalColor(signal),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFF59E0B)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_rounded, size: 16, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 6),
                                Text(
                                  'الدقة: ${_analysisResult!['trade_setup']?['confidence_percentage'] ?? 'N/A'}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF334155), height: 30),
                      _buildInfoRow(Icons.show_chart_rounded, 'الاتجاه العام', _analysisResult!['trend'] ?? ''),
                      _buildInfoRow(Icons.candlestick_chart_rounded, 'النموذج الفني', _analysisResult!['pattern_detected'] ?? ''),
                      _buildInfoRow(
                        Icons.layers_rounded,
                        'الدعم والمقاومة',
                        'دعم: ${_analysisResult!['key_levels']?['support']} | مقاومة: ${_analysisResult!['key_levels']?['resistance']}',
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFF334155)),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.login_rounded, 'سعر الدخول', _analysisResult!['trade_setup']?['entry'] ?? ''),
                      _buildInfoRow(
                        Icons.shield_rounded,
                        'وقف الخسارة (SL)',
                        _analysisResult!['trade_setup']?['stop_loss'] ?? '',
                        textColor: const Color(0xFFEF4444),
                      ),
                      _buildInfoRow(
                        Icons.ads_click_rounded,
                        'جني الأرباح (TP)',
                        _analysisResult!['trade_setup']?['take_profit'] ?? '',
                        textColor: const Color(0xFF10B981),
                      ),
                      const Divider(color: Color(0xFF334155), height: 30),
                      Row(
                        children: const [
                          Icon(Icons.description_rounded, color: Color(0xFFF59E0B), size: 20),
                          SizedBox(width: 8),
                          Text('رأي الذكاء الاصطناعي:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _analysisResult!['analysis_summary'] ?? '',
                        style: const TextStyle(color: Colors.white70, height: 1.4),
                      ),
                      if (signal == 'BUY' || signal == 'SELL') ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _copyTradeDetails,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFF59E0B)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.copy_rounded, color: Color(0xFFF59E0B)),
                                label: const Text('نسخ البيانات', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _openMT5App,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getSignalColor(signal),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.launch_rounded, color: Colors.white),
                                label: const Text('فتح MT5', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, {Color textColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white54),
          const SizedBox(width: 8),
          Text('$title: ', style: const TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

