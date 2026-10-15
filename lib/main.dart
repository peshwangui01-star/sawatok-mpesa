import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;
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
      body: [FeedPage(), LivePage(), InboxPage(), ProfilePage()][idx],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, selectedItemColor: Colors.white, unselectedItemColor: Colors.grey,
        currentIndex: idx, type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => idx = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "LIVE"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class FeedPage extends StatefulWidget { @override _FeedPageState createState() => _FeedPageState(); }
class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  late AnimationController disc;
  List<Map> videos = [
    {"user":"pesh_wangui","cap":"SawaTok live Murang'a #kenya #fyp","music":"Original Audio - pesh_wangui","likes":45200,"comm":1200,"book":340,"share":89,"av":"P","pin":true,"liked":false,"follow":false},
    {"user":"kenya_girl","cap":"Live gifts only! #sawatok","music":"Trending - SawaTok","likes":8900,"comm":450,"book":120,"share":34,"av":"K","pin":false,"liked":false,"follow":false},
    {"user":"nairobi_live","cap":"0 followers can go live!","music":"Original - nairobi_live","likes":23400,"comm":890,"book":560,"share":120,"av":"N","pin":false,"liked":false,"follow":false},
  ];
  int cur = 0;
  bool paused = false;
  @override void initState(){ super.initState(); disc = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat(); }
  @override void dispose(){ disc.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Colors.black, body: Stack(children: [
      PageView.builder(
        scrollDirection: Axis.vertical, itemCount: videos.length,
        onPageChanged: (i)=> setState(()=> cur=i),
        itemBuilder: (_,i){
          var v=videos[i];
          return GestureDetector(
            onTap: ()=> setState(()=> paused=!paused),
            child: Stack(children: [
              Container(width: double.infinity, height: double.infinity, color: Colors.primaries[i%18].withOpacity(0.3), child: Center(child: Icon(Icons.play_circle_fill, size: 80, color: Colors.white24))),
              if(paused) Center(child: Icon(Icons.play_arrow, size: 80, color: Colors.white70)),
              // Right Icons
              Positioned(right: 12, bottom: 120, child: Column(children: [
                Stack(clipBehavior: Clip.none, children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue, border: Border.all(color: Colors.white, width: 2)), child: Center(child: Text(v["av"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)))),
                  if(!v["follow"]) Positioned(bottom: -8, left: 10, right: 10, child: GestureDetector(onTap: ()=> setState(()=> v["follow"]=true), child: Container(decoration: BoxDecoration(color: Color(0xFFFF2D55), shape: BoxShape.circle), child: Icon(Icons.add, size: 18, color: Colors.white)))),
                  if(v["pin"]) Positioned(top: -5, right: -5, child: Icon(Icons.push_pin, color: Colors.yellow, size: 18)),
                ]),
                SizedBox(height: 20),
                iconBtn(Icons.favorite, v["liked"]?Colors.red:Colors.white, v["likes"], (){ if(!v["liked"]){ setState((){ v["liked"]=true; v["likes"]++; }); }}),
                iconBtn(Icons.chat_bubble, Colors.white, v["comm"], (){}),
                iconBtn(Icons.bookmark, Colors.white, v["book"], (){}),
                iconBtn(Icons.share, Colors.white, v["share"], (){}),
                SizedBox(height: 15),
                RotationTransition(turns: disc, child: Container(width: 45, height: 45, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, border: Border.all(color: Colors.white24)), child: Icon(Icons.album, color: Colors.white30))),
              ])),
              // Bottom Left
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
        Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: live?Colors.red:Colors.black54, borderRadius: BorderRadius.circular(20)), child: Text(live?"LIVE $viewers viewers":"PREVIEW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
        if(live) GestureDetector(onTap: ()=> setState(()=> live=false), child: Container(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: Text("End Live", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
      ]))),
      if(guests.isNotEmpty) Positioned(top: 70, left: 12, child: Row(children: guests.map((g)=> Container(margin: EdgeInsets.only(right: 6), width: 38, height: 38, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: Center(child: Text(g, style: TextStyle(color: Colors.white))))).toList())),
      Positioned(bottom: 15, left: 12, right: 12, child: Column(children: [
        if(live) Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [gift("Rose","10"), gift("Lion","1000"), gift("Rocket","200")]),
        SizedBox(height: 10),
        Row(children: [
          Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: live?Colors.grey:Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), padding: EdgeInsets.symmetric(vertical: 14)), onPressed: ()=> setState(()=> live=!live), child: Text(live?"END LIVE":"GO LIVE - 0 followers needed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          SizedBox(width: 8),
          if(live) ElevatedButton(onPressed: (){ if(guests.length<3) setState(()=> guests.add("G${guests.length+1}")); }, child: Text("Invite"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white24)),
        ]),
        if(live) Padding(padding: EdgeInsets.only(top: 5), child: Text("70% you / 30% SawaTok - Max 200 KES withdraw", style: TextStyle(color: Colors.white70, fontSize: 9))),
      ])),
    ]));
  }
  Widget gift(String name, String kes)=> Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(name, style: TextStyle(color: Colors.white, fontSize: 11)), Text(kes, style: TextStyle(color: Colors.white70, fontSize: 9))]));
}

class SearchPage extends StatelessWidget { @override Widget build(BuildContext context)=> Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("Search")), body: Center(child: Text("Search page - creators, sounds, hashtags", style: TextStyle(color: Colors.white54)))); }
class InboxPage extends StatelessWidget { @override Widget build(BuildContext context)=> Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("Inbox - Gifts 70% yours")), body: ListTile(leading: CircleAvatar(child: Text("K")), title: Text("kenya_girl sent Lion", style: TextStyle(color: Colors.white)), subtitle: Text("1000 KES - you get 700 KES", style: TextStyle(color: Colors.white54)))); }
class ProfilePage extends StatelessWidget { @override Widget build(BuildContext context)=> Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("Profile")), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 45, child: Text("P", style: TextStyle(fontSize: 35))), SizedBox(height: 8), Text("@pesh_wangui", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), Text("0 Followers can go LIVE ✅", style: TextStyle(color: Colors.green)), SizedBox(height: 15), Text("Pin: Long press video to pin 📌", style: TextStyle(color: Colors.white54))]))); }
