import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras=[];
const String MERCHANT_POCHI="0180879250";

Future<void> main() async {WidgetsFlutterBinding.ensureInitialized(); try{cameras=await availableCameras();}catch(e){} runApp(SawaTokApp());}
class SawaTokApp extends StatelessWidget {@override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: MainScreen());}
class MainScreen extends StatefulWidget {@override _MainScreenState createState()=>_MainScreenState();}
class _MainScreenState extends State<MainScreen>{
  int _index=0;
  final pages=[ForYouPage(), LivePage(), WalletPage()];
  @override Widget build(BuildContext context)=>Scaffold(body: pages[_index], bottomNavigationBar: BottomNavigationBar(currentIndex: _index, onTap: (i)=>setState(()=>_index=i), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.pink, backgroundColor: Colors.black, items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
    BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: "LIVE"),
    BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
  ]));
}

// SIMPLE GIFT ANIM
class GiftAnim extends StatefulWidget {
  final String emoji; final String name; final int price; final VoidCallback onDone;
  GiftAnim({required this.emoji, required this.name, required this.price, required this.onDone});
  @override _GiftAnimState createState()=>_GiftAnimState();
}
class _GiftAnimState extends State<GiftAnim> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _scale;
  late Animation<double> _fade;
  @override void initState(){
    super.initState();
    _c=AnimationController(vsync: this, duration: Duration(milliseconds: widget.price>=1000? 3000 : 1500));
    _scale=Tween<double>(begin: 0.2, end: widget.price>=1000? 3.0 : 1.6).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _fade=Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _c, curve: Interval(0.6, 1.0, curve: Curves.easeOut)));
    _c.forward().then((_)=>widget.onDone());
  }
  @override void dispose(){ _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context)=>FadeTransition(opacity: _fade, child: ScaleTransition(scale: _scale, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Text(widget.emoji, style: TextStyle(fontSize: widget.price>=1000? 90 : 60)),
    Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.pinkAccent, blurRadius: 20)]), child: Text("${widget.name} KSH ${widget.price}", style: TextStyle(fontWeight: FontWeight.bold))),
    if(widget.price>=1000) Text("🔥 LEGENDARY 🔥", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 12)),
  ])))));
}

// FOR YOU
class ForYouPage extends StatefulWidget {@override _ForYouPageState createState()=>_ForYouPageState();}
class _ForYouPageState extends State<ForYouPage>{
  List<int> likes=[12500,13200,9800,15000,11000];
  List<bool> isLiked=[false,false,false,false,false];
  List<bool> isFollowing=[false,false,false,false,false];
  List<List<String>> comments=[["Moto! 🔥","Nice!"],["Unafaa ❤️"],["Wapi store?"],["🔥🔥"],["Sawa!"]];
  List<Widget> anims=[];

