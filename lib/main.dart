import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const WaselApp());
}

class WaselApp extends StatelessWidget {
  const WaselApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'واصل - المحاويل',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          brightness: Brightness.dark,
          primary: const Color(0xFFFF6B00),
          surface: const Color(0xFF1E1E1E),
        ),
        fontFamily: 'Cairo',
      ),
      home: const PhoneAuthScreen(),
    );
  }
}

typedef Restaurant = ({
  String name,
  String category,
  String rating,
  String deliveryTime,
  String deliveryFee,
  String imageEmoji,
});

final List<Restaurant> globalRestaurants = [
  (
    name: 'مطعم الملكي للمأكولات',
    category: 'مطاعم',
    rating: '4.9',
    deliveryTime: '25-35 دقيقة',
    deliveryFee: '2,000 د.ع',
    imageEmoji: '👑',
  ),
  (
    name: 'بيتزا ومعجنات المحاويل',
    category: 'بيتزا',
    rating: '4.8',
    deliveryTime: '20-30 دقيقة',
    deliveryFee: '1,500 د.ع',
    imageEmoji: '🍕',
  ),
];

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isCodeSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('🛵', style: TextStyle(fontSize: 70))),
              const SizedBox(height: 20),
              Text(
                'مرحباً بك في واصل',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _isCodeSent
                    ? 'أدخل رمز التحقق المكون من 4 أرقام'
                    : 'أدخل رقم هاتفك لتسجيل الدخول والبدء بالطلب',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),
              if (!_isCodeSent) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    prefixText: '+964 ',
                    prefixStyle: const TextStyle(
                      color: Color(0xFFFF6B00),
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                    ),
                    onPressed: () {
                      if (_phoneController.text.length >= 10) {
                        setState(() => _isCodeSent = true);
                      }
                    },
                    child: const Text(
                      'إرسال رمز التحقق',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: '• • • •',
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                    ),
                    onPressed: _requestLocationPermission,
                    child: const Text(
                      'تأكيد والدخول 🚀',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'الكل';

  void _showDevPasswordDialog() {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Row(
          children: [
            Icon(Icons.lock, color: Color(0xFFFF6B00)),
            SizedBox(width: 8),
            Text('لوحة المطور التشفيرية', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: TextField(
          controller: passController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'أدخل رمز السر (1973)',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF6B00)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
            ),
            onPressed: () {
              if (passController.text == '1973') {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DevDashboardScreen()),
                ).then((_) => setState(() {}));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('رمز السر غير صحيح ❌'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('دخول'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = switch (_selectedCategory) {
      'الكل' => globalRestaurants,
      _ => globalRestaurants.where((r) => r.category == _selectedCategory).toList(),
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('واصل • موقعك الحالي', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('المحاويل 📍', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              const SizedBox(height: 10),
              const Text('الأقسام', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('الكل', '🍽️'),
                    _buildFilterChip('مطاعم', '🍔'),
                    _buildFilterChip('بيتزا', '🍕'),
                    _buildFilterChip('كافيهات', '☕'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...filteredRestaurants.map(_buildRestaurantCard),
            ],
          ),
          const Center(child: Text('الطلبات 📦', style: TextStyle(color: Colors.grey))),
          const Center(child: Text('السلة 🛒', style: TextStyle(color: Colors.grey))),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 80, color: Color(0xFFFF6B00)),
                const SizedBox(height: 10),
                const Text('الحساب الشخصي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    side: const BorderSide(color: Color(0xFFFF6B00)),
                  ),
                  onPressed: _showDevPasswordDialog,
                  icon: const Icon(Icons.code, color: Color(0xFFFF6B00)),
                  label: const Text('إعدادات المطور ⚙️', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 40),
                const Text(
                  'DEV: JMALALHSNAWE',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: const Color(0xFFFF6B00).withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'طلباتي'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'السلة'),
          NavigationDestination(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String emoji) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text('$emoji $label'),
        selectedColor: const Color(0xFFFF6B00),
        backgroundColor: const Color(0xFF2A2A2A),
        onSelected: (_) => setState(() => _selectedCategory = label),
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(restaurant.imageEmoji, style: const TextStyle(fontSize: 35)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'التصنيف: ${restaurant.category} • التوصيل: ${restaurant.deliveryFee}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DevDashboardScreen extends StatefulWidget {
  const DevDashboardScreen({super.key});

  @override
  State<DevDashboardScreen> createState() => _DevDashboardScreenState();
}

class _DevDashboardScreenState extends State<DevDashboardScreen> {
  final nameCtrl = TextEditingController();
  final categoryCtrl = TextEditingController(text: 'مطاعم');
  final feeCtrl = TextEditingController(text: '2,000 د.ع');
  final emojiCtrl = TextEditingController(text: '🍔');

  @override
  void dispose() {
    nameCtrl.dispose();
    categoryCtrl.dispose();
    feeCtrl.dispose();
    emojiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('لوحة المطور - إضافة مطعم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إضافة مطعم جديد للقائمة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00)),
              ),
              const SizedBox(height: 15),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم المطعم', filled: true, fillColor: Color(0xFF1E1E1E))),
              const SizedBox(height: 10),
              TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'القسم (مطاعم / بيتزا / كافيهات)', filled: true, fillColor: Color(0xFF1E1E1E))),
              const SizedBox(height: 10),
              TextField(controller: feeCtrl, decoration: const InputDecoration(labelText: 'أجرة التوصيل', filled: true, fillColor: Color(0xFF1E1E1E))),
              const SizedBox(height: 10),
              TextField(controller: emojiCtrl, decoration: const InputDecoration(labelText: 'رمز الايموجي للمطعم', filled: true, fillColor: Color(0xFF1E1E1E))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF6B00)),
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty) {
                      setState(() {
                        globalRestaurants.add((
                          name: nameCtrl.text,
                          category: categoryCtrl.text,
                          rating: '5.0',
                          deliveryTime: '20-30 دقيقة',
                          deliveryFee: feeCtrl.text,
                          imageEmoji: emojiCtrl.text,
                        ));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة المطعم بنجاح! 🎉')));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('حفظ المطعم الآن 💾', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text('DEV: JMALALHSNAWE', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
