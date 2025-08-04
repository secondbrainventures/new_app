class ULBResponse {
  int id;
  String ulb;

  ULBResponse({this.id, this.ulb});

  ULBResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ulb = json['ulb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ulb'] = this.ulb;
    return data;
  }
}
