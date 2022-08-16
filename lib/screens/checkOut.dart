
import 'package:city_super_market/constants.dart';
import 'package:city_super_market/main.dart';
import 'package:city_super_market/screens/home.dart';
import 'package:city_super_market/screens/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import "dart:convert";
import 'package:city_super_market/globals.dart' as globals;


class CheckOutPage extends StatefulWidget {

  var products;


  CheckOutPage({required this.products});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {

  final _checkOutFormKey = GlobalKey<FormState>();

  var orderDetails = {
    "userId":globals.User.getCurrentUser()['user']['_id'],
    "productId":"",
    "amount":0,
    "quantity":1,
    "deliveryAddress":jsonEncode({
      "firstName":"",
      "lastName":"",
      "mobile":"",
      "mandel":"",
      "village":"",
      "doorNumber":"",
      "streetName":"",
      "pinCode":""
    })
  };

  var deliveryAddress =
    {
      "firstName":"",
      "lastName":"",
      "mobile":"",
      "mandel":"",
      "village":"",
      "doorNumber":"",
      "streetName":"",
      "pinCode":""
    };


  void setOrderDetails(String key,String value)
  {
    setState(() {
      orderDetails = {
        ...orderDetails,
        key:value
      };
    });
  }

  void setDeliveryAddressDetails(String key,String value)
  {
    setState(() {
      deliveryAddress = {...deliveryAddress,key:value};
    });
  }

  void placeOrderForAllProducts () async
  {
    int successCount = 0;
    for(Map<String,dynamic> product in widget.products)
      {
        await post(Uri.https(authority, "orders/add"),headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },body: jsonEncode(<String,dynamic>{
          ...orderDetails,
          "deliveryAddress":deliveryAddress,
          "productId":product['_id'],
          "amount":(product['discount']/100*product['price']*product['orderQuantity']),
          "quantity":product['orderQuantity']
        }))
            .then((res) {
          print(res.body);
          if(res.body=="")
          {
            successCount += 1;
          }
        })
            .catchError((err){
              print(err);
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error Occured Please try again')),);
        });
      }
    print("successCount");
    print(successCount);
    if(successCount == widget.products.length)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order Placed successfully')),
        );
        globals.User.setPageNumber(0);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyStatefullWidget()), (route) => false);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Order"),
        backgroundColor: appBarColor,
      ),
      backgroundColor: homePageBackgroundColor,
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: 35,vertical: 60),
        child:
        // Text("Place order screen"),
        Column(
          children: [
            Text("Shipping Address",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,),),
            SizedBox(height: 20,),
            Form(
              key: _checkOutFormKey,
              child: StaggeredGrid.count(crossAxisCount: 6,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 10.0,
                children: [

                StaggeredGridTile.count(crossAxisCellCount: 3, mainAxisCellCount: 0.85,
                    child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return "Enter First Name";
                          setDeliveryAddressDetails("firstName", value);
                          // setState(() {
                          //   orderDetails = {...orderDetails,
                          //     "productId":widget.productId,
                          //   "quantity":widget.quantity.toString(),
                          //   "amount":widget.amount.toString()};
                          // });
                          return null;
                        },
                        // onChanged: (value){
                        //   setOrderDetails("firstName", value);
                        // },
                        style: TextStyle(fontSize: 15),
                        decoration: CustomTextField.getCustomBorderDecoration("First Name"))),
                StaggeredGridTile.count(crossAxisCellCount: 3, mainAxisCellCount: 0.85,
                    child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return "Enter Last Name";
                          setDeliveryAddressDetails("lastName", value);
                          return null;
                        },
                        // onChanged: (value){
                        //   setOrderDetails("lastName", value);
                        // },
                        style: TextStyle(fontSize: 15),
                        decoration: CustomTextField.getCustomBorderDecoration("Last Name"))),
                StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 0.85,
                    child: TextFormField(
                        keyboardType:TextInputType.phone,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return "Plese enter Mobile Number";
                          else if (value.length != 10)
                            return 'Please Enter 10 digits Mobile Number';
                          setDeliveryAddressDetails("mobile", value);
                          return null;
                        },
                        // onChanged: (value){
                        //   setOrderDetails("mobile", value);
                        // },
                        style: TextStyle(fontSize: 15),
                        decoration: CustomTextField.getCustomBorderDecoration("mobile"))),
                StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 0.55, child: Text("Mandel",style:TextStyle(fontWeight: FontWeight.w400,)),),
                StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 0.85, child: CustomDropDown(label: "Mandel",value: "xyz",)),
                  StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 0.55, child: Text("Village/Town",style:TextStyle(fontWeight: FontWeight.w400,)),),
                  StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 0.85, child: CustomDropDown(label: "Village/Town",value: "xyz",)),
                StaggeredGridTile.count(crossAxisCellCount: 2, mainAxisCellCount: 0.85,
                    child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty)
                              return "Enter DoorNo";
                          setDeliveryAddressDetails("doorNumber", value);
                          return null;
                        },
                        // onChanged: (value){
                        //   setDeliveryAddressDetails("doorNumber", value);
                        // },
                        style: TextStyle(fontSize: 15),
                        decoration: CustomTextField.getCustomBorderDecoration("Door No")),),
                StaggeredGridTile.count(crossAxisCellCount: 4, mainAxisCellCount: 0.85,
                    child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return "Enter Street Name";
                          setDeliveryAddressDetails("streetName", value);
                          return null;
                        },
                        // onChanged: (value){
                        //   setDeliveryAddressDetails("streetName", value);
                        // },
                        style: TextStyle(fontSize: 15),
                        decoration: CustomTextField.getCustomBorderDecoration("Street Name")),),
                StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 0.85,
                    child: TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return "Enter Pin Code";
                          else if(value.length!=6)
                            return "Invalid Pin Code";
                          setDeliveryAddressDetails("pinCode", value);
                          return null;
                        },
                        // onChanged: (value){
                        //   setDeliveryAddressDetails("pinCode", value);
                        // },
                        style: TextStyle(fontSize: 15),
                        decoration: CustomTextField.getCustomBorderDecoration("Pin Code"))),
                StaggeredGridTile.count(crossAxisCellCount: 2, mainAxisCellCount: 0.85, child: TextButton(onPressed: ()  {
                  if(_checkOutFormKey.currentState!.validate()) {
                    print("valid form");
                    print(jsonEncode(<String, dynamic>{
                      ...orderDetails,
                      "deliveryAddress": deliveryAddress
                    }));

                    // place order for all products
                    placeOrderForAllProducts();
                  }
                },child: Text("CONFIRM"),style: TextButton.styleFrom(backgroundColor: Color(0xfffa7d09),primary: Colors.white,shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),))),
              ],),
            ),
          ],
        ),
      )
    );
  }
}

