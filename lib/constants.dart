import 'package:flutter/material.dart';


var appBarColor = Color(0xff172437);
var homePageBackgroundColor = Color(0xffefefef);
var productBorderColor = Color(0xffeeeeee);
var footerTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12
);

var kBrandNameTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.w500
);

var kActualPriceTextStyle = TextStyle(
  color: Colors.green,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

const kMrpTextStyle = TextStyle(
  color: Colors.black38,
  decoration: TextDecoration.lineThrough,
  fontSize: 16,
);
const kDiscountTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 15,
);

const kDescriptionTextStyle = TextStyle(
  color: Colors.black54,
);

const authority = "city-super-market.herokuapp.com";

var kIconBrandNameTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 16
);

var kIconActualPriceTextStyle =TextStyle(
  fontSize: 18,
  color: Colors.green,
);

const kIconMrpTextStyle = TextStyle(
  color: Colors.black38,
  decoration: TextDecoration.lineThrough,
  fontSize: 16,
);
const kIconDiscountTextStyle = TextStyle(
    color: Colors.black38,
    decoration:TextDecoration.lineThrough
);

const kIconDescriptionTextStyle = TextStyle(
  color: Colors.black54,
);

const kLoginTitleTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

var kCartEmptyTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 35,
);

var kCartEmptyMsgTextStyle = TextStyle(
  color: Colors.black54,
);

var kCustomTextField = TextField(
    style: TextStyle(fontSize: 15),
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
        border:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
        hintText: "",
        focusedBorder:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.all(Radius.zero)),
        focusColor: Colors.black26
    ));

var kCartMissingCartItemsMsgTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 25,
);

var kPriceDetialsTextStyle = TextStyle(
  fontWeight: FontWeight.w500
);

var kPriceDiscountTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.green
);