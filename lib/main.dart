import 'package:flutter/material.dart';

void main() {
  runApp(const FoodZoneApp());
}

class FoodZoneApp extends StatelessWidget {
  const FoodZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Zone',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFA5F6F8),
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int cartCount = 0;

  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'برغر لحم دبل',
      'price': '8,000 د.ع',
      'icon': Icons.lunch_dining,
      'desc': 'لحم بقر طازج مع الجبن والصوص الخاص'
    },
    {
      'name': 'بيتزا ببروني',
      'price': '12,000 د.ع',
      'icon': Icons.local_pizza,
      'desc': 'جبن موزاريللا مع شرائح الببروني الحارة'
    },
    {
      'name': 'وجبة كريسبي',
      'price': '9,000 د.ع',
      'icon': Icons.set_meal,
      'desc': '4 قطع دجاج مقرمش مع البطاطا والثومية'
    },
    {
      'name': 'شاورما لحم عربي',
      'price': '6,000 د.ع',
      'icon': Icons.fastfood,
      'desc': 'صاج شاورما مع البطاطا والمخلل'
    },
    {
      'name': 'عصير برتقال طازج',
      'price': '2,500 د.ع',
      'icon': Icons.local_drink,
      'desc': 'عصير برتقال طبيعي 100%'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فود زون - Food Zone', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {},
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item['icon'], size: 40, color: Colors.orange),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['desc'],
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['price'],
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        cartCount++;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('إضافة', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
