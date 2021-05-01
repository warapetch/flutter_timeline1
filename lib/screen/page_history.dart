import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import '../data/db_ctrl_sqlite.dart';
import '../data/db_model_trans.dart';
import '../mylib/mydialog.dart';
import '../mylib/mylib_datetime.dart';
import '../screen/trans_edit_page.dart';
import 'package:share/share.dart';
import 'package:timelines/timelines.dart';


class PageHistory extends StatefulWidget {
  const PageHistory({Key key}) : super(key: key);

  @override
  _PageHistoryState createState() => _PageHistoryState();
}

class _PageHistoryState extends State<PageHistory> {


    List<TBTrans> dataQuery = [];
    var ctrlSDate     = new TextEditingController();
    var ctrlEDate     = new TextEditingController();
    int thisYear = 0;
    DateTime selectedSDate = DateTime.now();
    DateTime selectedEDate = DateTime.now();



    @override
    void initState() {
      super.initState();

        // open database
        DBProvider.db.initDB();

        thisYear = DateTime.now().year;

        // init value
        ctrlSDate.value    = TextEditingValue(text: cnvDateTimeToDMYStr(DateTime.now()));
        ctrlEDate.value    = TextEditingValue(text: cnvDateTimeToDMYStr(DateTime.now()));

    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
                appBar: AppBar(
                            title: Text("ประวัติการจดบันทึก"),
                            actions: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 35),
                                            child: ElevatedButton(
                                                    onPressed: (){

                                                        sharefile(ctrlSDate.text+'-'+ctrlEDate.text);
                                                    },
                                                    child: Icon(Icons.share,)
                                                    )
                                        ),
                                ],
                            ),
                body: buildBody(),
        );
}

Future<void> sharefile(String dataDesc) async {

    File _fileforExport;

    final directory = await getApplicationDocumentsDirectory();
    String fileName = 'timeline_$userId.json';
    String pathFileName = join(directory.path, fileName);

    // set filename
    _fileforExport = File(pathFileName);

    if (dataQuery != null){

        List<Map<String, dynamic>> jsonArray = [];
        String jsonString;


        dataQuery.forEach((row){
                    jsonString = '{"id": "${row.id.toString()}",'
                                  '"tldate": "${row.tldate.toString()}",'
                                  '"tlstime": "${row.tlstime.toString()}",'
                                  '"tletime": "${row.tletime.toString()}",'
                                  '"tlno": ${row.tlno.toString()},'
                                  '"tlplace": "${row.tlplace.toString()}",'
                                  '"tlwith": "${row.tlwith.toString()}",'
                                  '"tlvehicle": "${row.tlvehicle.toString()}",'
                                  '"tlnote": "${row.tlnote.toString()}",'
                                  '"tllatitude": "${row.tllatitude.toString()}",'
                                  '"tllongigude": "${row.tllongigude.toString()}"}';

                    jsonArray.add(jsonDecode(jsonString));
                }
        );

        // Encode Json
        jsonString = jsonEncode(jsonArray);

        // write to file (savetoFiles)
        await _fileforExport.writeAsString(jsonString.toString());
    }

    // Share
    Share.shareFiles(
            [pathFileName],
            mimeTypes: ['application/pdf','text/pain'],
            subject: 'ข้อมูลจดบันทึกการเดินทาง '+dataDesc,
            text: 'ประวัติการจดบันทึก');
}

Widget buildBody(){

    return SingleChildScrollView(child: Column(
               children: [
                    Container(
                            child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(children: [

                                                    SizedBox(width: 5.0,),
                                                    Flexible(child: TextField(
                                                                decoration: InputDecoration(
                                                                    labelText: "ตั้งแต่ :"),
                                                                maxLength: 10,
                                                                keyboardType: TextInputType.datetime,
                                                                controller: ctrlSDate,
                                                                )
                                                        ),
                                                    SizedBox(width: 10.0,),
                                                    Text("ถึง :"),
                                                    SizedBox(width: 5.0,),
                                                    Flexible(child: TextField(
                                                                decoration: InputDecoration(
                                                                    labelText: "ถึง :"),
                                                                maxLength: 10,
                                                                keyboardType: TextInputType.datetime,
                                                                controller: ctrlEDate,
                                                                )
                                                        ),
                                                    SizedBox(width: 5.0,),
                                                    ElevatedButton(onPressed: (){
                                                            /// refresh screen and data
                                                            setState(() {
                                                                /// it kick method >> buildDataTimelines
                                                            });
                                                        },
                                                        child: Icon(Icons.find_in_page))
                                                ],
                                            ),
                                    ),
                    ),

                /// build TimeLine
                /// ------------------------------------------------
                buildDataTimelines(ctrlSDate.text,ctrlEDate.text),
                /// ------------------------------------------------
               ],
        )
    );
}


Widget buildDataTimelines(String sDATE,String eDATE){

     return FutureBuilder(
            /// select Transaction == 'sDate - eDate'
            future: DBProvider.db.getTransByDatePeriod(userId, sDATE , eDATE),
                builder: (context, snapshot) {

                    if (snapshot.hasData) {
                        dataQuery = snapshot.data;
                        return buildTimelines(context,snapshot.data);
                    }

                    //if (snapshot.data == null || snapshot.data.length == 0) {
                    //    return Text('ยังไม่ได้มีการจดบันทึก');
                    //}

                    return showStatusSign("กำลังโหลด ..."); //CircularProgressIndicator();
                },
        );
}

Widget buildTimelines(BuildContext context, List<TBTrans> data){

    return SingleChildScrollView(
            child:Container(
            width: MediaQuery.of(context).size.width,//double.infinity,
            height: MediaQuery.of(context).size.height,//double.infinity,
            child: Timeline.tileBuilder(

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
                                                                                    child: buildCardTimeline(context,data,index)
                                                                                ),
                                                            itemCount: data.length,
                                                    ),
                                            ),
        )
    );
  }


    /// -----------------------------------------------------------
    /// Method showDlgDatePicker
    Future<void> showDlgDatePicker(BuildContext context,int saveTo) async {
        final DateTime picked = await showDatePicker(
            context: context,
            cancelText: "ยกเลิก",
            confirmText: "เลือก",
            helpText: "เลือกวันที่",
            //locale : const Locale("th","TH"),   // ต้องผ่าน 2 ขั้นตอนก่อน 1.add package pubspec 2.add GlobalMaterialLocalizations
            initialDate: saveTo == 1 ? selectedSDate : selectedEDate,
            firstDate: DateTime(thisYear-1),    // ตามที่ต้องการกำหนด
            lastDate: DateTime(thisYear+1),   // ห่างจากวันแรก +1 ปี หรือตามต้องการ
            initialDatePickerMode: DatePickerMode.day,
            );

            if (picked != null)
                setState(() {

                    if (saveTo == 1) {
                        selectedSDate = picked;
                        ctrlSDate.text = cnvDateTimeToDMYStr(picked);
                    } else if (saveTo == 2) {
                        selectedEDate = picked;
                        ctrlEDate.text = cnvDateTimeToDMYStr(picked);
                    }
                });
    }


  Widget buildCardTimeline(BuildContext context,List<TBTrans> data,int index){

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
                                                                                    // send parameter next form
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