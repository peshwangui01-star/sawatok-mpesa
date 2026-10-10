class WalletPage extends StatefulWidget {
  final String phone;
  WalletPage({this.phone="07"});
  @override _WalletPageState createState()=>_WalletPageState();
}
class _WalletPageState extends State<WalletPage>{
  int balance=1250;
  TextEditingController amountCtrl=TextEditingController();
  void withdraw(){
    int amount=int.tryParse(amountCtrl.text)??0;
    if(amount<100 || amount>balance) return;
    setState(()=> balance-=amount);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("KSH $amount imetumwa kwa ${widget.phone}!")));
  }
  @override Widget build(BuildContext context){
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Balance: KSH $balance", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text("30% Earnings!", style: TextStyle(color: Colors.green)),
      Padding(padding: EdgeInsets.all(16), child: TextField(controller: amountCtrl, decoration: InputDecoration(hintText: "Amount"), keyboardType: TextInputType.number)),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: withdraw, child: Text("WITHDRAW VIA M-PESA")),
      Text("Pochi: $POCHI  Phone: ${widget.phone}")
    ]));
  }
}
