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
      title: 'ZHJ',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'Cairo',
      ),
      home: const FullScreenWelcomeScreen(),
    );
  }
}

// 1. شاشة الترحيب الكاملة
class FullScreenWelcomeScreen extends StatelessWidget {
  const FullScreenWelcomeScreen({Key? key}) : super(key: key);

  final LinearGradient _goldGradient = const LinearGradient(
    colors: [Color(0xFFFFE57F), Color(0xFFD4AF37), Color(0xFFAA771C)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Column(
                children: [
                  const Text('👑', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 10),
                  ShaderMask(
                    shaderCallback: (bounds) => _goldGradient.createShader(bounds),
                    child: const Text(
                      'ZHJ',
                      style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: 4),
                    ),
                  ),
                  const Text('تطبيق التوصيل الملكي • المحاويل', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD4AF37)),
                ),
                child: const Column(
                  children: [
                    Text('أهلاً وسهلاً بكم في تطبيق ZHJ', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    SizedBox(height: 15),
                    Text(
                      'يا هلا بـ أهل الجود والكرامة، أهل المحاويل الأكارم.\n\n'
                      'يسعدنا ويشرفنا انضمامكم لتطبيق ZHJ، المنصة التي صُممت بكل فخامة لتليق بأهل هذه الأرض الطيبة وناسها المنظورين بالخير والنخوة.\n\n'
                      'صممنا هذا التطبيق ليكون خياركم الملكي الأسهل لطلب وجباتكم المفضلة من أفضل مطاعم المحاويل مباشرة إلى باب منزلكم.',
                      style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Container(
                  decoration: BoxDecoration(gradient: _goldGradient, borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainHomeScreen()));
                    },
                    child: const Text('تصفح التطبيق الآن ➔', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. الواجهة الرئيسية
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;
  String selectedCategory = 'الكل';

  final LinearGradient _goldGradient = const LinearGradient(
    colors: [Color(0xFFFFE57F), Color(0xFFD4AF37), Color(0xFFAA771C)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👑 ', style: TextStyle(fontSize: 22)),
            ShaderMask(
              shaderCallback: (bounds) => _goldGradient.createShader(bounds),
              child: const Text('ZHJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: 3)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // التصحيح تم هنا
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryBtn('🍔', 'مطاعم'),
                  _buildCategoryBtn('🍕', 'بيتزا'),
                  _buildCategoryBtn('🥪', 'سندويشات'),
                  _buildCategoryBtn('☕', 'كافيهات'),
                  _buildCategoryBtn('🥐', 'معجنات'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ShaderMask(
              shaderCallback: (bounds) => _goldGradient.createShader(bounds),
              child: const Text('مطاعم المحاويل 👑', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            _buildGoldRestaurantCard('مطعم الملكي للمأكولات', 'وجبات سريعة • المحاويل', '4.9'),
            const SizedBox(height: 12),
            _buildGoldRestaurantCard('مشويات وبيتزا المحاويل', 'مشويات ومعجنات • المحاويل', '4.8'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'طلباتي'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'السلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }

  Widget _buildCategoryBtn(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = label);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تصفية النتائج: $label')));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selectedCategory == label ? const Color(0xFFD4AF37) : const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD4AF37)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: selectedCategory == label ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldRestaurantCard(String name, String details, String rating) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37), width: 0.8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(backgroundColor: Color(0xFFD4AF37), child: Icon(Icons.restaurant, color: Colors.black)),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(details, style: const TextStyle(color: Colors.grey)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MealMenuScreen(restaurantName: name)));
          },
          child: const Text('عرض الوجبات'),
        ),
      ),
    );
  }
}

// 3. شاشة الوجبات مع العدادات والحسابات
class MealMenuScreen extends StatefulWidget {
  final String restaurantName;
  const MealMenuScreen({Key? key, required this.restaurantName}) : super(key: key);

  @override
  State<MealMenuScreen> createState() => _MealMenuScreenState();
}

class _MealMenuScreenState extends State<MealMenuScreen> {
  int itemCount = 0;
  int totalPrice = 0;

  void addItem(int price) {
    setState(() {
      itemCount++;
      totalPrice += price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        title: Text(widget.restaurantName, style: const TextStyle(color: Color(0xFFD4AF37))),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // التصحيح تم هنا
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                int mealPrice = (index + 1) * 2500;
                return Card(
                  color: const Color(0xFF1A1A1A),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('وجبة نموذجية رقم ${index + 1}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('$mealPrice د.ع', style: const TextStyle(color: Color(0xFFD4AF37))),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.black),
                      onPressed: () => addItem(mealPrice),
                      child: const Text('إضافة +'),
                    ),
                  ),
                );
              },
            ),
          ),
          if (itemCount > 0)
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF141414),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text('عدد الوجبات: $itemCount', style: const TextStyle(color: Colors.grey)),
                      Text('المجموع: $totalPrice د.ع', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.black),
                    onPressed: () {},
                    child: const Text('تأكيد الطلب 🛒'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

