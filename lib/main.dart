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

class ForYouPage extends StatefulWidget {
  @override _ForYouPageState createState() => _ForYouPageState();
}
class _ForYouPageState extends State<ForYouPage> {
  List<Widget> _giftAnims = []; int _id = 0;
  void _sendGift(String emoji, String name, int amount) {
    int myCut = (amount * 0.4).toInt();
    setState(() {
      _id++;
      _giftAnims.add(GiftAnim(key: ValueKey(_id), emoji: emoji, name: name, amount: amount, onDone: () => setState(() => _giftAnims.removeWhere((w) => w.key == ValueKey(_id)))));
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.pink, content: Text("$name KSH $amount - Yako KSH $myCut (40%) -> $MERCHANT_POCHI")));
  }
  @override Widget build(BuildContext context) => Stack(children: [
    PageView.builder(scrollDirection: Axis.vertical, itemCount: 10, itemBuilder: (ctx, i) => Stack(children: [
      Container(color: Colors.primaries[i % Colors.primaries.length], child: Center(child: Text("VIDEO ${i+1}\n@creator${i}", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))),
      Positioned(bottom: 100, right: 15, child: Column(children: [
        Icon(Icons.favorite, size: 35), Text("12k"), SizedBox(height: 20),
        Icon(Icons.comment, size: 35), Text("2k"), SizedBox(height: 20),
        GestureDetector(onTap: () => showModalBottomSheet(context: context, backgroundColor: Colors.black87, builder: (_) => Container(height: 250, padding: EdgeInsets.all(20), child: Column(children: [
          Text("Tuma Gift 40% Yako", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
          SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_giftBtn("🌹", "Rose", 10), _giftBtn("💋", "Kiss", 50), _giftBtn("🔥", "Fire", 100)]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_giftBtn("💎", "Diamond", 500), _giftBtn("🦁", "Lion", 1000, isBig: true), _giftBtn("🚀", "Rocket", 2000, isBig: true)]),
        ]))), child: Icon(Icons.card_giftcard, size: 38, color: Colors.pink)), Text("Gift"),
      ])),
   ..._giftAnims,
  ]);
  Widget _giftBtn(String emoji, String name, int amount, {bool isBig=false}) => ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: isBig? Colors.pink : Colors.white24), onPressed: () { Navigator.pop(context); _sendGift(emoji, name, amount); }, child: Column(children: [Text(emoji, style: TextStyle(fontSize: isBig? 28 : 22)), Text(name, style: TextStyle(fontSize: 10)), Text("KSH $amount", style: TextStyle(fontSize: 9))]));
}
class GiftAnim extends StatefulWidget {
  final String emoji; final String name; final int amount; final VoidCallback onDone;
  GiftAnim({required Key key, required this.emoji, required this.name, required this.amount, required this.onDone}) : super(key: key);
  @override _GiftAnimState createState() => _GiftAnimState();
}
class _GiftAnimState extends State<GiftAnim> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<Offset> _move; late Animation<double> _scale;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: Duration(milliseconds: widget.amount>=1000? 3000 : 1500)); _move = Tween<Offset>(begin: Offset(0.5, 1.0), end: Offset(Random().nextDouble()-0.5, -0.5)).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut)); _scale = Tween<double>(begin: 0.5, end: widget.amount>=1000? 3.0 : 1.5).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut)); _c.forward().whenComplete(widget.onDone); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => SlideTransition(position: _move, child: ScaleTransition(scale: _scale, child: Center(child: Column(children: [Text(widget.emoji, style: TextStyle(fontSize: 60)), Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(20)), child: Text("${widget.name} KSH ${widget.amount}", style: TextStyle(fontWeight: FontWeight.bold)))]))));
}

