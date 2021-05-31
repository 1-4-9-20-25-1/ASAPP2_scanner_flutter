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
  String numerr="",pinerr="",resErr="";
  bool numflag=false,pinflag=false,flag=false;
  final TextEditingController numberController=TextEditingController();
  final TextEditingController pincodeController=TextEditingController();

  Future<void> verifyCreds(String number,String pincode) async
  {

    if(number=="" || pincode=="" || number.length!=10)
    {
      setState(() {
        if(number=="" || number.length!=10)
        {
          numerr="Please enter a valid number.";
          pinflag=false;
          flag=false;
          numflag=true;
        }
        if(pincode=="")
        {
          pinerr="Please enter a valid pincode.";
          if(number!="" && number.length==10)
            numflag=false;
          flag=!flag;
          pinflag=true;
        }
      });
      return;
    }
    final url = Uri.parse("https://asapp2.herokuapp.com/scannerlogin");
    Map<String, String> headers = {"Content-type": "application/json"};
    final data=jsonEncode({
      "number":number,
      "pincode":pincode
    });
    Response response = await post(url,headers: headers, body:data);
    Map<String, dynamic> obj = jsonDecode(response.body);
    if(response.statusCode==200)
    {
      Navigator.pushReplacementNamed(context, '/scan',arguments:obj);
    }
    else{
      setState(() {
        resErr=obj['msg'];
        numflag=false;
        pinflag=false;
        flag=true;
      });
    }
  }

  Widget TextFieldWidget(String label,TextEditingController controller,bool flag)
  {
    return TextField(
      controller: controller,
      obscureText: flag,
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

  Widget ErrorMessageWidget(String message,bool flag)
  {
    return Visibility(
      visible:flag ,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Text(
          message,
          style:TextStyle(
              letterSpacing: 1,
            fontSize: 15,

          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "scanner",
                          style:TextStyle(
                            letterSpacing: 4,
                            fontSize: 69,
                            fontFamily:'Quicksand',
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 200,),

                  TextFieldWidget("NUMBER",numberController,false),
                  ErrorMessageWidget(numerr,numflag),
                  SizedBox(height:30),

                  TextFieldWidget("PIN CODE",pincodeController,true),
                  ErrorMessageWidget(pinerr,pinflag),
                  SizedBox(height: 35),
                  Visibility(
                    visible: flag,
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(resErr,
                      style:TextStyle(
                        fontSize: 15,
                        letterSpacing: 1
                      )
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                    ],
                  ),

                  SizedBox(height: 10,)
                ],
              ),
            ),
          )),
        ));
  }
}
