import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import 'dart:async';

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

// --- FOR YOU WITH GIFT ---
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

// --- LIVE PAGE WITH REAL-TIME CHAT ---
class ChatMessage {
  final String user; final String text; final Color color;
  ChatMessage(this.user, this.text, this.color);
}
class LivePage extends StatefulWidget { @override _LivePageState createState() => _LivePageState(); }
class _LivePageState extends State<LivePage> {
  CameraController? _controller; bool _isLive = false; bool _initing = true;
  List<ChatMessage> _chats = [ChatMessage("System", "Welcome to SawaTok LIVE! 🔥", Colors.green)];
  TextEditingController _chatCtrl = TextEditingController();
  Timer? _fakeChatTimer;
  final ScrollController _scrollCtrl = ScrollController();
  final List<String> fakeUsers = ["Brian", "Aisha", "Kevo", "Njeri", "Moses", "Shiko"];
  final List<String> fakeMsgs = ["🔥 Moto sana!", "Unafaa sana ❤️", "Tuma Lion 🦁", "Wapi store yako?", "Nimekubali!", "Kiss 💋 pls", "Nataka video yako", "KSH ngapi?"];

  @override void initState() { super.initState(); _setup(); }
  Future<void> _setup() async {
    if (cameras.isEmpty) { setState(() => _initing = false); return; }
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if(mounted) setState(() => _initing = false);
  }
  void _startLive() {
    setState(() => _isLive = true);
    _chats.add(ChatMessage("System", "You are LIVE now! Viewers wanaingia...", Colors.pink));
    // Fake real-time chats every 3 seconds
    _fakeChatTimer = Timer.periodic(Duration(seconds: 3), (t) {
      if(!_isLive) return;
      final user = fakeUsers[Random().nextInt(fakeUsers.length)];
      final msg = fakeMsgs[Random().nextInt(fakeMsgs.length)];
      setState(() => _chats.add(ChatMessage(user, msg, Colors.white)));
      _scrollDown();
    });
  }
  void _stopLive() {
    setState(() => _isLive = false);
    _fakeChatTimer?.cancel();
    _chats.add(ChatMessage("System", "LIVE imeisha. Earnings: KSH ${_chats.length*10} (40% yako)", Colors.red));
  }
  void _sendChat() {
    if(_chatCtrl.text.trim().isEmpty) return;
    setState(() => _chats.add(ChatMessage("You", _chatCtrl.text, Colors.yellow)));
    _chatCtrl.clear();
    _scrollDown();
  }
  void _scrollDown() {
    Future.delayed(Duration(milliseconds: 100), () {
      if(_scrollCtrl.hasClients) _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }
  @override void dispose() { _controller?.dispose(); _fakeChatTimer?.cancel(); _chatCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    if (_initing) return Center(child: CircularProgressIndicator());
    Widget cameraBg = (_controller == null ||!_controller!.value.isInitialized)
     ? Container(color: Colors.grey[900], child: Center(child: Icon(Icons.videocam_off, size: 80)))
      : SizedBox.expand(child: CameraPreview(_controller!));

    return Stack(children: [
      cameraBg,
      // LIVE Badge
      Positioned(top: 40, left: 15, child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _isLive? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(20)), child: Row(children: [Icon(Icons.circle, size: 10, color: Colors.white), SizedBox(width: 5), Text(_isLive? "LIVE ${_chats.length} viewers" : "READY", style: TextStyle(fontWeight: FontWeight.bold))]))),
      // Real-time Chat Overlay - Left Bottom
      Positioned(bottom: 110, left: 10, right: 80, child: Container(height: 180, child: ListView.builder(controller: _scrollCtrl, itemCount: _chats.length, itemBuilder: (ctx, i) {
        final c = _chats[i];
        return Padding(padding: EdgeInsets.symmetric(vertical: 2), child: RichText(text: TextSpan(children: [
          TextSpan(text: "${c.user}: ", style: TextStyle(color: c.color==Colors.white? Colors.pink : c.color, fontWeight: FontWeight.bold, fontSize: 12)),
          TextSpan(text: c.text, style: TextStyle(color: c.color, fontSize: 12)),
        ])));
      }))),
      // GO LIVE + Chat Input
      Positioned(bottom: 10, left: 10, right: 10, child: Column(children: [
        if(_isLive) Row(children: [
          Expanded(child: TextField(controller: _chatCtrl, style: TextStyle(fontSize: 13), decoration: InputDecoration(hintText: "Chat...", hintStyle: TextStyle(fontSize: 12), filled: true, fillColor: Colors.black54, contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)))),
          SizedBox(width: 8),
          GestureDetector(onTap: _sendChat, child: CircleAvatar(backgroundColor: Colors.pink, radius: 20, child: Icon(Icons.send, size: 18))),
        ]),
        SizedBox(height: 10),
        Row(children: [
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () => _isLive? _stopLive() : _startLive(), child: Text(_isLive? "STOP LIVE" : "🔴 GO LIVE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
          SizedBox(width: 10),
          if(!_isLive) Expanded(child: Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)), child: Text("40% -> $MERCHANT_POCHI", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)))),
        ]),
      ])),
    ]);
  }
}

class WalletPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.account_balance_wallet, size: 80, color: Colors.green), Text("Wallet", style: TextStyle(fontSize: 24)), SizedBox(height: 20), Text("Pochi: $MERCHANT_POCHI"), Text("Balance: KSH 0"), Text("40% ya gifts + store + live", style: TextStyle(color: Colors.green))])); }

class CreatorStorePage extends StatefulWidget { @override _CreatorStorePageState createState() => _CreatorStorePageState(); }
class _CreatorStorePageState extends State<CreatorStorePage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: Text("@AishaKenya 🔥 Store")),
      body: Column(children: [
        Container(padding: EdgeInsets.all(15), color: Colors.black87, child: Row(children: [
          CircleAvatar(radius: 40, backgroundColor: Colors.pink, child: Text("AK", style: TextStyle(fontSize: 30))),
          SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Aisha Kenya", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("@aishakenya • AV Creator", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 5),
            Row(children: [Text("12.5k ", style: TextStyle(fontWeight: FontWeight.bold)), Text("Followers ", style: TextStyle(color: Colors.grey, fontSize: 12)), Text("89 ", style: TextStyle(fontWeight: FontWeight.bold)), Text("Videos ", style: TextStyle(color: Colors.grey, fontSize: 12)), Text("KSH 45k ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), Text("Earned", style: TextStyle(color: Colors.grey, fontSize: 12))]),
          ])),
        ])),
        Container(color: Colors.black, child: TabBar(controller: _tab, indicatorColor: Colors.pink, tabs: [Tab(text: "Videos (12)"), Tab(text: "Pics (34)"), Tab(text: "LIVE Replay")])),
        Expanded(child: TabBarView(controller: _tab, children: [_buildGrid(isVideo: true), _buildGrid(isVideo: false), Center(child: Text("No replay - Go LIVE sasa!"))]
