import 'dart:convert';
import 'package:city_super_market/constants.dart';
import 'package:city_super_market/screens/categoryProducts.dart';
import 'package:city_super_market/screens/productDetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_super_market/main.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:city_super_market/globals.dart' as globals;
import 'package:city_super_market/arguments.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Widget> scrollableComponents = [
    CarosuelWidget(),
  ];

  List categories = [];
  List categoryTopItems = [];

  void appendAllComponents()
  {
    for(List categoryTopItem in categoryTopItems)
      {
        print("categoryTopitem");
        print(categoryTopItem[0]['category']);
        scrollableComponents.add(CategoryProductsWidgets(categoryData: categoryTopItem));
      }
    // scrollableComponents.add(Footer());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(Provider.of<User>(context).currentUser);

    // print(globals.User.getCurrentUser()['user']['_id']);
    //fetching categories
    get(Uri.https(authority, "categories"))
    .then((res)
    {
      var response = jsonDecode(res.body);
      setState((){
        categories = response;
      });
    });

    //fetching top 6 products from all categories
    get(Uri.https(authority, "products/noOfProducts/6"))
    .then((res) {
      print(res.body);
      setState((){
        categoryTopItems = jsonDecode(res.body);
      });
      // print(categoryTopItems);
      appendAllComponents();
    });


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: homePageBackgroundColor,
        child:Column(
          children: [
            CategoryWidget(categories: categories,),
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: scrollableComponents.length,
              itemBuilder: (BuildContext context,int index)
              {
                return scrollableComponents[index];
              },
            ),
          )
          ]
        )
      );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                  children:[
                    Text("CONTACT US",style: footerTextStyle,),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email,color: Colors.white,),
                        Text(" csm@gmail.com",style: footerTextStyle,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone,color: Colors.white,),
                        Text(" 9059186409      ",style: footerTextStyle,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone,color: Colors.white,),
                        Text(" 9951539257      ",style: footerTextStyle,),
                      ],
                    ),
                  ]
              ),
              Column(
                //social
                  children:[
                    Text("SOCIAL",style: footerTextStyle,),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.facebook,color: Colors.white,),
                        Text(" Facebook",style: footerTextStyle,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.twitter,color: Colors.white,),
                        Text(" Twitter    ",style: footerTextStyle,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.instagram,color: Colors.white,),
                        Text(" Instagram",style: footerTextStyle,),
                      ],
                    ),
                  ]
              ),
            ],
          ),
          //contact us
          SizedBox(height: 20),

          Center(child: Text("Rajam | Dolapeta | Palakonda | Vijayanagaram | Ponduru | Srikakulam",textAlign: TextAlign.center,style: footerTextStyle)),
          SizedBox(height: 10,),
          Text('© 2022 City Super Market',style: footerTextStyle,)
        ],
      ),
    );
  }
}


class CarosuelWidget extends StatelessWidget {
  const CarosuelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: homePageBackgroundColor,
      child: CarouselSlider(
        options: CarouselOptions(height: 160.0,
            autoPlay: true,autoPlayAnimationDuration: Duration(seconds: 2)),
        items: [1,2,3].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Image(image:AssetImage("images/carousel$i.jpg"))
              );
            },
          );
        }).toList(),
      ),
    );
  }
}


class CategoryWidget extends StatelessWidget {

  final categories;

  CategoryWidget({required this.categories});



  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      height: 115,
      color: Colors.white,
      child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context,int index){
                print(categories[index]['categoryName']);
                return CategoryIcon(name: categories[index]['categoryName'], image: categories[index]['categoryImage']);
              },
              scrollDirection: Axis.horizontal,

            )
    );
  }
}

class CategoryIcon extends StatelessWidget {
  
  String name;
  String image;
  
  CategoryIcon({required this.name,required this.image});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) => CategoryProductsPage(categoryName: name)));
    }, child: Column(
          children: [
            Image(image: NetworkImage(image),
            width: 65,
            height: 70,),
            Text(name,style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 14
            ),)
          ],

        ),);

  }
}

class CategoryItemsList extends StatelessWidget {
  List categoryData;

  CategoryItemsList({required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryData.length,
        itemBuilder: (BuildContext context, int index){
            return ProductIconWidget(id:categoryData[index]['_id'],image: categoryData[index]['image'], name: categoryData[index]['brand'], actualPrice: (categoryData[index]['price']*(100-categoryData[index]['discount'])/100),discount: categoryData[index]['discount'], mrp: categoryData[index]['price'], description: categoryData[index]['description']);
        },
      ),
    );
  }
}

class CategoryProductsWidgets extends StatelessWidget {

  List categoryData;
  CategoryProductsWidgets({required this.categoryData});



  @override
  Widget build(BuildContext context) {

    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0xffeeeeee),
          blurRadius: 2.0),
        ]
      ),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(categoryData[0]['category'],style:
                TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black
                )),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryProductsPage(categoryName: categoryData[0]['category'],)));
                  // print("navigating");
                }, child: Text("VIEW ALL"),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff172437),
                  primary: Colors.white,
                  padding: EdgeInsets.all(11)
                ),)
              ],
            ),
          ),
          SizedBox(height:1,
          child: Container(
            color: Color(0xffeeeeee),
          ),),
          CategoryItemsList(categoryData:categoryData),
        ],
      ),
    );
  }
}


class ProductIconWidget extends StatelessWidget {

  String id;
  String image;
  String name;
  double actualPrice;
  int mrp;
  int discount;
  String description;


  ProductIconWidget({required this.id,required this.image,required this.name,required this.actualPrice,required this.mrp,required this.discount,required this.description});

  @override
  Widget build(BuildContext context) {

    print("discount");
    print(discount);

    return TextButton(onPressed: (){
      Navigator.pushNamed(context,"/productDetails",
        arguments:ProductDetailsArguments(productId:id,image: image, brand: name, actualPrice: actualPrice, mrp: mrp, discount: discount, description: description),
      );
    },
        child: Container(
          // width: 115,
          // height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffeeeeee),
              width: 1
            )
          ),
          padding:EdgeInsets.all(5),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image(image:NetworkImage(image),width: 120,height: 120,)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    Text(name,
                    style: kIconBrandNameTextStyle,),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text("₹ ${actualPrice.toInt()}",style: kIconActualPriceTextStyle,),
                        Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Text("₹ $mrp",
                          style: kIconDiscountTextStyle,),
                        )
                      ],
                    ),
                    SizedBox(height: 5,),
                    Text(description,
                    style: kIconDescriptionTextStyle,),
                    SizedBox(height: 5,),
                  ],
                ),
              )
            ],
          )
        ));
  }
}







