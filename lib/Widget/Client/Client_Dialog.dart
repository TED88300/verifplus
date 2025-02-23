import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

// Freq
// Année ....

class Client_Dialog {

  Client_Dialog();
  static Future<void> Dialogs_Client(
      BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const ClientDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class ClientDialog extends StatefulWidget {
  const ClientDialog({super.key});



  @override
  _ClientDialogState createState() => _ClientDialogState();
}

class _ClientDialogState extends State<ClientDialog> {
  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    initLib();
  }



  @override
  Widget build(BuildContext context) {

    String wTitle = "${Srv_DbTools.gClient.Client_Nom} / ${Srv_DbTools.gAdresse.Adresse_Nom} / ${Srv_DbTools.gGroupe.Groupe_Nom}";

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
        color: gColors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            Container(
              height: 5,
            ),
            SizedBox(
              width: 500,
              child: Text(
                wTitle,
                style: gColors.bodyTitle1_B_G_20,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 10,
            ),

          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 320,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }


}
