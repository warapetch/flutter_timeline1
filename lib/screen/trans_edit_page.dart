import 'package:flutter/material.dart';
import '../data/db_ctrl_sqlite.dart';
import '../data/db_model_trans.dart';
import '../mylib/mylib_datetime.dart' as myLIB;


class TransEditPage extends StatefulWidget{

  TransEditPage({Key key,}) : super(key: key);

  @override
  _TransEditPage createState() => _TransEditPage();
}


class _TransEditPage extends State<TransEditPage> {

    var ctrlDate      = new TextEditingController();
    var ctrlNo        = new TextEditingController();
    var ctrlSTime     = new TextEditingController();
    var ctrlETime     = new TextEditingController();
    var ctrlPlace     = new TextEditingController();
    var ctrlVehicle   = new TextEditingController();
    var ctrlWithWho   = new TextEditingController();
    var ctrlNote      = new TextEditingController();
    var ctrlLatitude  = new TextEditingController();
    var ctrlLongigude = new TextEditingController();


    int thisYear = 0;
    bool formShowed = false;
    // int workNo   = 0;
    DateTime  selectedDate  = DateTime.now();
    TimeOfDay selectedSTime = TimeOfDay.now();
    TimeOfDay selectedETime = TimeOfDay.now();

    String vehicle = "รถยนต์";
    var vehicleList = ['รถยนต์','รถโดยสารประจำทาง','รถจักรยานยนต์','รถจักรยาน','เดิน','เรือ','เครื่องบิน','รถไฟ','รถไฟฟ้า','อื่นๆ'].
        map((item) => DropdownMenuItem(child: Text(item),value: item)).toList();


    final _formKey2 = new GlobalKey<FormState>();


    @override
    void initState() {      // OnCreate
      super.initState();

         formShowed = false;

         setState(() {

             // set values
            thisYear = DateTime.now().year;
            selectedDate = DateTime.now();
            selectedSTime = myLIB.cnvDateTimeToTimeOfDay(DateTime.now());
            selectedETime = myLIB.cnvDateTimeToTimeOfDay(DateTime.now());

            // init value
            ctrlDate.value     = TextEditingValue(text: myLIB.cnvDateTimeToDMYStr(selectedDate));
            ctrlSTime.value    = TextEditingValue(text: myLIB.cnvDateTimeToTimeStr(DateTime.now()));
            ctrlETime.value    = TextEditingValue(text: myLIB.cnvDateTimeToTimeStr(DateTime.now()));
            ctrlNo.value       = TextEditingValue(text: '0');
            ctrlVehicle.value  = TextEditingValue(text: 'รถยนต์');

        });
    }


    @override
    void dispose() {
        ctrlNo.dispose();
        ctrlSTime.dispose();
        ctrlETime.dispose();
        ctrlPlace.dispose();
        ctrlVehicle.dispose();
        ctrlWithWho.dispose();
        ctrlNote.dispose();
        ctrlLatitude.dispose();
        ctrlLongigude.dispose();

        super.dispose();
    }


