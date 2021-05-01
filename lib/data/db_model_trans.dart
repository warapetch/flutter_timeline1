import 'dart:convert';

TBTrans transFromMap(String str) => TBTrans.fromMap(json.decode(str));

String transToMap(TBTrans data) => json.encode(data.toMap());

class TBTrans {
    TBTrans({
        this.id,
        this.tldate,
        this.tlstime,
        this.tletime,
        this.tlno,
        this.tlplace,
        this.tlwith,
        this.tlvehicle,
        this.tlnote,
        this.tllatitude,
        this.tllongigude,
    });

    String id;
    String tldate;          //  DMY 29/04/2021
    String tlstime;         // HH:MM
    String tletime;
    int tlno;
    String tlplace;
    String tlwith;
    String tlvehicle;
    String tlnote;
    double tllatitude;
    double tllongigude;

    factory TBTrans.fromMap(Map<String, dynamic> json) => TBTrans(
        id: json["id"] == null ? null : json["id"],
        tldate: json["tldate"] == null ? null : json["tldate"],
        tlstime: json["tlstime"] == null ? null : json["tlstime"],
        tletime: json["tletime"] == null ? null : json["tletime"],
        tlno: json["tlno"] == null ? null : json["tlno"],
        tlplace: json["tlplace"] == null ? null : json["tlplace"],
        tlwith: json["tlwith"] == null ? null : json["tlwith"],
        tlvehicle: json["tlvehicle"] == null ? null : json["tlvehicle"],
        tlnote: json["tlnote"] == null ? null : json["tlnote"],
        tllatitude: json["tllatitude"] == null ? null : json["tllatitude"],
        tllongigude: json["tllongigude"] == null ? null : json["tllongigude"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "tldate": tldate == null ? null : tldate,
        "tlstime": tlstime == null ? null : tlstime,
        "tletime": tletime == null ? null : tletime,
        "tlno": tlno == null ? null : tlno,
        "tlplace": tlplace == null ? null : tlplace,
        "tlwith": tlwith == null ? null : tlwith,
        "tlvehicle": tlvehicle == null ? null : tlvehicle,
        "tlnote": tlnote == null ? null : tlnote,
        "tllatitude": tllatitude == null ? null : tllatitude,
        "tllongigude": tllongigude == null ? null : tllongigude,
    };
}