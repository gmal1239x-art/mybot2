import 'package:flutter/material.dart';

void main() {
  runApp(const ZakiFoodApp());
}

class ZakiFoodApp extends StatelessWidget {
  const ZakiFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'زاكي - Zaki',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HomeScreen(),
    );
  }
}

List<Map<String, String>> globalOrders = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> restaurants = const [
    {
      'name': 'مطعم البركة - المحاويل',
      'type': 'مشويات ووجبات سريعة',
      'rating': '4.8',
      'menu': [
        {'name': 'كباب عراقي (نفر)', 'price': '10,000 د.ع'},
        {'name': 'قص لحم / صاج', 'price': '7,000 د.ع'},
        {'name': 'دجاج شواية كاملة', 'price': '12,000 د.ع'},
      ]
    },
    {
      'name': 'كوردن بلو - المحاويل',
      'type': 'وجبات غربية وبيتزا',
      'rating': '4.7',
      'menu': [
        {'name': 'بيتزا سوبر بريمو', 'price': '11,000 د.ع'},
        {'name': 'برغر كلاسيك دبل', 'price': '8,500 د.ع'},
        {'name': 'وجبة زِنجر مقرمش', 'price': '9,000 د.ع'},
      ]
    },
    {
      'name': 'مطعم وشاورما العمدة',
      'type': 'شاورما وسندويشات',
      'rating': '4.5',
      'menu': [
        {'name': 'شاورما لحم عربي', 'price': '6,000 د.ع'},
        {'name': 'وجبة كريسبي دجاج', 'price': '8,000 د.ع'},
        {'name': 'عصير برتقال طازج', 'price': '2,500 د.ع'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'زاكي | Zaki 🍔' : 'الطلبات المباشرة 📝',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: _currentIndex == 0 ? _buildRestaurantList() : const OrdersScreen(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.deepOrange,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.store), label: 'المطاعم'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'الطلبات المباشرة'),
            ],
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            child: const Text(
              'تطوير وتصميم المطور: جمال الحسناوي',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // كارت البانر واللوجو الفخم لـ Zaki
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orange.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2129),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu, color: Colors.amber, size: 36),
                      Text(
                        'Zaki',
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تطبيق زاكي - Zaki 🍔',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'أفضل مطاعم قضاء المحاويل بين يديك مباشرة مع التوصيل الدقيق!',
                        style: TextStyle(color: Colors.white90, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // عنوان قائمة المطاعم
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 4),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              child: Text('اختر المطعم:'),
            ),
          ),

          // عرض كروت المطاعم
          ...restaurants.map((rest) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.deepOrangeAccent,
                  child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                ),
                title: Text(rest['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                subtitle: Text('${rest['type']}\nالتقييم: ⭐ ${rest['rating']}'),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepOrange, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuDetailScreen(restaurant: rest),
                    ),
                  );
                },
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
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final item = menu[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['price'], style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                child: const Text('طلب مباشر', style: TextStyle(color: Colors.white)),
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
  String _locationLink = "لم يتم تحديد الموقع الخريطي بعد 📍";
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
        const SnackBar(content: Text('تم التقاط موقعك الجغرافي بنجاح! 📍')),
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
        title: const Text('تم تثبيت الطلب والموقع بنجاح! 🎉'),
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
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.deepOrange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${widget.restaurantName} - ${widget.itemName}', style: const TextStyle(fontWeight: FontWeight.bold))),
                      Text(widget.price, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم الموبايل للتواصل', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'العنوان / نقطة دالة قريب عليك', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Colors.deepOrange),
                ),
                icon: _isLocating 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location, color: Colors.deepOrange),
                label: Text(
                  _isLocating ? 'جاري تحديد الموقع...' : 'تحديد موقعي الجغرافي حالياً 📍',
                  style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                ),
                onPressed: _getDeviceLocation,
              ),
              const SizedBox(height: 6),
              Text(
                _locationLink,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
      padding: const EdgeInsets.all(12),
      itemCount: globalOrders.length,
      itemBuilder: (context, index) {
        final order = globalOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order['restaurant'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Text(order['status'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const Divider(),
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
