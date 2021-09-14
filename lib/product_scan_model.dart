class ProductScan{
  final String productId;
  final String productName;
  final String productCode;
  final String productBarcode;
  final String productPic;
  final String productUnit;
  final String productUnitQty1;
  final String productUnit2;
  final String productUnitQty2;
  final String productUnit3;
  final String productUnitQty3;
  final String productFloorNo;
  final String productShelves;
  final String productRegisNumber;
  final String productWidth;
  final String productLength;
  final String productHeight;
  final String productCompany;
  final String productWeight;

  ProductScan({
    this.productId,
    this.productName,
    this.productCode,
    this.productBarcode,
    this.productPic,
    this.productUnit,
    this.productUnitQty1,
    this.productUnit2,
    this.productUnitQty2,
    this.productUnit3,
    this.productUnitQty3,
    this.productFloorNo,
    this.productShelves,
    this.productRegisNumber,
    this.productWidth,
    this.productLength,
    this.productHeight,
    this.productCompany,
    this.productWeight
  });

  factory ProductScan.fromJson(Map<String, dynamic> json){
    return new ProductScan(
      productId: json['pID'],
      productName: json['nproduct'],
      productCode: json['pcode'],
      productBarcode: json['bcode'],
      productPic: json['pic'],
      productUnit: json['unit1'],
      productUnitQty1: json['unitQty1'],
      productUnit2: json['unit2'],
      productUnitQty2: json['unitQty2'],
      productUnit3: json['unit3'],
      productUnitQty3: json['unitQty3'],
      productFloorNo: json['floor_no'],
      productShelves: json['Shelves'],
      productRegisNumber: json['reg_no'],
      productWidth: json['width'],
      productLength: json['length'],
      productHeight: json['height'],
      productCompany: json['company'],
      productWeight: json['productWeight'],
    );
  }

}