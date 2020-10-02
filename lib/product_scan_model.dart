class ProductScan{
  final String productId;
  final String productName;
  final String productCode;
  final String productBarcode;
  final String productPic;
  final String productUnit;
  final String productUnit2;
  final String productUnit3;

  ProductScan({
    this.productId,
    this.productName,
    this.productCode,
    this.productBarcode,
    this.productPic,
    this.productUnit,
    this.productUnit2,
    this.productUnit3
  });

  factory ProductScan.fromJson(Map<String, dynamic> json){
    return new ProductScan(
      productId: json['pID'],
      productName: json['nproduct'],
      productCode: json['pcode'],
      productBarcode: json['bcode'],
      productPic: json['pic'],
      productUnit: json['unit1'],
      productUnit2: json['unit2'],
      productUnit3: json['unit3'],
    );
  }

}