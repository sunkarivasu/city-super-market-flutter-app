import 'dart:convert';
import 'dart:ui';
import 'package:city_super_market/constants.dart';
import 'package:city_super_market/main.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart';
import 'package:city_super_market/globals.dart' as globals;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool loginPage = true;
  final _loginFormKey = GlobalKey<FormState>();
  final _registrationFormKey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  // RegExp name_valid = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
  RegExp name_valid = RegExp(r"^[a-zA-Z]+[a-zA-Z ]*$/gm");

  // Map<String,dynamic> currentUser = {};

  //loginDetails
  Map<String,String> loginDetails = {
    "emailId":"",
    "password":"",
  };

  //registrationDetails
  Map<String,String> registrationDetails = {
    "name":"",
    "emailId":"",
    "password":"",
    "mobile":"",
  };



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(loginPage?"Login":"Register"),
        backgroundColor: appBarColor,
      ),
      backgroundColor: homePageBackgroundColor,
      body: loginPage?Container(
        padding: EdgeInsets.symmetric(vertical: 100,horizontal: 30),
        child: Form(
          key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: getInputDecorationForFormTextField("Email"),
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                      return "Plese enter Email Id";
                  else if (EmailValidator.validate(value) == false)
                    return "Invalid Email";
                  loginDetails = {...loginDetails,"emailId":value};
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                obscureText: true,
                decoration: getInputDecorationForFormTextField("Password"),
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                    return "Plese enter Password";
                  loginDetails = {...loginDetails,"password":value};
                  return null;
                },
              ),
              SizedBox(height: 20,),

              TextButton(
                  onPressed: (){
                    if (_loginFormKey.currentState!.validate()) {
                      post(Uri.https(authority, 'users/login'),headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },body: jsonEncode(<String,String>{
                        ...loginDetails
                      }))
                      .then((res) {
                        var response = jsonDecode(res.body);
                        print(response.runtimeType);
                        if(response['success'] == true)
                          {
                            setState(() {
                              // User().setCurrerntUser(user)
                              // Provider.of<User>(context,listen: false).setCurrerntUser(response);
                              // print(Provider.of<User>(context,listen: false).getCurrentUser());
                              globals.User.setCurrerntUser(response);
                              print(globals.User.getCurrentUser());
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login successfull')),
                            );
                            Navigator.pop(context);

                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid Credentials')),
                            );
                          }
                      });

                    }
                  },
                  child: Text("Login",style: TextStyle(
                color: Colors.white,),
              ),style: TextButton.styleFrom(
                backgroundColor: appBarColor,
                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15)
              ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do\'nt have Account?",textAlign: TextAlign.center,style: TextStyle(
                  ),),
                  TextButton(onPressed: (){
                    setState((){
                      loginPage = false;
                    });
                  }, child: Text("Register"))
                ],
              )
            ],
          ),
        ),
      ):Container(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
        child: Form(
          key:_registrationFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20,),
              TextFormField(
                decoration: getInputDecorationForFormTextField("Name"),
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                    return "Please enter Name";
                  // else if(name_valid.hasMatch(value) == false)
                  //   return 'Name should contain only alphabets';
                  registrationDetails = {...registrationDetails,"name":value};
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: getInputDecorationForFormTextField("Email"),
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                    return "Plese enter Email Id";
                  else if(EmailValidator.validate(value) == false)
                    return 'Invalid Email';
                  registrationDetails = {...registrationDetails,"emailId":value};
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                obscureText: true,
                decoration: getInputDecorationForFormTextField("Password"),
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                    return "Plese enter Password";
                  else if (pass_valid.hasMatch(value) == false)
                    return 'Weak Password';
                  registrationDetails = {...registrationDetails,"password":value};
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                obscureText: true,
                decoration: getInputDecorationForFormTextField("Confirm Password"),
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                    return "Plese Confirm Password";
                  else if(value != registrationDetails['password'])
                    return 'Passwords did not match';
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: getInputDecorationForFormTextField("Mobile Number"),
                validator: (value)
                {
                  if(value == null || value.isEmpty)
                    return "Plese enter Mobile Number";
                  else if (value.length != 10)
                    return 'Please Enter 10 digits Mobile Number';
                  registrationDetails = {...registrationDetails,"mobile":value};
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextButton(
                onPressed: (){
                  if (_registrationFormKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    print(jsonEncode(<String,String>{
                      ...registrationDetails
                    }));
                    post(Uri.http(authority,'users/add',),headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },body: jsonEncode(<String,String>{
                      ...registrationDetails
                    }))
                    .then((res) {
                      var response = jsonDecode(res.body);
                      print(response);
                      String msg = response['msg'];
                      if(response['success'] == true)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Account Created Successfully')),
                          );
                          setState(() {
                            loginPage = true;
                          });
                        }
                      else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("EmailId Already Exists")),
                          );
                        }
                    })
                    .catchError((err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error Occured")),
                      );
                      print(err);
                    });
                  }
                },
                child: Text("Register",style: TextStyle(
                  color: Colors.white,),
                ),style: TextButton.styleFrom(
                  backgroundColor: appBarColor,
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15)
              ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have Account?",textAlign: TextAlign.center,),
                  TextButton(onPressed: (){
                    setState(() {
                      loginPage = true;
                    });
                  }, child: Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  
  InputDecoration getInputDecorationForFormTextField(label)
  {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
      border:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.circular(5)),
      hintText: label,
      focusedBorder:OutlineInputBorder(gapPadding: 0,borderRadius: BorderRadius.circular(5)),
      focusColor: Colors.black26,
    );
  }
}

// class LoginTextField extends StatelessWidget {
//
//   String label;
//   bool isPassword;
//
//   LoginTextField({required this.label,required this.isPassword});
//
//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }

