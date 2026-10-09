import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];
const String MERCHANT_POCHI = "0180879250";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch(e){}
  runApp(SawaTokApp());
}

class SawaTokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final pages = [ForYouPage(), LivePage(), WalletPage(), StorePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.red), label: "LIVE"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Store"),
        ],
      ),
    );
  }
}

class ForYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (ctx, i) {
        return Stack(
          children: [
            Container(color: Colors.primaries[i % Colors.primaries.length], child: Center(child: Text("VIDEO ${i+1}\n@creator${i}", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))),
            Positioned(bottom: 100, right: 15, child: Column(children: [
              Icon(Icons.favorite, size: 35, color: Colors.white),
              Text("12k"),
              SizedBox(height: 20),
              Icon(Icons.comment, size: 35),
              Text("2k"),
              SizedBox(height: 20),
              GestureDetector(onTap: (){
                showModalBottomSheet(context: context, builder: (_) => Container(height: 200, child: Column(children: [
                  SizedBox(height: 20),
                  Text("Tuma Gift", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    ElevatedButton(onPressed: (){Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Rose KSH 10 - Yako KSH 4 (40%) -> $MERCHANT_POCHI")));}, child: Text("🌹 10")),
                    ElevatedButton(onPressed: (){Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lion KSH 1000 - Yako KSH 400 (40%) -> $MERCHANT_POCHI")));}, child: Text("🦁 1000")),
                  ])
                ])));
              }, child: Icon(Icons.card_giftcard, size: 35, color: Colors.pink)),
              Text("Gift"),
            ])),
            Positioned(bottom: 20, left: 15, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("@creator${i} - AV Live", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("SawaTok Kenya 🔥 #Live"),
            ])),
          ],
        );
      },
    );
  }
}

class LivePage extends StatefulWidget {
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  CameraController? _controller;
  bool _isLive = false;
  bool _initing = true;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    if (cameras.isEmpty) {
      setState(() => _initing = false);
      return;
    }
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if(mounted) setState(() => _initing = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initing) return Center(child: CircularProgressIndicator());
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.videocam_off, size: 80),
        SizedBox(height: 10),
        Text("Camera itafanya kwa simu halisi"),
        Text("Emulator haina camera"),
        SizedBox(height: 20),
        ElevatedButton(onPressed: () => setState(() => _isLive = !_isLive), child: Text(_isLive ? "STOP LIVE" : "GO LIVE DEMO")),
      ]));
    }

    return Stack(
      children: [
        SizedBox.expand(child: CameraPreview(_controller!)),
        Positioned(top: 40, left: 15, child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _isLive ? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(20)), child: Row(children: [Icon(Icons.circle, size: 10, color: Colors.white), SizedBox(width: 5), Text(_isLive ? "LIVE 1.2k" : "READY", style: TextStyle(fontWeight: FontWeight.bold))]))),
        Positioned(bottom: 30, left: 20, right: 20, child: Column(children: [
          if (_isLive) Container(padding: EdgeInsets.all(8), color: Colors.black54, child: Text("Yako 40% inaenda $MERCHANT_POCHI | Creator 60%", style: TextStyle(fontSize: 11), textAlign: TextAlign.center)),
          SizedBox(height: 10),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isLive ? Colors.red : Colors.pink, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () => setState(() => _isLive = !_isLive), child: Text(_isLive ? "STOP LIVE" : "🔴 GO LIVE - ANZA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ])),
      ],
    );
  }
}

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.account_balance_wallet, size: 80, color: Colors.green), Text("Wallet", style: TextStyle(fontSize: 24)), SizedBox(height: 20), Text("Pochi yako: $MERCHANT_POCHI"), Text("Balance: KSH 0"), Text("40% ya gifts zote", style: TextStyle(color: Colors.green))]));
}

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.store, size: 80), Text("Creator Store"), Text("Videos & Pics za kuuza")]));
}
