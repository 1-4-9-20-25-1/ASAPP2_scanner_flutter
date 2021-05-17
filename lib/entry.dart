import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Entry extends StatefulWidget {
  const Entry({Key key}) : super(key: key);
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {

  final TextEditingController numberController=TextEditingController();
  final TextEditingController pincodeController=TextEditingController();

  Future<void> verifyCreds(String number,String pincode) async
  {
    final url = Uri.parse("https://asapp2.herokuapp.com/scannerlogin");
    Map<String, String> headers = {"Content-type": "application/json"};
    final data=jsonEncode({
      "number":number.toString(),
      "pincode":pincode.toString()
    });
    Response response = await post(url,headers: headers, body:data);
    if(response.statusCode==200)
    {
      Map<String, dynamic> obj = jsonDecode(response.body);
      Navigator.pushNamed(context, '/scan',arguments:obj);
    }
    else{

    }
  }

  Widget TextFieldWidget(String label,TextEditingController controller)
  {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.black
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color:Colors.black,width: 2)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black,width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[Color(0xFF93a5cf), Color(0xFFe4efe9)]
            )
          ),
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "scanner",
                      style:TextStyle(
                        letterSpacing: 4,
                        fontSize: 69,
                        fontFamily:'Quicksand',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  SizedBox(height: 200,),

                  TextFieldWidget("NUMBER",numberController),

                  SizedBox(height:30),

                  TextFieldWidget("PIN CODE",pincodeController),

                  SizedBox(height: 35),

                  RaisedButton(onPressed:(){
                    String number=numberController.text;
                    String pincode=pincodeController.text;
                    verifyCreds(number, pincode);
                  }, child: Text("SUBMIT"),
                    color: Colors.black,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: 15),
                    elevation: 5,
                  ),

                  SizedBox(height: 10,)
                ],
              ),
            ),
          )),
        ));
  }
}
