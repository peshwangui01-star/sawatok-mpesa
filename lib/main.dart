import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

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
      theme: ThemeData.dark(),
      home: MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;
  final pages = [FeedPage(), LiveCameraPage(), InboxPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Container(padding: EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)), child: Icon(Icons.live_tv, color: Colors.black, size: 20)), label: "LIVE"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ================= FEED PAGE - TIKTOK STYLE =================
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  List<VideoModel> videos = [
    VideoModel(username: "pesh_wangui", caption: "SawaTok live in Murang'a 🔥 #kenya #fyp", music: "Original Audio - pesh_wangui", likes: 45200, comments: 1200, bookmarks: 340, shares: 89, avatar: "P", isPinned: true),
    VideoModel(username: "kenya_girl", caption: "Live gifts only! #sawatok #live", music: "Trending Sound - SawaTok", likes: 8900, comments: 450, bookmarks: 120, shares: 34, avatar: "K", isPinned: false),
    VideoModel(username: "nairobi_live", caption: "0 followers can go live! #sawatok", music: "Original Audio - nairobi_live", likes: 23400, comments: 890, bookmarks: 560, shares: 120, avatar: "N", isPinned: false),
  ];

  int currentPage = 0;
  late AnimationController _discController;

  @override
  void initState() {
    super.initState();
    _discController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _discController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            onPageChanged: (i) {
              setState(() => currentPage = i);
            },
            itemBuilder: (context, index) {
              return VideoItem(video: videos[index], discController: _discController, isCurrent: currentPage == index);
            },
          ),
          // TOP TABS - Following, Followers, Friends
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  topTab("Following", false),
                  SizedBox(width: 20),
                  topTab("For You", true),
                  SizedBox(width: 20),
                  topTab("Friends", false),
                ],
              ),
            ),
          ),
          // PILL SEARCH BAR - AT VERY BOTTOM ABOVE NAV
          Positioned(
            bottom: 5,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage())),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white70, size: 20),
                    SizedBox(width: 10),
                    Text("Search creators, sounds...", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topTab(String text, bool active) {
    return Column(
      children: [
        Text(text, style: TextStyle(color: active? Colors.white : Colors.white60, fontWeight: active? FontWeight.bold : FontWeight.normal, fontSize: 16)),
        if(active) Container(margin: EdgeInsets.only(top: 4), width: 30, height: 3, color: Colors.white),
      ],
    );
  }
}

class VideoModel {
  String username, caption, music, avatar;
  int likes, comments, bookmarks, shares;
  bool isPinned, isLiked = false, isFollowing = false;
  VideoModel({required this.username, required this.caption, required this.music, required this.likes, required this.comments, required this.bookmarks, required this.shares, required this.avatar, required this.isPinned});
}

class VideoItem extends StatefulWidget {
  final VideoModel video;
  final AnimationController discController;
  final bool isCurrent;
  VideoItem({required this.video, required this.discController, required this.isCurrent});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _videoController;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // Demo video from network - replace with your video
    _videoController = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
     ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.setVolume(1.0);
        if(widget.isCurrent) _videoController.play();
      });
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isCurrent) {
      _videoController.play();
      _videoController.seekTo(Duration.zero); // Restart previous video as per requirement 23
    } else {
      _videoController.pause();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // VIDEO BACKGROUND
        GestureDetector(
          onTap: () {
            setState(() {
              _isPaused =!_isPaused;
              _isPaused? _videoController.pause() : _videoController.play();
            });
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: _videoController.value.isInitialized
             ? VideoPlayer(_videoController)
              : Center(child: Text(widget.video.avatar, style: TextStyle(fontSize: 100, color: Colors.white24))),
          ),
        ),
        if(_isPaused) Center(child: Icon(Icons.play_arrow, color: Colors.white70, size: 80)),

        // RIGHT ICONS - All white with count below + shadow
        Positioned(
          right: 12,
          bottom: 120,
          child: Column(
            children: [
              // Avatar + Follow overlapping
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaries[widget.video.username.length % 18], border: Border.all(color: Colors.white, width: 2)),
                    child: Center(child: Text(widget.video.avatar, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
                  ),
                  if(!widget.video.isFollowing)
                  Positioned(
                    bottom: -8, left: 10, right: 10,
                    child: GestureDetector(
                      onTap: () => setState(() => widget.video.isFollowing = true),
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFFFF2D55), shape: BoxShape.circle),
                        child: Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  if(widget.video.isPinned)
                  Positioned(top: -5, right: -5, child: Icon(Icons.push_pin, color: Colors.yellow, size: 20)),
                ],
              ),
              SizedBox(height: 25),
              sideIcon(Icons.favorite, widget.video.isLiked? Colors.red : Colors.white, widget.video.likes, () {
                if(!widget.video.isLiked) {
                  setState(() { widget.video.isLiked = true; widget.video.likes++; });
                }
              }),
              sideIcon(Icons.chat_bubble, Colors.white, widget.video.comments, () {}),
              sideIcon(Icons.bookmark, Colors.white, widget.video.bookmarks, () {}),
              sideIcon(Icons.link, Colors.white, widget.video.shares, () {}),
              SizedBox(height: 20),
              // Vinyl Record - Spinning
              RotationTransition(
                turns: widget.discController,
                child: Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, border: Border.all(color: Colors.grey, width: 2)),
                  child: Icon(Icons.album, color: Colors.white30, size: 30),
                ),
              ),
            ],
          ),
        ),

        // BOTTOM LEFT - Music + Username
        Positioned(
          left: 12,
          bottom: 70,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("@${widget.video.username}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
              SizedBox(height: 6),
              Text(widget.video.caption, style: TextStyle(color: Colors.white, fontSize: 14, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Expanded(child: Text(widget.video.music, style: TextStyle(color: Colors.white, fontSize: 13, shadows: [Shadow(color: Colors.black, blurRadius: 4)]), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sideIcon(IconData icon, Color color, int count, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: color, size: 32, shadows: [Shadow(color: Colors.black, blurRadius: 8)]),
            SizedBox(height: 4),
            Text(formatCount(count), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 6)])),
          ],
        ),
      ),
    );
  }

  String formatCount(int n) {
    if(n >= 1000) return "${(n/1000).toStringAsFixed(1)}K";
    return "$n";
  }
}

