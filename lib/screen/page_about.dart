import 'package:flutter/material.dart';


class ScreenPage3 extends StatelessWidget {
  const ScreenPage3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 return Scaffold(
                appBar: AppBar(
                            title: Text("ผู้พัฒนาโปรแกรม"),
                            ),
                body: SingleChildScrollView(
                        child: Center(
                        child: Column(
                                children: [
                                     SizedBox(height: 30),
                                     ClipRRect(
                                            borderRadius: BorderRadius.circular(180.0),//or 15.0
                                            child: Container(
                                                    width: 250,
                                                    child: Image.asset('lib/images/warapetch.jpg'),
                                                     )
                                            ),
                                     SizedBox(height: 10),
                                     Text("วรเพชร  เรืองพรวิสุทธิ์",style: TextStyle(fontSize:22) ),
                                     SizedBox(height: 10),
                                     Text("นักพัฒนาโปรแกรม",style: TextStyle(fontSize:18,
                                            color: Colors.blue.shade600) ),
                                     SizedBox(height: 10),
                                     Text("Developer : Delphi , Python , Flutter",
                                        style: TextStyle(fontSize:16,color: Colors.blue.shade900),),
                                     SizedBox(height: 10),
                                     Text("Develop by Flutter Framework ,Build : 30/04/2564 21.30 ",
                                        style: TextStyle(fontSize:14,color: Colors.red.shade900),),

                                ],
                        ),
                    )
                )
        );
  }
}