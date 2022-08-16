import 'dart:convert';

import 'package:city_super_market/constants.dart';
import 'package:city_super_market/screens/cart.dart';
import 'package:city_super_market/screens/checkOut.dart';
import 'package:city_super_market/screens/home.dart';
import 'package:city_super_market/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:city_super_market/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:city_super_market/main.dart';

class ProductDetailsPage extends StatefulWidget {

  String productId;
  String image;
  String brand;
  double actualPrice;
  int mrp;
  int discount;
  String description;

  ProductDetailsPage({required this.productId,required this.image,required this.brand,required this.actualPrice,required this.mrp,required this.discount,required this.description});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  bool alreadyInCart = false;
  var currentUser = globals.User.getCurrentUser()['user'];

  @override
  void initState() {
    // TODO: implement initState
    // print(Provider.of<User>(context).getCurrentUser()['_id']);
    super.initState();
    if(currentUser!=null)
      {
        //checking already in cart or not
        checkAlreadyInCartOrNot();
      }

  }

  void checkAlreadyInCartOrNot()
  {
    get(Uri.https(authority, 'users/inCartOrNot/${currentUser['_id']}/${widget.productId}'))
        .then((res) {
      // print('response');
      print(res.body);
      var response = res.body;
      setState(() {
        alreadyInCart = res.body=="false"?false:true;
        print(alreadyInCart);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<User>(context,listen: false).getCurrentUser()['user']['_id']);


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand),
        // title: Text(args.brand),
        backgroundColor: appBarColor,
      ),
      backgroundColor: homePageBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xffeeeeee),
                  blurRadius: 25.0),
            ]
        ),
        margin:EdgeInsets.fromLTRB(15, 30, 15, 30),
        padding:EdgeInsets.symmetric(horizontal: 30,vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                color: Colors.white,
                child: Center(child: Image(image: NetworkImage(widget.image),width: 300,height: 300,))),
            SizedBox(height: 10,),
            Text(widget.brand,style:kBrandNameTextStyle),
            // Text(args.brand,style:kBrandNameTextStyle),
            SizedBox(height: 10,),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("₹ ${widget.actualPrice.toInt()}",style:kActualPriceTextStyle),
                // Text("₹ ${args.actualPrice.toInt()}",style:kActualPriceTextStyle),
                SizedBox(width: 10,),
                Text("₹ ${widget.mrp.toString()}",style:kMrpTextStyle)
                // Text("₹ ${args.mrp.toString()}",style:kMrpTextStyle)
              ],
            ),
            SizedBox(height: 10,),
            Text("${((widget.mrp-widget.actualPrice)/widget.mrp*100).toStringAsFixed(0)} % OFF",style: kDiscountTextStyle,),
            // Text("${args.discount} % OFF",style: kDiscountTextStyle,),
            SizedBox(height: 10,),
            Text(widget.description,style:kDescriptionTextStyle),
            // Text(args.description,style:kDescriptionTextStyle),
            SizedBox(height: 10,),
            TextButton(onPressed: globals.User.getCurrentUser()['user']==null?(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }:alreadyInCart?(){
              globals.User.pageNumber = 1;
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyStatefullWidget()));
            }:(){
              post(Uri.https(authority, "users/addToCart/${globals.User.getCurrentUser()['user']['_id']}/${widget.productId}"))
                  .then((res) {
                print(res.body);
                setState(() {
                  alreadyInCart = true;
                });
              });
            },
                style:TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15)
                ),
                child: Text(alreadyInCart?"Go to Cart":"Add to Cart",style: TextStyle(fontSize: 16),)),
            SizedBox(height: 10,),
            TextButton(onPressed: globals.User.getCurrentUser()['user']!=null?(){
              print([{
                "_id":widget.productId,
                "discount":widget.actualPrice/widget.mrp*100,
                "price":widget.mrp,
                "orderQuantity":1
              }]);
              Navigator.push(context,MaterialPageRoute(builder: (context) => CheckOutPage(products:
              [{
                "_id":widget.productId,
                "discount":widget.actualPrice/widget.mrp*100,
                "price":widget.mrp,
                "orderQuantity":1
              }])));
            }:() async{
              print("before await");
              await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              print("await");
              print(globals.User.getCurrentUser()['user']);
              setState((){
                currentUser = globals.User.getCurrentUser()['user'];
              });
              checkAlreadyInCartOrNot();
            },
                style:TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15)
                ),
                child: Text("Buy Now",style: TextStyle(fontSize: 16),))
          ],
        ),
      ),
    );
  }
}

// class ProductDetailsArguments
// {
//   String productId;
//   String image;
//   String brand;
//   double actualPrice;
//   int mrp;
//   int discount;
//   String description;
//
//   ProductDetailsArguments({required this.productId,required this.image,required this.brand,required this.actualPrice,required this.mrp,required this.discount,required this.description});
//
// }
