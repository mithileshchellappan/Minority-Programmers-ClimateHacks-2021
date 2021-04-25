import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:trashgram/utils/bottom_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> tabs = ["Register", "Sign In"];
  final regForm = GlobalKey<FormState>(), signInForm = GlobalKey<FormState>();
  int tabIndex;
  String username, email, password, signInEmail, signInpassword;
  final RoundedLoadingButtonController _registerBtnController =
          new RoundedLoadingButtonController(),
      _signInBtnController = RoundedLoadingButtonController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFFfadecb),
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .35,
                width: double.infinity,
                child: Image.asset(
                    "assets/login_img.webp",
                    fit: BoxFit.fitWidth),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: buildTabBarView(),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(child: _buildTabBar(context)),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        Container(
            // color: Color(0xFFF191720),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 68.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child:
                          Text("Register to join the community of Trashgram.",
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Form(
                  key: regForm,
                  child: Column(
                    children: List.generate(
                        3,
                        (index) => Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: buildTextFormField(
                                  index == 0
                                      ? "Username"
                                      : (index == 1
                                          ? "Email address"
                                          : "Password"),
                                  "Register"),
                            )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .75,
                    child: RoundedLoadingButton(
                      controller: _registerBtnController,
                      color: Color(0xFFF191720),
                      valueColor: Colors.white,
                      onPressed: () async {
                        final form = regForm.currentState;

                        if (form.validate()) {
                          print("in here");
                          try {
                            final UserCredential user = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                    email: email.trim(), password: password);
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user.user.uid.toString())
                                .set({
                              "email": email,
                              "username": username,
                            });
                            print("done");
                            _registerBtnController.success();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppBottomBar()));
                            // Timer(Duration(seconds: 2), () {
                            //   _registerBtnController.reset();
                            // });
                          } catch (e) {
                            print(e);
                            _registerBtnController.error();
                            // Timer(Duration(seconds: 2), () {
                            // _registerBtnController.reset();
                            // });
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Center(
                                      child: Column(
                                        children: [
                                          Image.asset("assets/error.png"),
                                          Text(
                                            "Something went wrong. Please try again",
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }
                        // _registerBtnController.reset();
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        child: Ink(
                          height: 49,
                          // width: double.infinity,
                          width: MediaQuery.of(context).size.width * .75,
                          decoration: BoxDecoration(
                            color: Color(0xFFF191720),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text("Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            )),
        Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 19.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Let's Sign you In.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold)),
                          Text("Welcome back.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28)),
                          Text("You've been missed!",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28)),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Form(
                      key: signInForm,
                      child: Column(
                        children: List.generate(
                            2,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: buildTextFormField(
                                      index == 0 ? "Email address" : "Password",
                                      "Sign In"),
                                )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: RoundedLoadingButton(
                          controller: _signInBtnController,
                          color: Color(0xFFF191720),
                          valueColor: Colors.white,
                          onPressed: () async {
                            print(signInEmail + signInpassword);
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: signInEmail.trim(),
                                      password: signInpassword);
                              _signInBtnController.success();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AppBottomBar()));
                            } catch (e) {
                              if (e is PlatformException) {
                                if (e.code == "ERROR_USER_NOT_FOUND") {
                                  return alertDialog(
                                      "Your credentials doesn't match our records.Please try Signing up.");
                                }
                                if (e.code == "ERROR_WRONG_PASSWORD") {
                                  return alertDialog(
                                      "You entered the wrong password.");
                                }
                                _signInBtnController.reset();
                              }
                            }
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            child: Ink(
                              height: 49,
                              width: MediaQuery.of(context).size.width * .75,
                              decoration: BoxDecoration(
                                color: Color(0xFFF191720),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text("Sign In",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildTextFormField(String label, String mode) {
    return Container(
        width: MediaQuery.of(context).size.width * .75,
        height: 54,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF313039), width: 3),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (val) {
                print("vali");
                if (mode == "Register") {
                  if (label == "Email address" && !val.contains("@"))
                    return "Enter a valid e-mail";
                  if (label == "Password" && val.length < 5)
                    return "Password must be atleast 5 characters long";
                }
                return null;
              },
              onChanged: (val) {
                if (mode == "Register") {
                  setState(() {
                    if (label == "Username")
                      username = val;
                    else if (label == "Email address")
                      email = val;
                    else
                      password = val;
                  });
                } else {
                  setState(() {
                    if (label == "Email address")
                      signInEmail = val;
                    else
                      signInpassword = val;
                  });
                }
              },
              style: TextStyle(color: Color(0xFFF191720)),
              cursorColor: Colors.black,
              obscureText: label == "Password",
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
                  contentPadding: EdgeInsets.all(8),
                  hintStyle: TextStyle(
                      color: Color(0xFFF7c7d89), fontWeight: FontWeight.bold)),
            )));
  }

  alertDialog(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Center(
              child: Column(
                children: [
                  Image.asset("assets/error.png"),
                  Text(
                    message,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 28,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        color: Color(0xFFF39373f),
        borderRadius: BorderRadius.all(Radius.circular(29)),
      ),
      child: TabBar(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        labelColor: Color(0xFFF191720),
        unselectedLabelColor: Colors.white,
        isScrollable: false,
        tabs: buildTabs(context),
        indicator: RectangularIndicator(
          // color: Colors.white,
          color: Colors.white,

          bottomLeftRadius: 110,
          bottomRightRadius: 110,
          topLeftRadius: 110,
          topRightRadius: 110,
        ),
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
      ),
    );
  }

  List<Widget> buildTabs(BuildContext context) {
    return tabs
        .map((e) => Center(
                child: Text(
              e,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )))
        .toList();
  }
}
