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
    bottomNavigationBar: BottomNavigationBar(currentIndex: _index, onTap: (i)=>setState(()=>_index=i), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.pink, backgroundColor: Colors.black, items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: "LIVE"),
      BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
      BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
    ]),
  );
}

// --- FOR YOU WITH LIKES FOLLOW COMMENTS ---
class VideoData {
  int likes; bool isLiked; bool isFollowing; List<String> comments;
  VideoData({this.likes=12500, this.isLiked=false, this.isFollowing=false, List<String>? comments}) : comments = comments?? ["Moto sana! 🔥","Unafaa ❤️","Wapi store?"];
}

class ForYouPage extends StatefulWidget { @override _ForYouPageState createState() => _ForYouPageState(); }
class _ForYouPageState extends State<ForYouPage> {
  List<VideoData> videos = List.generate(10, (i)=>VideoData(likes: 12000 + i*500));

  void _showComments(int index){
    TextEditingController ctrl = TextEditingController();
    showModalBottomSheet(context: context, backgroundColor: Colors.black87, isScrollControlled: true, builder: (_)=>Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: Container(height: 400, padding: EdgeInsets.all(15), child: Column(children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
      SizedBox(height: 10),
      Text("${videos[index].comments.length} Comments", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Expanded(child: ListView.builder(itemCount: videos[index].comments.length, itemBuilder: (ctx,i)=>ListTile(leading: CircleAvatar(radius: 15, backgroundColor: Colors.pink, child: Text("U${i}")), title: Text(videos[index].comments[i], style: TextStyle(fontSize: 13)), subtitle: Text("2m ago", style: TextStyle(fontSize: 10, color: Colors.grey))))),
      Row(children: [
        Expanded(child: TextField(controller: ctrl, decoration: InputDecoration(hintText: "Add comment...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8)))),
        SizedBox(width: 8),
        GestureDetector(onTap: (){ if(ctrl.text.isNotEmpty){ setState(()=>videos[index].comments.add(ctrl.text)); ctrl.clear(); Navigator.pop(context); _showComments(index); } }, child: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.send, size: 18))),
      ]),
    ]))));
  }

  @override Widget build(BuildContext context) {
    return PageView.builder(scrollDirection: Axis.vertical, itemCount: videos.length, itemBuilder: (ctx,i){
      final v = videos[i];
      return Container(color: Colors.primaries[i%Colors.primaries.length][700], child: Stack(children: [
        Center(child: Text("VIDEO ${i+1}\n@creator$i\n#SawaTokKE 🔥", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
        // Creator info
        Positioned(bottom: 20, left: 15, right: 80, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(backgroundColor: Colors.pink, child: Text("C${i}")),
            SizedBox(width: 8),
            Text("@creator$i", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            GestureDetector(onTap: ()=>setState(()=>v.isFollowing=!v.isFollowing), child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: v.isFollowing? Colors.white24 : Colors.pink, borderRadius: BorderRadius.circular(5)), child: Text(v.isFollowing? "Following" : "Follow", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))),
          ]),
          SizedBox(height: 5),
          Text("SawaTok Kenya 🔥 Niko LIVE kila siku 8PM! #AV #Kenya", style: TextStyle(fontSize: 12)),
        ])),
        // Likes Follow Comments Gift - Right side
        Positioned(bottom: 80, right: 10, child: Column(children: [
          GestureDetector(onTap: ()=>setState((){ v.isLiked=!v.isLiked; v.likes+= v.isLiked? 1 : -1; }), child: Column(children: [
            Icon(Icons.favorite, size: 38, color: v.isLiked? Colors.red : Colors.white),
            Text("${(v.likes/1000).toStringAsFixed(1)}k", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ])),
          SizedBox(height: 18),
          GestureDetector(onTap: ()=>_showComments(i), child: Column(children: [
            Icon(Icons.chat_bubble, size: 35, color: Colors.white),
            Text("${v.comments.length}", style: TextStyle(fontSize: 12)),
          ])),
          SizedBox(height: 18),
          GestureDetector(onTap: (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.pink, content: Text("Gift: Rose KSH 10 - Yako KSH 4 (40%) -> $MERCHANT_POCHI"))); }, child: Column(children: [
            Icon(Icons.card_giftcard, size: 35, color: Colors.pink),
            Text("Gift", style: TextStyle(fontSize: 11, color: Colors.pink, fontWeight: FontWeight.bold)),
          ])),
          SizedBox(height: 18),
          Icon(Icons.share, size: 32),
          Text("Share", style: TextStyle(fontSize: 11)),
        ])),
      ]));
    });
  }
}

