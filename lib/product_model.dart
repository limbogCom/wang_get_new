class Product{
  final String recevicId;
  final String recevicRunId;
  final String recevicDetail;
  final String recevicPic;
  final String recevicPicEx;
  final String recevicPicPriceTag;
  final String recevicPicBill;
  final String recevicPicBC;
  final String recevicEmp;
  final String recevicDateAdd;
  final String recevicDateEdit;
  final String recevicTCid;
  final String recevicTCidPro;
  final String recevicTCbarcode;
  final String recevicTCqtyBox;
  final String recevicTCqtySub;
  final String recevicProductUnit;
  final String recevicProductUnitNew;
  final String recevicProductName;
  final String recevicProductCode;
  final String recevicProductCompany;
  final String recevicProductPic;

  Product({
    this.recevicId,
    this.recevicRunId,
    this.recevicDetail,
    this.recevicPic,
    this.recevicPicEx,
    this.recevicPicPriceTag,
    this.recevicPicBill,
    this.recevicPicBC,
    this.recevicEmp,
    this.recevicDateAdd,
    this.recevicDateEdit,
    this.recevicTCid,
    this.recevicTCidPro,
    this.recevicTCbarcode,
    this.recevicTCqtyBox,
    this.recevicTCqtySub,
    this.recevicProductUnit,
    this.recevicProductUnitNew,
    this.recevicProductName,
    this.recevicProductCode,
    this.recevicProductCompany,
    this.recevicProductPic
  });

  factory Product.fromJson(Map<String, dynamic> json){
    return new Product(
      recevicId: json['WH_receiveBox_id'],
      recevicRunId: json['WH_receiveBox_runID'],
      recevicDetail: json['WH_receiveBox_detail'],
      recevicPic: json['WH_receiveBox_pic'],
      recevicPicEx: json['WH_receiveBox_picEx'],
      recevicPicPriceTag: json['WH_receiveBox_picPriceTag'],
      recevicPicBill: json['WH_receiveBox_picBill'],
      recevicPicBC: json['WH_receiveBox_picBC'],
      recevicEmp: json['WH_receiveBox_emp'],
      recevicDateAdd: json['WH_receiveBox_dateAdd'],
      recevicDateEdit: json['WH_receiveBox_dateEdit'],
      recevicTCid: json['tc_id'],
      recevicTCidPro: json['WH_receiveBox_TC_idPro'],
      recevicTCbarcode: json['WH_receiveBox_TC_barcode'],
      recevicTCqtyBox: json['WH_receiveBox_TC_qtyBox'],
      recevicTCqtySub: json['WH_receiveBox_TC_qtySub'],
      recevicProductUnit: json['unitName'],
      recevicProductUnitNew: json['WH_receiveBox_TC_unit'],
      recevicProductName: json['nproduct'],
      recevicProductCode: json['pcode'],
      recevicProductCompany: json['company'],
      recevicProductPic: json['pic'],
    );
  }

}