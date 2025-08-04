
class SchemeStatusListGS {
  int srNo;
  int id;
  int mobileUserId;
  int schemeId;
  int stateId;
  int districtId;
  int b2BCodeId;
  String mobileNo;
  String loginPin;
  int isFirstTimeLogin;
  String name;
  String clientName;
  String address;
  String email;
  String landMark;
  String deviceId;
  String deviceType;
  String createDate;
  bool isActive;
  String let;
  String longi;
  bool isB2BUser;
  bool isValidB2BUser;
  int b2BUserApprovedById;
  String date;
  String schemeName;
  String stateName;
  String districtName;
  String uniqueCode;
  int isValidUser;

  SchemeStatusListGS(
      {this.srNo,
        this.id,
        this.mobileUserId,
        this.schemeId,
        this.stateId,
        this.districtId,
        this.b2BCodeId,
        this.mobileNo,
        this.loginPin,
        this.isFirstTimeLogin,
        this.name,
        this.address,
        this.email,
        this.landMark,
        this.deviceId,
        this.deviceType,
        this.createDate,
        this.isActive,
        this.let,
        this.longi,
        this.isB2BUser,
        this.isValidB2BUser,
        this.b2BUserApprovedById,
        this.date,
        this.schemeName,
        this.stateName,
        this.districtName,
        this.uniqueCode,
        this.clientName,
        this.isValidUser});

  SchemeStatusListGS.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    id = json['id'];
    mobileUserId = json['mobileUserId'];
    schemeId = json['schemeId'];
    stateId = json['stateId'];
    districtId = json['districtId'];
    b2BCodeId = json['b2BCodeId'];
    mobileNo = json['mobileNo'];
    loginPin = json['loginPin'];
    isFirstTimeLogin = json['isFirstTimeLogin'];
    name = json['name'];
    address = json['address'];
    email = json['email'];
    landMark = json['landMark'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    createDate = json['createDate'];
    isActive = json['isActive'];
    let = json['let'];
    longi = json['longi'];
    isB2BUser = json['isB2BUser'];
    isValidB2BUser = json['isValidB2BUser'];
    b2BUserApprovedById = json['b2BUserApprovedById'];
    date = json['date'];
    schemeName = json['schemeName'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    uniqueCode = json['uniqueCode'];
    clientName = json['clientName'];
    isValidUser = json['isValidUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['id'] = this.id;
    data['mobileUserId'] = this.mobileUserId;
    data['schemeId'] = this.schemeId;
    data['stateId'] = this.stateId;
    data['districtId'] = this.districtId;
    data['b2BCodeId'] = this.b2BCodeId;
    data['mobileNo'] = this.mobileNo;
    data['loginPin'] = this.loginPin;
    data['isFirstTimeLogin'] = this.isFirstTimeLogin;
    data['name'] = this.name;
    data['address'] = this.address;
    data['email'] = this.email;
    data['landMark'] = this.landMark;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['createDate'] = this.createDate;
    data['isActive'] = this.isActive;
    data['let'] = this.let;
    data['longi'] = this.longi;
    data['isB2BUser'] = this.isB2BUser;
    data['isValidB2BUser'] = this.isValidB2BUser;
    data['b2BUserApprovedById'] = this.b2BUserApprovedById;
    data['date'] = this.date;
    data['schemeName'] = this.schemeName;
    data['stateName'] = this.stateName;
    data['districtName'] = this.districtName;
    data['uniqueCode'] = this.uniqueCode;
    data['clientName'] = this.clientName;
    data['isValidUser'] = this.isValidUser;
    return data;
  }
}