import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
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



    DbTools.glfParcs_Desc.forEach((param_Saisie) async {
      switch (param_Saisie.ParcsDesc_Type) {
        case "DESC":
        case "DESC2":
          Srv_DbTools.DESC_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "FAB":
        case "FAB2":
          Srv_DbTools.FAB_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "TYPE":
        case "TYPE2":
          Srv_DbTools.TYPE_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "PRS":
          Srv_DbTools.PRS_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "CLF":
          Srv_DbTools.CLF_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "MOB":
          Srv_DbTools.MOB_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "PDT":
          Srv_DbTools.PDT_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "POIDS":
          Srv_DbTools.POIDS_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
        case "GAM":
          Srv_DbTools.GAM_Lib = param_Saisie.ParcsDesc_Lib.toString();
          break;
      }
    });

    print("RETOUR ${Srv_DbTools.FAB_Lib} ${Srv_DbTools.PRS_Lib} ${Srv_DbTools.CLF_Lib} ${Srv_DbTools.PDT_Lib} ${Srv_DbTools.POIDS_Lib} ${Srv_DbTools.GAM_Lib} ");

    List<Param_Saisie> ListParam_Saisie_Tmp = [];
    ListParam_Saisie_Tmp.addAll(Srv_DbTools.ListParam_Saisie);
    ListParam_Saisie_Tmp.addAll(Srv_DbTools.ListParam_Saisie_Base);

    DescAff = "N°${DbTools.gParc_Ent.Parcs_order} ${DbTools.gParc_Ent.Parcs_NoSpec!.isEmpty ? '': DbTools.gParc_Ent.Parcs_NoSpec}";

