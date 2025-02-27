import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Tools/shared_pref.dart';
import 'package:verifplus/Widget/2-home.dart';

enum LoginError {
  PENDING,
  EMAIL_VALIDATE,
  WAITING_CONFIRMATION,
  DISABLE,
  ERROR_USER_NOT_FOUND,
  WRONG_PASSWORD
}

enum AuthStatus { NOT_LOG, SIGNED_IN_PRO, SIGNED_IN_PATIENT }

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void initLib() async {}

  @override
  void initState() {
    super.initState();
    initLib();
    if (DbTools.gTED) {
      emailController.text =   DbTools.gUsername;
      passwordController.text = DbTools.gPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context, designSize: const Size(360, 690));

    var size = MediaQuery.of(context).size;

    print("size W ${size.width} H ${size.height}  ${MediaQuery.of(context).devicePixelRatio}");
    print("size Ratio W ${size.width *MediaQuery.of(context).devicePixelRatio } H ${size.height *MediaQuery.of(context).devicePixelRatio} ");



// VP R : 1,33
    //"601 x 913"
    // W 800.0 H 1232.0

// Emul
//    size W 600.0 H 976.0  1.0
//    size Ratio  W 600.0 H 976.0

    // T5
    // size W 551.7241197874096 H 834.4827311784569  1.4500000476837158
    // size Ratio W 800.0 H 1210.0

    // T5 Std
    // size W 640.0 H 964.0  1.25
    // size Ratio W 800.0 H 1205.0

    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      autofocus: false,
      decoration: const InputDecoration(
        hintText: 'Mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Mot de passe',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );


    final loginButton = SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: ElevatedButton(
        onPressed: () async {
          if (await Srv_DbTools.getUserLogin(emailController.text, passwordController.text)) {
            await SharedPref.setStrKey("username", emailController.text);
            await SharedPref.setStrKey("password", passwordController.text);
            await SharedPref.setBoolKey("IsRememberLogin", true);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()));
          }
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.secondary,
          padding: const EdgeInsets.all(12.0),),
        child: const Text('Login',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final loginbuttonTed = SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () async {
          emailController.text = "daudiert2@wanadoo.fr";
          passwordController.text = "Zzt88300";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.primary,
          padding: const EdgeInsets.all(12),
        ),
        child: const Text('TED',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final loginbuttonGd = SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () async {
          emailController.text = "g.deveza@mondialfeu.fr";
          passwordController.text = "enHEme";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.primary,
          padding: const EdgeInsets.all(12),
        ),
        child: const Text('GD',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final loginbuttonTr = SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () async {
          emailController.text = "Asaf@gmail.com";
          passwordController.text = "Asaf";
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gColors.primary,
          padding: const EdgeInsets.all(12),
        ),
        child: const Text('Asaf',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    //************************************
    return MediaQuery(

      data: MediaQuery.of(context).copyWith(devicePixelRatio: 1.0),
      child:

    Scaffold(
      backgroundColor: gColors.primary,
      body: Container(
        padding: const EdgeInsets.fromLTRB(80.0, 100.0, 80.0, 20.0),
        color: gColors.white,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8.0),
            Image.asset(
              'assets/images/MondialFeu.png',
            ),
            const SizedBox(height: 80.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Outils de vérification ",
                  style: gColors.bodyTitle1_B_P,
                ),
                Text(
                  "Incendie",
                  style: gColors.bodyTitle1_B_S,
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child:
//            Padding(padding: EdgeInsets.fromLTRB(180.0, 0.0, 180.0, 0.0),
//            child:
                  Column(
                children: [
                  const SizedBox(height: 8.0),
                  email,
                  const SizedBox(height: 8.0),
                  password,
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                loginButton,
                const Spacer(),

              ],
            ),

            Row(children: [
              const Spacer(),
              loginbuttonTed,
              const Spacer(),
              loginbuttonGd,
              const Spacer(),
              loginbuttonTr,
              const Spacer(),
            ],),

            const Spacer(),

            const SizedBox(height: 80.0),
            Image.asset(
              'assets/images/AppIco.png',
            ),

            const Spacer(),
            Text(DbTools.gVersion,
                style: const TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ),
    ));
  }

  Future<void> login(
      String emailcontrollerText, String passwordcontrollerText) async {}
}
