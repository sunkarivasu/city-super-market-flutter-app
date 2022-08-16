import 'dart:convert';

import 'package:city_super_market/constants.dart';
import 'package:city_super_market/screens/checkOut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:city_super_market/screens/login.dart';
import 'package:city_super_market/globals.dart' as globals;

class CartPage extends StatefulWidget {
  // final String userId;

  // const CartPage({required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var cartItems = [];
  num totalPrice = 0;
  num totalDiscount = 0;
  num totalAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() {
    if (globals.User.getCurrentUser()['user'] != null) {
      //fetching cartItems
      get(Uri.https(authority,
              "users/cartItems/${globals.User.getCurrentUser()['user']['_id']}"))
          .then((res) {
        print(res.body);
        setState(() {
          cartItems = jsonDecode(res.body);
        });
        caluclatePrice();
      });
    }
  }

  void caluclatePrice()
  {
    num price = 0;
    num discount = 0;
    for(Map<String,dynamic> product in cartItems)
      {
        int p = product['price']*product['orderQuantity'];
        price += product['price']*product['orderQuantity'];

        p = product['discount'];
        discount += ((product['discount'])/100)*product['price']*product['orderQuantity'];
        print("discount");
        print(discount);
      }
    setState(() {
        totalAmount = price - discount;
        totalPrice = price;
        totalDiscount = discount;
    });
    print(totalDiscount);
    print(totalPrice);
    print(totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    // fetchCartItems();
    return Container(
        color: homePageBackgroundColor,
        child: globals.User.getCurrentUser()['user'] != null
            ? cartItems.length != 0
                ? Container(
                    color: homePageBackgroundColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: GridView.count(
                                crossAxisCount: 1,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.43,
                                children:
                                    List.generate(cartItems.length, (index) {
                                  print(cartItems[index]['orderQuantity']);
                                  return Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(top: 5),
                                    child: StaggeredGrid
                                        .count(crossAxisCount: 2, children: [
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1.1,
                                        child: Column(
                                          children: [
                                            // Image(image: NetworkImage(cartItems[index]['image'])) ,
                                            Image(
                                                image: NetworkImage(
                                                    cartItems[index]['image']),
                                                width: 250,
                                                height: 150),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                  child: TextButton(
                                                    onPressed: cartItems[index][
                                                                'orderQuantity'] <=
                                                            9
                                                        ? () {
                                                            var userId = globals
                                                                        .User
                                                                    .getCurrentUser()[
                                                                'user']['_id'];
                                                            var productId =
                                                                cartItems[index]
                                                                    ['_id'];
                                                            post(
                                                                Uri.https(
                                                                    authority,
                                                                    "users/increaseQuantity"),
                                                                headers: <
                                                                    String,
                                                                    String>{
                                                                  'Content-Type':
                                                                      'application/json; charset=UTF-8',
                                                                },
                                                                body:
                                                                    jsonEncode(<
                                                                        String,
                                                                        String>{
                                                                  "userId":
                                                                      userId,
                                                                  "productId":
                                                                      productId
                                                                })).then((res) {
                                                              print(res.body);
                                                              fetchCartItems();
                                                            });
                                                          }
                                                        : null,
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            homePageBackgroundColor,
                                                        primary: Colors.black,
                                                        shape: CircleBorder(),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        elevation: 2.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                SizedBox(
                                                    height: 30,
                                                    width: 40,
                                                    child: TextFormField(
                                                      key: Key(cartItems[index]
                                                              ['orderQuantity']
                                                          .toString()),
                                                      readOnly: true,
                                                      initialValue: cartItems[
                                                                  index]
                                                              ['orderQuantity']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 0),
                                                          border: OutlineInputBorder(
                                                              gapPadding: 0,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .zero)),
                                                          hintText: "",
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  gapPadding: 0,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius
                                                                              .zero)),
                                                          focusColor:
                                                              Colors.black26),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                    // CustomTextField(
                                                    //   label: "",
                                                    //   readOnly: true,
                                                    //   initialValue: cartItems[index]['orderQuantity'].toString(),
                                                    // ),
                                                    ),
                                                SizedBox(width: 5),
                                                SizedBox(
                                                  width: 30,
                                                  child: TextButton(
                                                    onPressed: cartItems[index][
                                                                'orderQuantity'] >
                                                            1
                                                        ? () {
                                                            var userId = globals
                                                                        .User
                                                                    .getCurrentUser()[
                                                                'user']['_id'];
                                                            var productId =
                                                                cartItems[index]
                                                                    ['_id'];
                                                            post(
                                                                Uri.https(
                                                                    authority,
                                                                    "users/decreaseQuantity"),
                                                                headers: <
                                                                    String,
                                                                    String>{
                                                                  'Content-Type':
                                                                      'application/json; charset=UTF-8',
                                                                },
                                                                body:
                                                                    jsonEncode(<
                                                                        String,
                                                                        String>{
                                                                  "userId":
                                                                      userId,
                                                                  "productId":
                                                                      productId
                                                                })).then((res) {
                                                              print(res.body);
                                                              fetchCartItems();
                                                            });
                                                          }
                                                        : null,
                                                    // elevation: 2.0,
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            homePageBackgroundColor,
                                                        primary: Colors.black,
                                                        shape: CircleBorder(),
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        elevation: 2.0),
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                                  cartItems[index]['brand'],
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
                                                      "₹ ${(((100 - cartItems[index]['discount']) / 100) * cartItems[index]['price']).toInt()}",
                                                      style:
                                                          kIconActualPriceTextStyle,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      // child: Text("₹ ${cartItems[index]['price']}", style: kIconMrpTextStyle,),
                                                      child: Text(
                                                        "₹ ${cartItems[index]['price']}",
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
                                                  cartItems[index]
                                                      ['description'],
                                                  style:
                                                      kIconDescriptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          )),
                                      StaggeredGridTile.count(
                                          crossAxisCellCount: 2,
                                          mainAxisCellCount: 1,
                                          child: Column(
                                            children: [
                                              Divider(
                                                height: 1,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  post(Uri.https(authority,
                                                          "users/removeFromCart/${globals.User.getCurrentUser()['user']['_id']}/${cartItems[index]['_id']}"))
                                                      .then((res) {
                                                    print(res.body);
                                                    fetchCartItems();
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 30)),
                                              ),
                                            ],
                                          ))
                                    ]),
                                  );
                                })),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.fromLTRB(30, 10, 30,0),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Price Details",textAlign: TextAlign.center,),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text("Price",style: kPriceDetialsTextStyle,), Text(totalPrice.toString(),style: kPriceDetialsTextStyle,)],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text("Discount",style: kPriceDetialsTextStyle,), Text("-${totalDiscount.toString()}",style:kPriceDiscountTextStyle)],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text("Total Amount",style: kPriceDetialsTextStyle,), Text(totalAmount.toString(),style: kPriceDetialsTextStyle,)],
                              ),
                              Divider(),
                              TextButton(onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) => CheckOutPage(products: cartItems)));
                              },
                                child:Text("Place Order",style: kPriceDetialsTextStyle,) ,
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 13)
                                ),
                              )],
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    child: (Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Empty!",
                          style: kCartEmptyTextStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No Items added to Your Cart",
                          style: kCartEmptyMsgTextStyle,
                        ),
                      ],
                    )),
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Missing Cart Items?",
                    style: kCartMissingCartItemsMsgTextStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Login to see the items you added previously",
                    style: kCartEmptyMsgTextStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      // Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: appBarColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ));
  }
}