    @override
    Widget build(BuildContext context) {

        /// get Parameter
        // first time only
        if (formShowed == false){

            final TBTrans trans1 = ModalRoute.of(context).settings.arguments;

            selectedDate  = myLIB.cnvStrDateDMYToDateTime(trans1.tldate);
            selectedSTime = myLIB.cnvStrTimeHMToTimeOfDay(trans1.tlstime);
            selectedETime = myLIB.cnvStrTimeHMToTimeOfDay(trans1.tlstime);
            vehicle = trans1.tlvehicle.toString();

            ctrlNo.value        = TextEditingValue(text: trans1.tlno.toString());
            ctrlSTime.value     = TextEditingValue(text: trans1.tlstime.toString());
            ctrlETime.value     = TextEditingValue(text: trans1.tletime.toString());
            ctrlPlace.value     = TextEditingValue(text: trans1.tlplace.toString());
            ctrlVehicle.value   = TextEditingValue(text: trans1.tlvehicle.toString());
            ctrlWithWho.value   = TextEditingValue(text: trans1.tlwith.toString());
            ctrlNote.value      = TextEditingValue(text: trans1.tlnote.toString());
            ctrlLatitude.value  = TextEditingValue(text: trans1.tllatitude.toString());
            ctrlLongigude.value = TextEditingValue(text: trans1.tllongigude.toString());

            formShowed = true;
        }


        return
        Scaffold(
            appBar: AppBar(title: Text("จดบันทึกการเดินทาง"),
                ),

            body: SingleChildScrollView(
                                        child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                            children: [
                                                                buildForm(),
                                                                ElevatedButton(
                                                                    onPressed: (){

                                                                        if (_formKey2.currentState.validate()) {

                                                                            // kick form to state "submit"
                                                                            // not-thing about database
                                                                            // just validate values in form
                                                                            _formKey2.currentState?.save();

                                                                            // set data to model
                                                                            TBTrans newData = TBTrans.fromMap(
                                                                                {'id': userId ,'tldate': ctrlDate.text,'tlno': int.parse(ctrlNo.text),
                                                                                'tlstime':ctrlSTime.text,'tletime':ctrlETime.text,
                                                                                'tlplace':ctrlPlace.text,'tlwith':ctrlWithWho.text,
                                                                                'tlvehicle': ctrlVehicle.text,
                                                                                'tlnote':ctrlNote.text});

                                                                            // post data
                                                                            DBProvider.db.updateTrans(context,newData);
                                                                            }
                                                                        },
                                                                        child: Text("บันทึก")),
                                                            ],
                                                    ),
                                        ),
                                ),
        );
  }


    Widget buildForm(){

        return Form(
                key: _formKey2,
                child: Column(
                        children: [
                                buildEditDateBtnSelectDate(),
                                buildEditPlace(),
                                buildEditPeriod(),
                                buildEditGoWithWho(),
                                buildDropDownVia(),
                                buildEditNote(),
                       ],
                )
        );

    }


    Widget buildDropDownVia(){

        return Container(
                    child: Row(
                               children:[
                                        Icon(Icons.directions_car),
                                        SizedBox(width: 5),
                                        Text("เดินทางโดย : "),
                                        DropdownButton(
                                            value: vehicle,     // value (must in List items)
                                            items: vehicleList,    // list items
                                            onChanged: (selectedValue){
                                                    setState(() {
                                                        vehicle = selectedValue.toString();
                                                        ctrlVehicle.text = selectedValue.toString();
                                                    });
                                            }
                                        ),
                                ]
                            )
        );
    }


    Widget buildEditPeriod(){
        return Container(
                       //padding: EdgeInsets.only(right: 10),
                       child: Row(
	                               children: <Widget>[
                                                Icon(Icons.access_time),
                                                SizedBox(width: 5),
                                                ElevatedButton(
                                                                child: Text("ตั้งแต่"),
                                                                onPressed: (){ showDlgTimePicker(context,1);}
                                                                ),
                                                SizedBox(width: 10),
	                                            Flexible(
	                                                child: TextFormField(
                                                        decoration: InputDecoration(
                                                            labelText: "ตั้งแต่ :"),
                                                        maxLength: 5,
                                                        keyboardType: TextInputType.datetime,
                                                        controller: ctrlSTime,
                                                        ),
	                                                ),
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                                child: Text("ถึง"),
                                                                onPressed: (){
                                                                        showDlgTimePicker(context,2);}
                                                                ),
                                                SizedBox(width: 10),
	                                            Flexible(
	                                                child: TextFormField(
                                                        decoration: InputDecoration(
                                                            labelText: "ถึง :"),
                                                        maxLength: 5,
                                                        keyboardType: TextInputType.datetime,
                                                        controller: ctrlETime,
                                                        ),
	                                                ),

	                                            ]
                                    ),

                        );
    }

