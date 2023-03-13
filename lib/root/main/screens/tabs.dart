import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  MainController mainController =
      Get.put(MainController(mService: MainService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState>? globalKey = GlobalKey();

  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainController.hasDataCome.value = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(30.0),
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        child: Text("Kumar"),
                      ),
                      Tab(
                        child: Text("Lokesh"),
                      ),
                      Tab(
                        child: Text("Rathod"),
                      ),
                      Tab(
                        child: Text("Raj"),
                      ),
                      Tab(
                        child: Text("Madan"),
                      ),
                      Tab(
                        child: Text("Manju"),
                      )
                    ])),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text("Tab 1"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Tab 2"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Tab 3"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Tab 4"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Tab 5"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Tab 6"),
                ),
              ),
            ],
          )),
    );
  }
}
