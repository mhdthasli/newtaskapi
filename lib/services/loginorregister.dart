import 'package:flutter/cupertino.dart';

import '../login&register/login_page.dart';
import '../login&register/register_page.dart';



class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {


  //initially, show login page

  bool showLoginPage = true;


  // toggle between login and register page

  void togglePages(){

    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPages(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages );
    }
  }
}
