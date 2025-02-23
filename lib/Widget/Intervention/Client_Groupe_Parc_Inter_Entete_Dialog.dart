import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Entete_DialogNo.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Equip_Saisie.dart';

// Freq
// Année ....

class Client_Groupe_Parc_Inter_Entete_Dialog {
  static String DescAff = "";
  static String DescAff2 = "";
  static String DescAff3 = "";
  static Param_Saisie param_Saisie= Param_Saisie.Param_SaisieInit();
  Client_Groupe_Parc_Inter_Entete_Dialog();
  static Future<void> Dialogs_Entete(
      BuildContext context, VoidCallback onMaj) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_EnteteDialog(onMaj: onMaj, param_Saisie : param_Saisie),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_EnteteDialog extends StatefulWidget {
  final VoidCallback onMaj;
  final Param_Saisie param_Saisie;

  const Client_Groupe_Parc_Inter_EnteteDialog({Key? key, required this.onMaj, required this.param_Saisie}) : super(key: key);

  @override
  _Client_Groupe_Parc_Inter_EnteteDialogState createState() => _Client_Groupe_Parc_Inter_EnteteDialogState();
}

class _Client_Groupe_Parc_Inter_EnteteDialogState extends State<Client_Groupe_Parc_Inter_EnteteDialog> {
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

  void onMaj() async {
    print("•••••••••• Parent onMaj() Relaod()");
  }
  void AffDesc() {
    DbTools.glfParcs_Desc.forEach((element2) async {
      print(" DbTools.glfParcs_Desc ${element2.toMap()}");
    });



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

    print("RETOUR ${Srv_DbTools.FAB_Lib} ${Srv_DbTools.PRS_Lib} ${Srv_DbTools.CLF_Lib} ${Srv_DbTools.PDT_Lib} ${Srv_DbTools.POIDS_Lib} ${Srv_DbTools.GAM_Lib} ");

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
              DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
              print(" ELSE ${element.Param_Saisie_ID } ${element2.ParcsDesc_Lib} ${element2.toMap()}");
            }
          });
        }
      }
    });

    print(" AffDesc()  $DescAff");


    DescAff2 = "";
    listparamSaisieTmp.sort(Srv_DbTools.affL2SortComparison);
    listparamSaisieTmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L2) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
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

    Srv_DbTools.ListParam_Saisie_Base.sort(Srv_DbTools.affSortComparison);
    Srv_DbTools.ListParam_Saisie_Base.forEach((element) async {
      print("ListParam_Saisie_Base  ${element.Param_Saisie_ID}");
      if (element.Param_Saisie_Controle.compareTo("Group") != 0) {
        if (ListChamps.contains(element.Param_Saisie_ID))
        {
          print("Champs  DESC Entete ${element.Param_Saisie_ID}");
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      }
    });

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

  Widget RowSaisie(Param_Saisie paramSaisie, double LargeurCol,
      double LargeurCol2, double H2) {
//    print("RowSaisie A DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");
//    print("RowSaisie A param_Saisie ${param_Saisie.toString()}");

    Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(
        DbTools.gParc_Ent.ParcsId!, paramSaisie.Param_Saisie_ID);


//    print("RowSaisie Base 1 ${wParc_Desc.toString()}");
    if (wparcDesc.ParcsDesc_Type!.compareTo("FREQ") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_FREQ_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_FREQ_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("FREQ");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }

    if (wparcDesc.ParcsDesc_Type!.compareTo("ANN") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_ANN_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_ANN_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("ANN");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }

    if (wparcDesc.ParcsDesc_Type!.compareTo("AFAB") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_FAB_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_FAB_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("AFAB");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }
    
    
    if (wparcDesc.ParcsDesc_Type!.compareTo("NIV") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_NIV_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_NIV_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("NIV");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }
    if (wparcDesc.ParcsDesc_Type!.compareTo("ZNE") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_ZNE_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_ZNE_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("ZNE");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }
    if (wparcDesc.ParcsDesc_Type!.compareTo("EMP") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_EMP_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_EMP_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("EMP");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }
    if (wparcDesc.ParcsDesc_Type!.compareTo("LOT") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_LOT_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_LOT_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("LOT");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }

    if (wparcDesc.ParcsDesc_Type!.compareTo("SERIE") == 0) {
      wparcDesc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_SERIE_Id;
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_SERIE_Label;
      if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("SERIE");
        for (var element in Srv_DbTools.ListParam_Saisie_Param) {
          if (element.Param_Saisie_Param_Init) {
            wparcDesc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        }
      }
    }


    if (wparcDesc.ParcsDesc_Type!.compareTo("SPEC") == 0) {
      wparcDesc.ParcsDesc_Id = "";
      wparcDesc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_NoSpec!;
    }


    if (wparcDesc.ParcsDesc_Lib!.isEmpty) wparcDesc.ParcsDesc_Lib = "---";


//       print("RowSaisie Base 2 ${wParc_Desc.toString()}");

    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        print("onTap >>>>>>>>>>>>> BBBBB ${wparcDesc.toString()} ${wparcDesc.ParcsDesc_Lib}");

        if(wparcDesc.ParcsDesc_Type == "SPEC") {
          await Client_Groupe_Parc_Inter_Entete_DialogNo.Dialogs_Entete(context, onMaj);
        } else {
          await Client_Groupe_Parc_Inter_Equip_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie, wparcDesc);
        }

        if (wparcDesc.ParcsDesc_Type!.compareTo("FREQ") == 0) {
          DbTools.gParc_Ent.Parcs_FREQ_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_FREQ_Label = wparcDesc.ParcsDesc_Lib;
        }

        if (wparcDesc.ParcsDesc_Type!.compareTo("ANN") == 0) {
          DbTools.gParc_Ent.Parcs_ANN_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_ANN_Label = wparcDesc.ParcsDesc_Lib;
        }

        if (wparcDesc.ParcsDesc_Type!.compareTo("AFAB") == 0) {
          DbTools.gParc_Ent.Parcs_FAB_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_FAB_Label = wparcDesc.ParcsDesc_Lib;
        }

        if (wparcDesc.ParcsDesc_Type!.compareTo("NIV") == 0) {
          DbTools.gParc_Ent.Parcs_NIV_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_NIV_Label = wparcDesc.ParcsDesc_Lib;
        }

        if (wparcDesc.ParcsDesc_Type!.compareTo("ZNE") == 0) {
          DbTools.gParc_Ent.Parcs_ZNE_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_ZNE_Label = wparcDesc.ParcsDesc_Lib;
        }

        if (wparcDesc.ParcsDesc_Type!.compareTo("EMP") == 0) {
          DbTools.gParc_Ent.Parcs_EMP_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_EMP_Label = wparcDesc.ParcsDesc_Lib;
        }
        if (wparcDesc.ParcsDesc_Type!.compareTo("LOT") == 0) {
          DbTools.gParc_Ent.Parcs_LOT_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_LOT_Label = wparcDesc.ParcsDesc_Lib;
        }
        if (wparcDesc.ParcsDesc_Type!.compareTo("SERIE") == 0) {
          DbTools.gParc_Ent.Parcs_SERIE_Id = wparcDesc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_SERIE_Label = wparcDesc.ParcsDesc_Lib;
        }

        print("RowSaisie Retour ${wparcDesc.toString()}");
        print("RowSaisie Retour DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");

        print(" updateParc_Ent A");
        await DbTools.updateParc_Ent(DbTools.gParc_Ent);
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