  void _send(String e, String n, int p){
    int my=(p*0.4).toInt();
    Widget w;
    w=GiftAnim(emoji: e, name: n, price: p, onDone: ()=>setState(()=>anims.remove(w)));
    setState(()=>anims.add(w));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: p>=1000? Colors.orange : Colors.pink, content: Text("$n KSH $p! Yako KSH $my (40%) -> $MERCHANT_POCHI", style: TextStyle(fontWeight: FontWeight.bold))));
  }

  void _giftSheet(){
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, builder: (_)=>Container(height: 300, padding: EdgeInsets.all(12), child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
      SizedBox(height: 6), Text("Tuma Gift - 40% Yako!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
      Text("Pochi: $MERCHANT_POCHI", style: TextStyle(fontSize: 10, color: Colors.green)),
      SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [btn("🌹","Rose",10), btn("💋","Kiss",50), btn("🔥","Fire",100)]),
      SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [btn("💎","Diamond",500), btn("🦁","Lion",1000, big:true), btn("🚀","Rocket",2000, big:true)]),
    ])));
  }
  Widget btn(String e, String n, int p, {bool big=false})=>ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: big? Colors.pink : Colors.white12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(8)), onPressed: (){ Navigator.pop(context); _send(e,n,p); }, child: Column(children: [Text(e, style: TextStyle(fontSize: big? 28 : 22)), Text(n, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)), Text("KSH $p", style: TextStyle(fontSize: 8, color: Colors.greenAccent))]));

  void _commentSheet(int i){
    TextEditingController c=TextEditingController();
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, isScrollControlled: true, builder: (_)=>Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: Container(height: 350, padding: EdgeInsets.all(12), child: Column(children: [
      Text("${comments[i].length} Comments", style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(child: ListView.builder(itemCount: comments[i].length, itemBuilder: (ctx,j)=>ListTile(leading: CircleAvatar(radius: 12, backgroundColor: Colors.pink, child: Text("U$j", style: TextStyle(fontSize: 8))), title: Text(comments[i][j], style: TextStyle(fontSize: 12))))),
      Row(children: [Expanded(child: TextField(controller: c, decoration: InputDecoration(hintText: "Add comment...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6)))), SizedBox(width: 5), GestureDetector(onTap: (){ if(c.text.isNotEmpty){ setState(()=>comments[i].add(c.text)); c.clear(); Navigator.pop(context); _commentSheet(i); } }, child: CircleAvatar(backgroundColor: Colors.pink, radius: 16, child: Icon(Icons.send, size: 14)))])
    ]))));
  }

  @override Widget build(BuildContext context){
    return Stack(children: [
      PageView.builder(scrollDirection: Axis.vertical, itemCount: 5, itemBuilder: (ctx,i)=>Container(color: Colors.primaries[i%Colors.primaries.length][800], child: Stack(children: [
        Center(child: Text("VIDEO ${i+1}\n@creator$i\n#SawaTokKE 🔥", textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
        Positioned(bottom: 20, left: 10, right: 70, child: Row(children: [CircleAvatar(backgroundColor: Colors.pink, radius: 16, child: Text("C$i", style: TextStyle(fontSize: 10))), SizedBox(width: 5), Text("@creator$i", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), SizedBox(width: 5), GestureDetector(onTap: ()=>setState(()=>isFollowing[i]=!isFollowing[i]), child: Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: isFollowing[i]? Colors.white24 : Colors.pink, borderRadius: BorderRadius.circular(4)), child: Text(isFollowing[i]? "Following" : "Follow", style: TextStyle(fontSize: 9))))])),
        Positioned(bottom: 60, right: 6, child: Column(children: [
          GestureDetector(onTap: ()=>setState((){ isLiked[i]=!isLiked[i]; likes[i]+= isLiked[i]? 1 : -1; }), child: Column(children: [Icon(Icons.favorite, size: 32, color: isLiked[i]? Colors.red : Colors.white), Text("${(likes[i]/1000).toStringAsFixed(1)}k", style: TextStyle(fontSize: 10))])),
          SizedBox(height: 14),
          GestureDetector(onTap: ()=>_commentSheet(i), child: Column(children: [Icon(Icons.chat_bubble, size: 30), Text("${comments[i].length}", style: TextStyle(fontSize: 10))])),
          SizedBox(height: 14),
          GestureDetector(onTap: _giftSheet, child: Column(children: [Icon(Icons.card_giftcard, size: 30, color: Colors.pink), Text("Gift", style: TextStyle(fontSize: 9, color: Colors.pink, fontWeight: FontWeight.bold))])),
        ]))
      ]))),
     ...anims,
    ]);
  }
}

class LivePage extends StatefulWidget {@override _LivePageState createState()=>_LivePageState();}
class _LivePageState extends State<LivePage>{
  CameraController? _ctrl; bool _live=false; bool _init=true;
  List<String> _chats=["Welcome! 🔥","Moto!"];
  TextEditingController _chatCtrl=TextEditingController();
  @override void initState(){ super.initState(); _setup(); }
  Future<void> _setup() async { if(cameras.isEmpty){ setState(()=>_init=false); return; } _ctrl=CameraController(cameras[0], ResolutionPreset.medium); await _ctrl!.initialize(); if(mounted) setState(()=>_init=false); }
  @override void dispose(){ _ctrl?.dispose(); _chatCtrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    if(_init) return Center(child: CircularProgressIndicator());
    Widget bg=(_ctrl==null ||!_ctrl!.value.isInitialized)? Container(color: Colors.black, child: Center(child: Icon(Icons.videocam_off))) : SizedBox.expand(child: CameraPreview(_ctrl!));
    return Stack(children: [
      bg,
      Positioned(top: 35, left: 10, child: Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _live? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(12)), child: Text(_live? "LIVE" : "READY", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))),
      Positioned(bottom: 100, left: 10, right: 10, child: Container(height: 110, child: ListView.builder(itemCount: _chats.length, itemBuilder: (ctx,i)=>Text(_chats[i], style: TextStyle(fontSize: 11))))),
      Positioned(bottom: 10, left: 10, right: 10, child: Column(children: [
        if(_live) Row(children: [Expanded(child: TextField(controller: _chatCtrl, style: TextStyle(fontSize: 11), decoration: InputDecoration(hintText: "Chat...", filled: true, fillColor: Colors.black54, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)))), SizedBox(width: 5), InkWell(onTap: (){ if(_chatCtrl.text.isNotEmpty){ setState(()=>_chats.add("You: ${_chatCtrl.text}")); _chatCtrl.clear(); } }, child: CircleAvatar(backgroundColor: Colors.pink, radius: 16, child: Icon(Icons.send, size: 14)))]),
        SizedBox(height: 6),
        SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _live? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: ()=>setState(()=>_live=!_live), child: Text(_live? "STOP" : "🔴 GO LIVE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
      ])),
    ]);
  }
}
class WalletPage extends StatelessWidget {@override Widget build(BuildContext context)=>Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.wallet, size: 60, color: Colors.green), Text("Pochi: $MERCHANT_POCHI", style: TextStyle(fontWeight: FontWeight.bold)), Text("40% Earnings", style: TextStyle(color: Colors.green)), Text("Gifts: 🌹10 💋50 🔥100 💎500 🦁1000 🚀2000", style: TextStyle(fontSize: 10))])) ;}
