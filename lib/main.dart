import 'package:flutter/material.dart';

// Pochi yako - HIDDEN, user haoni
const String MERCHANT_POCHI = "0180879250";
const double MY_CUT = 0.4; // 40% yako
const double CREATOR_CUT = 0.6;

void main() => runApp(SawaTokApp());

class SawaTokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SawaTok',
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final pages = [FeedPage(), LivePage(), WalletPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Store'),
        ],
      ),
    );
  }
}

// 1. FEED kama TikTok
class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(color: Colors.primaries[index % Colors.primaries.length], child: Center(child: Text("VIDEO ${index+1}\n@creator${index}", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))),
            Positioned(right: 10, bottom: 100, child: Column(
              children: [
                IconButton(icon: Icon(Icons.favorite, size: 35, color: Colors.white), onPressed: (){}),
                Text("2k"),
                SizedBox(height: 15),
                IconButton(icon: Icon(Icons.card_giftcard, size: 35, color: Colors.pink), onPressed: () => _showGifts(context)),
                Text("Gifts"),
              ],
            )),
            Positioned(left: 15, bottom: 30, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("@sawatok_creator", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("#SawaTok Live"),
            ]))
          ],
        );
      },
    );
  }

  void _showGifts(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) => Container(
      height: 250,
      color: Colors.black87,
      child: Column(children: [
        Padding(padding: EdgeInsets.all(15), child: Text("Tuma Gift - Lipa kwa SawaTok", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: GridView.count(crossAxisCount: 4, children: [
          _giftItem(context, "Rose", 10),
          _giftItem(context, "Heart", 50),
          _giftItem(context, "Lion", 100),
          _giftItem(context, "Universe", 500),
        ]))
      ]),
    ));
  }

  Widget _giftItem(BuildContext context, String name, int price) {
    double myProfit = price * MY_CUT;
    return InkWell(
      onTap: (){
        // Hapa ndio Daraja itaingia kesho
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name KSH $price - Yako: KSH $myProfit (40%) inaenda Pochi $MERCHANT_POCHI")));
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.card_giftcard, color: Colors.pink, size: 30),
        Text(name),
        Text("KSH $price", style: TextStyle(fontSize: 10, color: Colors.green)),
      ]),
    );
  }
}

class LivePage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.live_tv, size: 80, color: Colors.red), Text("AV Live 2k Viewers"), ElevatedButton(onPressed: (){}, child: Text("Go Live"))])); }
class WalletPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.account_balance_wallet, size: 80), Text("Wallet Balance: KSH 0"), SizedBox(height: 10), ElevatedButton(onPressed: (){}, child: Text("Top-up via M-Pesa STK"))])); }
class ProfilePage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 50), SizedBox(height: 10), Text("My Store - SawaTok Business"), Text("Pochi: Lipa kwa SawaTok (Hidden)") ])); }
