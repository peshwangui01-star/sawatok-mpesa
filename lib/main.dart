import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(SawaTokApp());
}

class SawaTokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TikTokFeedScreen(),
    );
  }
}

class TikTokFeedScreen extends StatefulWidget {
  @override
  _TikTokFeedScreenState createState() => _TikTokFeedScreenState();
}

class _TikTokFeedScreenState extends State<TikTokFeedScreen> {
  // Demo videos from internet - we will replace with your videos later
  final List<String> videos = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
  ];

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoItem(videoUrl: videos[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 40, color: Color(0xFFFF004F)), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String videoUrl;
  VideoItem({required this.videoUrl});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
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
    return Stack(
      children: [
        // Video
        _controller.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator(color: Colors.white)),

        // Right side buttons like TikTok
        Positioned(
          right: 10,
          bottom: 100,
          child: Column(
            children: [
              Icon(Icons.favorite, color: Colors.white, size: 35),
              Text('12.5K', style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              Icon(Icons.comment, color: Colors.white, size: 35),
              Text('340', style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              Icon(Icons.share, color: Colors.white, size: 35),
              Text('Share', style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              Icon(Icons.attach_money, color: Color(0xFF00FF00), size: 35),
              Text('M-Pesa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // Bottom text
        Positioned(
          left: 15,
          bottom: 20,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('@sawatok_user', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 5),
              Text('Welcome to SawaTok! 🔥 #kenya #sawatok #mpesa', style: TextStyle(color: Colors.white)),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 15),
                  Text(' Original sound - SawaTok', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
