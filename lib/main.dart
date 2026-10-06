import 'package:flutter/material.dart';

// SAWATOK PAYMENT CONFIG - Number hidden, name only
const String pochiNumber = "0180879250";
const String pochiFull = "254180879250";
const String businessName = "SawaTok";
const bool showNumber = false; // ficha number

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
  int _idx = 1;
  double platformBalance = 0;
  double creatorBalance = 2450;

  void addGift(double price) {
    double yourCut = price * 0.4;
    double creatorCut = price * 0.6;
    setState(() {
      platformBalance += yourCut;
      creatorBalance += creatorCut;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gift Ksh $price: You Ksh $yourCut, Creator Ksh $creatorCut - Lipa kwa $businessName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'LIVE'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
        ],
      ),
      body: _idx == 1 ? _buildLive() : _idx == 2 ? _buildWallet() : _buildHome(),
    );
  }

  Widget _buildHome() {
    return Center(child: Text('SawaTok - Karibu!', style: TextStyle(color: Colors.white, fontSize: 24)));
  }

  Widget _buildLive() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('SawaTok LIVE', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _giftBtn('Rose', 20),
                _giftBtn('Heart', 50),
                _giftBtn('Car', 500),
              ],
            ),
            SizedBox(height: 20),
            Text('Lipa kwa $businessName', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            Text('Pochi imefichwa - salama', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _giftBtn(String name, double price) {
    return ElevatedButton(
      onPressed: () => addGift(price),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: Text('$name\nKSh $price'),
    );
  }

  Widget _buildWallet() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(color: Colors.green.shade900, child: ListTile(title: Text('Your Balance (40%)', style: TextStyle(color: Colors.white)), subtitle: Text('KSh ${platformBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)), trailing: Icon(Icons.trending_up, color: Colors.green))),
            SizedBox(height: 10),
            Card(color: Colors.black87, child: ListTile(title: Text('Creator Balance (60%)', style: TextStyle(color: Colors.white)), subtitle: Text('KSh ${creatorBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), trailing: Icon(Icons.person, color: Colors.white))),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.send), label: Text('Withdraw to M-Pesa'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: EdgeInsets.all(16)))),
            SizedBox(height: 10),
            Text('Every gift: 40% to you, 60% to creator. Automated!', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text('Payments via $businessName', style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
