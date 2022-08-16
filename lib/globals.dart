import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User extends ChangeNotifier
{
  static var currentUser = jsonEncode(<String,dynamic>{
    "user":null
  });

  static var pageNumber = 0;

  static void setCurrerntUser(Map<String,dynamic> user)
  {
    // var decodedUser = jsonDecode(user);
    currentUser = jsonEncode(<String,dynamic>{
      ...user
    });

    print("global value set");
    print(currentUser);
    // notifyListeners();
  }

  static Map<String,dynamic> getCurrentUser()
  {
    return jsonDecode(currentUser);
  }

  static void setPageNumber(int n)
  {
    pageNumber = n;
  }

}


