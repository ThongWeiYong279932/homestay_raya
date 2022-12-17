class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? regdate;

  User(
      {this.id, this.name, this.email, this.phone, this.address, this.regdate});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['regdate'] = this.regdate;
    return data;
  }
}
