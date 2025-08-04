class SchemeGS {
  int otp;
  int responseCode;
  List<SchemeListGS> responseObj;

  SchemeGS(
      {this.otp, this.responseCode, this.responseObj});

  SchemeGS.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    responseCode = json['responseCode'];
    if (json['responseObj'] != null) {
      responseObj = new List<SchemeListGS>();
      json['responseObj'].forEach((v) {
        responseObj.add(new SchemeListGS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['responseCode'] = this.responseCode;
    if (this.responseObj != null) {
      data['responseObj'] = this.responseObj.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemeListGS {
  int id;
  String schemeName;
  String schemeAbbreviation;

  SchemeListGS({this.id, this.schemeName, this.schemeAbbreviation});

  SchemeListGS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schemeName = json['schemeName'];
    schemeAbbreviation = json['schemeAbbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['schemeName'] = this.schemeName;
    data['schemeAbbreviation'] = this.schemeAbbreviation;
    return data;
  }
}