import 'package:flutter/material.dart';
import '../data/db_model_trans.dart';
import '../data/db_model_user.dart';
import '../mylib/mylib_datetime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';


var userId = "";

class DBProvider {

    DBProvider._();
    static final DBProvider db = DBProvider._();
    static final String _databaseFileName = 'timeline_easy_warapetch2.db';
    static final int    _databaseVersion  = 1;

    Database _database;
    String usersFieldList = "'id','name','gender','agerange','subdistrict','district','province','phone'";
    String transFieldList = "'id','tldate','tlno','tlstime','tletime','tlplace','tlwith','tlvehicle','tlnote','tllatitude','tllongigude'";


    /// get "database"
    Future<Database> get database async {

        if (_database != null) return _database;

        _database = await initDB();

        return _database;
    }

    /// ----------------------------------------------------------------------
    /// Initialize OpenDatabase and Create if not Exists
    /// ห้ามทำเป็น Future<> !!
    /// getApplicationDocumentsDirectory ไม่รองรับการทำงานบนเวบ
    /// package Library SQLite ที่ใช้อยู่รองรับ OS: Android และ iOS เท่านั้น !!
    /// ถ้าต้องการทำงาน บนเวบ หรือ วินโดว์เดสทอป ให้ใช้ Moor แทน การเขียนโค้ดก็คนละเรื่องเลย
    initDB() async {

        final dbFolder = await getApplicationDocumentsDirectory();
        String fullPathDBFileName = join(dbFolder.path, _databaseFileName);

        //print("Path data >> $pathFileName");

        /// Open database
        return await openDatabase(fullPathDBFileName,
                            version: _databaseVersion,
                            onOpen: (dbMAIN) {},
                            /// onCreate Database if not Exists
                            onCreate: (Database dbMAIN, int version)
                                        async {

            Batch batch = dbMAIN.batch();

            /// Create Table
            batch.execute(
                        "CREATE TABLE users ("
                            "id TEXT PRIMARY KEY,"
                            "name TEXT,"
                            "gender TEXT,"
                            "agerange TEXT,"
                            "subdistrict TEXT,"
                            "district TEXT,"
                            "province TEXT,"
                            "phone TEXT"
                            ")"
                        );

            /// Create Table
            batch.execute(
                        "CREATE TABLE trans ("
                            "id TEXT NOT NULL,"
                            "tldate DATE NOT NULL,"
                            "tlno INTEGER NOT NULL,"
                            "tlstime TIME NOT NULL,"
                            "tletime TIME NOT NULL,"
                            "tlplace TEXT,"
                            "tlwith TEXT,"
                            "tlvehicle TEXT,"
                            "tlnote TEXT,"
                            "tllatitude REAL,"
                            "tllongigude REAL,"

                            "PRIMARY KEY (id, tldate,tlno)"
                            ")"
                        );

            /// เพิ่มข้อมูล user 1 คน ตายตัว
            userId =  cnvDateTimeToYMDHMS(DateTime.now());
            /// "'id','name','gender','agerange','subdistrict','district','province','phone'";
            batch.execute("INSERT INTO users(id,name)"
                           " VALUES ('$userId','no-name')"
                         );


            // Datetime == YYYY-MM-DD HH:MM:SS.SSS     Text == 29/04/2021
            // batch.execute("INSERT INTO trans(id,tldate,tlno,tlstime,tletime,tlplace,tlwith,tlvehicle,tlnote)"
            //                " VALUES ('$userId', '"+cnvDateTimeToDMYStr(DateTime.now())+"' ,1,'09:00','09:30','ตลาดใกล้บ้าน','ไปคนเดียว','รถยนต์','ทดสอบ สร้างเองอัตโนมัติ')"
            //              );

            await batch.commit();
            print("Log : Create New Database [OK]");
            }
        );
    }


    //----------------------------------------------------------------------
    /// new user 1 Device = 1 user
    newUser(TBUsers newData) async {

        final db = await database;

        String userId = cnvDateTimeToYMDHMS(DateTime.now());

        /// insert to the table using the userid
        var resultSet = await db.rawInsert(
            "INSERT Into users ($usersFieldList)"
                //"'id','name','gender','agerange','subdistrict','district','province','phone'";
            " VALUES (?,?,?,?,?,?,?,?)",
            [userId, newData.name,newData.gender,newData.agerange,newData.subdistrict, newData.district ,newData.province,newData.phone]);

        return resultSet;
    }


    /// ----------------------------------------------------------------------
    /// get Users มีคนเดียวทั้งเทเบิล ใช้ Preference แทนก็ได้
    getUser() async {

        final db = await database;

        var resultSet = await db.query("users");

        return resultSet.isNotEmpty ? TBUsers.fromMap(resultSet.first) : null;

    }