class CustomTextField extends StatelessWidget {

  String label;
  TextInputType keyBoardType;
  bool readOnly;
  String initialValue = "";

  CustomTextField({required this.label,this.keyBoardType=TextInputType.text,this.readOnly=false,this.initialValue=""});

  @override
  Widget build(BuildContext context) {
     return TextFormField(
      readOnly: readOnly,
      keyboardType: keyBoardType,
      initialValue: initialValue,
      style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
            border:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
            hintText: label,
            focusedBorder:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
            focusColor: Colors.black26
        ));
  }

  static InputDecoration getCustomBorderDecoration(String label)
  {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
        border:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
        hintText: label,
        focusedBorder:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
        focusColor: Colors.black26
    );
  }
}

class CustomDropDown extends StatelessWidget {

  String label;
  String value;

  CustomDropDown({required this.label,required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(label: value);

  }
}

const customBorderDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
    border:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
    hintText: "First Name",
    focusedBorder:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
    focusColor: Colors.black26
);


// {
// "userId":"6251c93e53b149610db04427",
// "productId":"",
// "amount":0,
// "quantity":1,
// "deliveryAddress":{
// "firstName":"",
// "lastName":"",
// "mobile":"",
// "mandel":"",
// "village":"",
// "doorNumber":"",
// "streetName":"",
// "pinCode":""
// }
// }