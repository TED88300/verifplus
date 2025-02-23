import 'dart:async';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';
import 'package:verifplus/Widget/Import_Data.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Import_Menu_Dialog {
  Import_Menu_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Import_MenuDialog(
        onSaisie: onSaisie,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Import_MenuDialog extends StatefulWidget {
  final VoidCallback onSaisie;

  const Import_MenuDialog({
    Key? key,
    required this.onSaisie,
  }) : super(key: key);

  @override
  Import_MenuDialogState createState() => Import_MenuDialogState();
}

class Import_MenuDialogState extends State<Import_MenuDialog> with TickerProviderStateMixin {
  late AnimationController acontroller;
  bool iStrfExp = false;

  
  @override
  void initLib() async {

    return;
  }

  @override
  void initState() {
    acontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    acontroller.repeat(reverse: true);
    acontroller.stop();

    initLib();
    super.initState();
  }

  @override
  void dispose() {
    acontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            children: [
              Text(
                "Import Data Menu",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 900,
          width: MediaQuery.of(context).size.width,

          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),

              Container(
                height: 10,
              ),
              !iStrfExp ? Container() :
              CircularProgressIndicator(
                value: acontroller.value,
                semanticsLabel: 'Circular progress indicator',
              ),
              Container(
                height: 10,
              ),
           Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 25,
              ),

              ElevatedButton(
                onPressed: () async {
                  DbTools.setBoolErrorSync(false);
                  await Import_Data_Dialog.Dialogs_Saisie(context, widget.onSaisie, "Listing");
                  FBroadcast.instance().broadcast("Maj_Planning");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    minimumSize: const Size(400, 100),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: const BorderSide(
                      width: 10,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Import Listing', style: gColors.bodyTitle1_B_W32),
              ),
              Container(
                height: 50,
              ),

              ElevatedButton(
                onPressed: () async {
                  DbTools.setBoolErrorSync(false);
                  await Import_Data_Dialog.Dialogs_Saisie(context, widget.onSaisie, "Param");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    minimumSize: const Size(400, 100),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: const BorderSide(
                      width: 10,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Import Param', style: gColors.bodyTitle1_B_W32),
              ),
              Container(
                height: 50,
              ),

              ElevatedButton(
                onPressed: () async {
                  DbTools.setBoolErrorSync(false);
                  await Import_Data_Dialog.Dialogs_Saisie(context, widget.onSaisie, "NF74");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    minimumSize: const Size(400, 100),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: const BorderSide(
                      width: 10,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Import NF 074', style: gColors.bodyTitle1_B_W32),
              ),
              Container(
                height: 50,
              ),

              ElevatedButton(
                onPressed: () async {
                  List<Parc_Ent> listparcsEnt = await DbTools.getParcs_EntAll();
                  print(" ListParcs_Ent ${listparcsEnt.length}");
                  await DbTools.TrunckParcs_Ent();

                  List<Parc_Desc> listparcDesc = await DbTools.getParcs_DescAll();
                  print(" ListParc_Desc ${listparcDesc.length}");
                  await DbTools.TrunckParcs_Desc();

                  List<Parc_Art> listparcArt = await DbTools.getParcs_ArtTout();
                  print(" ListParc_Art ${listparcArt.length}");
                  await DbTools.TrunckParcs_Art();

                  List<Parc_Img> listparcImgs = await DbTools.getParcs_ImgsTout();
                  print(" ListParc_Imgs ${listparcImgs.length}");
                  await DbTools.TrunckParcs_Imgs();
                },



                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.secondary,
                    minimumSize: const Size(400, 100),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: const BorderSide(
                      width: 10,
                      color: gColors.secondary,
                    )),
                child: Text('Trunck Parc', style: gColors.bodyTitle1_B_W32),
              ),


            ]),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        iStrfExp ? Container() : ElevatedButton(
          child: const Text(
            "OK",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************
}
