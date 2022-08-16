import 'dart:convert';
import 'package:city_super_market/screens/productDetails.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:city_super_market/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:city_super_market/constants.dart';
import 'package:city_super_market/globals.dart' as globals;

class CategoryProductsPage extends StatefulWidget {

  String categoryName;

  CategoryProductsPage({required this.categoryName});


  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {

  List products = [];

  @override
  void initState() {
    // TODO: implement initState
    get(Uri.https(authority,"products/category/${widget.categoryName}"))
        .then((res) {
        print(res.body);
        setState(() {
          products = jsonDecode(res.body);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text(widget.categoryName),
          backgroundColor: appBarColor,
        ),
        backgroundColor: Colors.white,
        body: Container(
          // padding: EdgeInsets.all(10),
          child:GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 0.59,
            children: List.generate(products.length, (index)
            {
              return Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: productBorderColor,width: 0.5)
                ),
                child:TextButton(
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ProductDetailsPage(productId:products[index]['_id'],image: products[index]['image'], brand: products[index]['brand'], actualPrice: (((100-products[index]['discount'])/100)*products[index]['price']), mrp: products[index]['price'], discount: products[index]['discount'], description: products[index]['description'])));
                  },
                    style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image(image: NetworkImage(products[index]['image']),height: 200,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(height: 5,),
                      Text(products[index]['brand'],
                        style: kIconBrandNameTextStyle,),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("₹ ${(((100-products[index]['discount'])/100)*products[index]['price']).toInt()}",style: kIconActualPriceTextStyle,),
                          Padding(
                            padding: const EdgeInsets.only(left:10),
                            child: Text("₹ ${products[index]['price']}",
                              style: kIconMrpTextStyle,),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(products[index]['description'],
                        style: kIconDescriptionTextStyle,),
                      SizedBox(height: 5,),
                      ],
                      ),
                    )

                  ],
                )
              ));
            }),
          )
        ),
      );
  }
}
