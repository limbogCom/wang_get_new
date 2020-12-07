class ShippingCompany{
  final String scId;
  final String scComCode;
  final String scShipCode;
  final String scShipName;
  final String scShipPhone;
  final String scShipMinTime;
  final String scShipMaxTime;
  final String scShipComments;

  ShippingCompany({
    this.scId,
    this.scComCode,
    this.scShipCode,
    this.scShipName,
    this.scShipPhone,
    this.scShipMinTime,
    this.scShipMaxTime,
    this.scShipComments
  });

  factory ShippingCompany.fromJson(Map<String, dynamic> json){
    return new ShippingCompany(
      scId: json['cs_id'],
      scComCode: json['sc_comcode'],
      scShipCode: json['sc_shipcode'],
      scShipName: json['sc_shipname'],
      scShipPhone: json['sc_shipphone'],
      scShipMinTime: json['sc_shipmintime'],
      scShipMaxTime: json['sc_shipmaxtime'],
      scShipComments: json['sc_shipcomments'],
    );
  }

}