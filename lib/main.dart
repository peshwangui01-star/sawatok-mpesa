import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
    bottomNavigationBar: BottomNavigationBar(currentIndex: _index, onTap: (i)=>setState(()=>_index=i), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.pink, items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: "LIVE"),
      BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
      BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
    ]),
  );
}

class ForYouPage extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return PageView.builder(scrollDirection: Axis.vertical, itemCount: 10, itemBuilder: (ctx,i)=>Container(color: Colors.primaries[i%Colors.primaries.length], child: Stack(children: [
      Center(child: Text("VIDEO ${i+1}\n@creator$i", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
      Positioned(bottom: 100, right: 15, child: Column(children: [
        Icon(Icons.favorite, size: 35), Text("12k"), SizedBox(height: 20),
        Icon(Icons.comment, size: 35), Text("2k"), SizedBox(height: 20),
        Icon(Icons.card_giftcard, size: 35, color: Colors.pink), Text("Gift"),
      ])),
      Positioned(bottom: 20, left: 15, child: Text("@creator$i - AV Live", style: TextStyle(fontWeight: FontWeight.bold))),
    ])));
  }
}

class LivePage extends StatefulWidget { @override _LivePageState createState() => _LivePageState(); }
class _LivePageState extends State<LivePage> {
  CameraController? _controller;
  bool _isLive = false;
  bool _initing = true;
  List<String> _chats = ["System: Welcome to LIVE! 🔥", "Brian: Moto sana! 🔥", "Aisha: Unafaa ❤️"];
  TextEditingController _chatCtrl = TextEditingController();

  @override void initState() { super.initState(); _setup(); }
  Future<void> _setup() async {
    if(cameras.isEmpty){ setState(()=>_initing=false); return; }
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if(mounted) setState(()=>_initing=false);
  }
  @override void dispose() { _controller?.dispose(); _chatCtrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    if(_initing) return Center(child: CircularProgressIndicator());
    Widget bg;
    if(_controller==null ||!_controller!.value.isInitialized){
      bg = Container(color: Colors.black, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.videocam_off, size: 60), Text("Camera kwa simu halisi tu")])));
    } else {
      bg = SizedBox.expand(child: CameraPreview(_controller!));
    }
    return Stack(children: [
      bg,
      Positioned(top: 40, left: 15, child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _isLive? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(20)), child: Text(_isLive? "LIVE ${_chats.length} viewers" : "READY"))),
      Positioned(bottom: 120, left: 10, right: 10, child: Container(height: 150, child: ListView.builder(itemCount: _chats.length, itemBuilder: (ctx,i)=>Padding(padding: EdgeInsets.symmetric(vertical: 2), child: Text(_chats[i], style: TextStyle(fontSize: 12, color: i==0? Colors.green : Colors.white)))))),
      Positioned(bottom: 20, left: 10, right: 10, child: Column(children: [
        if(_isLive) Row(children: [
          Expanded(child: TextField(controller: _chatCtrl, decoration: InputDecoration(hintText: "Chat...", filled: true, fillColor: Colors.black54, contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)))),
          SizedBox(width: 8),
          InkWell(onTap: (){ if(_chatCtrl.text.isNotEmpty){ setState(()=>_chats.add("You: ${_chatCtrl.text}")); _chatCtrl.clear(); } }, child: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.send))),
        ]),
        SizedBox(height: 10),
        SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: ()=>setState(()=>_isLive=!_isLive), child: Text(_isLive? "STOP LIVE" : "🔴 GO LIVE", style: TextStyle(fontWeight: FontWeight.bold)))),
        SizedBox(height: 5),
        Text("40% -> $MERCHANT_POCHI", style: TextStyle(fontSize: 10, color: Colors.green)),
      ])),
    ]);
  }
}

class WalletPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text("Wallet - Pochi: $MERCHANT_POCHI\n40% Earnings")); }

class CreatorStorePage extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Creator Store")), body: GridView.builder(padding: EdgeInsets.all(5), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 0.7), itemCount: 12, itemBuilder: (ctx,i){
      int price = [50,100,200,350,500][i%5];
      bool locked = i%3!=0;
      return Stack(children: [
        Container(decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8))),
        if(locked) Center(child: Icon(Icons.lock)),
        Positioned(bottom: 0, left: 0, right: 0, child: Container(color: locked? Colors.pink : Colors.green, padding: EdgeInsets.symmetric(vertical: 4), child: Text(locked? "KSH $price" : "UNLOCKED", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
      ]);
    }));
  }
}
