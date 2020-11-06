import 'package:flutter/material.dart';

import 'package:wang_get/add_product.dart';
import 'package:wang_get/report.dart';
import 'package:wang_get/user.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var username;

  int currentIndex = 0;
  List pages = [AddProductPage(), ReportPage(), UserPage()];

  getCodeEmpReceive() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("empCodeReceive");
    });
    return username;
  }

  _clearSharedPrefer() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCodeEmpReceive();
  }

  @override
  Widget build(BuildContext context) {

    Widget bottomNavBar = BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos),
              title: Text('รับสินค้า', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('รายงาน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              title: Text('ผู้ใช้', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
        ]
    );

    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("ระบบรับสินค้า-$username"),
        actions: <Widget>[

        ],
      ),*/
      body: AddProductPage(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("รหัสพนักงาน-$username",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(1, 2), blurRadius: 2)
                      ]
                  )
              ),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("รายงาน"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage()));
              }
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
                leading: Icon(Icons.close),
                title: Text("ออกจากระบบ", style: TextStyle(color: Colors.red),),
                onTap: (){
                  _clearSharedPrefer();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                }
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: Container(
        child: MaterialButton(
          color: Colors.green,
          textColor: Colors.white,
          minWidth: double.infinity,
          height: 50,
          child: Text(
            "OK",
            style: new TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          //onPressed: (){Navigator.pushReplacementNamed(context, '/Home');},
          onPressed: () {
          },
        ),
      ),*/
    );
  }
}
