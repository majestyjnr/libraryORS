import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:toast/toast.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool obscured = true;
  bool isLoading = false;
  TextEditingController _passwordNew = new TextEditingController();
  TextEditingController _passwordConfirm = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: obscured,
                  controller: _passwordNew,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('[ ]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    labelText: 'Enter New Password',
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
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: obscured,
                  controller: _passwordConfirm,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('[ ]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    labelText: 'Confirm New Password',
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
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    setState(
                      () {
                        isLoading = true;
                      },
                    );

                    if (_passwordNew.text == _passwordConfirm.text) {
                      User userCurrent = FirebaseAuth.instance.currentUser;
                      userCurrent
                          .updatePassword(_passwordNew.text)
                          .then((value) {
                        Toast.show(
                          'Password changed successfully',
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                        );
                      }).catchError(() {
                        Toast.show(
                          'Password changing failed!',
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                        );
                      });
                    } else {
                      Toast.show(
                        'Passwords do not match!',
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM,
                      );
                    }
                  },
                  child: isLoading
                      ? NutsActivityIndicator(
                          activeColor: Colors.white,
                        )
                      : Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
