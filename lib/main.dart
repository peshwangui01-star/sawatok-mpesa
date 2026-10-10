import 'package:flutter/material.dart';
const String POCHI="0180879250";
void main(){runApp(MaterialApp(debugShowCheckedModeBanner:false, home:HomePage()));}
class HomePage extends StatefulWidget{@override _HomePageState createState()=>_HomePageState();}
class _HomePageState extends State<HomePage>{
int idx=0; int my=1250; int creator=0;

Widget forYou()=>Container(color:Colors.black, child:Center(child:Column(mainAxisSize:MainAxisSize.min, children:[
Text("FOR YOU", style:TextStyle(color:Colors.white, fontSize:24)),
SizedBox(height:20),
Text("Gift hapa = 100% YAKO\nCreator 0%", style:TextStyle(color:Colors.grey), textAlign:TextAlign.center),
SizedBox(height:20),
ElevatedButton(onPressed:(){setState(()=>my+=100); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("For You 100: Yako KSH 100 | Creator 0")));}, child:Text("🎁 Gift 100 - Yako 100%")),
])));

Widget live()=>Container(color:Colors.black, child:Center(child:Column(mainAxisSize:MainAxisSize.min, children:[
Icon(Icons.live_tv, color:Colors.red, size:50),
Text("LIVE GIFTS PEKEE", style:TextStyle(color:Colors.white, fontSize:22, fontWeight:FontWeight.bold)),
SizedBox(height:10),
Text("Creator 70% | Wewe 30%", style:TextStyle(color:Colors.yellow, fontWeight:FontWeight.bold)),
SizedBox(height:20),
ElevatedButton(onPressed:(){
setState((){creator+=70; my+=30;});
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Live 100: Creator 70 | Wewe 30")));
}, child:Text("🌹 Rose 100")),
SizedBox(height:10),
ElevatedButton(onPressed:(){
setState((){creator+=700; my+=300;});
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Live 1000: Creator 700 | Wewe 300")));
}, child:Text("🦁 Simba 1000")),
SizedBox(height:20),
Text("Creator amepata: KSH $creator", style:TextStyle(color:Colors.white)),
Text("Wewe umepata: KSH $my", style:TextStyle(color:Colors.green)),
])));

Widget wallet()=>Scaffold(backgroundColor:Colors.black, body:Padding(padding:EdgeInsets.all(20), child:Column(children:[
SizedBox(height:50),
Text("KSH $my", style:TextStyle(color:Colors.white, fontSize:40, fontWeight:FontWeight.bold)),
Text("YAKO", style:TextStyle(color:Colors.green)),
SizedBox(height:20),
Container(padding:EdgeInsets.all(15), decoration:BoxDecoration(color:Color(0xFF222222), borderRadius:BorderRadius.circular(10)), child:Column(children:[
Text("LIVE GIFTS PEKEE", style:TextStyle(color:Colors.yellow, fontWeight:FontWeight.bold)),
Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Text("Creator:", style:TextStyle(color:Colors.grey)), Text("70% = KSH $creator", style:TextStyle(color:Colors.white))]),
Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Text("Wewe:", style:TextStyle(color:Colors.grey)), Text("30% = Live + 100% For You", style:TextStyle(color:Colors.green))]),
])),
SizedBox(height:30),
SizedBox(width:double.infinity, height:50, child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Colors.green), onPressed:(){
if(my<100) return; setState(()=>my-=100); showDialog(context:context, builder:(_)=>AlertDialog(title:Text("Success"), content:Text("KSH 100 Pochi $POCHI"), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:Text("Sawa"))]));
}, child:Text("WITHDRAW VIA M-PESA"))),
Spacer(),
Text("Pochi: $POCHI", style:TextStyle(color:Colors.grey)),
])));

@override Widget build(BuildContext context)=>Scaffold(body:[forYou(), live(), wallet()][idx], bottomNavigationBar:BottomNavigationBar(currentIndex:idx, onTap:(i)=>setState(()=>idx=i), items:[BottomNavigationBarItem(icon:Icon(Icons.home), label:"For You"), BottomNavigationBarItem(icon:Icon(Icons.live_tv), label:"Live 70/30"), BottomNavigationBarItem(icon:Icon(Icons.wallet), label:"Wallet")]));
}
