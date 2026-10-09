import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';

List<CameraDescription> cameras=[];
const String MERCHANT_POCHI="0180879250";

Future<void> main() async {WidgetsFlutterBinding.ensureInitialized(); try{cameras=await availableCameras();}catch(e){} runApp(SawaTokApp());}

class SawaTokApp extends StatelessWidget {
  @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: MainScreen());
}

class MainScreen extends StatefulWidget {@override _MainScreenState createState()=>_MainScreenState();}
class _MainScreenState extends State<MainScreen>{
  int _index=0;
  final pages=[ForYouPage(), LivePage(), WalletPage()];
  @override Widget build(BuildContext context)=>Scaffold(
    body: pages[_index],
    bottomNavigationBar: BottomNavigationBar(currentIndex: _index, onTap: (i)=>setState(()=>_index=i), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.pink, backgroundColor: Colors.black, items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: "LIVE"),
      BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
    ]),
  );
}

// GIFT ANIMATION WIDGET
class GiftAnim extends StatefulWidget {
  final String emoji; final String name; final int amount; final VoidCallback onDone;
  GiftAnim({required Key key, required this.emoji, required this.name, required this.amount, required this.onDone}) : super(key: key);
  @override _GiftAnimState createState()=>_GiftAnimState();
}
class _GiftAnimState extends State<GiftAnim> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<Offset> _move;
  late Animation<double> _scale;
  late Animation<double> _fade;
  @override void initState(){
    super.initState();
    _c=AnimationController(vsync: this, duration: Duration(milliseconds: widget.amount>=1000? 3500 : 1800));
    _move=Tween<Offset>(begin: Offset(0.3, 1.2), end: Offset(Random().nextDouble()-0.5, -0.6)).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _scale=Tween<double>(begin: 0.5, end: widget.amount>=1000? 3.5 : 1.8).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _fade=Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _c, curve: Interval(0.7, 1.0)));
    _c.forward().whenComplete(widget.onDone);
  }
  @override void dispose(){ _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context)=>FadeTransition(opacity: _fade, child: SlideTransition(position: _move, child: ScaleTransition(scale: _scale, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Text(widget.emoji, style: TextStyle(fontSize: widget.amount>=1000? 80 : 60)),
    Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.pinkAccent, blurRadius: 15)]), child: Text("${widget.name} KSH ${widget.amount}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.amount>=1000? 16 : 12))),
    if(widget.amount>=1000) Padding(padding: EdgeInsets.only(top: 5), child: Text("🔥 LEGENDARY! 🔥", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow, fontSize: 12))),
  ]))))));
}

// FOR YOU PAGE
class ForYouPage extends StatefulWidget {@override _ForYouPageState createState()=>_ForYouPageState();}
class _ForYouPageState extends State<ForYouPage>{
  List<int> likes=[12500,13200,9800,15000,11000,12300,14200,10800,13500,11800];
  List<bool> isLiked=[false,false,false,false,false,false,false,false,false,false];
  List<bool> isFollowing=[false,false,false,false,false,false,false,false,false,false];
  List<List<String>> comments=[["Moto! 🔥","Nice!"],["Unafaa ❤️"],["Wapi store?"],["🔥🔥🔥"],["Sawa sana"],["❤️❤️"],["Poa!"],["Best!"],["Love it"],["Top!"]];
  List<Widget> _giftAnims=[]; int _giftId=0;

  void _sendGift(String emoji, String name, int amount){
    int myCut=(amount*0.4).toInt();
    setState((){
      _giftId++;
      _giftAnims.add(GiftAnim(key: ValueKey(_giftId), emoji: emoji, name: name, amount: amount, onDone: ()=>setState(()=>_giftAnims.removeWhere((w)=>w.key==ValueKey(_giftId)))));
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: amount>=1000? Colors.orange : Colors.pink, duration: Duration(seconds: 2), content: Text("$name KSH $amount! Yako KSH $myCut (40%) -> $MERCHANT_POCHI", style: TextStyle(fontWeight: FontWeight.bold))));
  }

