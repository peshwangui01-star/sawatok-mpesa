import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<CameraDescription> cameras=[];
const String POCHI="0180879250";
const String MPESA_BACKEND="https://sawatok-mpesa-1.onrender.com";

Future<void> main() async {

class LoginPage extends StatefulWidget {@override _LoginPageState createState()=>_LoginPageState();}
class _LoginPageState extends State<LoginPage>{
  TextEditingController phoneCtrl=TextEditingController();
  TextEditingController otpCtrl=TextEditingController();
  bool otpSent=false;
  bool loading=false;

  void sendOtp(){
    if(phoneCtrl.text.length<9){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Weka namba sahihi"))); return; }
    setState(()=>loading=true);
    Future.delayed(Duration(seconds: 1), (){
      setState((){ otpSent=true; loading=false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text("OTP: 123456")));
    });
  }
  void verify(){
    if(otpCtrl.text=="123456"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainScreen(phone: phoneCtrl.text)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Tumia 123456")));
    }
  }
  Widget phoneView(){
    return Column(children: [
      Text("Ingia na Phone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      SizedBox(height: 15),
      TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(prefixText: "+254 ", hintText: "7XX XXX XXX", filled: true, fillColor: Colors.black38, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      SizedBox(height: 15),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: EdgeInsets.symmetric(vertical: 14)), onPressed: loading? null : sendOtp, child: loading? CircularProgressIndicator(color: Colors.white) : Text("Tuma OTP", style: TextStyle(fontWeight: FontWeight.bold)))),
    ]);
  }
  Widget otpView(){
    return Column(children: [
      Text("Weka OTP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      SizedBox(height: 8),
      Text("Code: 123456 kwa ${phoneCtrl.text}", style: TextStyle(fontSize: 12, color: Colors.greenAccent)),
      SizedBox(height: 15),
      TextField(controller: otpCtrl, keyboardType: TextInputType.number, maxLength: 6, textAlign: TextAlign.center, style: TextStyle(letterSpacing: 8, fontSize: 22, fontWeight: FontWeight.bold), decoration: InputDecoration(hintText: "123456", filled: true, fillColor: Colors.black38, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), counterText: "")),
      SizedBox(height: 15),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 14)), onPressed: verify, child: Text("Thibitisha", style: TextStyle(fontWeight: FontWeight.bold)))),
      SizedBox(height: 10),
      TextButton(onPressed: (){ setState(()=>otpSent=false); }, child: Text("Badilisha namba", style: TextStyle(color: Colors.white70, fontSize: 12))),
    ]);
  }
  @override Widget build(BuildContext context){
    return Scaffold(body: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.pink, Colors.black])), width: double.infinity, height: double.infinity, child: Center(child: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.play_circle_filled, size: 80, color: Colors.white),
      SizedBox(height: 10),
      Text("SawaTok", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
      Text("Kenya TikTok + M-Pesa", style: TextStyle(color: Colors.white70)),
      SizedBox(height: 25),
      Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: otpSent? otpView() : phoneView()),
      SizedBox(height: 20),
      Text("Pochi: $POCHI", style: TextStyle(fontSize: 11, color: Colors.white54)),
    ])))));
  }
}

class MainScreen extends StatefulWidget {
  final String phone;
  MainScreen({this.phone="07"});
  @override _MainScreenState createState()=>_MainScreenState();
}
class _MainScreenState extends State<MainScreen>{
  int _i=0;
  @override Widget build(BuildContext context){
    return Scaffold(
      body: [ForYouPage(), LivePage(), WalletPage(phone: widget.phone)][_i],
      bottomNavigationBar: BottomNavigationBar(currentIndex: _i, onTap: (x)=>setState(()=>_i=x), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.pink, backgroundColor: Colors.black, items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: "LIVE"),
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
      ])
    );
  }
}

class ForYouPage extends StatefulWidget {@override _ForYouPageState createState()=>_ForYouPageState();}
class _ForYouPageState extends State<ForYouPage>{
  List<int> likes=[12500,13200,9800,15000,11000];
  List<bool> liked=[false,false,false,false,false];
  List<bool> following=[false,false,false,false,false];
  List<List<String>> cmts=[["Moto!"], ["Nice"], ["Wapi?"], ["🔥"], ["Sawa"]];
  bool showGift=false; String gEmoji="🦁"; String gName="Lion"; int gPrice=1000;

