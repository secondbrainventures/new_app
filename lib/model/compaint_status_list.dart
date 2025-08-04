class ComplaintStatusListResponse {

  String complaintID;
  String callStatus;
  String complaintDate;
  String compDate;

  ComplaintStatusListResponse({this.complaintID, this.callStatus,this.complaintDate, this.compDate});

  ComplaintStatusListResponse.fromJson(Map<String, dynamic> json) {
    complaintID = json['complaintID'];
    callStatus = json['callStatus'];
    complaintDate = json['complaintDate'];
    compDate = json['compDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaintID'] = this.complaintID;
    data['callStatus'] = this.callStatus;
    data['complaintDate'] = this.complaintDate;
    data['compDate'] = this.compDate;
    return data;
  }
}
