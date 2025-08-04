class ComplaintStatusResponse {

  String status;
  String date;

  ComplaintStatusResponse({this.status, this.date});

  ComplaintStatusResponse.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}
