import 'dart:convert';

import 'package:city_super_market/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:city_super_market/globals.dart' as globals;

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  List products = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get(Uri.https(authority, "orders/getOrdersByUserId/${globals.User.getCurrentUser()['user']['_id']}"))
    .then((res){
      print(res.body);
      var decodedResponse = jsonDecode(res.body);
      setState((){
        products = decodedResponse;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("My Orders"),
      ),
      backgroundColor: homePageBackgroundColor,
      body: Container(
        // padding: EdgeInsets.all(10),
        color: Colors.white,
          child:GridView.count(
            crossAxisCount: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 1,
            childAspectRatio: 1.5,
            children: List.generate(products.length, (index)
            {
              return StaggeredGrid
                  .count(crossAxisCount: 2, children: [
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.1,
                  child: Column(
                    children: [
                      // Image(image: NetworkImage(cartItems[index]['image'])) ,
                      Image(
                          image: NetworkImage(
                              products[products.length-1-index]['productDetails'][0]['image']),
                          width: 250,
                          height: 150),
                    ],
                  ),
                ),
                StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1.1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 2, horizontal: 15),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          // Text(cartItems[index]['brand'],
                          Text(
                            products[products.length-1-index]['productDetails'][0]['brand'],
                            style:
                            kIconBrandNameTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              // Text("₹ ${(((100-cartItems[index]['discount'])/100)*cartItems[index]['price']).toInt()}",style: kIconActualPriceTextStyle,),
                              Text(
                                "₹ ${(((100 - products[products.length-1-index]['productDetails'][0]['discount']) / 100) * products[index]['productDetails'][0]['price']).toInt()}",
                                style:
                                kIconActualPriceTextStyle,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 10),
                                // child: Text("₹ ${cartItems[index]['price']}", style: kIconMrpTextStyle,),
                                child: Text(
                                  "₹ ${products[products.length-1-index]['productDetails'][0]['price']}",
                                  style:
                                  kIconMrpTextStyle,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Text(cartItems[index]['description'],
                          Text(
                            products[products.length-1-index]['productDetails'][0]
                            ['description'],
                            style:
                            kIconDescriptionTextStyle,
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text(
                            "Yet to be delivered",
                            style: TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    )),
                StaggeredGridTile.count(crossAxisCellCount: 2, mainAxisCellCount: 0.001, child: Divider())
              ]);
            }),
          )
      ),
    );
  }
}
