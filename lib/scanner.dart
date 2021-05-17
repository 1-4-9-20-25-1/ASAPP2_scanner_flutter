import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  Map<String, dynamic> data;
  String qrCodeResult = "- -";
  Future<void> scanResult() async {
    String codeScanner = await BarcodeScanner.scan();
    final url = Uri.parse('https://asapp2.herokuapp.com/scan');
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = codeScanner;
    Map<String,dynamic> obj=jsonDecode(json);
    if(obj['placeid']!=data['_id']){
      setState(() {
          qrCodeResult = "DENIED";
        });
        return;
    }
    Response response = await post(url, headers: headers, body: json);
    if (response.statusCode == 200) {
      setState(() {
        qrCodeResult = response.body;
      });
    }
  }

  IconData iconfxn() {
    if (qrCodeResult == "GRANTED")
      return Icons.check_circle;
    else if (qrCodeResult == "DENIED")
      return Icons.remove_circle ;
    else
      return Icons.qr_code_scanner_rounded;
  }

  Color colorfxn() {
    if (qrCodeResult == "GRANTED")
      return Colors.green;
    else if (qrCodeResult == "DENIED")
      return Colors.red;
    else
      return Colors.grey;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data['name'],
          style: TextStyle(
              color: Colors.black, fontSize: 69, fontFamily: 'Quicksand'),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  // colors: [Color(0xFFd4fc79), Color(0xFF96e6a1)]
                  colors:[Color(0xFF93a5cf), Color(0xFFe4efe9)]
              )),
        ),
        elevation: 5,
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 150,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 44,
                fontFamily: 'Quicksand',
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                color: colorfxn(),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Icon(
              iconfxn(),

              size: 200,
              color: colorfxn(),
            ),
            SizedBox(height: 70),
            RaisedButton(
              onPressed: () {
                scanResult();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
              padding: EdgeInsets.all(0),
              child:Container(
                decoration: BoxDecoration(
                    gradient:LinearGradient(
                        colors:[Color(0xFF93a5cf), Color(0xFFe4efe9)]
                  ),
                  borderRadius: BorderRadius.circular(80)
                ),
                padding: EdgeInsets.symmetric(horizontal: 60,vertical: 10),
                child: Text(
                  "SCAN",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Quicksand'
                  ),

                ),
              ),
              // color: Colors.black,

              elevation: 5,
            ),
          ],
        ),
      ),
    );
  }
}
