import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wang_get/report_image_detail.dart';
import 'package:wang_get/report.dart' as reportPage;

import 'package:fluttertoast/fluttertoast.dart';

class ReportDetailPage extends StatefulWidget {

  var receiveProducts;
  ReportDetailPage({Key key, this.receiveProducts}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {

  showDialogDelConfirm(id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("ยืนยันลบรายการ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              color: Colors.green,
              child: Text("ตกลง",style: TextStyle(color: Colors.white, fontSize: 18),),
              onPressed: () {
                removeOrder(id);
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/Home');
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  removeOrder(id) async{

    final response = await http.post(
        'https://wangpharma.com/API/delReceiveProduct.php',
        body: {'id': id, 'act': "Del"});

    if(response.statusCode == 200){
      print('del OK');

    }else{
      print('Connect ERROR');
    }
    //
    showToastRemove();
    print(id);
  }

  showToastRemove(){
    Fluttertoast.showToast(
        msg: "ลบรายการแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.product.productName.toString()),
        title: Text("รายละเอียดรับสินค้า"),
        actions: <Widget>[
          /*IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                //Navigator.pushReplacementNamed(context, '/Order');
              }
          )*/
        ],
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      leading: Image.network('https://www.wangpharma.com/cms/product/${widget.receiveProducts.recevicProductPic}', fit: BoxFit.cover, width: 70, height: 70),
                      title: Text('${widget.receiveProducts.recevicProductName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Code : ${widget.receiveProducts.recevicProductCode}'),
                          Text('Barcode : ${widget.receiveProducts.recevicTCbarcode}'),
                          Text('ลัง : ${widget.receiveProducts.recevicTCqtyBox}', style: TextStyle(color: Colors.red),),
                          widget.receiveProducts.recevicProductUnitNew.isEmpty ?
                                Text('หน่วยย่อย : ${widget.receiveProducts.recevicTCqtySub} ${widget.receiveProducts.recevicProductUnit}', style: TextStyle(color: Colors.lightBlue),)
                              : Text('หน่วยย่อย : ${widget.receiveProducts.recevicTCqtySub} ${widget.receiveProducts.recevicProductUnitNew}', style: TextStyle(color: Colors.lightBlue),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("รูปวันหมดอายุ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReportImageDetailPage(receiveProductPic: widget.receiveProducts.recevicPic)));
                          },
                          child: Image.network('https://www.wangpharma.com/cms/FileUpload/Warehouse/receiveBox/${widget.receiveProducts.recevicPic}', fit: BoxFit.cover, width: 120, height: 100),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("รูปราคาป้าย", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReportImageDetailPage(receiveProductPic: widget.receiveProducts.recevicPicEx)));
                          },
                          child: Image.network('https://www.wangpharma.com/cms/FileUpload/Warehouse/receiveBox/${widget.receiveProducts.recevicPicEx}', fit: BoxFit.cover, width: 120, height: 100),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("รูป LOT สินค้า", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReportImageDetailPage(receiveProductPic: widget.receiveProducts.recevicPicPriceTag)));
                          },
                          child: Image.network('https://www.wangpharma.com/cms/FileUpload/Warehouse/receiveBox/${widget.receiveProducts.recevicPicPriceTag}', fit: BoxFit.cover, width: 120, height: 100),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: MaterialButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        minWidth: double.infinity,
                        height: 50,
                        child: Text(
                          "ลบรายบการ",
                          style: new TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        //onPressed: (){Navigator.pushReplacementNamed(context, '/Home');},
                        onPressed: () {
                          showDialogDelConfirm(widget.receiveProducts.recevicId);
                        },
                      ),
                    )
                  )
                ],
              )
            ],
          ),
      ),
    );
  }
}