// --- LIVE WITH CHAT ---
class LivePage extends StatefulWidget { @override _LivePageState createState() => _LivePageState(); }
class _LivePageState extends State<LivePage> {
  CameraController? _controller; bool _isLive=false; bool _initing=true;
  List<String> _chats=["System: Welcome! 🔥","Brian: Moto!","Aisha: ❤️"];
  TextEditingController _chatCtrl=TextEditingController();
  @override void initState(){ super.initState(); _setup(); }
  Future<void> _setup() async {
    if(cameras.isEmpty){ setState(()=>_initing=false); return; }
    _controller=CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if(mounted) setState(()=>_initing=false);
  }
  @override void dispose(){ _controller?.dispose(); _chatCtrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    if(_initing) return Center(child: CircularProgressIndicator());
    Widget bg = (_controller==null ||!_controller!.value.isInitialized)? Container(color: Colors.black, child: Center(child: Icon(Icons.videocam_off, size: 60))) : SizedBox.expand(child: CameraPreview(_controller!));
    return Stack(children: [
      bg,
      Positioned(top: 40, left: 15, child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _isLive? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(20)), child: Text(_isLive? "LIVE ${_chats.length}" : "READY", style: TextStyle(fontWeight: FontWeight.bold)))),
      Positioned(bottom: 120, left: 10, right: 10, child: Container(height: 130, child: ListView.builder(itemCount: _chats.length, itemBuilder: (ctx,i)=>Text(_chats[i], style: TextStyle(fontSize: 12))))),
      Positioned(bottom: 15, left: 10, right: 10, child: Column(children: [
        if(_isLive) Row(children: [Expanded(child: TextField(controller: _chatCtrl, decoration: InputDecoration(hintText: "Chat...", filled: true, fillColor: Colors.black54, contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)))), SizedBox(width: 8), InkWell(onTap: (){ if(_chatCtrl.text.isNotEmpty){ setState(()=>_chats.add("You: ${_chatCtrl.text}")); _chatCtrl.clear(); } }, child: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.send)))]),
        SizedBox(height: 10),
        SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: ()=>setState(()=>_isLive=!_isLive), child: Text(_isLive? "STOP LIVE" : "🔴 GO LIVE", style: TextStyle(fontWeight: FontWeight.bold)))),
      ])),
    ]);
  }
}

class WalletPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.wallet, size: 80, color: Colors.green), SizedBox(height: 10), Text("Pochi: $MERCHANT_POCHI", style: TextStyle(fontWeight: FontWeight.bold)), Text("Balance: KSH 0"), Text("40% ya kila kitu", style: TextStyle(color: Colors.green))])) ; }

class CreatorStorePage extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.black, title: Text("Store - @AishaKenya")), body: GridView.builder(padding: EdgeInsets.all(5), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 0.7), itemCount: 12, itemBuilder: (ctx,i){
      int price=[50,100,200,350,500][i%5]; bool locked=i%3!=0;
      return Stack(children: [Container(decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8))), if(locked) Center(child: Icon(Icons.lock)), Positioned(bottom: 0, left: 0, right: 0, child: Container(color: locked? Colors.pink : Colors.green, padding: EdgeInsets.symmetric(vertical: 4), child: Text(locked? "KSH $price" : "UNLOCKED", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))))]);
    }));
  }
}
