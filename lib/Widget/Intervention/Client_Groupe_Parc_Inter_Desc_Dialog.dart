import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Equip_Saisie.dart';

// Freq
// Année ....

class Client_Groupe_Parc_Inter_Desc_Dialog {
  static String DescAff = "";
  static String DescAff2 = "";
  static String DescAff3 = "";
  static Param_Saisie param_Saisie= Param_Saisie.Param_SaisieInit();
  Client_Groupe_Parc_Inter_Desc_Dialog();
  static Future<void> Dialogs_Desc(
      BuildContext context, VoidCallback onMaj, Param_Saisie paramSaisie) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_DescDialog(onMaj: onMaj, param_Saisie : paramSaisie),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_DescDialog extends StatefulWidget {
  final VoidCallback onMaj;
  final Param_Saisie param_Saisie;

  const Client_Groupe_Parc_Inter_DescDialog({Key? key, required this.onMaj, required this.param_Saisie}) : super(key: key);

  @override
  _Client_Groupe_Parc_Inter_DescDialogState createState() => _Client_Groupe_Parc_Inter_DescDialogState();
}

class _Client_Groupe_Parc_Inter_DescDialogState extends State<Client_Groupe_Parc_Inter_DescDialog> {
  Future Reload() async {
    AffDesc();

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    print("_EnteteDialog initState param_Saisie ${widget.param_Saisie.Param_Saisie_ID}");
    initLib();
  }

  String DescAff = "N° 11 : Eau + Additif 6l PA portatif 2018";
  String DescAff2 = "RDC - Bâtiment A1 - Bureau";
  String DescAff3 = "";


  void AffDesc() {
    DbTools.glfParcs_Desc.forEach((paramSaisie) async {
      switch (paramSaisie.ParcsDesc_Type) {
        case "DESC":
        case "DESC2":
          Srv_DbTools.DESC_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "FAB":
        case "FAB2":
          Srv_DbTools.FAB_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "TYPE":
        case "TYPE2":
          Srv_DbTools.TYPE_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;


        case "ARM":
          Srv_DbTools.ARM_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "INOX":
          Srv_DbTools.INOX_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;

        case "DIAM":
          Srv_DbTools.DIAM_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "LONG":
          Srv_DbTools.LONG_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "DIF":
          Srv_DbTools.DIF_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "DISP":
          Srv_DbTools.DISP_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "PREM":
          Srv_DbTools.PREM_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;



        case "PRS":
          Srv_DbTools.PRS_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "CLF":
          Srv_DbTools.CLF_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "MOB":
          Srv_DbTools.MOB_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "PDT":
          Srv_DbTools.PDT_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "POIDS":
          Srv_DbTools.POIDS_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "GAM":
          Srv_DbTools.GAM_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
      }
    });

    print("RETOUR ");

    List<Param_Saisie> listparamSaisieTmp = [];
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie);
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie_Base);

    DescAff = "N°${DbTools.gParc_Ent.Parcs_order} ${DbTools.gParc_Ent.Parcs_NoSpec!.isEmpty ? '': DbTools.gParc_Ent.Parcs_NoSpec}";

//    PDT POIDS PRS MOB ANN FAB