Widget buildEditNote(){
        return Container(
                       padding: EdgeInsets.only(right: 10),
                       child: Row(
	                               children: <Widget>[
                                                Icon(Icons.notes),
                                                SizedBox(width: 5),
                                                Flexible(
	                                                child: TextFormField(
                                                        decoration: InputDecoration(
                                                            labelText: "หมายเหตุ :"),
                                                        maxLength: 200,
                                                        keyboardType: TextInputType.text,
                                                        controller: ctrlNote,
                                                        ),
                                                ),
                                   ]
	                    ),
            );
    }



    Widget buildEditPlace(){

        return Container(
                       padding: EdgeInsets.only(),
                       child: Row(
                                children: <Widget>[
                                    Icon(Icons.place),
                                    SizedBox(width: 5),
                                    Flexible(
                                        child: TextFormField(
                                            decoration: InputDecoration(
                                                    labelText: "สถานที่ :"),
                                            maxLength: 200,
                                            keyboardType: TextInputType.text,
                                            controller: ctrlPlace,
                                            ),
                                    ),
                                ]
                            )
        );
    }


    Widget buildEditGoWithWho(){

        return Container(
                       padding: EdgeInsets.only(),
                       child: Row(
                                children: <Widget>[
                                    Icon(Icons.face),
                                    SizedBox(width: 5),
                                    Flexible(
                                        child: TextFormField(
                                            decoration: InputDecoration(
                                                    labelText: "ไปกับใคร :"),
                                            maxLength: 200,
                                            keyboardType: TextInputType.text,
                                            controller: ctrlWithWho,
                                            ),
                                    ),
                                ]
                            )

        );

    }


    Widget buildEditDateBtnSelectDate(){

        /// #1 วันที่ + ปุ่ม
        return Container(
                       padding: EdgeInsets.only(left:10,right: 10),
                       child: Row(
	                               children: <Widget>[
                                                ElevatedButton(
                                                                child: Text("เลือกวันที่"),
                                                                onPressed: (){
                                                                        showDlgDatePicker(context);
                                                                        }
                                                                ),
                                                SizedBox(width: 10),
	                                            Flexible(
	                                                child: TextFormField(
                                                        decoration: InputDecoration(
                                                            labelText: "วันที่ (ค.ศ.)"),
                                                        maxLength: 10,
                                                        keyboardType: TextInputType.datetime,
                                                        controller: ctrlDate,
				                                        readOnly : true,
                                                        ),
	                                                ),
                                                SizedBox(width: 10),
	                                            Flexible(
	                                                child: TextFormField(
                                                        decoration: InputDecoration(
                                                            labelText: "ลำดับ"),
                                                        maxLength: 5,
                                                        keyboardType: TextInputType.number,
                                                        controller: ctrlNo,  // initialValue and controller มันตีกัน !! ห้ามใช้พร้อมกัน ถ้าเกิด null จะจอแดง
                                                        //initialValue: '0', // ห้ามใส่ initialValue ช่วงยังไม่โหลดค่า มันจะไม่มีค่า !!
                                                        ),
	                                                ),


	                                            ]
                                    ),

                        );
    }


    /// -----------------------------------------------------------
    /// Method showDlgDatePicker
    Future<void> showDlgDatePicker(BuildContext context) async {
        final DateTime picked = await showDatePicker(
            context: context,
            cancelText: "ยกเลิก",
            confirmText: "เลือก",
            helpText: "เลือกวันที่",
            //locale : const Locale("th","TH"),   // ต้องผ่าน 2 ขั้นตอนก่อน 1.add package pubspec 2.add GlobalMaterialLocalizations
            initialDate: selectedDate,
            firstDate: DateTime(thisYear-1),    // ตามที่ต้องการกำหนด
            lastDate: DateTime(thisYear+1),   // ห่างจากวันแรก +1 ปี หรือตามต้องการ
            initialDatePickerMode: DatePickerMode.day,
            );

            if (picked != null && picked != selectedDate)
                setState(() {
                    selectedDate = picked;
                    ctrlDate.text = myLIB.cnvDateTimeToDMYStr(picked);
                    print("เลือกวันที่ : $selectedDate");
                });
    }


    /// -----------------------------------------------------------
    /// Method showDlgTimePicker
    Future<void> showDlgTimePicker(BuildContext context,int saveTo) async {

        final TimeOfDay picked = await showTimePicker(
            context: context,
            cancelText: "ยกเลิก",
            confirmText: "เลือก",
            helpText: "เลือกเวลา",
            initialTime: saveTo == 1 ? selectedSTime : selectedETime,
            initialEntryMode: TimePickerEntryMode.dial,
            //initialEntryMode: TimePickerEntryMode.input,

            // Display 24 hours //
            builder: (BuildContext context,Widget child) {
                     return  MediaQuery(
                             data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                             child: child
                             );
                         },
            );

            if (picked != null){
                setState(() {
                    print('$picked');
                    if (saveTo == 1){
                        selectedSTime = picked;
                        ctrlSTime.text = myLIB.cnvTimeOfDayToStr(picked);
                    } else if (saveTo == 2){
                        selectedETime = picked;
                        ctrlETime.text = myLIB.cnvTimeOfDayToStr(picked);
                        }
                });
        }
    }


}