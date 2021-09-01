import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:intl/intl.dart';
import 'package:wang_get/product_model.dart';

import 'package:wang_get/product_scan_model.dart';
import 'package:wang_get/image_detail.dart';
import 'package:wang_get/home.dart';

import 'package:soundpool/soundpool.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:wang_get/shipping_company_model.dart';
import 'package:wang_get/shipping_model.dart';
import 'package:wang_get/system_model.dart';


class AddProductPage extends StatefulWidget {

  //var empCodeReceive;
  //AddProductPage({Key key, this.empCodeReceive}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  var username;

  List units = [];
  List unitsQty = [];
  List unitsID = [];
  String _currentUnit;
  var _currentUnitID;

  List<ShippingCompany> shipCom = [];
  List<Shipping> shipComAll = [];
  //AutoCompleteTextField _currentShipComAll;
  //GlobalKey<AutoCompleteTextFieldState<Shipping>> key = GlobalKey();
  List shipComID = [];
  var _currentShipCom;


  DateTime _dateTime = DateTime.now();

  Future<int> _soundId;
  Soundpool _soundpool = Soundpool();

  List<int> imageBytes1;
  List<int> imageBytes2;
  List<int> imageBytes3;
  List<int> imageBytes4;

  List<int> responseBody = [];

  String act = "Unit";

  File imageFile1;
  File imageFile2;
  File imageFile3;
  File imageFile4;

  var empCodeReceive;

  var loading = false;
  var loadingAdd = false;

  String barcode;
  List<ProductScan> _product = [];
  List<ProductScan> _search = [];

  TextEditingController barcodeProduct = TextEditingController();
  TextEditingController barcodeProductNumber = TextEditingController();
  TextEditingController boxAmount = TextEditingController();
  TextEditingController unitAmount = TextEditingController();
  var unitAmountSum = 0;
  List<TextEditingController> unitAmountAll = [];
  TextEditingController typeUnit = TextEditingController();
  TextEditingController receiveDetail = TextEditingController();
  TextEditingController receiveLot = TextEditingController();
  TextEditingController noProductRegis = TextEditingController();

  TextEditingController receiveDateEXP = TextEditingController();
  TextEditingController receiveDateMFG = TextEditingController();

  TextEditingController productWidth = TextEditingController();
  TextEditingController productLength = TextEditingController();
  TextEditingController productHeight = TextEditingController();

  TextEditingController productWeight = TextEditingController();

  TextEditingController productShipCom = TextEditingController();

  var poDetail;