  void _showGiftSheet(){
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, builder: (_)=>Container(height: 300, padding: EdgeInsets.all(15), child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
      SizedBox(height: 8),
      Text("Tuma Gift - 40% Yako!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink, fontSize: 16)),
      Text("Pochi: $MERCHANT_POCHI", style: TextStyle(fontSize: 10, color: Colors.green)),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_giftBtn("🌹","Rose",10), _giftBtn("💋","Kiss",50), _giftBtn("🔥","Fire",100)]),
      SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_giftBtn("💎","Diamond",500), _giftBtn("🦁","Lion",1000, big:true), _giftBtn("🚀","Rocket",2000, big:true)]),
    ])));
  }

  Widget _giftBtn(String emoji, String name, int price, {bool big=false})=>ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: big? Colors.pink : Colors.white12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)), onPressed: (){ Navigator.pop(context); _sendGift(emoji,name,price); }, child: Column(children: [Text(emoji, style: TextStyle(fontSize: big? 30 : 24)), Text(name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), Text("KSH $price", style: TextStyle(fontSize: 9, color: Colors.greenAccent)), Text("Yako ${ (price*0.4).toInt()}", style: TextStyle(fontSize: 8, color: Colors.yellow))]));

  void _showComments(int i){
    TextEditingController c=TextEditingController();
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, isScrollControlled: true, builder: (_)=>Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: Container(height: 380, padding: EdgeInsets.all(15), child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
      SizedBox(height: 10), Text("${comments[i].length} Comments", style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(child: ListView.builder(itemCount: comments[i].length, itemBuilder: (ctx,j)=>ListTile(leading: CircleAvatar(radius: 14, backgroundColor: Colors.pink, child: Text("U$j", style: TextStyle(fontSize: 10))), title: Text(comments[i][j], style: TextStyle(fontSize: 13))))),
      Row(children: [Expanded(child: TextField(controller: c, decoration: InputDecoration(hintText: "Add comment...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)))), SizedBox(width: 6), GestureDetector(onTap: (){ if(c.text.isNotEmpty){ setState(()=>comments[i].add(c.text)); c.clear(); Navigator.pop(context); _showComments(i); } }, child: CircleAvatar(backgroundColor: Colors.pink, radius: 18, child: Icon(Icons.send, size: 16)))])
    ]))));
  }

  @override Widget build(BuildContext context){
    return Stack(children: [
      PageView.builder(scrollDirection: Axis.vertical, itemCount: 10, itemBuilder: (ctx,i)=>Container(color: Colors.primaries[i%Colors.primaries.length][800], child: Stack(children: [
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("VIDEO ${i+1}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), Text("@creator$i", style: TextStyle(fontSize: 18)), SizedBox(height: 10), Text("SawaTok Kenya 🔥", style: TextStyle(color: Colors.white70))])),
        Positioned(bottom: 20, left: 12, right: 80, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [CircleAvatar(backgroundColor: Colors.pink, radius: 18, child: Text("C$i", style: TextStyle(fontSize: 12))), SizedBox(width: 6), Text("@creator$i", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), SizedBox(width: 6), GestureDetector(onTap: ()=>setState(()=>isFollowing[i]=!isFollowing[i]), child: Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: isFollowing[i]? Colors.white24 : Colors.pink, borderRadius: BorderRadius.circular(4)), child: Text(isFollowing[i]? "Following" : "Follow", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))))]),
          SizedBox(height: 4), Text("Niko LIVE 8PM! Tuma Gift 🦁 #SawaTok", style: TextStyle(fontSize: 11))
        ])),
        Positioned(bottom: 70, right: 8, child: Column(children: [
          GestureDetector(onTap: ()=>setState((){ isLiked[i]=!isLiked[i]; likes[i]+= isLiked[i]? 1 : -1; }), child: Column(children: [Icon(Icons.favorite, size: 36, color: isLiked[i]? Colors.red : Colors.white), Text("${(likes[i]/1000).toStringAsFixed(1)}k", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))])),
          SizedBox(height: 16),
          GestureDetector(onTap: ()=>_showComments(i), child: Column(children: [Icon(Icons.chat_bubble, size: 32), Text("${comments[i].length}", style: TextStyle(fontSize: 11))])),
          SizedBox(height: 16),
          GestureDetector(onTap: _showGiftSheet, child: Column(children: [Icon(Icons.card_giftcard, size: 34, color: Colors.pink), Text("Gift", style: TextStyle(fontSize: 10, color: Colors.pink, fontWeight: FontWeight.bold))])),
          SizedBox(height: 16),
          Icon(Icons.share, size: 30), Text("Share", style: TextStyle(fontSize: 10))
        ]))
      ]))),
     ..._giftAnims,
    ]);
  }
}