//    PDT POIDS PRS MOB ANN FAB

    ListParam_Saisie_Tmp.sort(Srv_DbTools.affL1SortComparison);
    ListParam_Saisie_Tmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L1) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {


          DbTools.glfParcs_Desc.forEach((element2) async {
            if (element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff = "${DescAff} ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
              print(" ELSE ${element.Param_Saisie_ID } ${element2.ParcsDesc_Lib} ${element2.toMap()}");
            }
          });
        }
      }
    });

    print(" AffDesc()  ${DescAff}");


    DescAff2 = "";
    ListParam_Saisie_Tmp.sort(Srv_DbTools.affL2SortComparison);
    ListParam_Saisie_Tmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L2) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {
          DbTools.glfParcs_Desc.forEach((element2) async {
            if (element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff2 = "${DescAff2} ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
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
            Container(
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
            Container(
              width: 500,
              child: Text(
                DescAff2,
                style: gColors.bodyTitle1_N_Gr,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
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
          new ElevatedButton(
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
          new ElevatedButton(
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

    if (Srv_DbTools.ListParam_Param.length > 0)
    {
       ListChamps = Srv_DbTools.ListParam_Param[0].Param_Param_Text;
      print("ListChamps ${ListChamps}");
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

    return Container(
      width: 560,
      height: 310,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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

  Widget RowSaisie(Param_Saisie param_Saisie, double LargeurCol,
      double LargeurCol2, double H2) {
//    print("RowSaisie A DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");
//    print("RowSaisie A param_Saisie ${param_Saisie.toString()}");

    Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(
        DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);


//    print("RowSaisie Base 1 ${wParc_Desc.toString()}");
    if (wParc_Desc.ParcsDesc_Type!.compareTo("FREQ") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_FREQ_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_FREQ_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("FREQ");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }

    if (wParc_Desc.ParcsDesc_Type!.compareTo("ANN") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_ANN_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_ANN_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("ANN");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }

    if (wParc_Desc.ParcsDesc_Type!.compareTo("AFAB") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_FAB_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_FAB_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("AFAB");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }
    
    
    if (wParc_Desc.ParcsDesc_Type!.compareTo("NIV") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_NIV_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_NIV_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("NIV");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }
    if (wParc_Desc.ParcsDesc_Type!.compareTo("ZNE") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_ZNE_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_ZNE_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("ZNE");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }
    if (wParc_Desc.ParcsDesc_Type!.compareTo("EMP") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_EMP_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_EMP_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("EMP");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }
    if (wParc_Desc.ParcsDesc_Type!.compareTo("LOT") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_LOT_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_LOT_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("LOT");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }

    if (wParc_Desc.ParcsDesc_Type!.compareTo("SERIE") == 0) {
      wParc_Desc.ParcsDesc_Id = DbTools.gParc_Ent.Parcs_SERIE_Id;
      wParc_Desc.ParcsDesc_Lib = DbTools.gParc_Ent.Parcs_SERIE_Label;
      if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
        Srv_DbTools.getParam_Saisie_ParamMem("SERIE");
        Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
          if (element.Param_Saisie_Param_Init) {
            wParc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
          }
        });
      }
    }


    if (wParc_Desc.ParcsDesc_Type!.compareTo("SPEC") == 0) {
      wParc_Desc.ParcsDesc_Id = "";
      wParc_Desc.ParcsDesc_Lib = "${DbTools.gParc_Ent.Parcs_NoSpec!}";
    }


    if (wParc_Desc.ParcsDesc_Lib!.isEmpty) wParc_Desc.ParcsDesc_Lib = "---";


//       print("RowSaisie Base 2 ${wParc_Desc.toString()}");

    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        print("onTap >>>>>>>>>>>>> BBBBB ${wParc_Desc.toString()} ${wParc_Desc.ParcsDesc_Lib}");

        if(wParc_Desc.ParcsDesc_Type == "SPEC")
          await Client_Groupe_Parc_Inter_Entete_DialogNo.Dialogs_Entete(context, onMaj);
        else
          await Client_Groupe_Parc_Inter_Equip_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, param_Saisie, wParc_Desc);

        if (wParc_Desc.ParcsDesc_Type!.compareTo("FREQ") == 0) {
          DbTools.gParc_Ent.Parcs_FREQ_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_FREQ_Label = wParc_Desc.ParcsDesc_Lib;
        }

        if (wParc_Desc.ParcsDesc_Type!.compareTo("ANN") == 0) {
          DbTools.gParc_Ent.Parcs_ANN_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_ANN_Label = wParc_Desc.ParcsDesc_Lib;
        }

        if (wParc_Desc.ParcsDesc_Type!.compareTo("AFAB") == 0) {
          DbTools.gParc_Ent.Parcs_FAB_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_FAB_Label = wParc_Desc.ParcsDesc_Lib;
        }

        if (wParc_Desc.ParcsDesc_Type!.compareTo("NIV") == 0) {
          DbTools.gParc_Ent.Parcs_NIV_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_NIV_Label = wParc_Desc.ParcsDesc_Lib;
        }

        if (wParc_Desc.ParcsDesc_Type!.compareTo("ZNE") == 0) {
          DbTools.gParc_Ent.Parcs_ZNE_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_ZNE_Label = wParc_Desc.ParcsDesc_Lib;
        }

        if (wParc_Desc.ParcsDesc_Type!.compareTo("EMP") == 0) {
          DbTools.gParc_Ent.Parcs_EMP_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_EMP_Label = wParc_Desc.ParcsDesc_Lib;
        }
        if (wParc_Desc.ParcsDesc_Type!.compareTo("LOT") == 0) {
          DbTools.gParc_Ent.Parcs_LOT_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_LOT_Label = wParc_Desc.ParcsDesc_Lib;
        }
        if (wParc_Desc.ParcsDesc_Type!.compareTo("SERIE") == 0) {
          DbTools.gParc_Ent.Parcs_SERIE_Id = wParc_Desc.ParcsDesc_Id;
          DbTools.gParc_Ent.Parcs_SERIE_Label = wParc_Desc.ParcsDesc_Lib;
        }

        print("RowSaisie Retour ${wParc_Desc.toString()}");
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
            padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              "    ${param_Saisie.Param_Saisie_Label}",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          BtnCard("${wParc_Desc.ParcsDesc_Lib} >", param_Saisie, wParc_Desc,
              LargeurCol2),
        ],
      ),
    );
  }

  Widget BtnCard(String? wText, Param_Saisie param_Saisie, Parc_Desc wParc_Desc,
      double LargeurCol2) {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