  getCodeEmpReceive() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("empCodeReceive");
    });
    return username;
  }

  var sysStatusVal = 'open';
  List<SystemStatus> sysStatusValue = [];

  getSystemStatus() async{

    sysStatusValue.clear();

    final res = await http.get('https://wangpharma.com/API/systemStatus.php');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((sysStatusGet) => sysStatusValue.add(SystemStatus.fromJson(sysStatusGet)));

        print(sysStatusValue[0].sysStatus);
        sysStatusVal = sysStatusValue[0].sysStatus;

      });

      return sysStatusValue[0].sysStatus;


    }else{
      throw Exception('Failed load Json');
    }

  }

  lockSysAlertDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ระบบ Lock"),
          content: Text("กรุณาแก้ไขส่วนงานที่เกิดปัญหา"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                print('Out');
              },
            ),
          ],
        );
      },
    );
  }

  _getUiitProduct() async{
    final res = await http.get('https://wangpharma.com/API/receiveProduct.php?act=$act');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        //units = jsonData;

        jsonData.forEach((unit) => units.add(unit['unitName']));
        jsonData.forEach((unitID) => unitsID.add(unitID['unitID']));

        print(units);
        print(unitsID);
        return units;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  _getShipCom(comCode) async{
    final res = await http.get('https://wangpharma.com/API/receiveProduct.php?act=Shipping&comCode=$comCode');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((shipComs) =>shipCom.add(ShippingCompany.fromJson(shipComs)));

        /*setState(() {
          if(_product[0].productUnit != null && _product[0].productUnit != ''){
            unitsID.add(1);
            units.add(_product[0].productUnit);
          }
          if(_product[0].productUnit2 != null && _product[0].productUnit2 != ''){
            unitsID.add(2);
            units.add(_product[0].productUnit2);
          }
          if(_product[0].productUnit3 != null && _product[0].productUnit3 != ''){
            unitsID.add(3);
            units.add(_product[0].productUnit3);
          }
        });*/

        print(shipCom);
        print(shipComID);
        return shipCom;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  _getShipComAll() async{
    final res = await http.get('https://wangpharma.com/API/receiveProduct.php?act=ShippingAll');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((shipComAlls) =>shipComAll.add(Shipping.fromJson(shipComAlls)));

        print(shipComAll);
        print(shipComID);
        return shipComAll;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  _onDropDownItemSelected(newValueSelected){
    setState(() {
      _currentUnit = newValueSelected;
    });
  }

  _onDropDownShipComSelected(shipComValueSelected){
    setState(() {
      _currentShipCom = shipComValueSelected;
    });
  }

  _openCamera(camPosition) async {
      var picture = await ImagePicker().getImage(source: ImageSource.camera);
      this.setState((){
        if(camPosition == 1){
          imageFile1 = File(picture.path);
        }else if(camPosition == 2){
          imageFile2 = File(picture.path);
        }else if(camPosition == 3){
          imageFile3 = File(picture.path);
        }else{
          imageFile4 = File(picture.path);
        }
      });
      //Navigator.of(context).pop();
  }

  _decideImageView(camPosition){

    File imageFileC;

    if(camPosition == 1){
      imageFileC = imageFile1;
    }else if(camPosition == 2){
      imageFileC = imageFile2;
    }else if(camPosition == 3){
      imageFileC = imageFile3;
    }else{
      imageFileC = imageFile4;
    }

    if(imageFileC == null){
      return GestureDetector(
        onTap: () {
          _openCamera(camPosition);
        },
        child: Image (
          image: AssetImage ( "assets/photo_default_2.png" ), width: 90, height: 90,
        ),
      );
    }else{
      return GestureDetector(
        onTap: () {
          _openCamera(camPosition);
          /*print("open img.");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageDetailPage(imageFile: imageFileC)));*/
        },
        onLongPress: (){
          print("open img.");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageDetailPage(imageFile: imageFileC)));
        },
        child: Image.file(imageFileC, width: 100, height: 100),
      );
    }
  }

  onSearch(String text) async{
    _search.clear();
    if(text.isEmpty){
      setState(() {});
      return;
    }

    setState(() {
      searchProduct(text);
    });
    /*_product.forEach((f){
      if(f.productName.contains(text)) _search.add(f);
    });*/

    //setState(() {});
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load("assets/sounds/beep.mp3");
    return await _soundpool.load(asset);
  }

  Future<void> _playSound() async {
    var _alarmSound = await _soundId;
    await _soundpool.play(_alarmSound);
  }

  showToastVal(textVal){
    Fluttertoast.showToast(
        msg: textVal,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3
    );
  }

  /*scanBarcode() async {
    try {
      var barcode = await BarcodeScanner.scan();
      _playSound();
      print('ttttttttttttttt${barcode.rawContent}');
      setState((){
        if(barcode.rawContent.isNotEmpty){
          searchProduct(barcode.rawContent);
        }else{
          showToastVal('ไม่พบสินค้า');
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        _showAlertBarcode();
        print('Camera permission was denied');
      } else {
        print('Unknow Error $e');
      }
    } on FormatException {
      print('User returned using the "back"-button before scanning anything.');
    } catch (e) {
      print('Unknown error.');
    }
  }*/

  scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      _playSound();
      setState((){
        this.barcode = barcode;
        searchProduct(this.barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showAlertBarcode();
        print('Camera permission was denied');
      } else {
        print('Unknow Error $e');
      }
    } on FormatException {
      print('User returned using the "back"-button before scanning anything.');
    } catch (e) {
      print('Unknown error.');
    }
  }

  void _showAlertBarcode() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('คุณไม่เปิดอนุญาตใช้กล้อง'),
        );
      },
    );
  }

  _selectDateProduct(BuildContext context, exp) async{
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if(_pickedDate != null){
      if(exp == 0){
        setState(() {
          _dateTime = _pickedDate;

          print(_dateTime.toString().substring(0,10));
          receiveDateMFG.text = _dateTime.toString().substring(0,10);
        });
      }else{
        setState(() {
          _dateTime = _pickedDate;

          print(_dateTime.toString().substring(0,10));
          receiveDateEXP.text = _dateTime.toString().substring(0,10);
        });
      }
    }
  }

  List<Product> productRecent = [];

  getProductRecent(idPro) async{

    final res = await http.get('https://wangpharma.com/API/receiveProduct.php?idPro=$idPro&act=Recent');

    if(res.statusCode == 200){

      setState(() {
        //isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) => productRecent.add(Product.fromJson(products)));

        print(productRecent);

        return productRecent;

      });


    }else{
      throw Exception('Failed load Json');
    }
  }

  _getProductRecentDetail(){

    if(productRecent.isEmpty){
      return Text('....');
    }else{
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, int index){
            return ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
              onTap: (){
                //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => ReportDetailPage(receiveProducts: productAll[index])));
              },
              leading: Image.network('https://www.wangpharma.com/cms/product/${productRecent[index].recevicProductPic}', fit: BoxFit.cover, width: 70, height: 70,),
              title: Text('${productRecent[index].recevicProductName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${productRecent[index].recevicProductCode}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ลัง : ${productRecent[index].recevicTCqtyBox}', style: TextStyle(color: Colors.red)),
                      Text('เวลาที่รับ ${productRecent[index].recevicDateAdd}')
                    ],
                  ),
                  productRecent[index].recevicProductUnitNew == null ?
                  Text('หน่วยย่อย : ${productRecent[index].recevicTCqtySub} ${productRecent[index].recevicProductUnit}', style: TextStyle(color: Colors.lightBlue))
                      : Text('หน่วยย่อย : ${productRecent[index].recevicTCqtySub} ${productRecent[index].recevicProductUnitNew}', style: TextStyle(color: Colors.lightBlue)),
                  productRecent[index].recevicPoRefCode == null ?
                  Text('ไม่มีคำสั่งซื้อ', style: TextStyle(color: Colors.red))
                      : Text("ตามใบสั่งซื้อ - ${productRecent[index].recevicPoRefCode} จำนวน ${productRecent[index].recevicPoRefQty}/${productRecent[index].recevicPoRefUnit}", style: TextStyle(color: Colors.red)),
                ],
              ),
            );
          },
          itemCount: productRecent != null ? productRecent.length : 0,
        ),
      );
    }
  }

  searchProduct(searchVal) async{

    //barcodeProduct.text = searchVal;

    //barcodeProduct = TextEditingController(text: searchVal);


    setState(() {
      loading = true;
    });
    _product.clear();
    units.clear();
    unitsQty.clear();
    unitsID.clear();

    shipCom.clear();

    productRecent.clear();

    //productAll = [];

    final res = await http.get('https://wangpharma.com/API/receiveProduct.php?SearchVal=$searchVal&act=Search');

    if(res.statusCode == 200){

      setState(() {

        //loading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) =>_product.add(ProductScan.fromJson(products)));

        setState(() {
          if(_product[0].productUnit != null && _product[0].productUnit != ''){
            unitsID.add(1);
            units.add(_product[0].productUnit);
            unitsQty.add(_product[0].productUnitQty1);
          }
          if(_product[0].productUnit2 != null && _product[0].productUnit2 != ''){
            unitsID.add(2);
            units.add(_product[0].productUnit2);
            unitsQty.add(_product[0].productUnitQty2);
          }
          if(_product[0].productUnit3 != null && _product[0].productUnit3 != ''){
            unitsID.add(3);
            units.add(_product[0].productUnit3);
            unitsQty.add(_product[0].productUnitQty3);
          }
        });

        setState(() {
          getPoDetail(_product[0].productCode);
          _getShipCom(_product[0].productCompany);
          _getShipComAll();

          getProductRecent(_product[0].productId);
        });

        print(poDetail);

        print(_product);
        return _product;

      });

    }else{
      throw Exception('Failed load Json');
    }

  }

  getPoDetail(pcode) async{

    final res = await http.get('https://wangpharma.com/API/receiveProductGetPO.php?productCode=$pcode&act=getPoDetail');
    //print('https://wangpharma.com/API/receiveProductGetPO.php?productCode=$pcode&act=getPoDetail');

    if(res.statusCode == 200){

      setState(() {

        //loading = false;

        var jsonData = json.decode(res.body);

        //jsonData.forEach((products) =>_product.add(ProductScan.fromJson(products)));
        jsonData.forEach((poDetails) async {
          poDetail = poDetails;
        });

        //print('ใบสั่งซื้อ-$poDetail');
        return poDetail;

      });

    }else{
      throw Exception('Failed load Json');
    }

  }

  _getProductInfo(){

    if(!loading){
      return Text('....');
    }else{
      return Container(
        child: ListView.builder(
          shrinkWrap:true,
          itemCount: _product.length,
          itemBuilder: (context, i){
            final a = _product[0];
            return ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
              onTap: (){

              },
              leading: Container(
                child: Stack(
                  children: [
                    Image.network('https://www.wangpharma.com/cms/product/${a.productPic}', fit: BoxFit.cover, width: 80, height: 80),
                    a.productWidth == "0" ?
                        Text('')
                      : Text('W ${a.productWidth} x L ${a.productLength} x H ${a.productHeight}',
                          style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold, backgroundColor: Colors.white)),
                  ],
                ),
              ),
              title: Text('${a.productName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${a.productCode}'),
                      Text('ชั้น ${a.productFloorNo} / shelf ${a.productShelves}', style: TextStyle(color: Colors.green),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('หน่วยเล็กสุด : ${a.productUnit}', style: TextStyle(color: Colors.blue), overflow: TextOverflow.ellipsis),
                      poDetail != null ?
                      Text("ตามใบสั่งซื้อ - ${poDetail['po_code']} จำนวน ${poDetail['Num']}/${poDetail['po_punit']}", style: TextStyle(color: Colors.red))
                          : Text('ไม่มีคำสั่งซื้อ', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  Text('No.ทะเบียนยา : ${a.productRegisNumber} ', style: TextStyle(color: Colors.purple),),
                ],
              ),
              /*trailing: IconButton(
                  icon: Icon(Icons.view_list, color: Colors.teal, size: 40,),
                  onPressed: (){
                    //addToOrderFast(a);
                  }
              ),*/
            );
          },
        ),
      );
    }
  }

  _getUnitProduct(){

    //if(units.isNotEmpty){
      //units.map((item) {
        //unitAmountAll[units.indexOf(item)] = new TextEditingController();
      //}).toList();
    //}


    print(units.length);
    for (var i = 0; i <= units.length; i++) {
      unitAmountAll.add(TextEditingController());
      print(i);
    }

    //units.asMap().forEach((i, value) {
      //unitAmountAll[i] = new TextEditingController();
    //});

    if(!loading){
      return Text('....');
    }else{
      return Container(
        child: ListView.builder(
          shrinkWrap:true,
          itemCount: units.length,
          itemBuilder: (context, i){
            return ListTile(
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
              leading: Text('จำนวนหน่วยย่อย', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              title: Container(
                width: 120,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: TextFormField (
                  textAlign: TextAlign.center,
                  controller: unitAmountAll[i],
                  style: TextStyle (
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (text){
                    unitAmountSum = 0;
                    for (var i = 0; i <= units.length; i++) {
                      //unitAmountSum = unitAmountSum + int.parse(text);
                      if(unitAmountAll[i].text.isNotEmpty){
                        setState(() {
                          //print(unitsQty[0]);
                          var unitQtyAmountSum;
                          unitQtyAmountSum = (int.parse(unitsQty[0]) / int.parse(unitsQty[i])) * int.parse(unitAmountAll[i].text);
                          //print(unitQtyAmountSum.toInt());
                          unitAmountSum = unitAmountSum + unitQtyAmountSum.toInt();
                          //print(unitAmountSum);
                          _currentUnitID = unitsID[0];
                          _currentUnit = units[0];
                          unitAmount.text = unitAmountSum.toString();
                        });
                      }

                    }

                    print(unitAmount.text);
                    print(_currentUnitID);
                    print(_currentUnit);

                    //for (var i = 1; i <= units.length; i++) {
                      //unitAmountSum = unitAmountSum + int.parse(text);
                      //print(unitAmountSum);
                    //}

                  },
                ),
              ),
              trailing: Container(
                width: 100,
                child: Text('/ ${units[i]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              )
            );
          },
        ),
      );
    }
  }


  resizeImgFun(imageFile){

    setState(() {
      loadingAdd = true;
    });

    img.Image preImageFile = img.decodeImage(imageFile.readAsBytesSync());
    img.Image resizeImage = img.copyResize(preImageFile, width: 800);

    File resizeImageFile = File(imageFile.path)
      ..writeAsBytesSync(img.encodeJpg(resizeImage, quality: 70));

    return resizeImageFile;
  }

  _addReceiveProductTest() async{
    var tempDateMFG = DateFormat("dd/MM/yyyy").parse(receiveDateMFG.text);
    var tempDateEXP = DateFormat("dd/MM/yyyy").parse(receiveDateEXP.text);
    print(tempDateMFG);
    print(tempDateEXP);
    //print(receiveDateEXP.text);
  }


  _addReceiveProduct() async{

    var tempDateMFG;
    var tempDateEXP;

    if(receiveDateMFG.text == ''){
      tempDateMFG = '';
    }else{
      tempDateMFG = DateFormat("dd/MM/yyyy").parse(receiveDateMFG.text);
    }

    if(receiveDateEXP.text == ''){
      tempDateEXP = '';
    }else{
      tempDateEXP = DateFormat("dd/MM/yyyy").parse(receiveDateEXP.text);
    }

    //tempDateMFG = DateFormat("dd/MM/yyyy").parse(receiveDateMFG.text);
    //521tempDateEXP = DateFormat("dd/MM/yyyy").parse(receiveDateEXP.text);

    /*setState(() {
      loadingAdd = true;
    });*/

    if(imageFile1 != null
        && imageFile2 != null
        && imageFile4 != null
        && _product != []
        && boxAmount.text != null
        && unitAmount.text != null
        && _currentUnitID != null
        && _currentUnit != null) {
      var uri = Uri.parse("https://wangpharma.com/API/addReceiveProduct.php");
      var request = http.MultipartRequest("POST", uri);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      empCodeReceive = prefs.getString("empCodeReceive");

      /*img.Image preImageFile1 = img.decodeImage(imageFile1.readAsBytesSync());
      img.Image resizeImage1 = img.copyResize(preImageFile1, width: 400);

      File resizeImageFile1 = File(imageFile1.path)
        ..writeAsBytesSync(img.encodeJpg(resizeImage1, quality: 85));*/

      //File resizeImageFile1 = await resizeImgFun(imageFile1);

      imageBytes1 = imageFile1.readAsBytesSync();
      String image1B64 = base64Encode(imageBytes1);

      /*var stream1 = http.ByteStream(
          DelegatingStream.typed(resizeImageFile1.openRead()));
      var imgLength1 = await resizeImageFile1.length();
      var multipartFile1 = http.MultipartFile("runFile2", stream1, imgLength1,
          filename: path.basename("resizeImageFile1.jpg"));*/

      /*img.Image preImageFile2 = img.decodeImage(imageFile2.readAsBytesSync());
      img.Image resizeImage2 = img.copyResize(preImageFile2, width: 400);

      File resizeImageFile2 = File(imageFile2.path)
        ..writeAsBytesSync(img.encodeJpg(resizeImage2, quality: 85));*/

      //File resizeImageFile2 = await resizeImgFun(imageFile2);

      imageBytes2 = imageFile2.readAsBytesSync();
      String image2B64 = base64Encode(imageBytes2);

      /*var stream2 = http.ByteStream(
          DelegatingStream.typed(resizeImageFile2.openRead()));
      var imgLength2 = await resizeImageFile2.length();
      var multipartFile2 = http.MultipartFile("runFile2ex", stream2, imgLength2,
          filename: path.basename("resizeImageFile2.jpg"));*/

      /*img.Image preImageFile3 = img.decodeImage(imageFile3.readAsBytesSync());
      img.Image resizeImage3 = img.copyResize(preImageFile3, width: 400);

      File resizeImageFile3 = File(imageFile3.path)
        ..writeAsBytesSync(img.encodeJpg(resizeImage3, quality: 85));*/

      //File resizeImageFile3 = await resizeImgFun(imageFile3);

      //imageBytes3 = imageFile3.readAsBytesSync();
      //String image3B64 = base64Encode(imageBytes3);

      /*var stream3 = http.ByteStream(
          DelegatingStream.typed(resizeImageFile3.openRead()));
      var imgLength3 = await resizeImageFile3.length();
      var multipartFile3 = http.MultipartFile(
          "runFile2priceTag", stream3, imgLength3,
          filename: path.basename("resizeImageFile3.jpg"));*/

      imageBytes4 = imageFile4.readAsBytesSync();
      String image4B64 = base64Encode(imageBytes4);

      //request.files.add(multipartFile1);
      //request.files.add(multipartFile2);
      //request.files.add(multipartFile3);
      request.fields['runFile2'] = image1B64;
      request.fields['runFile2ex'] = image2B64;
      //request.fields['runFile2priceTag'] = image3B64;
      request.fields['runFile2box'] = image4B64;


      request.fields['runDetail2'] = receiveDetail.text;
      request.fields['runPeople2'] = empCodeReceive;

      request.fields['idPro2'] = _product[0].productId;
      request.fields['bcode2'] = _product[0].productBarcode;
      request.fields['runQ2'] = boxAmount.text;
      request.fields['runQs2'] = unitAmount.text;
      request.fields['unit2'] = _currentUnitID.toString();
      request.fields['unit2Val'] = _currentUnit;
      request.fields['lot'] = receiveLot.text;
      request.fields['noProductRegis'] = noProductRegis.text;
      request.fields['shipComCodeVal'] = _currentShipCom.toString();


      //request.fields['dateMFG'] = receiveDateMFG.text;
      //request.fields['dateEXP'] = receiveDateEXP.text;

      request.fields['dateMFG'] = tempDateMFG.toString();
      request.fields['dateEXP'] = tempDateEXP.toString();

      request.fields['productWidth'] = productWidth.text;
      request.fields['productLength'] = productLength.text;
      request.fields['productHeight'] = productHeight.text;

      request.fields['productWeight'] = productWeight.text;

      if(poDetail != null){
        request.fields['poRefCode'] = poDetail['po_code'];
        request.fields['poRefQty'] = poDetail['Num'];
        request.fields['poRefUnit'] = poDetail['po_punit'];
      }

      print(request.fields['runFile2']);
      print(request.fields['noProductRegis']);
      /*print(request.files[0].filename);
      print(request.files[0].length);
      print(request.files[1].filename);
      print(request.files[1].length);
      print(request.files[2].filename);
      print(request.files[2].length);*/

      print(request.fields['idPro2']);
      print(request.fields['bcode2']);
      print(request.fields['runQ2']);
      print(request.fields['runQs2']);
      print(request.fields['unit2']);
      print(request.fields['unit2Val']);
      print(request.fields['shipComCodeVal']);

      var response = await request.send();

      if (response.statusCode == 200) {

        var respStr = await response.stream.bytesToString();

        print(respStr);

        if(respStr == 'OK add DB'){
          showToastAddFast();

          /*loadingAdd = false;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()));*/

          setState(() {
            loadingAdd = false;
          });

          Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);

          print("add OK");

          /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home())).then((r){
                setState(() {
                  loadingAdd = false;
                });
          });*/
        }else{
          _showAlertErrorAddDB();
        }


      } else {
        print("add Error");
      }

    }else{
      _showAlert();

        setState(() {
          loadingAdd = false;
        });

    }
  }

  showToastAddFast(){
    Fluttertoast.showToast(
        msg: "เพิ่มรายการแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3
    );
  }

  _showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('คุณกรอกรายละเอียดไม่ครบถ้วน'),
        );
      },
    );
  }

  _showAlertErrorAddDB() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('ไม่สามารถเพิ่มสินค้าเข้าระบบได้\nโปรดตรวจสอบรายละเอียดสินค้าในฐานข้อมูล'),
        );
      },
    );
  }

  @override
  void initState(){
    super.initState();
    //_getUiitProduct();
    getCodeEmpReceive();

    _soundId = _loadSound();
    //getPoDetail('23011201');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    barcodeProduct.dispose();
    barcodeProductNumber.dispose();
    boxAmount.dispose();
    unitAmount.dispose();
    typeUnit.dispose();
    receiveDetail.dispose();
    receiveLot.dispose();
    noProductRegis.dispose();

    receiveDateEXP.dispose();
    receiveDateMFG.dispose();

    productWidth.dispose();
    productLength.dispose();
    productHeight.dispose();

    productWeight.dispose();

    productShipCom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.auto_awesome_mosaic, size: 40),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        backgroundColor: Colors.blue,
        title: Text("ระบบรับสินค้า-$username"),
        actions: <Widget>[
          Container(
            //color: Colors.lightGreen,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: loadingAdd ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
                :IconButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: Icon(Icons.add_circle, size: 50, color: Colors.white,),
                  onPressed: () async {
                      await getSystemStatus();

                    if(sysStatusVal == 'lock'){
                      lockSysAlertDialog();
                    }else{
                      setState(() => loadingAdd = true);
                      await _addReceiveProduct();
                      setState(() => loadingAdd = false);
                    }

                    //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                }
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon: Icon(Icons.aspect_ratio, size: 50, color: Colors.red,),
                        onPressed: (){
                          scanBarcode();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                        }
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                      child: TextField (
                        controller: barcodeProduct,
                        onChanged: onSearch,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'Barcode / Code สินค้า',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  /*Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: loadingAdd ? CircularProgressIndicator()
                        :IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon: Icon(Icons.add_circle, size: 50, color: Colors.green,),
                        onPressed: () async {
                          setState(() => loadingAdd = true);
                          await _addReceiveProduct();
                          setState(() => loadingAdd = false);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                        }
                    ),
                  ),*/
                ],
              ),
              /*Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon: Icon(Icons.tag, size: 50, color: Colors.green,),
                        onPressed: (){
                          scanBarcode();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                        }
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                      child: TextField (
                        controller: barcodeProductNumber,
                        onChanged: onSearch,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'Barcode / Code สินค้า (เฉพาะตัวเลข)',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),*/
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.lightBlue,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('รายละเอียดสินค้า', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                      )
                  )
                ],
              ),
              _getProductInfo(),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('จำนวนที่รับ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                      )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField (
                        textAlign: TextAlign.center,
                        controller: boxAmount,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'จำนวนลัง',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(" / ลัง", style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField (
                        textAlign: TextAlign.center,
                        controller: productWeight,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'น้ำหนักต่อชิ้น',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(" / กรัม", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.deepOrange,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('รวมหน่วยเล็กสุด ${unitAmountSum} ${(units.isNotEmpty)?units[0]:''}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                      )
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _getUnitProduct(),)
                ],
              ),
              /*Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: TextFormField (
                        textAlign: TextAlign.center,
                        controller: unitAmount,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'จำนวนหน่วยย่อย',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Text("/", style: TextStyle(fontSize: 18)),
                  /*Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: DropdownButton(
                          hint: Text("หน่วยสินค้า",style: TextStyle(fontSize: 16)),
                          items: units.map((dropDownStringItem){
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem, style: TextStyle(fontSize: 16)),
                            );
                          }).toList(),
                          onChanged: (newValueSelected){
                            var tempIndex = units.indexOf(newValueSelected);
                            _onDropDownItemSelected(newValueSelected);
                            _currentUnitID = unitsID[tempIndex];
                            print(this._currentUnit);
                            print(_currentUnitID);
                          },
                          value: _currentUnit,
                        ),
                      )
                  ),*/
                  Expanded(
                    flex: 2,
                      child: Text("หลอด", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),*/
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('ข้อมูลวันผลิตและหมดอายุ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                      )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField (
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        controller: noProductRegis,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'No.ทะเบียนยา',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField (
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        controller: receiveLot,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'Lot สินค้า',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField (
                        /*onTap: (){
                        _selectDateProduct(context,0);
                      },*/
                        maxLines: null,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        controller: receiveDateMFG,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            hintText: 'dd/MM/yyyy',
                            labelText: 'วันผลิต',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp(r'\d+|-|/')),
                          DateInputFormatter(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField (
                        /*onTap: (){
                        _selectDateProduct(context,1);
                      },*/
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        controller: receiveDateEXP,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            hintText: 'dd/MM/yyyy',
                            labelText: 'วันหมดอายุ',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp(r'\d+|-|/')),
                          DateInputFormatter(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('ขนาดสินค้า', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                      )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField (
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        controller: productWidth,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'กว้าง cm',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField (
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        controller: productLength,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'ยาว cm',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField (
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        controller: productHeight,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'สูง cm',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              /*Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField (
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.start,
                        controller: receiveDetail,
                        style: TextStyle (
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration (
                            labelText: 'เพิ่มเติม*',
                            labelStyle: TextStyle (
                              fontSize: (15),
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        /*child: DropdownButton(
                          hint: Text("ขนส่ง",style: TextStyle(fontSize: 16)),
                          items: shipCom.map((dropDownStringItemShip){
                            return DropdownMenuItem<String>(
                              value: dropDownStringItemShip.scShipCode,
                              child: Text(dropDownStringItemShip.scShipName, style: TextStyle(fontSize: 16)),
                            );
                          }).toList(),
                          onChanged: (shipComValueSelected){
                            //var tempIndex = units.indexOf(newValueSelected);
                            _onDropDownShipComSelected(shipComValueSelected);
                            //_currentUnitID = unitsID[tempIndex];
                            //print(this._currentUnit);
                            //print(_currentUnitID);
                          },
                          value: _currentShipCom,
                        ),*/
                        child: AutoCompleteTextField<Shipping>(
                            controller: productShipCom,
                            clearOnSubmit: false,
                            suggestions: shipComAll,
                            decoration: InputDecoration(
                                labelText: "ขนส่ง",
                            ),
                            itemFilter: (item, query){
                              return item.shipComName.toLowerCase().startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b){
                              return a.shipComName.compareTo(b.shipComName);
                            },
                            itemSubmitted: (item){
                              //setState(() {
                                productShipCom.text = item.shipComName;
                                _currentShipCom = item.shipComCode;
                              //});
                              print(productShipCom.text);
                              print(_currentShipCom);
                            },
                            itemBuilder: (context, item){
                              return Text(item.shipComName, style: TextStyle(color: Colors.green, fontSize: 16),);
                            },
                        ),
                      )
                  ),
                ],
              ),*/
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("รูปวันหมดอายุ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        _decideImageView(1),
                        /*IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            icon: Icon(Icons.camera_alt, size: 40,),
                            onPressed: (){
                              _openCamera(1);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                            }
                        ),*/
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("รูปราคาป้าย", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        _decideImageView(2),
                        /*IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            icon: Icon(Icons.camera_alt, size: 40,),
                            onPressed: (){
                              _openCamera(2);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                            }
                        ),*/
                      ],
                    ),
                  ),
                  /*Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("รูป LOT สินค้า", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        _decideImageView(3),
                        /*IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            icon: Icon(Icons.camera_alt, size: 40,),
                            onPressed: (){
                              _openCamera(3);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                            }
                        ),*/
                      ],
                    ),
                  ),*/
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("รูปลังสินค้า", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        _decideImageView(4),
                        /*IconButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            icon: Icon(Icons.camera_alt, size: 40,),
                            onPressed: (){
                              _openCamera(4);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                            }
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.deepOrange,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('สินค้าตัวเดียวกันที่เคยรับภายในวันนี้ล่าสุด', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                      )
                  )
                ],
              ),
              _getProductRecentDetail(),
            ],
          ),
        ),
      ),
    );
  }
}