    listparamSaisieTmp.sort(Srv_DbTools.affL1SortComparison);
    listparamSaisieTmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L1) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DbTools.gDateMS = DbTools.gParc_Ent.Parcs_ANN_Label!;
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {
          DbTools.glfParcs_Desc.forEach((element2) async {
            if (element.Param_Saisie_ID == element2.ParcsDesc_Type) {
//              print("AffDesc() ParcsDesc_Type ${element2.ParcsDesc_Type}");
              DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
            }
          });
        }
      }
    });

    DescAff2 = "";
    listparamSaisieTmp.sort(Srv_DbTools.affL2SortComparison);
    listparamSaisieTmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L2) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DbTools.gDateMS = DbTools.gParc_Ent.Parcs_ANN_Label!;

          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {
          DbTools.glfParcs_Desc.forEach((element2) async {
            if (element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
            }
          });
        }
      }
    });

    DescAff3 = "${Srv_DbTools.GAM_Lib}  ${Srv_DbTools.gArticle_EbpEnt.Article_descriptionCommercialeEnClair}";


  }

  void onSaisie() async {
    widget.onMaj();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    Ctrl = buildDesc(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,
      surfaceTintColor: Colors.white,
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
                DescAff,
                style: gColors.bodyTitle1_B_G_20,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 10,
            ),
            SizedBox(
              width: 500,
              child: Text(
                DescAff2,
                style: gColors.bodyTitle1_N_Gr,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 500,
              child: Text(
                DescAff3,
                style: gColors.bodyTitle1_N_Gr,
                textAlign: TextAlign.center,
              ),
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
                        Ctrl,
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

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 440,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  @override
  Widget buildDesc(BuildContext context) {
    double LargeurCol = 220;
    double LargeurCol2 = 340;
    double H2 = 4;

    List<Widget> RowSaisies = [];

    String ListChamps = "";
    Srv_DbTools.getParam_ParamMemDet("Param_Div", widget.param_Saisie.Param_Saisie_ID);

    if (Srv_DbTools.ListParam_Param.isNotEmpty)
    {
       ListChamps = Srv_DbTools.ListParam_Param[0].Param_Param_Text;
      print("ListChamps $ListChamps");
    }
    else
    {
      print("ListChamps VIDE  ${widget.param_Saisie.Param_Saisie_ID}");
    }



    Srv_DbTools.ListParam_Saisie.sort(Srv_DbTools.affSortComparison);
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];



      if (element.Param_Saisie_Controle.compareTo("Group") != 0) {
        if (ListChamps.contains(element.Param_Saisie_ID))
        {
          print("Champs  Desc Dialog ${element.Param_Saisie_ID}");
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      }
    }

    return SizedBox(
      width: 560,
      height: 310,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        color: gColors.greyLight,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: RowSaisies.length,
          itemBuilder: (context, index) {
            return RowSaisies[index];
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            color: gColors.greyDark,
          ),
        ),
      ),
    );
  }

  Widget RowSaisie(Param_Saisie paramSaisie, double LargeurCol, double LargeurCol2, double H2) {
    Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, paramSaisie.Param_Saisie_ID);
    print(" RowSaisie A DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()} ${wparcDesc.ParcsDesc_Lib}");
    print(" RowSaisie A wParc_Desc ${wparcDesc.toString()}");


    if (wparcDesc.ParcsDesc_Lib!.isEmpty) wparcDesc.ParcsDesc_Lib = "---";
    //   print("RowSaisie Base 2 ${wParc_Desc.toString()}");

    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        print("••••••• RowSaisie Group > ${wparcDesc.toString()} ");
        await Client_Groupe_Parc_Inter_Equip_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie, wparcDesc);
        print("••••••• RowSaisie Group < ${wparcDesc.toString()} ${wparcDesc.ParcsDesc_Lib}");


         AffDesc();
        onSaisie();

        setState(() {});
      },
      child: Row(
        children: [
          Container(
            width: LargeurCol,
            height: 20,
            padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              "    ${paramSaisie.Param_Saisie_Label}",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          BtnCard("${wparcDesc.ParcsDesc_Lib} >", paramSaisie, wparcDesc,
              LargeurCol2),
        ],
      ),
    );
  }

  Widget BtnCard(String? wText, Param_Saisie paramSaisie, Parc_Desc wparcDesc,
      double LargeurCol2) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: LargeurCol2,
      height: 31,
      child: Card(
        color: gColors.greyLight,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              wText!,
              textAlign: TextAlign.center,
              style: gColors.bodyTitle1_B_Gr.copyWith(
                color:
                    wText.contains("---") ? Colors.black : gColors.primaryGreen,
              ),
            )
          ],
        ),
      ),
    );
  }
}
