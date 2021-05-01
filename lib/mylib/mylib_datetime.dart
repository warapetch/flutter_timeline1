import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



String cnvDateTimeToTimeStr(DateTime dateValue){
/// แปลง DateTime เป็น String "HH:mm"
    return DateFormat('HH:mm').format(dateValue);
}


String cnvDateTimeToDMYStr(DateTime dateValue){
/// แปลง DateTime เป็น String "dd/mm/yyyy"

    return DateFormat('dd/MM/yyyy').format(dateValue);
}

String cnvDateTimeToYMDHMS(DateTime dateValue){
/// แปลง DateTime เป็น String "yyyymmddhhnnss"

    return DateFormat('yyyyMMddHHmmss').format(dateValue);
}


String cnvDateTimeToYMDStr(DateTime dateValue){
/// แปลง DateTime เป็น String "yyyy/mm/dd"
    return DateFormat('yyyy/MM/dd').format(dateValue);
}


String cnvTimeOfDayToStr(TimeOfDay todValue){
/// แปลง TimeOfDay เป็น String "HH:mm"
    return DateFormat('HH:mm').format(DateTime(0,0,0, todValue.hour, todValue.minute));
}


String cnvTime12To24Str(String timeValue){
/// แปลง "HH:mm am/pm" เป็น String "HH:mm"

    var dtFormat = DateFormat("h:mm a");
    var dtTime = dtFormat.parse(timeValue);
    return DateFormat('HH:mm').format(dtTime);
}

TimeOfDay cnvDateTimeToTimeOfDay(DateTime dateValue){
/// แปลง DateTime เป็น TimeOfDay
    return  TimeOfDay.fromDateTime(dateValue);
}


TimeOfDay cnvStrTimeHMToTimeOfDay(String timeHMStr){
/// แปลง String DateTime เป็น TimeOfDay
    return TimeOfDay( hour: int.parse(timeHMStr.split(":")[0]),
                      minute: int.parse(timeHMStr.split(":")[1])
                    );
}

DateTime cnvStrDateDMYToDateTime(String dateDMYStr){
/// แปลง String DateTime เป็น DateTime
/// "2012-02-27 13:27:00.123456789z"
/// 29/04/2021 TO 2019-04-29

    String nDay   = dateDMYStr.substring(0, 2);    // ตั้งแต่ index 0+1 ไปถึงตัวที่ 2
    String nMonth = dateDMYStr.substring(3, 5);    // ตั้งแต่ index 3+1 ไปถึงตัวที่ 5
    String nYear  = dateDMYStr.substring(6, 10);   // ตั้งแต่ index 6+1 ไปถึงตัวที่ 10

    return  DateTime.parse(nYear+'-'+nMonth+'-'+nDay+' 00:00:00');
}


// String cnvStrDateDMYToYMD(String dateDMYStr){
// /// แปลง String DateTime เป็น DateTime
// /// "2012-02-27 13:27:00.123456789z"
// /// 29/04/2021 TO 2019-04-29

//     String nDay   = dateDMYStr.substring(0, 2);    // ตั้งแต่ index 0+1 ไปถึงตัวที่ 2
//     String nMonth = dateDMYStr.substring(3, 5);    // ตั้งแต่ index 3+1 ไปถึงตัวที่ 5
//     String nYear  = dateDMYStr.substring(6, 10);   // ตั้งแต่ index 6+1 ไปถึงตัวที่ 10

//     return  nYear+'/'+nMonth+'/'+nDay;
// }
