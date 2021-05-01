//     final userTimeline = userTimelineFromJson(jsonString);

import 'dart:convert';

TBUsers userFromMap(String str) => TBUsers.fromMap(json.decode(str));

String userToMap(TBUsers data) => json.encode(data.toMap());

class TBUsers {
    TBUsers({
        this.id,
        this.name,
        this.gender,
        this.agerange,
        this.subdistrict,
        this.district,
        this.province,
        this.phone,
    });

    String id;
    String name;
    String gender;
    String agerange;
    String subdistrict;
    String district;
    String province;
    String phone;

    factory TBUsers.fromMap(Map<String, dynamic> json) => TBUsers(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        agerange:json["agerange"] == null ? null : json["agerange"],
        subdistrict: json["subdistrict"] == null ? null : json["subdistrict"],
        district: json["district"] == null ? null : json["district"],
        province: json["province"] == null ? null : json["province"],
        phone: json["phone"] == null ? null : json["phone"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "agerange": agerange == null ? null : agerange,
        "subdistrict": subdistrict == null ? null : subdistrict,
        "district": district == null ? null : district,
        "province": province == null ? null : province,
        "phone": phone == null ? null : phone,
    };
}