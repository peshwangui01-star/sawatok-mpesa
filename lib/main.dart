import 'package:flutter/material.dart';

void main() => runApp(SawaTokApp());

class SawaTokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SawaTok M-Pesa',
      theme: ThemeData(primaryColor: Colors.green),
      home: MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _idx = 1; // start at LIVE
  double platformBalance = 0; // YOUR 40%
  double creatorBalance = 2450; // Creator 60%

  void addGift(double price) {
    double yourCut = price * 0.4;
    double creatorCut = price * 0.6;
    setState(() {
      platformBalance += yourCut;
      creatorBalance += creatorCut;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gift sent! You earned KSh ${yourCut.toStringAsFixed(0)} (40%) | Creator KSh ${creatorCut.toStringAsFixed(0)}'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFeed(),
      LivePage(onGift: addGift, creatorBalance: creatorBalance),
      WalletPage(platformBalance: platformBalance, creatorBalance: creatorBalance),
    ];
    return Scaffold(
      body: pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        selectedItemColor: Colors.green,
        onTap: (i) => setState(() => _idx = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: 'LIVE'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
        ],
      ),
    );
  }
}

// HOME FEED
class HomeFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SawaTok'), backgroundColor: Colors.black, foregroundColor: Colors.white),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, i) => Container(
          height: 600,
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.grey[900],
          child: Stack(children: [
            Center(child: Icon(Icons.play_circle, size: 80, color: Colors.white30)),
            Positioned(left: 10, bottom: 20, child: Text('@creator_${i+1} • Kenyan Vibes 🔥', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            Positioned(right: 10, bottom: 20, child: Column(children: [
              Icon(Icons.favorite, color: Colors.red, size: 32), Text('${(23+i)}K', style: TextStyle(color: Colors.white)),
              SizedBox(height: 10), Icon(Icons.comment, color: Colors.white, size: 32),
            ])),
          ]),
        ),
      ),
    );
  }
}

// LIVE PAGE WITH 40%
class LivePage extends StatefulWidget {
  final Function(double) onGift;
  final double creatorBalance;
  LivePage({required this.onGift, required this.creatorBalance});
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  List<String> chats = ["Amani: You are glowing today! 🔥", "Brian KE: Pole! Love from Nairobi 🇰🇪", "Zuri: First time here!"];

  final gifts = [
    {"name":"Rose","price":5.0,"icon":"🌹"},
    {"name":"Beer","price":20.0,"icon":"🍺"},
    {"name":"Lion","price":500.0,"icon":"🦁"},
    {"name":"Sawa Car","price":1000.0,"icon":"🚗"},
  ];

  void showGiftSheet() {
    showModalBottomSheet(context: context, backgroundColor: Colors.grey[900], builder: (_) => Container(
      padding: EdgeInsets.all(15),
      height: 250,
      child: Column(children: [
        Text('Send Gift - You keep 40%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Expanded(child: GridView.count(crossAxisCount: 4, children: gifts.map((g) => GestureDetector(
          onTap: (){ Navigator.pop(context); widget.onGift(g['price'] as double); setState(()=>chats.add("You sent ${g['icon']} ${g['name']}!")); },
          child: Column(children: [Text(g['icon'] as String, style: TextStyle(fontSize: 32)), Text(g['name'] as String, style: TextStyle(color: Colors.white, fontSize: 11)), Text('KSh ${g['price']}', style: TextStyle(color: Colors.green, fontSize: 10))]),
        )).toList())),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        // VIDEO PLACEHOLDER
        Container(color: Colors.grey[800], child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.videocam, size: 80, color: Colors.white24),
          Text('LIVE CAMERA\n(Will use Agora later)', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
        ]))),
        // TOP BAR
        SafeArea(child: Padding(padding: EdgeInsets.all(10), child: Row(children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)), child: Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          SizedBox(width: 8),
          Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(Icons.visibility, size: 14, color: Colors.white), SizedBox(width: 4), Text('12.4K viewers', style: TextStyle(color: Colors.white, fontSize: 12))])),
          Spacer(),
          Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: Text('KSh ${widget.creatorBalance.toStringAsFixed(0)}', style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold))),
        ]))),
        // CHAT
        Positioned(left: 10, right: 80, bottom: 90, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: chats.map((c) => Container(margin: EdgeInsets.only(bottom: 6), padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)), child: Text(c, style: TextStyle(color: Colors.white, fontSize: 12)))).toList())),
        // BOTTOM
        Positioned(left: 0, right: 0, bottom: 0, child: Container(padding: EdgeInsets.all(10), color: Colors.black87, child: Row(children: [
          Expanded(child: Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)), child: Text('Say something...', style: TextStyle(color: Colors.white70)))),
          SizedBox(width: 8),
          GestureDetector(onTap: showGiftSheet, child: Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)), child: Row(children: [Text('🎁', style: TextStyle(fontSize: 16)), SizedBox(width: 4), Text('Gift', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))),
        ]))),
      ]),
    );
  }
}

class WalletPage extends StatelessWidget {
  final double platformBalance;
  final double creatorBalance;
  WalletPage({required this.platformBalance, required this.creatorBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('M-Pesa Wallet'), backgroundColor: Colors.green),
      body: Padding(padding: EdgeInsets.all(16), child: Column(children: [
        Card(color: Colors.green[50], child: ListTile(title: Text('Your Platform Earnings (40%)'), subtitle: Text('KSh ${platformBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)), trailing: Icon(Icons.trending_up, color: Colors.green))),
        Card(color: Colors.black87, child: ListTile(title: Text('Creator Balance (60%)', style: TextStyle(color: Colors.white)), subtitle: Text('KSh ${creatorBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), trailing: Icon(Icons.person, color: Colors.white))),
        SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.send), label: Text('Withdraw to M-Pesa'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: EdgeInsets.all(16)))),
        SizedBox(height: 10),
        Text('Every gift: 40% to you, 60% to creator. Automated!', style: TextStyle(color: Colors.grey)),
      ])),
    );
  }
}
