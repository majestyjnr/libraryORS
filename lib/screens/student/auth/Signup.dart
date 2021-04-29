import 'package:LibraryOrientationApp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool obscured = true;
  bool isLoading = false;
  String dropdownValue = '100';
  TextEditingController _firstname = new TextEditingController();
  TextEditingController _lastname = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _department = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _firstname,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Firstname',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _lastname,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Lastname',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.phone_iphone,
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _department,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Department',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.school),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text('Select Level:    '),
                      Spacer(),
                      DropdownButton<String>(
                        value: dropdownValue,
                        items: <String>[
                          '100',
                          '200',
                          '300',
                          '400',
                          '500',
                          '600'
                        ].map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text('Level $value'),
                            );
                          },
                        ).toList(),
                        onChanged: (String newLevel) {
                          setState(() {
                            dropdownValue = newLevel;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: obscured,
                    controller: _password,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (obscured) {
                              obscured = false;
                            } else {
                              obscured = true;
                            }
                          });
                        },
                        icon: Icon(
                          obscured ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      UserCredential user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _email.text,
                        password: _password.text,
                      );

                      if (user != null) {
                        // Get The Current User
                        User userCurrent = FirebaseAuth.instance.currentUser;

                        // Save the user details into the database
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCurrent.uid)
                            .set({
                          'firstName': _firstname.text,
                          'lastName': _lastname.text,
                          'email': _email.text,
                          'phone': _phone.text,
                          'department': _department.text,
                          'level': 'Level $dropdownValue',
                          'role': 'User'
                        });
                        // updateUser.displayName =
                        //     _firstname.text + ' ' + _lastname.text;
                        // userCurrent.updateProfile(updateUser);

                        await prefs.setString(
                          'studentName',
                          _firstname.text + ' ' + _lastname.text,
                        );
                        await prefs.setString(
                          'studentEmail',
                          _email.text,
                        );
                        await prefs.setString(
                          'studentPhone',
                          _phone.text,
                        );
                        await prefs.setString(
                          'studentDepartment',
                          _department.text,
                        );
                        await prefs.setString(
                          'studentLevel',
                          'Level $dropdownValue',
                        );

                        User signInUser = FirebaseAuth.instance.currentUser;
                        signInUser.sendEmailVerification().then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                            builder: (context) {
                              return HomeScreen();
                            },
                          ), (Route<dynamic> route) => false);
                        }).catchError((onError) {
                          print(onError);
                        });
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e);
                      Toast.show(
                        '$e',
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM,
                      );
                      setState(() {
                        isLoading = false;
                      });
                      _email.text = '';
                      _password.text = '';
                    }
                  },
                  child: isLoading
                      ? NutsActivityIndicator(
                          activeColor: Colors.white,
                        )
                      : Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