// --- LIVE WITH SIMPLE CHAT (FIXED) ---
class LivePage extends StatefulWidget { @override _LivePageState createState() => _LivePageState(); }
class _LivePageState extends State<LivePage> {
  CameraController? _controller; bool _isLive = false; bool _initing = true;
  List<Map<String,String>> _chats = [{"user":"System","text":"Welcome to LIVE! 🔥"}];
  TextEditingController _chatCtrl = TextEditingController();
  @override void initState() { super.initState(); _setup(); }
  Future<void> _setup() async {
    if(cameras.isEmpty) { setState(() => _initing=false); return; }
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if(mounted) setState(() => _initing=false);
  }
  @override void dispose() { _controller?.dispose(); _chatCtrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    if(_initing) return Center(child: CircularProgressIndicator());
    Widget bg = (_controller==null ||!_controller!.value.isInitialized)? Container(color: Colors.grey[900], child: Center(child: Icon(Icons.videocam_off, size: 80))) : SizedBox.expand(child: CameraPreview(_controller!));
    return Stack(children: [
      bg,
      Positioned(top: 40, left: 15, child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _isLive? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(20)), child: Text(_isLive? "LIVE ${_chats.length}" : "READY", style: TextStyle(fontWeight: FontWeight.bold)))),
      Positioned(bottom: 110, left: 10, right: 80, child: Container(height: 180, child: ListView.builder(itemCount: _chats.length, itemBuilder: (ctx,i) {
        final c=_chats[i];
        return Padding(padding: EdgeInsets.symmetric(vertical: 2), child: Text.rich(TextSpan(children: [TextSpan(text: "${c["user"]}: ", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 12)), TextSpan(text: c["text"]!, style: TextStyle(fontSize: 12))])) );
      }))),
      Positioned(bottom: 10, left: 10, right: 10, child: Column(children: [
        if(_isLive) Row(children: [Expanded(child: TextField(controller: _chatCtrl, style: TextStyle(fontSize: 13), decoration: InputDecoration(hintText: "Chat...", filled: true, fillColor: Colors.black54, contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)))), SizedBox(width: 8), GestureDetector(onTap: () { if(_chatCtrl.text.trim().isEmpty) return; setState(() => _chats.add({"user":"You","text":_chatCtrl.text})); _chatCtrl.clear(); }, child: CircleAvatar(backgroundColor: Colors.pink, radius: 20, child: Icon(Icons.send, size: 18)))]),
        SizedBox(height: 10),
        Row(children: [Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () => setState(() => _isLive=!_isLive), child: Text(_isLive? "STOP LIVE" : "🔴 GO LIVE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))]),
      ])),
    ]);
  }
}

class WalletPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.wallet, size: 80, color: Colors.green), Text("Wallet KSH 0"), Text("Pochi: $MERCHANT_POCHI"), Text("40% earnings", style: TextStyle(color: Colors.green))])); }
class CreatorStorePage extends StatefulWidget { @override _CreatorStorePageState createState() => _CreatorStorePageState(); }
class _CreatorStorePageState extends State<CreatorStorePage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab=TabController(length: 2, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(backgroundColor: Colors.black, title: Text("@AishaKenya Store")), body: Column(children: [
    Container(padding: EdgeInsets.all(15), color: Colors.black87, child: Row(children: [CircleAvatar(radius: 35, backgroundColor: Colors.pink, child: Text("AK")), SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Aisha Kenya", style: TextStyle(fontWeight: FontWeight.bold)), Text("12.5k Followers | KSH 45k Earned", style: TextStyle(fontSize: 12))])])),
    TabBar(controller: _tab, indicatorColor: Colors.pink, tabs: [Tab(text: "Videos"), Tab(text: "Pics")]),
    Expanded(child: TabBarView(controller: _tab, children: [_grid(true), _grid(false)])),
  ]));
  Widget _grid(bool isVideo) => GridView.builder(padding: EdgeInsets.all(5), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 0.7), itemCount: 12, itemBuilder: (ctx,i) {
    final price=[50,100,200,350,500][i%5]; final locked=i%3!=0;
    return GestureDetector(onTap: () { if(locked) showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: Colors.black87, title: Text("Unlock? KSH $price"), content: Text("Yako: KSH ${(price*0.4).toInt()} -> $MERCHANT_POCHI"), actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink), onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("STK Push KSH $price!"))); }, child: Text("Lipa"))])); }, child: Stack(children: [
      Container(decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8), image: DecorationImage(image: NetworkImage("https://picsum.photos/200/300?random=$i"), fit: BoxFit.cover, colorFilter: locked? ColorFilter.mode(Colors.black54, BlendMode.darken) : null))),
      if(locked) Center(child: Icon(Icons.lock, size: 30, color: Colors.white70)),
      Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: EdgeInsets.symmetric(vertical: 3), color: locked? Colors.pink : Colors.green, child: Text(locked? "KSH $price" : "UNLOCKED", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))),
    ]));
  });
}
