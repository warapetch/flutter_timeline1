import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../data/db_ctrl_sqlite.dart';
import '../data/db_model_trans.dart';

import '../mylib/mydialog.dart';
import '../mylib/mylib_datetime.dart';
import '../screen/trans_add_page.dart';
import '../screen/trans_edit_page.dart';
import 'package:timelines/timelines.dart';


class PageToday extends StatefulWidget {
  const PageToday({Key key}) : super(key: key);

  @override
  _PageTodayState createState() => _PageTodayState();
}

class _PageTodayState extends State<PageToday> {

    @override
    void initState() {
      super.initState();

        // open database
        DBProvider.db.initDB();


    }

    getUserId() async {
        var resultSet = await DBProvider.db.getUser();
        setState(() {
            userId = resultSet.id;
        });

    }

  @override
  Widget build(BuildContext context) {

    if (userId==""){
        getUserId();
    }

    if (userId == ""){
        return showStatusSign("กำลังโหลด ...");//CircularProgressIndicator();
    }
    else
     return FutureBuilder(
            /// select Transaction == 'Today'
            future: DBProvider.db.getTransByDate(userId, DateTime.now()),
                builder: (context, snapshot) {

                    if (snapshot.hasData) {
                        return buildTimelines(snapshot.data);
                    }

                    //if (snapshot.data == null || snapshot.data.length == 0) {
                    //    return Text('ยังไม่ได้มีการจดบันทึก');
                   // }

                   return new Center(child: new CircularProgressIndicator());

                },
        );
  }


Widget buildTimelines(List<TBTrans> data){

    return Container(
            width: MediaQuery.of(context).size.width,//double.infinity,
            height: MediaQuery.of(context).size.height,//double.infinity,

            child: Scaffold(
                        appBar: AppBar(
                            title: Text("รายการวันนี้ :  "+cnvDateTimeToDMYStr(DateTime.now())),
                            actions: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 35),
                                            child:
                                        ElevatedButton(onPressed: (){
                                                        MaterialPageRoute newRoute = MaterialPageRoute(builder: (context) => TransAddPage(),);
                                                        Navigator.push(context, newRoute).then((_)=>setState((){})); // refresh screen
                                                        },
                                                    child: Icon(Icons.add,)
                                                    )
                                        )
                                ],
                            ),
                        body: Timeline.tileBuilder(

                                            theme: new TimelineThemeData(
                                                    nodePosition: 0.05,
                                                    connectorTheme: ConnectorThemeData(
                                                            thickness: 3.0,
                                                            color: Color(0xffd3d3d3),
                                                            )
                                                        ),

                                            padding: EdgeInsets.all(8),
                                            builder: TimelineTileBuilder.fromStyle(

                                                            contentsAlign: ContentsAlign.basic,
                                                            indicatorStyle: IndicatorStyle.outlined,
                                                            connectorStyle: ConnectorStyle.dashedLine,
                                                            contentsBuilder: (context, index) =>
                                                                                 Padding(
                                                                                    padding: const EdgeInsets.all(0.0),
                                                                                    child: buildCardTimeline(data,index)
                                                                                ),
                                                            itemCount: data.length,
                                                    ),
                                            )
            ),
    );
  }


  Widget buildCardTimeline(List<TBTrans> data,int index){

       return Card(
                    shadowColor: Colors.blue,
                    //color: selectedIndex ? Colors.blueAccent : Colors.white ,
                    child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Stack(
                                           children: <Widget>[
                                                            Positioned(
                                                                    left: 260,
                                                                    child: TextButton(
                                                                            onPressed: (){
                                                                                MaterialPageRoute newRoute = MaterialPageRoute(builder: (context) => TransEditPage(),
                                                                                    settings: RouteSettings(arguments: data[index]),);

                                                                                Navigator.push(context, newRoute).then((_)=>setState((){})); // refresh screen

                                                                            },
                                                                            child: Icon(Icons.edit))
                                                                            ),
                                                            Positioned(
                                                                    left: 260,
                                                                    top: 50,
                                                                    child: TextButton(
                                                                            onPressed: (){
                                                                                    confirmDialog(context: context,
                                                                                        textTitle: "ยืนยันการลบข้อมูล ?",
                                                                                        textBody: "หากลบแล้วข้อมูลจะหายไป !!",
                                                                                        textButtonConfirm: "ยืนยัน",
                                                                                        textButtonCancel: "ยกเลิก",
                                                                                        onSelected: (confirm){
                                                                                                        if (confirm){
                                                                                                            DBProvider.db.deleteTrans1(
                                                                                                                data[index].id,
                                                                                                                data[index].tldate,
                                                                                                                data[index].tlstime,
                                                                                                                data[index].tlno);

                                                                                                            setState(() {

                                                                                                            });
                                                                                                        }
                                                                                                    }
                                                                                    );
                                                                            },
                                                                            child: Icon(Icons.delete,color: Colors.red,))
                                                                            ),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                                Text('${data[index].tlplace}',style: TextStyle(fontSize: 16 ,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.blue),),
                                                                SizedBox(height:10),
                                                                buildRow1(data,index),
                                                                buildRow2(data,index),
                                                                buildRow3(data,index),
                                                        ],
                                                    ),
                                            ],
                                    )
                            )
                );
  }


  Widget buildRow1(List<TBTrans> data,int index){

      return Flexible(child: Row(children: [
                                 Icon(Icons.access_alarm,color: Colors.grey) ,
                                 Text('${data[index].tlstime}-${data[index].tletime} น.  '),
                                 Icon(Icons.face_outlined,color: Colors.grey) ,
                                 Text('  ${data[index].tlwith==null?"..":"${data[index].tlwith}"}'),
                            ],
                    )
      );
  }


  Widget buildRow2(List<TBTrans> data,int index){

      return Flexible(child: Row(children: [
                                 Icon(Icons.directions_car_outlined,color: Colors.grey),
                                 Text('${data[index].tlvehicle}'),
                            ],
                    )
      );
  }


  Widget buildRow3(List<TBTrans> data,int index){

      return Flexible(child: Row(children: [
                                 Icon(Icons.note_outlined,color: Colors.grey),
                                 Text(' ${data[index].tlnote}'),
                            ],
                    )
        );

  }

}