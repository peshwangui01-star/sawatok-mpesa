import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

late List<CameraDescription> cameras;
List<Map> globalVideos = [
  {"user":"pesh_wangui","cap":"SawaTok live Murang'a 🔥 #kenya #fyp","music":"Original Audio - pesh_wangui","likes":45200,"comm":1200,"book":340,"share":89,"av":"P","pin":true,"liked":false,"follow":false},
  {"user":"kenya_girl","cap":"Live gifts only! #sawatok","music":"Trending - SawaTok","likes":8900,"comm":450,"book":120,"share":34,"av":"K","pin":false,"liked":false,"follow":false},
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MainNav(), theme: ThemeData.dark()));
}

class MainNav extends StatefulWidget { @override _MainNavState createState() => _MainNavState(); }
class _MainNavState extends State<MainNav> {
  int idx = 0;
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: [FeedPage(), UploadPage(), LivePage(), InboxPage(), ProfilePage()][idx],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, selectedItemColor: Colors.white, unselectedItemColor: Colors.grey,
        currentIndex: idx, type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => idx = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32), label: "Post"),
          BottomNavigationBarItem(icon: Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)), child: Text("LIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))), label: "LIVE"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ================= FEED PAGE =================
class FeedPage extends StatefulWidget { @override _FeedPageState createState() => _FeedPageState(); }
class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  late AnimationController disc;
  bool paused = false;
  VideoPlayerController? videoCtrl;
  int cur = 0;

  @override void initState(){ super.initState(); disc = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat(); }
  @override void dispose(){ disc.dispose(); videoCtrl?.dispose(); super.dispose(); }

  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Colors.black, body: Stack(children: [
      PageView.builder(
        scrollDirection: Axis.vertical, itemCount: globalVideos.length,
        onPageChanged: (i){ setState(()=> cur=i); videoCtrl?.seekTo(Duration.zero); },
        itemBuilder: (_,i){
          var v=globalVideos[i];
          return GestureDetector(
            onTap: ()=> setState(()=> paused=!paused),
            child: Stack(children: [
              Container(width: double.infinity, height: double.infinity, color: Colors.primaries[i%18].withOpacity(0.4), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.play_circle_fill, size: 70, color: Colors.white24), SizedBox(height: 10), Text(v["cap"], textAlign: TextAlign.center, style: TextStyle(color: Colors.white54))] ))),
              if(paused) Center(child: Icon(Icons.play_arrow, size: 80, color: Colors.white70)),
              Positioned(right: 12, bottom: 120, child: Column(children: [
                Stack(clipBehavior: Clip.none, children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue, border: Border.all(color: Colors.white, width: 2)), child: Center(child: Text(v["av"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)))),
                  if(!v["follow"]) Positioned(bottom: -8, left: 10, right: 10, child: GestureDetector(onTap: ()=> setState(()=> v["follow"]=true), child: Container(decoration: BoxDecoration(color: Color(0xFFFF2D55), shape: BoxShape.circle), child: Icon(Icons.add, size: 18, color: Colors.white)))),
                  if(v["pin"]) Positioned(top: -5, right: -5, child: Icon(Icons.push_pin, color: Colors.yellow, size: 18)),
                ]),
                SizedBox(height: 20),
                iconBtn(Icons.favorite, v["liked"]?Colors.red:Colors.white, v["likes"], (){ if(!v["liked"]){ setState((){ v["liked"]=true; v["likes"]++; }); }}),
                iconBtn(Icons.chat_bubble, Colors.white, v["comm"], (){ showComments(v); }),
                iconBtn(Icons.bookmark, Colors.white, v["book"], (){ setState(()=> v["book"]++); }),
                iconBtn(Icons.share, Colors.white, v["share"], (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Link copied: sawatok.com/@${v["user"]}"))); }),
                SizedBox(height: 15),
                RotationTransition(turns: disc, child: Container(width: 45, height: 45, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, border: Border.all(color: Colors.white24)), child: Icon(Icons.album, color: Colors.white30))),
              ])),
              Positioned(left: 12, bottom: 70, right: 90, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("@${v["user"]}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                SizedBox(height: 5),
                Text(v["cap"], style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(height: 8),
                Row(children: [Icon(Icons.music_note, size: 14, color: Colors.white), SizedBox(width: 5), Expanded(child: Text(v["music"], style: TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis))]),
              ])),
            ]),
          );
        },
      ),
      SafeArea(child: Padding(padding: EdgeInsets.only(top: 10), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [tab("Following", false), SizedBox(width: 20), tab("For You", true), SizedBox(width: 20), tab("Friends", false)]))),
      Positioned(bottom: 8, left: 20, right: 20, child: GestureDetector(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchPage())), child: Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white24)), child: Row(children: [Icon(Icons.search, size: 18, color: Colors.white70), SizedBox(width: 8), Text("Search creators, sounds...", style: TextStyle(color: Colors.white70, fontSize: 13))])))),
    ]));
  }
  Widget tab(String t, bool a)=> Column(children: [Text(t, style: TextStyle(color: a?Colors.white:Colors.white60, fontWeight: a?FontWeight.bold:FontWeight.normal)), if(a) Container(margin: EdgeInsets.only(top: 3), width: 25, height: 2, color: Colors.white)]);
  Widget iconBtn(IconData ic, Color c, int num, VoidCallback f)=> Padding(padding: EdgeInsets.only(bottom: 16), child: GestureDetector(onTap: f, child: Column(children: [Icon(ic, color: c, size: 30), SizedBox(height: 3), Text(fmt(num), style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)) ])));
  String fmt(int n){ if(n>=1000) return "${(n/1000).toStringAsFixed(1)}K"; return "$n"; }
  void showComments(Map v){ showModalBottomSheet(context: context, backgroundColor: Colors.grey[900], builder: (_)=> Container(padding: EdgeInsets.all(16), height: 300, child: Column(children: [Text("${v["comm"]} Comments", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(height: 10), Expanded(child: ListView(children: [ListTile(leading: CircleAvatar(child: Text("K")), title: Text("Nice video! 🔥", style: TextStyle(color: Colors.white)), subtitle: Text("@kenya_girl", style: TextStyle(color: Colors.white54)))]))]))); }
}

