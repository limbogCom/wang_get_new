class Shipping{
  final String shipComId;
  final String shipComCode;
  final String shipComName;
  final String shipComNameENG;
  final String shipComTime;
  final String shipComAddress;
  final String shipComTel;
  final String shipComEmail;

  Shipping({
    this.shipComId,
    this.shipComCode,
    this.shipComName,
    this.shipComNameENG,
    this.shipComTime,
    this.shipComAddress,
    this.shipComTel,
    this.shipComEmail
  });

  factory Shipping.fromJson(Map<String, dynamic> json){
    return new Shipping(
      shipComId: json['id'],
      shipComCode: json['code'],
      shipComName: json['name'],
      shipComNameENG: json['nameShipComENG'],
      shipComTime: json['transit_time'],
      shipComAddress: json['address'],
      shipComTel: json['tel'],
      shipComEmail: json['email'],
    );
  }

}