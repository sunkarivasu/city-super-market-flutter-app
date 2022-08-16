import 'package:city_super_market/main.dart';
import 'package:city_super_market/screens/login.dart';
import 'package:city_super_market/screens/orders.dart';
import 'package:flutter/material.dart';
import "package:city_super_market/constants.dart";
import "package:city_super_market/globals.dart" as globals;
import 'dart:convert';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return globals.User.getCurrentUser()['user']!=null?Container(
      padding: EdgeInsets.symmetric(vertical: 50,horizontal: 5),
      // color: appBarColor,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.account_circle,size: 100,),
              SizedBox(height: 20,),
              Text(globals.User.getCurrentUser()['user']['name'],style: TextStyle(
                  // color: Colors.white,
                  fontSize: 22
              ),),
              SizedBox(height: 10,),
              Text(globals.User.getCurrentUser()['user']['emailId'],style: TextStyle(
                  color: Colors.black,
                  fontSize: 15
              ),),
              SizedBox(height: 10,),
            ],
          ),
          Divider(
            // color: homePageBackgroundColor,
          ),
          SizedBox(height: 10,),
          // SizedBox(height: 5,),
          DrawerOptionIcon(icon: Icons.shopping_cart, option: "My Cart",),
          SizedBox(height: 5,),
          DrawerOptionIcon(icon: Icons.shopping_bag_outlined, option: "My Orders"),
          SizedBox(height: 5,),
          DrawerOptionIcon(icon: Icons.logout, option: "Log out"),


        ],
      ),
    ):Container(
      padding: EdgeInsets.symmetric(vertical: 50,horizontal: 5),
      // color: appBarColor,
      child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(Icons.account_circle,size: 100,),
                SizedBox(height: 10,),
                TextButton(onPressed: () async {
                  await Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                  globals.User.setPageNumber(0);
                  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MyStatefullWidget()),(route) => false);
                },
                  style: TextButton.styleFrom(
                    backgroundColor: appBarColor,
                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: 5)
                  ),
                  child:Text("Login",style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                  ),),),
                SizedBox(height: 10,),
              ],
            ),
            Divider(
              // color: homePageBackgroundColor,
            ),
          ]),
    );
  }
}

class DrawerOptionIcon extends StatelessWidget {

  IconData icon;
  String option;

  DrawerOptionIcon({required this.icon,required this.option});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        if(option=="My Cart")
        {
          globals.User.setPageNumber(1);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyStatefullWidget()));
        }
        else if(option == "My Orders")
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
          // Navigator.pop(context);
        }
        else if(option == "Log out")
        {
            globals.User.setCurrerntUser(
              {
                "user":null,
              });
            globals.User.setPageNumber(0);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyStatefullWidget()),(route) => false);
        }
      },
      child: Row(
        children: [
          Icon(icon,size: 21,color: Colors.black54,),
          SizedBox(width: 10,),
          Text(option,style: TextStyle(
              color: Colors.black54,
              fontSize: 17,
              fontWeight: FontWeight.w500
          ),)
        ],
      ),
    );
  }
}