// ================= UPLOAD PAGE - CAMERA/GALLERY PICKER =================
class UploadPage extends StatefulWidget { @override _UploadPageState createState() => _UploadPageState(); }
class _UploadPageState extends State<UploadPage> {
  XFile? pickedVideo;
  final picker = ImagePicker();
  final capCtrl = TextEditingController();
  final hashCtrl = TextEditingController(text: "#kenya #fyp #sawatok ");
  final musicCtrl = TextEditingController(text: "Original Audio - pesh_wangui");
  VideoPlayerController? previewCtrl;

  Future<void> pickVideoGallery() async {
    final v = await picker.pickVideo(source: ImageSource.gallery);
    if(v!=null){ setState(()=> pickedVideo=v); initPreview(); }
  }
  Future<void> pickVideoCamera() async {
    final v = await picker.pickVideo(source: ImageSource.camera);
    if(v!=null){ setState(()=> pickedVideo=v); initPreview(); }
  }
  void initPreview(){
    if(pickedVideo!=null){
      previewCtrl = VideoPlayerController.file(File(pickedVideo!.path))..initialize().then((_){ setState((){}); previewCtrl!.setLooping(true); previewCtrl!.play(); });
    }
  }
  @override void dispose(){ previewCtrl?.dispose(); capCtrl.dispose(); hashCtrl.dispose(); musicCtrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("New Post"), actions: [if(pickedVideo!=null) TextButton(onPressed: postVideo, child: Text("POST", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)))]),
      body: pickedVideo==null? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.video_library, size: 80, color: Colors.white24),
        SizedBox(height: 20),
        Text("Select video to post", style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton.icon(icon: Icon(Icons.camera_alt), label: Text("Camera"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: pickVideoCamera),
          SizedBox(width: 20),
          ElevatedButton.icon(icon: Icon(Icons.photo_library), label: Text("Gallery"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: pickVideoGallery),
        ]),
        SizedBox(height: 20),
        Text("10+ bottom row support ✅", style: TextStyle(color: Colors.white54, fontSize: 12)),
      ]))
      : SingleChildScrollView(child: Column(children: [
        Container(height: 350, color: Colors.grey[900], child: previewCtrl!=null && previewCtrl!.value.isInitialized? VideoPlayer(previewCtrl!): Center(child: CircularProgressIndicator())),
        Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: capCtrl, style: TextStyle(color: Colors.white), maxLines: 3, decoration: InputDecoration(labelText: "Add caption", labelStyle: TextStyle(color: Colors.white54), border: OutlineInputBorder(), hintText: "What's happening?", hintStyle: TextStyle(color: Colors.white30))),
          SizedBox(height: 12),
          TextField(controller: hashCtrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Hashtags", labelStyle: TextStyle(color: Colors.white54), border: OutlineInputBorder(), prefixIcon: Icon(Icons.tag, color: Colors.white54))),
          SizedBox(height: 12),
          TextField(controller: musicCtrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Music name", labelStyle: TextStyle(color: Colors.white54), border: OutlineInputBorder(), prefixIcon: Icon(Icons.music_note, color: Colors.white54))),
          SizedBox(height: 20),
          ElevatedButton(onPressed: postVideo, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text("POST TO FEED →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          SizedBox(height: 10),
          TextButton(onPressed: ()=> setState(()=> pickedVideo=null), child: Text("Pick another video", style: TextStyle(color: Colors.white54))),
        ])),
      ])),
    );
  }
  void postVideo(){
    if(capCtrl.text.isEmpty && hashCtrl.text.isEmpty) return;
    final newVid = {"user":"pesh_wangui","cap":"${capCtrl.text} ${hashCtrl.text}","music":musicCtrl.text,"likes":0,"comm":0,"book":0,"share":0,"av":"P","pin":false,"liked":false,"follow":false};
    setState(()=> globalVideos.insert(0, newVid));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Posted! Now in For You feed ✅")));
    setState(()=> pickedVideo=null);
    capCtrl.clear();
    // Go to feed
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> MainNav()), (r)=> false);
  }
}