// GridView CartView = GridView.count(
//     crossAxisCount: 1,
//     mainAxisSpacing: 2,
//     childAspectRatio: 2.0,
//     children: List.generate(5, (index) {
//       return Container(
//         child: StaggeredGrid.count(crossAxisCount: 2, children: [
//           StaggeredGridTile.count(
//             crossAxisCellCount: 1,
//             mainAxisCellCount: 1,
//             child: Column(
//               children: [
//                 // Image(image: NetworkImage(cartItems[index]['image'])) ,
//                 Image(
//                     image: NetworkImage(
//                         "https://firebasestorage.googleapis.com/v0/b/city-super-market.appspot.com/o/Beautyperfumesaxe%2Fimage?alt=media&token=8c680d62-d000-412e-9f63-5d64ef46cdc2"),
//                     width: 200,
//                     height: 150),
//                 Row(
//                   children: [
//                     IconButton(onPressed: () {}, icon: Icon(Icons.add)),
//                     // TextField(),
//                     IconButton(onPressed: () {}, icon: Icon(Icons.add)),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           StaggeredGridTile.count(
//               crossAxisCellCount: 1,
//               mainAxisCellCount: 1,
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 5,
//                     ),
//                     // Text(cartItems[index]['brand'],
//                     Text(
//                       "xyz",
//                       style: kIconBrandNameTextStyle,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         // Text("₹ ${(((100-cartItems[index]['discount'])/100)*cartItems[index]['price']).toInt()}",style: kIconActualPriceTextStyle,),
//                         Text(
//                           "₹ 34",
//                           style: kIconActualPriceTextStyle,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           // child: Text("₹ ${cartItems[index]['price']}", style: kIconMrpTextStyle,),
//                           child: Text(
//                             "₹ 34",
//                             style: kIconMrpTextStyle,
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     // Text(cartItems[index]['description'],
//                     Text(
//                       'description',
//                       style: kIconDescriptionTextStyle,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                   ],
//                 ),
//               )),
//         ]),
//       );
//     }));
