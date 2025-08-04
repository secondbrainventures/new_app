class ProductResponse {

  String product;
  String qty;
  int id;
  int vednorID;

  ProductResponse({this.product, this.id});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    id = json['id'];
    vednorID = json['vednorID'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product;
    data['id'] = this.id;
    data['qty'] = this.qty;
    data['vednorID'] = this.vednorID;
    return data;
  }
}