class LivePage extends StatefulWidget { @override _LivePageState createState() => _LivePageState(); }
class _LivePageState extends State<LivePage> {
  late CameraController ctrl; bool live=false; int viewers=0; List<String> guests=[];
  @override void initState(){ super.initState(); ctrl = CameraController(cameras[0], ResolutionPreset.medium); ctrl.initialize().then((_){ if(mounted) setState((){}); }); }
  @override void dispose(){ ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    if(!ctrl.value.isInitialized) return Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    return Scaffold(body: Stack(children: [
      SizedBox(width: double.infinity, height: double.infinity, child: CameraPreview(ctrl)),
      SafeArea(child: Padding(padding: EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: live?Colors.red:Colors.black54, borderRadius: BorderRadius.circular(20)), child: Text(live?"🔴 LIVE $viewers viewers":"PREVIEW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
        if(live) GestureDetector(onTap: ()=> setState(()=> live=false), child: Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: Text("End Live", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
      ]))),
      if(guests.isNotEmpty) Positioned(top: 70, left: 12, child: Row(children: guests.map((g)=> Container(margin: EdgeInsets.only(right: 6), width: 38, height: 38, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: Center(child: Text(g, style: TextStyle(color: Colors.white))))).toList())),
      Positioned(bottom: 15, left: 12, right: 12, child: Column(children: [
        if(live) Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [gift("Rose","10"), gift("Lion","1000"), gift("Rocket","200")]),
        SizedBox(height: 10),
        Row(children: [
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: live?Colors.grey:Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), padding: EdgeInsets.symmetric(vertical: 14)), onPressed: ()=> setState(()=> live=!live), child: Text(live?"END LIVE":"GO LIVE - 0 followers needed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          SizedBox(width: 8),
          if(live) ElevatedButton(onPressed: (){ if(guests.length<3) setState(()=> guests.add("G${guests.length+1}")); }, child: Text("Invite Guest"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white24)),
        ]),
        if(live) Padding(padding: EdgeInsets.only(top: 5), child: Text("70% you / 30% SawaTok - Max 200 KES withdraw per gift", style: TextStyle(color: Colors.white70, fontSize: 9))),
      ])),
    ]));
  }
  Widget gift(String name, String kes)=> Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(name, style: TextStyle(color: Colors.white, fontSize: 11)), Text(kes, style: TextStyle(color: Colors.white70, fontSize: 9))]));
}

class SearchPage extends StatelessWidget { @override Widget build(BuildContext context)=> Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: TextField(decoration: InputDecoration(hintText: "Search...", hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none), style: TextStyle(color: Colors.white), autofocus: true)), body: Center(child: Text("Type to search creators, sounds, hashtags", style: TextStyle(color: Colors.white54)))); }
class InboxPage extends StatelessWidget { @override Widget build(BuildContext context)=> Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("Inbox - Gifts 70% yours")), body: ListTile(leading: CircleAvatar(child: Text("K")), title: Text("kenya_girl sent Lion", style: TextStyle(color: Colors.white)), subtitle: Text("1000 KES - you get 700 KES", style: TextStyle(color: Colors.white54)))); }
class ProfilePage extends StatelessWidget { @override Widget build(BuildContext context)=> Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("Profile")), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 45, child: Text("P", style: TextStyle(fontSize: 35))), SizedBox(height: 8), Text("@pesh_wangui", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), Text("0 Followers can go LIVE ✅", style: TextStyle(color: Colors.green)), SizedBox(height: 10), Text("${globalVideos.length} Videos posted", style: TextStyle(color: Colors.white70))]))); }
