import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras=[];
const String POCHI="0180879250";

Future<void> main() async {WidgetsFlutterBinding.ensureInitialized(); cameras=await availableCameras(); runApp(SawaTokApp());}
class SawaTokApp extends StatelessWidget {@override Widget build(BuildContext context){return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());}}

class LoginPage extends StatefulWidget {@override _LoginPageState createState()=>_LoginPageState();}
class _LoginPageState extends State<LoginPage>{
  TextEditingController phoneCtrl=TextEditingController();
  TextEditingController otpCtrl=TextEditingController();
  bool otpSent=false;
  void sendOtp(){setState((){otpSent=true;}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP: 123456")));}
  void verify(){if(otpCtrl.text=="123456"){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomePage(phone: phoneCtrl.text)));}}
  @override Widget build(BuildContext context){
    return Scaffold(body: Center(child: Padding(padding: EdgeInsets.all(20), child: otpSent? Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: otpCtrl, decoration: InputDecoration(hintText: "OTP 123456")), ElevatedButton(onPressed: verify, child: Text("Verify"))]) : Column(mainAxisSize: MainAxisSize.min, children: [Text("SawaTok Login", style: TextStyle(fontSize:22, fontWeight:FontWeight.bold)), TextField(controller: phoneCtrl, decoration: InputDecoration(hintText:"07...")), ElevatedButton(onPressed: sendOtp, child: Text("Tuma OTP"))]))));
  }
}

class HomePage extends StatefulWidget {final String phone; HomePage({required this.phone}); @override _HomePageState createState()=>_HomePageState();}
class _HomePageState extends State<HomePage>{
  int idx=0;
  @override Widget build(BuildContext context){return Scaffold(body: [ForYouPage(), LivePage(), WalletPage(phone: widget.phone)][idx], bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i)=>setState(()=>idx=i), items: [BottomNavigationBarItem(icon: Icon(Icons.home), label:"For You"), BottomNavigationBarItem(icon: Icon(Icons.live_tv), label:"Live"), BottomNavigationBarItem(icon: Icon(Icons.wallet), label:"Wallet")]));}
}

class ForYouPage extends StatefulWidget {@override _ForYouPageState createState()=>_ForYouPageState();}
class _ForYouPageState extends State<ForYouPage>{
  List<int> likes=[12500,13200,9800]; List<bool> liked=[false,false,false];
  bool showGift=false; String gEmoji="🦁"; String gName="Simba"; int gPrice=100;
  void sendGift(String e, String n, int p){int my=(p*0.3).toInt(); setState((){showGift=true; gEmoji=e; gName=n; gPrice=p;}); Future.delayed(Duration(seconds:2), ()=>setState(()=>showGift=false)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Umetuma $n! Yako KSH $my")));}
  void showGifts(){showModalBottomSheet(context: context, backgroundColor: Colors.black87, builder: (_){return Padding(padding: EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [Text("Tuma Gift - 30% Yako! 70% Creator", style: TextStyle(color: Colors.white)), SizedBox(height:10), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [gBtn("🌹","Rose",10), gBtn("❤️","Heart",50), gBtn("🦁","Simba",1000, big:true)])]));});}
  Widget gBtn(String e, String n, int p, {bool big=false}){return GestureDetector(onTap: ()=>sendGift(e,n,p), child: Column(children: [Text(e, style: TextStyle(fontSize: big?40:30)), Text(n, style: TextStyle(color:Colors.white)), Text("KSH $p", style: TextStyle(color:Colors.grey))]));}
  @override Widget build(BuildContext context){return Stack(children: [PageView.builder(scrollDirection: Axis.vertical, itemCount: 3, itemBuilder: (_,i){return Container(color: Colors.black, child: Stack(children: [Center(child: Text("VIDEO ${i+1}\nLikes ${likes[i]}", style: TextStyle(color:Colors.white, fontSize:20), textAlign: TextAlign.center)), Positioned(bottom:60, right:10, child: Column(children: [IconButton(icon: Icon(liked[i]? Icons.favorite: Icons.favorite_border, color: Colors.white), onPressed: ()=>setState((){liked[i]=!liked[i]; likes[i]+=liked[i]?1:-1;})), IconButton(icon: Icon(Icons.card_giftcard, color: Colors.yellow), onPressed: showGifts)]))])));}), if(showGift) Center(child: Text(gEmoji, style: TextStyle(fontSize: 80)))]);}
}

class LivePage extends StatefulWidget {@override _LivePageState createState()=>_LivePageState();}
class _LivePageState extends State<LivePage>{
  CameraController? ctrl; bool live=false; bool init=true;
  @override void initState(){super.initState(); _setup();}
  Future<void> _setup() async {if(cameras.isEmpty){setState(()=>init=false); return;} ctrl=CameraController(cameras[0], ResolutionPreset.medium); await ctrl!.initialize(); setState(()=>init=false);}
  @override void dispose(){ctrl?.dispose(); super.dispose();}
  @override Widget build(BuildContext context){if(init) return Center(child: CircularProgressIndicator()); Widget bg=(ctrl==null ||!ctrl!.value.isInitialized)? Container(color: Colors.black) : CameraPreview(ctrl!); return Stack(children: [bg, Positioned(bottom:10, left:10, right:10, child: ElevatedButton(onPressed: ()=>setState(()=>live=!live), child: Text(live?"Maliza Live":"Anza Live")))]);}
}

class WalletPage extends StatefulWidget {final String phone; WalletPage({this.phone="07"}); @override _WalletPageState createState()=>_WalletPageState();}
class _WalletPageState extends State<WalletPage>{
  int balance=1250; TextEditingController amountCtrl=TextEditingController(); bool withdrawing=false;
  void withdraw(){int amount=int.tryParse(amountCtrl.text)??0; if(amount<100 || amount>balance) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Min 100, Max $balance"))); return;} setState(()=>withdrawing=true); Future.delayed(Duration(seconds:1), (){setState((){balance-=amount; withdrawing=false; amountCtrl.clear();}); showDialog(context: context, builder: (_)=>AlertDialog(title: Text("Success ✅"), content: Text("KSH $amount imetumwa kwa ${widget.phone}\nPochi: $POCHI"), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Sawa"))]));});}
  @override Widget build(BuildContext context){return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("Wallet"), backgroundColor: Colors.black), body: Padding(padding: EdgeInsets.all(16), child: Column(children: [Container(width: double.infinity, padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green)), child: Column(children: [Icon(Icons.account_balance_wallet, size:50, color:Colors.green), Text("KSH $balance", style: TextStyle(color:Colors.white, fontSize:32, fontWeight:FontWeight.bold)), Text("30% Yako - 70% Creator", style: TextStyle(color:Colors.green)), Text("Phone: ${widget.phone}", style: TextStyle(color:Colors.white70)), Text("Pochi: $POCHI", style: TextStyle(color:Colors.white70))])), SizedBox(height:20), TextField(controller: amountCtrl, keyboardType: TextInputType.number, style: TextStyle(color:Colors.white), decoration: InputDecoration(hintText:"Weka amount min 100", filled:true, fillColor:Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))), SizedBox(height:15), SizedBox(width:double.infinity, height:50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: withdrawing? null : withdraw, child: Text("WITHDRAW VIA M-PESA"))), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [TextButton(onPressed: ()=>setState(()=>amountCtrl.text="100"), child: Text("100")), TextButton(onPressed: ()=>setState(()=>amountCtrl.text="500"), child: Text("500")), TextButton(onPressed: ()=>setState(()=>amountCtrl.text="$balance"), child: Text("ALL"))])])));}
}