  void sendGift(String e, String n, int p){
    setState((){ showGift=true; gEmoji=e; gName=n; gPrice=p; });
    Future.delayed(Duration(milliseconds: p>=1000? 3000 : 1500), (){ if(mounted) setState(()=>showGift=false); });
    int my=(p*0.4).toInt();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: p>=1000? Colors.orange : Colors.pink, content: Text("$n KSH $p - Yako $my -> $POCHI", style: TextStyle(fontWeight: FontWeight.bold))));
  }
  void showGifts(){
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, builder: (_)=>Container(height: 280, padding: EdgeInsets.all(12), child: Column(children: [
      Container(width: 35, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
      SizedBox(height: 8), Text("Tuma Gift - 40% Yako!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
      SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [gBtn("🌹","Rose",10), gBtn("💋","Kiss",50), gBtn("🔥","Fire",100)]),
      SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [gBtn("💎","Diamond",500), gBtn("🦁","Lion",1000, big:true), gBtn("🚀","Rocket",2000, big:true)]),
    ])));
  }
  Widget gBtn(String e, String n, int p, {bool big=false})=>ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: big? Colors.pink : Colors.white12, padding: EdgeInsets.all(8)), onPressed: (){ Navigator.pop(context); sendGift(e,n,p); }, child: Column(children: [Text(e, style: TextStyle(fontSize: big? 28 : 22)), Text(n, style: TextStyle(fontSize: 9)), Text("KSH $p", style: TextStyle(fontSize: 8, color: Colors.greenAccent))]));
  void showComments(int i){
    TextEditingController c=TextEditingController();
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, isScrollControlled: true, builder: (_)=>Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: Container(height: 350, padding: EdgeInsets.all(12), child: Column(children: [
      Text("${cmts[i].length} Comments", style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(child: ListView.builder(itemCount: cmts[i].length, itemBuilder: (ctx,j)=>ListTile(leading: CircleAvatar(radius: 12, backgroundColor: Colors.pink, child: Text("U$j", style: TextStyle(fontSize: 8))), title: Text(cmts[i][j], style: TextStyle(fontSize: 12))))),
      Row(children: [Expanded(child: TextField(controller: c, decoration: InputDecoration(hintText: "Add...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none)))), SizedBox(width: 5), GestureDetector(onTap: (){ if(c.text.isNotEmpty){ setState(()=>cmts[i].add(c.text)); c.clear(); Navigator.pop(context); showComments(i); } }, child: CircleAvatar(backgroundColor: Colors.pink, radius: 16, child: Icon(Icons.send, size: 14)))])
    ]))));
  }
  @override Widget build(BuildContext context){
    return Stack(children: [
      PageView.builder(scrollDirection: Axis.vertical, itemCount: 5, itemBuilder: (ctx,i)=>Container(color: Colors.primaries[i%Colors.primaries.length][800], child: Stack(children: [
        Center(child: Text("VIDEO ${i+1}\n@creator$i", textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
        Positioned(bottom: 20, left: 10, child: Row(children: [CircleAvatar(backgroundColor: Colors.pink, radius: 15, child: Text("C$i", style: TextStyle(fontSize: 9))), SizedBox(width: 5), Text("@creator$i", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)), GestureDetector(onTap: ()=>setState(()=>following[i]=!following[i]), child: Container(margin: EdgeInsets.only(left: 6), padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: following[i]? Colors.white24 : Colors.pink, borderRadius: BorderRadius.circular(4)), child: Text(following[i]? "Following" : "Follow", style: TextStyle(fontSize: 9))))])),
        Positioned(bottom: 60, right: 6, child: Column(children: [
          GestureDetector(onTap: ()=>setState((){ liked[i]=!liked[i]; likes[i]+= liked[i]? 1 : -1; }), child: Column(children: [Icon(Icons.favorite, size: 30, color: liked[i]? Colors.red : Colors.white), Text("${(likes[i]/1000).toStringAsFixed(1)}k", style: TextStyle(fontSize: 10))])),
          SizedBox(height: 12),
          GestureDetector(onTap: ()=>showComments(i), child: Column(children: [Icon(Icons.chat_bubble, size: 28), Text("${cmts[i].length}", style: TextStyle(fontSize: 10))])),
          SizedBox(height: 12),
          GestureDetector(onTap: showGifts, child: Column(children: [Icon(Icons.card_giftcard, size: 28, color: Colors.pink), Text("Gift", style: TextStyle(fontSize: 9, color: Colors.pink))])),
        ]))
      ]))),
      if(showGift) Center(child: TweenAnimationBuilder<double>(tween: Tween(begin: 0.0, end: 1.0), duration: Duration(milliseconds: 800), curve: Curves.elasticOut, builder: (ctx, val, child){
        return Transform.scale(scale: val * (gPrice>=1000? 3.5 : 2.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(gEmoji, style: TextStyle(fontSize: 60)),
          Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(20)), child: Text("$gName KSH $gPrice", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        ]));
      })),
    ]);
  }
}

class LivePage extends StatefulWidget {@override _LivePageState createState()=>_LivePageState();}
class _LivePageState extends State<LivePage>{
  CameraController? ctrl; bool live=false; bool init=true;
  @override void initState(){ super.initState(); _setup(); }
  Future<void> _setup() async { if(cameras.isEmpty){ setState(()=>init=false); return; } ctrl=CameraController(cameras[0], ResolutionPreset.medium); await ctrl!.initialize(); if(mounted) setState(()=>init=false); }
  @override void dispose(){ ctrl?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    if(init) return Center(child: CircularProgressIndicator());
    Widget bg=(ctrl==null ||!ctrl!.value.isInitialized)? Container(color: Colors.black, child: Center(child: Icon(Icons.videocam_off))) : SizedBox.expand(child: CameraPreview(ctrl!));
    return Stack(children: [bg,
      Positioned(top: 35, left: 10, child: Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: live? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(12)), child: Text(live? "LIVE" : "READY", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))),
      Positioned(bottom: 10, left: 10, right: 10, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: live? Colors.red : Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: ()=>setState(()=>live=!live), child: Text(live? "STOP" : "GO LIVE"))),
    ]);
  }
}
class WalletPage extends StatelessWidget {
  final String phone;
  WalletPage({this.phone="07"});
  @override Widget build(BuildContext context)=>Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    CircleAvatar(backgroundColor: Colors.pink, radius: 35, child: Icon(Icons.person, size: 35)),
    SizedBox(height: 10),
    Text("Phone: $phone", style: TextStyle(fontWeight: FontWeight.bold)),
    Text("Pochi: $POCHI", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    SizedBox(height: 10),
    Text("Balance: KSH 0", style: TextStyle(fontSize: 12)),
    Text("40% Earnings!", style: TextStyle(color: Colors.green)),
    SizedBox(height: 20),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white12), onPressed: (){ Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LoginPage()), (r)=>false); }, child: Text("Logout")),
  ]));
}
