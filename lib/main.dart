import 'package:flutter/material.dart';
import 'screen/page_today.dart';
import 'screen/page_history.dart';
import 'screen/page_about.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'จดบันทึกการเดินทาง (Timeline)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'จดบันทึกการเดินทาง (Timeline)'),
      /// hide banner
      debugShowCheckedModeBanner:false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(

                    appBar: AppBar(
                        title: Text(widget.title),
                        bottom: TabBar(
                                    tabs: <Widget>[
                                        Tab(icon: Icon(Icons.access_time),
                                            text: "ประจำวัน"),
                                        Tab(icon: Icon(Icons.access_alarm),
                                            text: "ประวัติ"),
                                        Tab(icon: Icon(Icons.account_box_outlined),
                                            text: "เกี่ยวกับ"),

                                    ],
                            ),
                        ),
                    body: TabBarView(
                            children: [
                                PageToday(),
                                PageHistory(),
                                ScreenPage3(),
                                ],
                            ),
            ),
        );
    }


}
