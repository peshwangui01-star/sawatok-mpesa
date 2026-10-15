import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(SawaTokApp());
}

class SawaTokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LivePage(),
    );
  }
}

class LivePage extends StatefulWidget {
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  late CameraController _controller;
  bool _isLive = false;
  int viewers = 1247;
  int likes = 0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          // FULL CAMERA
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_controller),
          ),
          // TOP BAR
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 12),
                        SizedBox(width: 6),
                        Text(_isLive? "LIVE • $viewers" : "PREVIEW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 30), onPressed: () async {
                        final newCam = _controller.description == cameras[0]? cameras[1] : cameras[0];
                        await _controller.dispose();
                        _controller = CameraController(newCam, ResolutionPreset.high);
                        await _controller.initialize();
                        setState(() {});
                      }),
                      Icon(Icons.close, color: Colors.white, size: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // BOTTOM GIFTS
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87])),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      giftButton("🌹", "10"),
                      giftButton("👏", "50"),
                      giftButton("🦁", "1000"),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.grey : Colors.red, padding: EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        setState(() {
                          _isLive =!_isLive;
                          if (_isLive) viewers += 50;
                        });
                      },
                      child: Text(_isLive? "END LIVE" : "🔴 GO LIVE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // HEARTS
          Positioned(
            right: 16,
            bottom: 160,
            child: Column(
              children: [
                IconButton(icon: Icon(Icons.favorite, color: Colors.white, size: 40), onPressed: () => setState(() => likes++)),
                Text("$likes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Icon(Icons.comment, color: Colors.white, size: 35),
                Text("342", style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),
                Icon(Icons.share, color: Colors.white, size: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget giftButton(String emoji, String price) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white)),
      child: Column(children: [Text(emoji, style: TextStyle(fontSize: 24)), Text("$price KES", style: TextStyle(color: Colors.white, fontSize: 10))]),
    );
  }
}