class LivePage extends StatefulWidget {@override _LivePageState createState()=>_LivePageState();}
class _LivePageState extends State<LivePage>{
  CameraController? _ctrl; bool _isLive=false; bool _initing=true;
  List<String> _chats=["Welcome! 🔥","Moto sana!"];
  TextEditingController _chatCtrl=TextEditingController();
  @override void initState(){ super.initState(); _setup(); }
  Future<void> _setup() async { if(cameras.isEmpty){ setState(()=>_initing=false); return; } _ctrl=CameraController(cameras[0], ResolutionPreset.medium); await _ctrl!.initialize(); if(mounted) setState(()=>_initing=false); }
  @override void dispose(){ _ctrl?.dispose(); _chatCtrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    if(_initing) return Center(child: CircularProgressIndicator());
    Widget bg=(_ctrl==null ||!_ctrl!.value.isInitialized)? Container(color: Colors.black, child: Center(child: Icon(Icons.videocam_off, size: 50))) : SizedBox.expand(child: CameraPreview(_ctrl!));
    return Stack(children: [
      bg,
      Positioned(top: 35, left: 12, child: Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _isLive? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(15)), child: Text(_isLive? "LIVE" : "READY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
      Positioned(bottom: 110, left: 10, right: 10, child: Container(height: 120, child: ListView.builder(itemCount: _chats.length, itemBuilder: (ctx,i)=>Text(_chats[i], style: TextStyle(fontSize: 11))))),
      Positioned(bottom: 12, left: 10, right: 10, child: Column(children: [
        if(_isLive) Row(children: [Expanded(child: TextField(controller: _chatCtrl, style: TextStyle(fontSize: 12), decoration: InputDecoration(hintText: "Chat...", filled: true, fillColor: Colors.black54, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 7), border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none)))), SizedBox(width: 6), InkWell(onTap: (){ if(_chatCtrl.text.isNotEmpty){ setState(()=>_chats.add("You: ${_chatCtrl.text}")); _chatCtrl.clear(); } }, child: CircleAvatar(backgroundColor: Colors.pink, radius: 18, child: Icon(Icons.send, size: 16)))]),
        SizedBox(height: 8),
        SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), onPressed: ()=>setState(()=>_isLive=!_isLive), child: Text(_isLive? "STOP LIVE" : "🔴 GO LIVE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
      ])),
    ]);
  }
}
class WalletPage extends StatelessWidget {@override Widget build(BuildContext context)=>Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.wallet, size: 70, color: Colors.green), SizedBox(height: 10), Text("Pochi: $MERCHANT_POCHI", style: TextStyle(fontWeight: FontWeight.bold)), Text("Balance: KSH 0"), SizedBox(height: 10), Text("40% ya kila Gift!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)), SizedBox(height: 20), Text("Gifts: 🌹10, 💋50, 🔥100, 💎500, 🦁1000, 🚀2000", style: TextStyle(fontSize: 11))])) ;}