// ================= LIVE CAMERA PAGE =================
class LiveCameraPage extends StatefulWidget {
  @override
  _LiveCameraPageState createState() => _LiveCameraPageState();
}

class _LiveCameraPageState extends State<LiveCameraPage> {
  late CameraController _controller;
  bool _isLive = false;
  int viewers = 0;
  List<String> guests = [];

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    _controller.initialize().then((_) { if(mounted) setState(() {}); });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if(!_controller.value.isInitialized) return Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(width: double.infinity, height: double.infinity, child: CameraPreview(_controller)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: _isLive? Colors.red : Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Text(_isLive? "🔴 LIVE • $viewers viewers" : "PREVIEW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  if(_isLive) GestureDetector(
                    onTap: () => setState(() { _isLive = false; viewers = 0; }),
                    child: Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: Text("End Live", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
          ),
          if(guests.isNotEmpty) Positioned(top: 80, left: 12, child: Row(children: guests.map((g) => Container(margin: EdgeInsets.only(right: 8), width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: Center(child: Text(g)))).toList())),
          Positioned(
            bottom: 20, left: 16, right: 16,
            child: Column(
              children: [
                if(_isLive) Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  giftBtn("🌹", 10), giftBtn("🦁", 1000), giftBtn("🚀", 200),
                ]),
                SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _isLive? Colors.grey : Colors.red, padding: EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      onPressed: () => setState(() { _isLive =!_isLive; if(_isLive) viewers = 1; }),
                      child: Text(_isLive? "END LIVE" : "🔴 GO LIVE (0 followers needed)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 10),
                  if(_isLive) ElevatedButton(onPressed: () { if(guests.length < 3) setState(() => guests.add("G${guests.length+1}")); }, child: Text("Invite Guest"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                ]),
                if(_isLive) Padding(padding: EdgeInsets.only(top: 8), child: Text("70% to you, 30% to SawaTok • Max withdraw 200 KES per gift", style: TextStyle(color: Colors.white70, fontSize: 10))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget giftBtn(String emoji, int kes) {
    return Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white)), child: Column(children: [Text(emoji, style: TextStyle(fontSize: 20)), Text("$kes", style: TextStyle(color: Colors.white, fontSize: 10))])),
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Container(padding: EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)), child: TextField(decoration: InputDecoration(icon: Icon(Icons.search, color: Colors.white54), hintText: "Search creators, sounds...", hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none), style: TextStyle(color: Colors.white)))), body: Center(child: Text("Search results will show here", style: TextStyle(color: Colors.white54))));
  }
}

class InboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("Inbox")), body: ListView(children: [ListTile(leading: CircleAvatar(child: Text("K")), title: Text("kenya_girl sent you a gift 🌹", style: TextStyle(color: Colors.white)), subtitle: Text("10 KES • 70% yours = 7 KES", style: TextStyle(color: Colors.white54)), trailing: Text("now", style: TextStyle(color: Colors.white54)))]));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("Profile")), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 50, child: Text("P", style: TextStyle(fontSize: 40))), SizedBox(height: 10), Text("@pesh_wangui", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text("0 Followers can go LIVE ✅", style: TextStyle(color: Colors.green)), SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.center, children: [profileStat("12", "Videos"), SizedBox(width: 20), profileStat("0", "Followers"), SizedBox(width: 20), profileStat("0", "Following")]), SizedBox(height: 20), ElevatedButton(onPressed: () {}, child: Text("Pinned Video 📌")), Text("Long press any video to Pin", style: TextStyle(color: Colors.white54, fontSize: 12))])));
  }
  Widget profileStat(String count, String label) => Column(children: [Text(count, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), Text(label, style: TextStyle(color: Colors.white54))]);
}
