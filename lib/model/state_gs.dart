class StateResponse {
  int id;
  String text;
  String mastertext;

  StateResponse({this.id, this.text, this.mastertext});

  StateResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    mastertext = json['mastertext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['mastertext'] = this.mastertext;
    return data;
  }
  
}
