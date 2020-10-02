import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wang_get/product_model.dart';
import 'package:wang_get/report_detail.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  ScrollController _scrollController = new ScrollController();

  //Product product;
  List <Product>productAll = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "All";

  //var product;

  getReceiveProduct() async{

    final res = await http.get('https://wangpharma.com/API/receiveProduct.php?PerPage=$perPage&act=$act');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) => productAll.add(Product.fromJson(products)));
        perPage = perPage + 30;

        print(productAll);
        print(perPage);

        return productAll;

      });


    }else{
      throw Exception('Failed load Json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReceiveProduct();

    _scrollController.addListener((){
      //print(_scrollController.position.pixels);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getReceiveProduct();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? CircularProgressIndicator()
          :ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, int index){
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportDetailPage(receiveProducts: productAll[index])));
            },
            leading: Image.network('https://www.wangpharma.com/cms/product/${productAll[index].recevicProductPic}', fit: BoxFit.cover, width: 70, height: 70,),
            title: Text('${productAll[index].recevicProductName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${productAll[index].recevicProductCode}'),
                Text('ลัง : ${productAll[index].recevicTCqtyBox}', style: TextStyle(color: Colors.red),),
                productAll[index].recevicProductUnitNew == null ?
                      Text('หน่วยย่อย : ${productAll[index].recevicTCqtySub} ${productAll[index].recevicProductUnit}', style: TextStyle(color: Colors.lightBlue))
                    : Text('หน่วยย่อย : ${productAll[index].recevicTCqtySub} ${productAll[index].recevicProductUnitNew}', style: TextStyle(color: Colors.lightBlue)),
              ],
            ),
            trailing: IconButton(
                icon: Icon(Icons.view_list, size: 40,),
                onPressed: (){
                  //addToOrderFast(productAll[index]);
                }
            ),
          );
        },
        itemCount: productAll != null ? productAll.length : 0,
      ),

    );
  }
}
