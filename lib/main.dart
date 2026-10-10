import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras=[];
const String POCHI="0180879250";

Future<void> main() async {WidgetsFlutterBinding.ensureInitialized(); cameras=await availableCameras(); runApp(SawaTokApp());}
class SawaTokApp extends StatelessWidget {@override Widget build(BuildContext context){return MaterialApp(home: LoginPage());}}

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP: 123456")));
    });
  }
  void verify(){
    if(otpCtrl.text=="123456"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomePage(phone: phoneCtrl.text)));
    } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP si sahihi")));
    }
  }
  Widget phoneView(){
    return Column(children: [
        Text("Ingia na Phone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        TextField(controller: phoneCtrl, decoration: InputDecoration(hintText: "07...")),
        ElevatedButton(onPressed: sendOtp, child: Text("Tuma OTP"))
    ]);
  }
  @override Widget build(BuildContext context){return Scaffold(body: Center(child: otpSent? Column(children: [TextField(controller: otpCtrl), ElevatedButton(onPressed: verify, child: Text("Verify"))]) : phoneView()));}
}

class HomePage extends StatefulWidget {final String phone; HomePage({required this.phone}); @override _HomePageState createState()=>_HomePageState();}
class _HomePageState extends State<HomePage>{
  int idx=0;
  @override Widget build(BuildContext context){
    return Scaffold(
      body: [ForYouPage(), LivePage(), WalletPage(phone: widget.phone)][idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i)=>setState(()=>idx=i), items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "Live"),
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet")
      ])
    );
  }
}

class ForYouPage extends StatefulWidget {@override _ForYouPageState createState()=>_ForYouPageState();}
class _ForYouPageState extends State<ForYouPage>{
  List<int> likes=[12500,13200,9800,15000,11000];
  List<bool> liked=[false,false,false,false,false];
  List<bool> following=[false,false,false,false,false];
  List<List<String>> cmts=[["Moto!"], ["Nice"], ["Wapi"], ["Sawa"], ["Poa"]];
  bool showGift=false; String gEmoji="🦁"; String gName="Simba"; int gPrice=100; int gMy=30;

  void sendGift(String e, String n, int p){
    setState((){ showGift=true; gEmoji=e; gName=n; gPrice=p; gMy=(p*0.3).toInt(); });
    Future.delayed(Duration(milliseconds: p>=1000? 3000: 1500), ()=> setState(()=> showGift=false));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Umetuma $n! Wewe: KSH $gMy, Creator: KSH ${p-gMy}")));
  }

  void showGifts(){
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, builder: (_){
      return Container(width: 35, height: 4, decoration: BoxDecoration(), child: Column(children: [
        SizedBox(height: 8), Text("Tuma Gift - 30% Yako! 70% kwa Creator", style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [gBtn("🌹", "Rose", 10), gBtn("❤️", "Heart", 50), gBtn("🎉", "Party", 100)]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [gBtn("🦁", "Simba", 1000, big: true), gBtn("💎", "Diamond", 5000, big: true)])
      ]));
    });
  }
  Widget gBtn(String e, String n, int p, {bool big=false}){
    return GestureDetector(onTap: ()=> sendGift(e,n,p), child: Column(children: [Text(e, style: TextStyle(fontSize: big? 40: 30)), Text(n), Text("KSH $p")]));
  }
  void showComments(int i){
    TextEditingController c=TextEditingController();
    showModalBottomSheet(context: context, backgroundColor: Colors.white, builder: (_){
      return Column(children: [
        Text("${cmts[i].length} Comments", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: ListView.builder(itemCount: cmts[i].length, itemBuilder: (_,j)=> ListTile(title: Text(cmts[i][j])))),
        Row(children: [Expanded(child: TextField(controller: c)), IconButton(icon: Icon(Icons.send), onPressed: (){setState(()=> cmts[i].add(c.text)); Navigator.pop(context);})])
      ]);
    });
  }

  @override Widget build(BuildContext context){
    return Stack(children: [
      PageView.builder(scrollDirection: Axis.vertical, itemCount: 5, itemBuilder: (_,i){
        return Stack(children: [
          Center(child: Text("VIDEO ${i+1}\n@creator$i\nLikes: ${likes[i]}", style: TextStyle(color: Colors.white, fontSize: 20))),
          Positioned(bottom: 20, left: 10, child: Row(children: [Text("@creator$i"), SizedBox(width: 10), ElevatedButton(onPressed: ()=> setState(()=> following[i]=!following[i]), child: Text(following[i]? "Following": "Follow"))])),
          Positioned(bottom: 60, right: 6, child: Column(children: [
            GestureDetector(onTap: ()=>setState((){ liked[i]=!liked[i]; likes[i]+= liked[i]?1:-1; }), child: Column(children: [Icon(liked[i]? Icons.favorite: Icons.favorite_border, color: Colors.white), Text("${likes[i]}")])),
            SizedBox(height: 12),
            GestureDetector(onTap: ()=>showComments(i), child: Column(children: [Icon(Icons.comment, color: Colors.white), Text("${cmts[i].length}")])),
            SizedBox(height: 12),
            GestureDetector(onTap: showGifts, child: Column(children: [Icon(Icons.card_giftcard, color: Colors.yellow), Text("Gift")])),
          ]))
        ]);
      }),
      if(showGift) Center(child: TweenAnimationBuilder(tween: Tween(begin: 0.0, end: 1.0), duration: Duration(milliseconds: 500), builder: (_, val, __){
        return Transform.scale(scale: val * (gPrice>=1000? 1.5: 1.0), child: Column(children: [
          Text(gEmoji, style: TextStyle(fontSize: 60)),
          Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: Text("$gName - KSH $gPrice", style: TextStyle(color: Colors.white)))
        ]));
      })),
    ]);
  }
}

class LivePage extends StatefulWidget {@override _LivePageState createState()=>_LivePageState();}
class _LivePageState extends State<LivePage>{
  CameraController? ctrl; bool live=false; bool init=true;
  @override void initState(){ super.initState(); _setup(); }
  Future<void> _setup() async { if(cameras.isEmpty){ setState(()=> init=false); return; } ctrl=CameraController(cameras[0], ResolutionPreset.medium); await ctrl!.initialize(); setState(()=> init=false); }
  @override void dispose(){ ctrl?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    if(init) return Center(child: CircularProgressIndicator());
    Widget bg=(ctrl==null ||!ctrl!.value.isInitialized)? Container(color: Colors.black) : CameraPreview(ctrl!);
    return Stack(children: [bg,
      Positioned(top: 35, left: 10, child: Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.red), child: Text(live? "LIVE": "OFF", style: TextStyle(color: Colors.white)))),
      Positioned(bottom: 10, left: 10, right: 10, child: ElevatedButton(onPressed: ()=> setState(()=> live=!live), child: Text(live? "Maliza Live": "Anza Live")))
    ]);
  }
}

class WalletPage extends StatelessWidget {
  final String phone;
  WalletPage({this.phone="07"});
  @override Widget build(BuildContext context)=>Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    CircleAvatar(backgroundColor: Colors.pink, radius: 40, child: Icon(Icons.person, size: 40)),
    SizedBox(height: 10),
    Text("Phone: $phone", style: TextStyle(fontWeight: FontWeight.bold)),
    Text("Pochi: $POCHI", style: TextStyle(color: Colors.grey)),
    SizedBox(height: 10),
    Text("Balance: KSH 0", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    Text("30% Earnings! 70% kwa Creators", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: (){}, child: Text("Withdraw via M-Pesa"))
  ]));
}
