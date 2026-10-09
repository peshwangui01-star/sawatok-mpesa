import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';

List<CameraDescription> cameras = [];
const String MERCHANT_POCHI = "0180879250";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try { cameras = await availableCameras(); } catch(e){}
  runApp(SawaTokApp());
}

class SawaTokApp extends StatelessWidget {
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: MainScreen());
}

class MainScreen extends StatefulWidget {
  @override _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final pages = [ForYouPage(), LivePage(), WalletPage(), CreatorStorePage()];
  @override Widget build(BuildContext context) => Scaffold(
    body: pages[_index],
    bottomNavigationBar: BottomNavigationBar(currentIndex: _index, onTap: (i) => setState(() => _index = i), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.pink, items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: "LIVE"),
      BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
      BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
    ]),
  );
}

// --- FOR YOU WITH GIFT ANIMATION ---
class ForYouPage extends StatefulWidget {
  @override _ForYouPageState createState() => _ForYouPageState();
}
class _ForYouPageState extends State<ForYouPage> with TickerProviderStateMixin {
  List<Widget> _giftAnims = []; int _id = 0;
  void _sendGift(String emoji, String name, int amount) {
    int myCut = (amount * 0.4).toInt();
    setState(() {
      _id++;
      _giftAnims.add(GiftAnim(key: ValueKey(_id), emoji: emoji, name: name, amount: amount, onDone: () => setState(() => _giftAnims.removeWhere((w) => w.key == ValueKey(_id)))));
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.pink, content: Text("$name KSH $amount - Yako KSH $myCut (40%) -> $MERCHANT_POCHI 🎉", style: TextStyle(fontWeight: FontWeight.bold))));
  }
  @override Widget build(BuildContext context) => Stack(children: [
    PageView.builder(scrollDirection: Axis.vertical, itemCount: 10, itemBuilder: (ctx, i) => Stack(children: [
      Container(color: Colors.primaries[i % Colors.primaries.length], child: Center(child: Text("VIDEO ${i+1}\n@creator${i}", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))),
      Positioned(bottom: 100, right: 15, child: Column(children: [
        Icon(Icons.favorite, size: 35, color: Colors.white), Text("12k"), SizedBox(height: 20),
        Icon(Icons.comment, size: 35), Text("2k"), SizedBox(height: 20),
        GestureDetector(onTap: () => showModalBottomSheet(context: context, backgroundColor: Colors.black87, builder: (_) => Container(height: 280, padding: EdgeInsets.all(20), child: Column(children: [
          Text("Tuma Gift 🎁 - 40% Yako", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
          SizedBox(height: 15), Text("Pochi: $MERCHANT_POCHI", style: TextStyle(fontSize: 12, color: Colors.green)), SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_giftBtn("🌹", "Rose", 10), _giftBtn("💋", "Kiss", 50), _giftBtn("🔥", "Fire", 100)]),
          SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_giftBtn("💎", "Diamond", 500), _giftBtn("🦁", "Lion", 1000, isBig: true), _giftBtn("🚀", "Rocket", 2000, isBig: true)]),
        ]))), child: Icon(Icons.card_giftcard, size: 38, color: Colors.pink)), Text("Gift", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
      ])),
      Positioned(bottom: 20, left: 15, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("@creator${i} - AV Live", style: TextStyle(fontWeight: FontWeight.bold)), Text("SawaTok Kenya 🔥 #Live")])),
    ])),
   ..._giftAnims,
  ]);
  Widget _giftBtn(String emoji, String name, int amount, {bool isBig = false}) => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: isBig? Colors.pink : Colors.white24, padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    onPressed: () { Navigator.pop(context); _sendGift(emoji, name, amount); },
    child: Column(children: [Text(emoji, style: TextStyle(fontSize: isBig? 28 : 22)), Text(name, style: TextStyle(fontSize: 10)), Text("KSH $amount", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
  );
}

class GiftAnim extends StatefulWidget {
  final String emoji; final String name; final int amount; final VoidCallback onDone;
  GiftAnim({required Key key, required this.emoji, required this.name, required this.amount, required this.onDone}) : super(key: key);
  @override _GiftAnimState createState() => _GiftAnimState();
}
class _GiftAnimState extends State<GiftAnim> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<Offset> _move; late Animation<double> _scale;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: Duration(milliseconds: widget.amount >= 1000? 3000 : 1500));
    _move = Tween<Offset>(begin: Offset(0.5, 1.0), end: Offset(Random().nextDouble()-0.5, -0.5)).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.5, end: widget.amount >= 1000? 3.0 : 1.5).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _c.forward().whenComplete(widget.onDone);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => SlideTransition(position: _move, child: ScaleTransition(scale: _scale, child: Center(child: Column(children: [
    Text(widget.emoji, style: TextStyle(fontSize: 60)),
    Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(20)), child: Text("${widget.name} x1 - KSH ${widget.amount}", style: TextStyle(fontWeight: FontWeight.bold))),
    if(widget.amount >= 1000) Text("🦁 LION ROARS! 🔥", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow)),
  ]))));
}