    //----------------------------------------------------------------------
    /// new Transaction , new Timeline
    newTrans(BuildContext context,TBTrans newData) async {

        final db = await database;
        /// ใส่เครื่องหมาย ' ' or " " ครอบค่าที่ไม่ใช่ตัวเลขด้วย !!
        String sql = "SELECT MAX(tlno)+1 AS tlno FROM trans "
                     " WHERE id = '${newData.id}' and tldate = '${newData.tldate}'";

        //print("SQL >> $sql");

        var table = await db.rawQuery(sql);

        /// insert to the table using the id,date,time ,no+1
        int transno = table.first["tlno"];

        if (transno == null){
            transno = 1;
            }

        String sMsg = "";
        var resultSet;
        Color msgColor = Colors.greenAccent.shade700;

        try{
            resultSet = await db.rawInsert(
                    "INSERT Into trans ($transFieldList)"
                        /// "'id','tldate','tlno','tlstime','tletime','tlplace','tlwith','tlvehicle','tlnote','tllatitude','tllongigude'";
                        /// ใส่เครื่องหมาย ' ' or " " ครอบค่าที่ไม่ใช่ตัวเลขด้วย !!
                    " VALUES ('${newData.id}','${newData.tldate}',$transno,'${newData.tlstime}','${newData.tletime}',"
                            "'${newData.tlplace}' ,'${newData.tlwith??=""}','${newData.tlvehicle}', '${newData.tlnote??=""}',"
                            "${newData.tllatitude??=0},${newData.tllongigude??=0} )"
                      );

            //print('Record Count = $resultSet');
            sMsg = 'บันทึกข้อมูล ... สำเร็จ';

        }catch(err){
            sMsg = 'บันทึกข้อมูล ... ไม่สำเร็จ !! \n'+err.toString();
            msgColor = Colors.red.shade500;
        }


        final snackBar = SnackBar(content: Text(sMsg) ,
                backgroundColor: msgColor);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context);

        return resultSet;

        }

    //----------------------------------------------------------------------
    /// update Transaction , update Timeline
    updateTrans(BuildContext context,TBTrans newData) async {

        final db = await database;
        String sMsg = "";
        var resultSet;

        try{
            var resultSet = await db.update("trans", newData.toMap(),
                where: "id = ? and tldate = ? and tlno = ?",
                /// ส่งค่าแบบ parameter ก็ส่งไปตามนั้น !!
                whereArgs: [newData.id,newData.tldate,newData.tlno]);

            print('Record Count = $resultSet');
            sMsg = 'บันทึกข้อมูล ... สำเร็จ';


        }catch(err){
            sMsg = 'บันทึกข้อมูล ... ไม่สำเร็จ !! \n'+err.toString();
        }

        print('update Record : $sMsg');

        final snackBar = SnackBar(content: Text(sMsg));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context);

        return resultSet;
    }


    //----------------------------------------------------------------------
    /// search Transaction , search Timeline
    Future<List<TBTrans>> getTransByDateTransNo(String id,DateTime date,int transno) async {

        final db = await database;
        String dateStr = cnvDateTimeToYMDStr(date);
        //print("search Transaction by TransNo");

        var resultSet = await db.query("trans",
            where: "id = ? and tldate = ? and tlno = ?",
            whereArgs: [id,dateStr,transno]); // DMY

        //print("Search ResultSet = $resultSet");
        return resultSet.isNotEmpty ? resultSet.map((col) => TBTrans.fromMap(col)).toList() : [];

    }


    //----------------------------------------------------------------------
    /// search Transaction , search Timeline
    Future<List<TBTrans>> getTransByDate(String id,DateTime date) async {

        final db = await database;
        String dateStr = cnvDateTimeToDMYStr(date);
        //print("search Transaction by Date");

        var resultSet = await db.query("trans",
            where: "id = ? and tldate = ? ",
            whereArgs: [id,dateStr]); // DMY

        //print("Search ResultSet = $resultSet");
        return resultSet.isNotEmpty ? resultSet.map((col) => TBTrans.fromMap(col)).toList() : [];

    }

    //----------------------------------------------------------------------
    /// search Transaction , search Timeline
    Future<List<TBTrans>> getTransByDatePeriod(String id,String sDate , String eDate) async {

        final db = await database;
        print("search Transaction by Date Period ");

        var resultSet = await db.query("trans",
            where: "id = ? and (tldate >= ?  and tldate <= ? )",
            whereArgs: [id,sDate,eDate]); // DMY

        print("Search ResultSet = $resultSet");
        return resultSet.isNotEmpty ? resultSet.map((col) => TBTrans.fromMap(col)).toList() : [];

    }


    //----------------------------------------------------------------------
    /// search Transaction , search Timeline
    Future<List<TBTrans>> getAllTrans() async {

        final db = await database;

        var resultSet = await db.query("trans");

        return resultSet.isNotEmpty ? resultSet.map((col) => TBTrans.fromMap(col)).toList() : [];
    }


    //----------------------------------------------------------------------
    /// search Transaction , search Timeline
    deleteTrans1(String id,String dateStrDMY, String timeStrHM , int transNo) async {

        final db = await database;

        var resultSet = await db.delete("trans",
            where: "id = ? and tldate = ? and tlstime = ? and tlno = ?",
            whereArgs: [id,dateStrDMY,timeStrHM,transNo]);

        print(resultSet);

        return resultSet;
    }


    //----------------------------------------------------------------------
    /// search Transaction , search Timeline
    deleteTrans1Day(String id,String dateStrDMY) async {

        final db = await database;

        return db.delete("trans",
            where: "id = ? and tldate = ?",
            whereArgs: [id,dateStrDMY]);
    }


    //----------------------------------------------------------------------
    /// search Transaction , search Timeline
    deleteTransAll() async {

        final db = await database;

        db.rawDelete("Delete * from trans");

    }

}
/// End.