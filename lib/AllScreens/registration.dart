import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tnrapp/AllScreens/login.dart';
import 'package:tnrapp/AllScreens/mainscreen.dart';
import 'package:tnrapp/AllScreens/verificationScreen.dart';
import 'package:tnrapp/main.dart';

class RegistrationScreen extends StatelessWidget {
  static  const String idScreen = "registration";

  TextEditingController emailTextEditingController =  TextEditingController();
  TextEditingController passwordTextEditingController =  TextEditingController();
  TextEditingController nameTextEditingController =  TextEditingController();
  TextEditingController phoneTextEditingController=  TextEditingController();
  TextEditingController confirmpasswordTextEditingController =  TextEditingController();
  TextEditingController usernameTextEditingController =  TextEditingController();

  var confirmpass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Positioned(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 20,),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, VerificationScreen.idScreen, (route) => false);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Create New Account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[400],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    TextFormField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      validator: (String value){
                        if(value.isEmpty){
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ), 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 12),
                    TextFormField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.number,
                      validator: (String value){
                        if(value.isEmpty)
                        {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ), 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 12),
                    TextFormField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String value){
                        if(value.isEmpty)
                        {
                          return 'Please enter email address';
                        }
                        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                          return 'Please enter a Valid Email.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ), 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 12,),
                    TextFormField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      validator: (String value){
                        if(value.isEmpty)
                        {
                          return 'Please enter password';
                        }
                        if(value.length < 6){
                          return 'Password must be atleast 6 characters';
                        }
                        return null;
                      },
                      //onChanged: (val) => passwordTextEditingController.text = val,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ), 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    
                    SizedBox(height: 12,),
                    TextFormField(
                      controller: confirmpasswordTextEditingController,
                      obscureText: true,
                      validator: (String value){
                      if(value.isEmpty){
                        return 'Please re-enter password';
                      }
                      else if(confirmpasswordTextEditingController.text != passwordTextEditingController.text){
                        return "Password does not match";
                      }
                      else{
                        return null;
                      }
                      
                      },
                      onChanged: (value) {
                        confirmpass.setConfirmPassword(value);
                      },
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ), 
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 5),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.035,),),
                      CustomButton(
                        label: "Register",
                        primaryColor: Theme.of(context).primaryColor,
                        secondaryColor: Colors.white,
                        onPressed: () {
                          if(nameTextEditingController.text.length < 3){
                            displayToastMessage("Name must be atleast 3 characters.", context);
                          }
                          else if(phoneTextEditingController.text.isEmpty){
                            displayToastMessage("Phone Number si mandatory", context);
                          }
                          else if(phoneTextEditingController.text.length < 11){
                            displayToastMessage("Number is incomplete.", context);
                          }
                          else if(!emailTextEditingController.text.contains("@")){
                            displayToastMessage("Email address is not Valid.", context);
                          }
                          else if(emailTextEditingController.text.isEmpty){
                            displayToastMessage("Email address is empty.", context);
                          }
                          else if(passwordTextEditingController.text.length < 6){
                            displayToastMessage("Password must be atleast 6 characters.", context);
                          }else if(passwordTextEditingController.text != confirmpasswordTextEditingController.text){
                            displayToastMessage("Password does not match.", context);
                          }
                          else{
                            registerNewUser(context);
                          }
                          
                        },
                      ),
                    
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.045,),),
                  ],
                ),
              ),

              DecoratedBox(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(200.0), topRight: Radius.circular(200.0))),
                child: Container(
                  padding: EdgeInsets.only(top: 5, left: 0, right: 0),
                  child: Row(
                      children: <Widget>[
                        Text('Already have an account?',
                            style: TextStyle(fontSize: 15,color: Colors.white)),
                        FlatButton(
                          textColor: Colors.white,
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  alignment: Alignment.bottomCenter,
                ),
                ),

            ],)
          ,),
        ),
      ),
    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditingController.text, 
    password: passwordTextEditingController.text).catchError((errMsg){
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null){
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations, your account has been created.", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }
    else{
      displayToastMessage("New User Account has not been Created.", context);
    }

  }

}

displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}

class CustomButton extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  final String label;
  final Function() onPressed;
  const CustomButton({
    Key key,
    this.primaryColor,
    this.secondaryColor,
    @required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: RaisedButton(
        highlightElevation: 0.0,
        splashColor: secondaryColor,
        highlightColor: primaryColor,
        elevation: 0.0,
        color: primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0), side: BorderSide(color: Colors.white, width: 3)),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

