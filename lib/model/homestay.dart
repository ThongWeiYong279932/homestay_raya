class Homestays {
  String? homestayId;
  String? userId;
  String? homestayName;
  String? homestayDesc;
  String? homestayPrice;
  String? homestayDeposit;
  String? homestayRoomno;
  String? homestayState;
  String? homestayLocal;
  String? homestayLat;
  String? homestayLong;
  String? homestayDate;

  Homestays(
      {this.homestayId,
      this.userId,
      this.homestayName,
      this.homestayDesc,
      this.homestayPrice,
      this.homestayDeposit,
      this.homestayRoomno,
      this.homestayState,
      this.homestayLocal,
      this.homestayLat,
      this.homestayLong,
      this.homestayDate});

  Homestays.fromJson(Map<String, dynamic> json) {
    homestayId = json['homestay_id'];
    userId = json['user_id'];
    homestayName = json['homestay_name'];
    homestayDesc = json['homestay_desc'];
    homestayPrice = json['homestay_price'];
    homestayDeposit = json['homestay_deposit'];
    homestayRoomno = json['homestay_roomno'];
    homestayState = json['homestay_state'];
    homestayLocal = json['homestay_local'];
    homestayLat = json['homestay_lat'];
    homestayLong = json['homestay_long'];
    homestayDate = json['homestay_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homestay_id'] = this.homestayId;
    data['user_id'] = this.userId;
    data['homestay_name'] = this.homestayName;
    data['homestay_desc'] = this.homestayDesc;
    data['homestay_price'] = this.homestayPrice;
    data['homestay_deposit'] = this.homestayDeposit;
    data['homestay_roomno'] = this.homestayRoomno;
    data['homestay_state'] = this.homestayState;
    data['homestay_local'] = this.homestayLocal;
    data['homestay_lat'] = this.homestayLat;
    data['homestay_long'] = this.homestayLong;
    data['homestay_date'] = this.homestayDate;
    return data;
  }
}