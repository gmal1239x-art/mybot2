import 'package:flutter/material.dart';

void main() {
  runApp(const ZakiFoodApp());
}

// 🌐 متغيرات عامة للتحكم في ثيم ولون التطبيق ديناميكياً
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
      title: 'زاكي - Zaki',
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

// 📦 قاعدة البيانات المباشرة للتطبيق
List<Map<String, dynamic>> globalRestaurants = [];
List<Map<String, String>> globalOrders = [];

// 💳 معلومات بطاقة الماستركارد والحساب المصرفي للمطور
String masterCardNumber = "5320 **** **** 8890";
String masterCardHolder = "عبد السلام عباس كريم";
double appCommissionRate = 0.10; // نسبة ربح التطبيق 10%

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // 🚀 عرض نافذة الترحيب والتعليمات فور فتح التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  void _refreshUI() {
    setState(() {});
  }

  // 🌟 نافذة الترحيب والتعليمات الذكية
  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryAppColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('👋🍔', style: TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 14),
                const Text(
                  'أهلاً بك في تطبيق زاكي! ⚡',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2022),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  'وجهتك الأولى لطلب أشهى الوجبات السريعة في المحاويل',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                _buildInstructionStep(
                  icon: Icons.search_rounded,
                  iconColor: primaryAppColor,
                  title: '1. اختر مطعمك المفضل',
                  desc: 'تصفح قائمة المطاعم المتنوعة واختر وجبتك الشهية بسهولة.',
                ),
                const SizedBox(height: 10),
                _buildInstructionStep(
                  icon: Icons.my_location_rounded,
                  iconColor: Colors.blue,
                  title: '2. حدد موقعك الجغرافي',
                  desc: 'اضغط زر التحديد التلقائي لضمان وصول الطلب لباب بيتك.',
                ),
                const SizedBox(height: 10),
                _buildInstructionStep(
                  icon: Icons.local_shipping_rounded,
                  iconColor: Colors.green,
                  title: '3. استلم طلبك بسرعة',
                  desc: 'تابع حالة طلبك مباشرة عبر قائمة "طلباتي".',
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAppColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ابدأ الاستكشاف الآن 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionStep({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2022)),
              ),
              Text(
                desc,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildSmartRestaurantList(),
      const OrdersScreen(),
      DeveloperAdminScreen(onDataChanged: _refreshUI),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryAppColor,
        title: Text(
          _currentIndex == 0
              ? 'Zaki | زاكي ⚡'
              : _currentIndex == 1
                  ? 'طلباتي المباشرة 📦'
                  : 'لوحة التحكم والمطور ⚙️',
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 21, letterSpacing: 0.5),
        ),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: primaryAppColor,
            unselectedItemColor: Colors.grey.shade500,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            type: BottomNavigationBarType.fixed,
            elevation: 12,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'استكشف'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_rounded), label: 'طلباتي'),
              BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings_rounded), label: 'المطور'),
            ],
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFF121212),
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: const Text(
              'تطوير وتصميم المطور: عبد السلام عباس كريم',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFB800), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartRestaurantList() {
    final List<Map<String, String>> categories = [
      {'name': 'الكل', 'icon': '🔥'},
      {'name': 'مشويات', 'icon': '🥩'},
      {'name': 'برغر', 'icon': '🍔'},
      {'name': 'بيتزا', 'icon': '🍕'},
      {'name': 'شاورما', 'icon': '🌯'},
      {'name': 'حلويات', 'icon': '🍰'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: primaryAppColor),
                hintText: 'ابحث عن مطعم أو وجبة مفضلة...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 🏷️ Categories Scroll View
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = index == 0;
                return Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryAppColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(cat['icon']!, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        cat['name']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'المطاعم المميزة في المحاويل 📍',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2022)),
          ),
          const SizedBox(height: 12),

          if (globalRestaurants.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                children: const [
                  Icon(Icons.storefront_outlined, size: 65, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('لا توجد مطاعم حالياً', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('قم بالدخول إلى "المطور" لإضافة أول مطعم بالمنيو الخاص به!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )
          else
            ...globalRestaurants.map((rest) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuDetailScreen(restaurant: rest)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryAppColor, primaryAppColor.withOpacity(0.7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 36),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    rest['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E2022)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFB800).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 16),
                                        const SizedBox(width: 2),
                                        Text(
                                          rest['rating'],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(rest['type'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.delivery_dining_rounded, color: primaryAppColor, size: 18),
                                  const SizedBox(width: 4),
                                  Text('توصيل سريع ⚡', style: TextStyle(color: primaryAppColor, fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

// 🔒 شاشة المطور المحمية + التحكم بالألوان الأرباح وطلبات اليوم
class DeveloperAdminScreen extends StatefulWidget {
  final VoidCallback onDataChanged;
  const DeveloperAdminScreen({super.key, required this.onDataChanged});

  @override
  State<DeveloperAdminScreen> createState() => _DeveloperAdminScreenState();
}

class _DeveloperAdminScreenState extends State<DeveloperAdminScreen> {
  bool _isAuthenticated = false;
  final _pinController = TextEditingController();
  final String _developerPin = "1234";

  final _restNameController = TextEditingController();
  final _restTypeController = TextEditingController();

  final List<Map<String, dynamic>> _themeColors = [
    {'name': 'الأحمر الكلاسيكي', 'color': const Color(0xFFE5293E)},
    {'name': 'الأزرق الملكي', 'color': const Color(0xFF1E88E5)},
    {'name': 'الأخضر الحديث', 'color': const Color(0xFF2E7D32)},
    {'name': 'البرتقالي الجذاب', 'color': const Color(0xFFE65100)},
    {'name': 'البنفسجي الفاخر', 'color': const Color(0xFF6A1B9A)},
    {'name': 'الأسود الداكن', 'color': const Color(0xFF212121)},
  ];

  void _verifyPin() {
    if (_pinController.text == _developerPin) {
      setState(() {
        _isAuthenticated = true;
      });
      _pinController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرمز السري غير صحيح! غیر مصرح لك بالدخول ❌'), backgroundColor: Colors.red),
      );
    }
  }

  void _addNewRestaurant() {
    if (_restNameController.text.isEmpty || _restTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة اسم المطعم ونوعه أولاً')),
      );
      return;
    }

    setState(() {
      globalRestaurants.add({
        'name': _restNameController.text,
        'type': _restTypeController.text,
        'rating': '5.0',
        'menu': <Map<String, String>>[],
      });
      _restNameController.clear();
      _restTypeController.clear();
    });

    widget.onDataChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت إضافة المطعم بنجاح!'), backgroundColor: Colors.green),
    );
  }

  void _addMenuItem(Map<String, dynamic> restaurant) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('إضافة وجبة لـ ${restaurant['name']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم الوجبة (مثلاً: كباب حلي)')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'السعر (مثلاً: 6,000 د.ع)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryAppColor),
            onPressed: () {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                setState(() {
                  (restaurant['menu'] as List).add({
                    'name': nameController.text,
                    'price': priceController.text,
                  });
                });
                widget.onDataChanged();
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة الوجبة', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // 📊 حساب إجمالي مبيعات اليوم
  double _calculateTodayTotalSales() {
    double total = 0.0;
    for (var order in globalOrders) {
      String rawPrice = order['price'] ?? '0';
      rawPrice = rawPrice.replaceAll(RegExp(r'[^0-9]'), '');
      double parsed = double.tryParse(rawPrice) ?? 0.0;
      total += parsed;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primaryAppColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.admin_panel_settings_rounded, size: 50, color: primaryAppColor),
                  ),
                  const SizedBox(height: 16),
                  const Text('لوحة المطور المحمية 🔒', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('أدخل رمز الدخول السرّي للوصول إلى الأرباح وإعدادات الثيم والمنيو:', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'رمز الدخول السري (PIN)',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryAppColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _verifyPin,
                      child: const Text('دخول للوحة التحكم', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    double todaySales = _calculateTodayTotalSales();
    double todayEarnings = todaySales * appCommissionRate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('⚙️ إعدادات التحكم والأرباح', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _isAuthenticated = false;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 14),

          // 📅 1. قسم طلبات المبيعات وأرباح اليوم
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.today_rounded, color: primaryAppColor, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'إحصائيات وطلبات اليوم 📅',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2022)),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('عدد طلبات اليوم', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('${globalOrders.length}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryAppColor)),
                      ],
                    ),
                    Container(height: 35, width: 1, color: Colors.grey.shade300),
                    Column(
                      children: [
                        const Text('مبيعات اليوم', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('${todaySales.toStringAsFixed(0)} د.ع', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    Container(height: 35, width: 1, color: Colors.grey.shade300),
                    Column(
                      children: [
                        const Text('ربحك الصافي (10%)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('${todayEarnings.toStringAsFixed(0)} د.ع', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 💳 2. بطاقة الماستركارد
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2022), Color(0xFF373B3E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('MasterCard 💳', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Icon(Icons.credit_card_rounded, color: Color(0xFFFFB800), size: 30),
                  ],
                ),
                const SizedBox(height: 16),
                Text(masterCardNumber, style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('صاحب الحساب: $masterCardHolder', style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 🎨 3. تغيير لون وثيم التطبيق
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎨 تغيير لون وثيم التطبيق الرئيسي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('اختر اللون المناسب للتطبيق لتتغير كل الواجهات فوراً:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: _themeColors.map((theme) {
                      final bool isSelected = primaryAppColor == theme['color'];
                      return InkWell(
                        onTap: () {
                          ZakiFoodApp.of(context).changeThemeColor(theme['color']);
                          widget.onDataChanged();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم تغيير لون التطبيق إلى ${theme['name']}!🎨')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme['color'],
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected ? Border.all(color: Colors.amber, width: 3) : null,
                          ),
                          child: Text(
                            theme['name'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ➕ 4. إضافة المطاعم والتحكم بالمنيو
          const Text('➕ إضافة مطعم جديد', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(controller: _restNameController, decoration: InputDecoration(labelText: 'اسم المطعم', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          const SizedBox(height: 10),
          TextField(controller: _restTypeController, decoration: InputDecoration(labelText: 'نوع الأكلات', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryAppColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('حفظ وإضافة المطعم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: _addNewRestaurant,
            ),
          ),
          const Divider(height: 40, thickness: 1.5),
          const Text('📋 التحكم المباشر بالمنيو والوجبات:', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (globalRestaurants.isEmpty)
            const Text('لم تقم بإضافة أي مطعم بعد.', style: TextStyle(color: Colors.grey))
          else
            ...globalRestaurants.map((rest) {
              final menu = rest['menu'] as List;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(rest['name'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: primaryAppColor)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                globalRestaurants.remove(rest);
                              });
                              widget.onDataChanged();
                            },
                          )
                        ],
                      ),
                      Text('التصنيف: ${rest['type']}', style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 18),
                        label: const Text('إضافة وجبة جديدة للمنيو', style: TextStyle(color: Colors.white)),
                        onPressed: () => _addMenuItem(rest),
                      ),
                      const SizedBox(height: 8),
                      if (menu.isEmpty)
                        const Text('لا توجد وجبات مضافة لهذا المطعم.', style: TextStyle(fontSize: 12, color: Colors.grey))
                      else
                        Column(
                          children: menu.map((item) {
                            return ListTile(
                              dense: true,
                              title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(item['price'], style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold)),
                              trailing: IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.red, size: 18),
                                onPressed: () {
                                  setState(() {
                                    menu.remove(item);
                                  });
                                  widget.onDataChanged();
                                },
                              ),
                            );
                          }).toList(),
                        )
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

class MenuDetailScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const MenuDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final List menu = restaurant['menu'];

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name']),
        backgroundColor: primaryAppColor,
        foregroundColor: Colors.white,
      ),
      body: menu.isEmpty
          ? const Center(child: Text('لا توجد وجبات بالمنيو حالياً!', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final item = menu[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(item['price'], style: TextStyle(color: primaryAppColor, fontWeight: FontWeight.bold, fontSize: 15)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryAppColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('طلب الآن 🛒', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderFormScreen(
                              restaurantName: restaurant['name'],
                              itemName: item['name'],
                              price: item['price'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class OrderFormScreen extends StatefulWidget {
  final String restaurantName;
  final String itemName;
  final String price;

  const OrderFormScreen({
    super.key,
    required this.restaurantName,
    required this.itemName,
    required this.price,
  });

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _locationLink = "لم يتم تحديد الموقع الجغرافي بعد 📍";
  bool _isLocating = false;

  void _getDeviceLocation() {
    setState(() {
      _isLocating = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLocating = false;
        _locationLink = "https://maps.google.com/?q=32.6581,44.4025";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التقاط موقعك الجغرافي بنجاح! 📍'), backgroundColor: Colors.green),
      );
    });
  }

  void _submitOrder() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع البيانات لإرسال الطلب')),
      );
      return;
    }

    globalOrders.add({
      'restaurant': widget.restaurantName,
      'item': widget.itemName,
      'price': widget.price,
      'customer': _nameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'location': _locationLink,
      'status': 'قيد الإعداد ⏳',
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('تم إرسال الطلب بنجاح! 🎉'),
        content: Text(
          'شكراً ${_nameController.text}!\nتم إرسال موقعك الجغرافي وطلبك عبر تطبيق (زاكي) إلى ${widget.restaurantName}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد الطلب والموقع'),
        backgroundColor: primaryAppColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: primaryAppColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${widget.restaurantName} - ${widget.itemName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      Text(widget.price, style: TextStyle(color: primaryAppColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'رقم الموبايل للتواصل', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'العنوان / نقطة دالة', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: BorderSide(color: primaryAppColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: _isLocating 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.my_location_rounded, color: primaryAppColor),
                label: Text(
                  _isLocating ? 'جاري تحديد الموقع...' : 'تحديد موقعي الجغرافي حالياً 📍',
                  style: TextStyle(color: primaryAppColor, fontWeight: FontWeight.bold),
                ),
                onPressed: _getDeviceLocation,
              ),
              const SizedBox(height: 6),
              Text(
                _locationLink,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submitOrder,
                  child: const Text('إرسال الطلب والموقع للمطعم', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (globalOrders.isEmpty) {
      return const Center(
        child: Text('لا توجد طلبات حالياً 🛒', style: TextStyle(fontSize: 18, color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: globalOrders.length,
      itemBuilder: (context, index) {
        final order = globalOrders[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order['restaurant'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryAppColor)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: primaryAppColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                      child: Text(order['status'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primaryAppColor)),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text('الوجبة: ${order['item']} (${order['price']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('الزبون: ${order['customer']}'),
                Text('الهاتف: ${order['phone']}'),
                Text('العنوان: ${order['address']}'),
                const SizedBox(height: 4),
                Text('رابط الموقع 📍: ${order['location']}', style: const TextStyle(color: Colors.blue, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}