// --- LIVE PAGE ---
class LivePage extends StatefulWidget { @override _LivePageState createState() => _LivePageState(); }
class _LivePageState extends State<LivePage> {
  CameraController? _controller; bool _isLive = false; bool _initing = true;
  @override void initState() { super.initState(); _setup(); }
  Future<void> _setup() async {
    if (cameras.isEmpty) { setState(() => _initing = false); return; }
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if(mounted) setState(() => _initing = false);
  }
  @override void dispose() { _controller?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    if (_initing) return Center(child: CircularProgressIndicator());
    if (_controller == null ||!_controller!.value.isInitialized) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.videocam_off, size: 80), Text("Camera kwa simu halisi tu"), ElevatedButton(onPressed: () => setState(() => _isLive =!_isLive), child: Text(_isLive? "STOP" : "GO LIVE DEMO"))]));
    return Stack(children: [
      SizedBox.expand(child: CameraPreview(_controller!)),
      Positioned(top: 40, left: 15, child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _isLive? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(20)), child: Row(children: [Icon(Icons.circle, size: 10, color: Colors.white), SizedBox(width: 5), Text(_isLive? "LIVE 1.2k" : "READY", style: TextStyle(fontWeight: FontWeight.bold))]))),
      Positioned(bottom: 30, left: 20, right: 20, child: Column(children: [if(_isLive) Container(padding: EdgeInsets.all(8), color: Colors.black54, child: Text("40% -> $MERCHANT_POCHI | 60% Creator", style: TextStyle(fontSize: 11), textAlign: TextAlign.center)), SizedBox(height: 10), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () => setState(() => _isLive =!_isLive), child: Text(_isLive? "STOP LIVE" : "🔴 GO LIVE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))])),
    ]);
  }
}

class WalletPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.account_balance_wallet, size: 80, color: Colors.green), Text("Wallet", style: TextStyle(fontSize: 24)), SizedBox(height: 20), Text("Pochi: $MERCHANT_POCHI"), Text("Balance: KSH 0"), Text("40% ya gifts + store", style: TextStyle(color: Colors.green))])); }

// --- NEW CREATOR STORE PAGE - PROFILE STORE YA CREATOR ---
class CreatorStorePage extends StatefulWidget {
  @override _CreatorStorePageState createState() => _CreatorStorePageState();
}
class _CreatorStorePageState extends State<CreatorStorePage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: Text("@AishaKenya 🔥 Store"), actions: [Icon(Icons.settings)]),
      body: Column(children: [
        // PROFILE HEADER
        Container(padding: EdgeInsets.all(15), color: Colors.black87, child: Row(children: [
          CircleAvatar(radius: 40, backgroundColor: Colors.pink, child: Text("AK", style: TextStyle(fontSize: 30))),
          SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Aisha Kenya", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("@aishakenya • AV Creator", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 5),
            Row(children: [
              Text("12.5k ", style: TextStyle(fontWeight: FontWeight.bold)), Text("Followers ", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text("89 ", style: TextStyle(fontWeight: FontWeight.bold)), Text("Videos ", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text("KSH 45k ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), Text("Earned", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ]),
            SizedBox(height: 5),
            Text("🔥 Exclusives hapa tu! Unlock na M-Pesa", style: TextStyle(fontSize: 11, color: Colors.pink)),
          ])),
        ])),
        Container(color: Colors.black, child: TabBar(controller: _tab, indicatorColor: Colors.pink, tabs: [
          Tab(text: "Videos (12)"), Tab(text: "Pics (34)"), Tab(text: "LIVE Replay"),
        ])),
        Expanded(child: TabBarView(controller: _tab, children: [
          _buildGrid(isVideo: true),
          _buildGrid(isVideo: false),
          Center(child: Text("No replay - Go LIVE sasa!")),
        ])),
        Container(padding: EdgeInsets.all(10), color: Colors.black54, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.info, size: 12, color: Colors.green), SizedBox(width: 5),
          Text("40% yako -> $MERCHANT_POCHI kwa kila mauzo", style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
        ])),
      ]),
    );
  }

  Widget _buildGrid({required bool isVideo}) {
    final items = List.generate(12, (i) => {"price": [50, 100, 200, 350, 500][i % 5], "locked": i % 3!= 0});
    return GridView.builder(padding: EdgeInsets.all(5), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 0.7), itemCount: items.length, itemBuilder: (ctx, i) {
      final item = items[i];
      final locked = item["locked"] as bool;
      final price = item["price"] as int;
      return GestureDetector(
        onTap: () {
          if (locked) {
            showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: Colors.black87, title: Text("Unlock ${isVideo? "Video" : "Pic"} ${i+1}?"), content: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(isVideo? Icons.play_circle : Icons.photo, size: 50, color: Colors.pink),
              SizedBox(height: 10),
              Text("Bei: KSH $price"),
              SizedBox(height: 5),
              Text("Yako: KSH ${(price*0.4).toInt()} (40%)", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              Text("-> $MERCHANT_POCHI", style: TextStyle(fontSize: 10, color: Colors.green)),
              SizedBox(height: 5),
              Text("Creator: KSH ${(price*0.6).toInt()} (60%)", style: TextStyle(fontSize: 11)),
            ]),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink), onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text("STK Push KSH $price kwa simu yako! Lipa na M-Pesa - Yako KSH ${(price*0.4).toInt()} -> $MERCHANT_POCHI")));
              }, child: Text("Lipa na M-Pesa KSH $price")),
            ]));
          }
        },
        child: Stack(children: [
          Container(decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8), image: DecorationImage(image: NetworkImage("https://picsum.photos/200/300?random=$i"), fit: BoxFit.cover, colorFilter: locked? ColorFilter.mode(Colors.black54, BlendMode.darken) : null))),
          if (locked) Center(child: Icon(Icons.lock, size: 30, color: Colors.white70)),
          Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3), decoration: BoxDecoration(color: locked? Colors.pink : Colors.green, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))), child: Text(locked? "KSH $price" : "UNLOCKED", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))),
          if (isVideo) Positioned(top: 5, left: 5, child: Icon(Icons.play_circle, size: 18, color: Colors.white70)),
        ]),
      );
    });
  }
}
