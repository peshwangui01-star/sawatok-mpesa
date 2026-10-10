class WalletPage extends StatefulWidget {
  final String phone;
  WalletPage({this.phone="07"});
  @override _WalletPageState createState()=>_WalletPageState();
}
class _WalletPageState extends State<WalletPage>{
  int balance = 1250; // balance ya mfano - itakuja kutoka Firebase baadaye
  TextEditingController amountCtrl = TextEditingController();
  bool withdrawing = false;

  void withdraw() async {
    int amount = int.tryParse(amountCtrl.text) ?? 0;
    if(amount < 100){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Min withdraw KSH 100"))); return; }
    if(amount > balance){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Balance haitoshi"))); return; }
    
    setState(()=> withdrawing=true);
    // hapa ndipo tuna-call M-Pesa API yako
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inatuma KSH $amount kwa ${widget.phone}...")));
    
    await Future.delayed(Duration(seconds: 2)); // simulate API call
    
    setState((){
      balance -= amount;
      withdrawing=false;
      amountCtrl.clear();
    });
    
    showDialog(context: context, builder: (_)=> AlertDialog(
      title: Text("Success! ✅"),
      content: Text("KSH $amount imetumwa kwa M-Pesa ${widget.phone}\nPochi: $POCHI\nBalance mpya: KSH $balance"),
      actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Sawa"))],
    ));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("My Wallet"), backgroundColor: Colors.black),
      body: Padding(padding: EdgeInsets.all(16), child: Column(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green)),
          child: Column(children: [
            Icon(Icons.account_balance_wallet, size: 50, color: Colors.green),
            SizedBox(height: 10),
            Text("Balance Yako", style: TextStyle(color: Colors.grey)),
            Text("KSH $balance", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("30% Earnings - 70% kwa Creators", style: TextStyle(color: Colors.green, fontSize: 12)),
            SizedBox(height: 5),
            Text("Phone: ${widget.phone}", style: TextStyle(color: Colors.white70)),
            Text("Pochi: $POCHI", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        SizedBox(height: 20),
        TextField(controller: amountCtrl, keyboardType: TextInputType.number, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Weka amount (min 100)", hintStyle: TextStyle(color: Colors.grey), filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
        SizedBox(height: 15),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: withdrawing? null : withdraw,
          child: withdrawing? CircularProgressIndicator(color: Colors.white) : Text("WITHDRAW VIA M-PESA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        )),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          TextButton(onPressed: (){setState(()=> amountCtrl.text="100");}, child: Text("100")),
          TextButton(onPressed: (){setState(()=> amountCtrl.text="500");}, child: Text("500")),
          TextButton(onPressed: (){setState(()=> amountCtrl.text="${balance}");}, child: Text("ALL")),
        ]),
        Spacer(),
        Text("Withdraws huenda kwa M-Pesa within 1 min", style: TextStyle(color: Colors.grey, fontSize: 11))
      ])),
    );
  }
}
