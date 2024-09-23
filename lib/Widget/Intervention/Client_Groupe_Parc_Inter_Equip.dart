import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Desc_Dialog.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Equip_Saisie.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Entete_Dialog.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_Equip extends StatefulWidget {
  final VoidCallback onMaj;

  const Client_Groupe_Parc_Inter_Equip({Key? key, required this.onMaj})
      : super(key: key);

  @override
  Client_Groupe_Parc_Inter_EquipState createState() =>
      Client_Groupe_Parc_Inter_EquipState();
}

class Client_Groupe_Parc_Inter_EquipState
    extends State<Client_Groupe_Parc_Inter_Equip> {
  Image? wImageArt;
  Image? wImageGam;

  bool isLoadImage = false;
  Uint8List blankBytes = Base64Codec()
      .decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");

  Future initImg() async {
    wImageArt = Image.memory(
      blankBytes,
      height: 1,
    );

    String wImgPath =
        "${Srv_DbTools.SrvImg}ArticlesImg_Ebp_${DbTools.gParc_Ent.Parcs_CodeArticle}.jpg";

    print(
        "❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath ArticlesImg_Ebp_ ${wImgPath}");

    gObj.pic = await gObj.networkImageToByte(wImgPath);
    print(
        "❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath ArticlesImg_Ebp_  ${gObj.pic.length}");
    if (gObj.pic.length > 0) {
      wImageArt = await Image.memory(
        gObj.pic,
      );
      print(
          "❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath ArticlesImg_Ebp_ ${wImageArt!.toString()} ");
    }

    wImageGam = Image.memory(
      blankBytes,
      height: 1,
    );

    wImgPath = "${Srv_DbTools.SrvImg}Gamme_${Srv_DbTools.GAM_ID}.jpg";

    print("❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath Gamme_${wImgPath}");
    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.length > 0) {
      wImageGam = await Image.memory(
        gObj.pic,
      );
    }
  }

  @override
  void initLib() async {
    await initImg();
    isLoadImage = true;
    UpdateChaine();
    setState(() {});
  }

  Future Reload(String Param_Saisie_ID) async {
    print(
        " Reload Param_Saisie_ID ${Param_Saisie_ID}");
    await UpdateChaine();

    print(
        "${Param_Saisie_ID} ListParam_Saisie_Param lenght  ${Srv_DbTools.ListParam_Saisie_Param.length}");

    setState(() {});
  }

  Future UpdateNCERT_REF() async {

    print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶*>>> UpdateNCERT_REF");

    List<NF074_Gammes> lNF074_Gammes = await DbTools.getNF074_Gammes_Get_DESC();
    DbTools.gParc_Ent.Parcs_NCERT = "";
    DbTools.gParc_Ent.Parcs_CODF = "";
    DbTools.gParc_Ent.Parcs_CodeArticle = "";
    for (int i = 0; i < lNF074_Gammes.length; i++) {
      NF074_Gammes element = lNF074_Gammes[i];
      print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶*>>>   lNF074_Gammes > ${element.NF074_Gammes_GAM} /C ${element.NF074_Gammes_NCERT} /R ${element.NF074_Gammes_REF}");
      DbTools.gParc_Ent.Parcs_NCERT = element.NF074_Gammes_NCERT;
      DbTools.gParc_Ent.Parcs_CodeArticle = element.NF074_Gammes_REF;
      DbTools.gParc_Ent.Parcs_CODF = element.NF074_Gammes_CODF;
      break;
    }
    print(" UpdateNCERT_REF");
    await DbTools.updateParc_Ent(DbTools.gParc_Ent);

    await initImg();
  }

  Future UpdateChaine() async {
    //      print("   UpdateChaine");

    DbTools.glfParcs_Desc =  await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);
    print("   getParcs_Desc ${Srv_DbTools.gIntervention.Intervention_Parcs_Type}");

    print("   getParcs_Desc ${DbTools.gParc_Ent.ParcsId!}");
    print("   getParcs_Desc ${DbTools.gParc_Ent.ParcsId!}");
    print("   getParcs_Desc ${DbTools.gParc_Ent.ParcsId!}");

    if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ext")
      {
        for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
          Param_Saisie param_Saisie = Srv_DbTools.ListParam_Saisie[i];
          Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);

          bool MajAuto = false;
          if (wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
            switch (param_Saisie.Param_Saisie_ID) {
              case "PRS":
                await DbTools.getNF074_Gammes_PRS();
                if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                  MajAuto = true;
                  Srv_DbTools.PRS_Lib = Srv_DbTools
                      .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                  //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                }
                break;
              case "CLF":
                await DbTools.getNF074_Gammes_CLF();
                if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                  MajAuto = true;
                  Srv_DbTools.CLF_Lib = Srv_DbTools
                      .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                  //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                }
                break;
              case "MOB":
                await DbTools.getNF074_Gammes_MOB();
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                  MajAuto = true;
                  Srv_DbTools.MOB_Lib = Srv_DbTools
                      .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                  //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                }
                break;
                break;
              case "PDT":
                await DbTools.getNF074_Gammes_PDT();
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                  MajAuto = true;
                  Srv_DbTools.PDT_Lib = Srv_DbTools
                      .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                  //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                }
                break;
              case "POIDS":
                await DbTools.getNF074_Gammes_POIDS();
                if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                  MajAuto = true;
                  Srv_DbTools.POIDS_Lib = Srv_DbTools
                      .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                  //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                }
                break;
              case "GAM":
                await DbTools.getNF074_Gammes_GAM();
                if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                  MajAuto = true;
                  Srv_DbTools.GAM_Lib = Srv_DbTools
                      .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                  //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
                }
                break;
            }

            if (MajAuto) {
                    print("   MajAuto updateParc_Desc");
              wParc_Desc.ParcsDesc_Id = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_ParamId.toString();
              wParc_Desc.ParcsDesc_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
              await DbTools.updateParc_Desc(wParc_Desc, "---");
              await UpdateChaine();
              widget.onMaj();
              await Reload(param_Saisie.Param_Saisie_ID);
            }
            print("UpdateChaine ${wParc_Desc.ParcsDesc_Type}");
          }
        }
        if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ext") await UpdateNCERT_REF();

      }
    else
    if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ria")
    {
      for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
        Param_Saisie param_Saisie = Srv_DbTools.ListParam_Saisie[i];
        Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);

        bool MajAuto = false;
        print("UpdateChaine DEB ${wParc_Desc.ParcsDesc_Type}");

        if (wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
          switch (param_Saisie.Param_Saisie_ID) {
            
            case "TYPE2":
              await DbTools.getRIA_Gammes_TYPE();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.TYPE_Lib = Srv_DbTools
                    .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "ARM":
              await DbTools.getRIA_Gammes_ARM();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.ARM_Lib = Srv_DbTools
                    .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "INOX":
              await DbTools.getRIA_Gammes_INOX();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.INOX_Lib = Srv_DbTools
                    .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "DIAM":
              await DbTools.getRIA_Gammes_DIAM();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.DIAM_Lib = Srv_DbTools
                    .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "LONG":
              await DbTools.getRIA_Gammes_LONG();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.LONG_Lib = Srv_DbTools
                    .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "DIF":
              await DbTools.getRIA_Gammes_DIF();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.DIF_Lib = Srv_DbTools
                    .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "DISP":
              await DbTools.getRIA_Gammes_DISP();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.DISP_Lib = Srv_DbTools
                    .ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;




          }

          if (MajAuto) {
            print("   MajAuto updateParc_Desc");
            wParc_Desc.ParcsDesc_Id = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_ParamId.toString();
            wParc_Desc.ParcsDesc_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
            await DbTools.updateParc_Desc(wParc_Desc, "---");
            await UpdateChaine();
            widget.onMaj();
            await Reload(param_Saisie.Param_Saisie_ID);
          }
          print("UpdateChaine FIN ${wParc_Desc.ParcsDesc_Type}");
        }
      }


    }




  }

  void initState() {
    initLib();
    super.initState();
  }

  void onSaisie() async {
    print("onSaisie>>>> ${Srv_DbTools.GAM_ID}");
    wImageGam = Image.memory(
      blankBytes,
      height: 1,
    );
    String wImgPath = "${Srv_DbTools.SrvImg}Gamme_${Srv_DbTools.GAM_ID}.jpg";
    print("Client_Groupe_Parc_Inter_Entete_Dialog wImgPath ${wImgPath}");
    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.length > 0) {
      wImageGam = await Image.memory(
        gObj.pic,
      );
    }

    await UpdateChaine();

    print("onSaisie<<<<<>");
    widget.onMaj();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildEnt(context),
              Container(
                height: 1,
                color: gColors.greyDark,
              ),
              buildDescEnt(context),
              buildDesc0(context),
              buildDesc(context),
              isLoadImage ? buildBottom(context) : Container(),
            ],
          )),
    );
  }

  @override
  Widget buildEnt(BuildContext context) {
    String wDate = "";
    try {
      wDate = DateFormat('dd/MM/yy HH:mm')
          .format(DateTime.parse(DbTools.gParc_Ent.Parcs_Date_Rev!));
    } on FormatException {}

    return Container(
      width: gColors.MediaQuerysizewidth,
//        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.fromLTRB(16, 5, 10, 8),
      color: gColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Dernière Visite périodique de l’organe : ",
            style: gColors.bodyTitle1_N_Gr,
          ),
          Text(
            wDate,
            style: gColors.bodyTitle1_N_Gr,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  //    print("DbTools.gParc_Ent.Parcs_LOT_Label ${DbTools.gParc_Ent.Parcs_LOT_Label }");
  //     if (DbTools.gParc_Ent.Parcs_LOT_Label!.isEmpty) {
  //       DbTools.gParc_Ent.Parcs_LOT_Label = "Non renseigné sur l'équipement".toUpperCase();
  //     }
  //

  @override
  Widget buildDescEnt(BuildContext context) {
    double LargeurCol = 190;
    double LargeurCol2 = gColors.MediaQuerysizewidth - 190 - 60;
    double H2 = 4;

    List<Widget> RowSaisies = [];
    List<String> GroupLibs = [];
    List<String> GroupDets = [];
    List<String> Groups = [];

    // Formation des Groupement
    Srv_DbTools.ListParam_Saisie_Base.sort(Srv_DbTools.affSortComparison);
    Srv_DbTools.ListParam_Saisie_Base.forEach((element) async {
      if (element.Param_Saisie_Controle.compareTo("Group") == 0) {

        String GroupLib = "";
        Groups.add(element.Param_Saisie_ID);
        Srv_DbTools.getParam_ParamMemDet("Param_Div", element.Param_Saisie_ID);
        String ListChamps = Srv_DbTools.ListParam_Param[0].Param_Param_Text;
        GroupDets.add(ListChamps);
        List<String> Champs = ListChamps.split(",");
        Champs.forEach((champ) {
          if (champ.compareTo("NIV") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_NIV_Label!;
          } else if (champ.compareTo("ZNE") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_ZNE_Label!;
          } else if (champ.compareTo("EMP") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_EMP_Label!;
          } else if (champ.compareTo("LOT") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_LOT_Label!;
          } else if (champ.compareTo("SERIE") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_SERIE_Label!;
          } else if (champ.compareTo("ANN") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_ANN_Label!;
          } else if (champ.compareTo("AFAB") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_FAB_Label!;
          }  else if (champ.compareTo("DIAM") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_FAB_Label!;
          }  else if (champ.compareTo("LONG") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_FAB_Label!;
          }
        });
        GroupLibs.add(GroupLib);
      }
    });

    Srv_DbTools.ListParam_Saisie_Base.sort(Srv_DbTools.affSortComparison);
    Srv_DbTools.ListParam_Saisie_Base.forEach((element) async {
      LargeurCol = 190;
      LargeurCol2 = gColors.MediaQuerysizewidth - 190 - 60;
      if (element.Param_Saisie_Controle.compareTo("Group") == 0) {
        for (int i = 0; i < Groups.length; i++) {
          if (element.Param_Saisie_ID.compareTo(Groups[i]) == 0) {
            if (element.Param_Saisie_ID == "LOTSERIE") {
              LargeurCol = 80;
              LargeurCol2 = gColors.MediaQuerysizewidth - LargeurCol - 60;
            }
            RowSaisies.add(RowSaisieEntGroup(element, gColors.AbrevTxt(GroupLibs[i]), LargeurCol, LargeurCol2, H2));
          }
        }
      } else {
        bool Trv = false;
        for (int i = 0; i < GroupDets.length; i++) {
          if (GroupDets[i].contains(element.Param_Saisie_ID)) Trv = true;
        }
        if (!Trv) {
          RowSaisies.add(RowSaisieEnt(element, LargeurCol, LargeurCol2, H2));
        }
      }
    });

    return Container(
      width: gColors.MediaQuerysizewidth,
      height: RowSaisies.length * 47,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: gColors.white,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: RowSaisies.length,
          itemBuilder: (context, index) {
            return RowSaisies[index];
          },
          separatorBuilder: (BuildContext context, int index) => Container(
              height: 1, width: double.infinity, color: gColors.greyDark),
        ),
      ),
    );
  }

  Widget RowSaisieEntGroup(Param_Saisie param_Saisie, String wText,
      double LargeurCol, double LargeurCol2, double H2) {
//    print("RowSaisieEntGroup DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");
    double IcoWidth = 30;

    if (wText.isEmpty) {
      wText = "---";
    }

    return Container(
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
// ENTETE GROUP
            Client_Groupe_Parc_Inter_Entete_Dialog.param_Saisie = param_Saisie;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff = ""; //DescAff;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff2 = ""; //DescAff2;
            await Client_Groupe_Parc_Inter_Entete_Dialog.Dialogs_Entete(
                context, onSaisie);
            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              param_Saisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container(
                      width: IcoWidth,
                    )
                  : Image.asset(
                      "assets/images/${param_Saisie.Param_Saisie_Icon}.png",
                      height: IcoWidth,
                      width: IcoWidth,
                    ),
              param_Saisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container()
                  : Container(
                      width: 10,
                    ),
              Container(
                width: LargeurCol,
                height: 20,
                padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${param_Saisie.Param_Saisie_Label}",
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ),
              BtnCard("$wText >", LargeurCol2),
            ],
          ),
        ));
  }



  Widget RowSaisieGroup(Param_Saisie param_Saisie, String wText,
      double LargeurCol, double LargeurCol2, double H2) {
//    print("RowSaisieEntGroup DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");
    double IcoWidth = 30;
    if (wText.isEmpty) {
      wText = "---";
    }

    return Container(
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
// ENTETE GROUP
            Client_Groupe_Parc_Inter_Entete_Dialog.param_Saisie = param_Saisie;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff = ""; //DescAff;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff2 = ""; //DescAff2;
            await Client_Groupe_Parc_Inter_Desc_Dialog.Dialogs_Desc(context, onSaisie, param_Saisie);
            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              Container(
                width: LargeurCol + 40,
                height: 20,
                padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${param_Saisie.Param_Saisie_Label}",
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ),
              BtnCard("$wText >", LargeurCol2),
            ],
          ),
        ));
  }
  //

  Widget RowSaisieEnt(Param_Saisie param_Saisie, double LargeurCol,
      double LargeurCol2, double H2) {
    Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(
        DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);

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

    if (wParc_Desc.ParcsDesc_Lib!.isEmpty) {
      wParc_Desc.ParcsDesc_Lib = "---";
    }
    //   print("RowSaisieEnt DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");

    double IcoWidth = 30;
    return Container(
        color: (wParc_Desc.ParcsDesc_Type!.compareTo("FREQ") == 0)
            ? gColors.greyLight
            : Colors.white,
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            print(
                "RowSaisie CALL Client_Groupe_Parc_Inter_Equip_Saisie_Dialog ${wParc_Desc.toString()}");
            await Client_Groupe_Parc_Inter_Equip_Saisie_Dialog.Dialogs_Saisie(
                context, onSaisie, param_Saisie, wParc_Desc);

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
            print(
                "RowSaisie Retour DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");

            DbTools.updateParc_Ent(DbTools.gParc_Ent);
            onSaisie();

            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              param_Saisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container(
                      width: IcoWidth,
                    )
                  : Image.asset(
                      "assets/images/${param_Saisie.Param_Saisie_Icon}.png",
                      height: IcoWidth,
                      width: IcoWidth,
                    ),
              param_Saisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container()
                  : Container(
                      width: 10,
                    ),
              Container(
                width: LargeurCol,
                height: 20,
                padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${param_Saisie.Param_Saisie_Label}",
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ),
              BtnCard("${wParc_Desc.ParcsDesc_Lib} >", LargeurCol2),
            ],
          ),
        ));
  }

  //
  // SAISIE DESCRIPTION

  @override
  Widget buildDesc0(BuildContext context) {

    return Container(
      color: gColors.greyDark,
        width: gColors.MediaQuerysizewidth,
        height: 1,
    );

    double LargeurCol = 190;
    double LargeurCol2 = gColors.MediaQuerysizewidth - 190 - 60;
    double H2 = 4;
    List<Widget> RowSaisies = [];
    Srv_DbTools.ListParam_Saisie.sort(Srv_DbTools.affSortComparison);
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];
      // PARAM INDICE == 0
      if (i == 0) {
        RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      }
    }

    return Container(
        width: gColors.MediaQuerysizewidth,
        height: 45,
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
            color: gColors.greyDark,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: gColors.greyLight,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: RowSaisies.length,
                itemBuilder: (context, index) {
                  return RowSaisies[index];
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: gColors.greyDark,
                ),
              ),
            )));
  }

  @override
  Widget buildDesc(BuildContext context) {
    double LargeurCol = 190;
    double LargeurCol2 = gColors.MediaQuerysizewidth - 190 - 60;
    double H2 = 4;

    List<Widget> RowSaisies = [];

    List<String> GroupLibs = [];
    List<String> GroupDets = [];
    List<String> Groups = [];

//    Srv_DbTools.ListParam_Saisie.forEach((element) async {
      int iDesc = 0;

      for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
        Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];
    //    print(" element ${element.Param_Saisie_ID} $i");

        if (element.Param_Saisie_ID.startsWith("DESC")) iDesc = i;

      if (element.Param_Saisie_Controle.compareTo("Group") == 0) {
      //  print(" Group ${element.Param_Saisie_ID}");
        String GroupLib = "";
        Groups.add(element.Param_Saisie_ID);
        Srv_DbTools.getParam_ParamMemDet("Param_Div", element.Param_Saisie_ID);
        String ListChamps = Srv_DbTools.ListParam_Param[0].Param_Param_Text;
        GroupDets.add(ListChamps);
        List<String> Champs = ListChamps.split(",");

    //    print(" ListChamps ${ListChamps}");



        Champs.forEach((champ) {

          Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, champ);

          if (GroupLib.isNotEmpty) GroupLib = GroupLib + " / ";
          GroupLib = GroupLib + wParc_Desc.ParcsDesc_Lib!;


        });
        GroupLibs.add(GroupLib);
      }
    }


    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];
      LargeurCol = 190;
      LargeurCol2 = gColors.MediaQuerysizewidth - 190 - 60;
      if (element.Param_Saisie_Controle.compareTo("Group") == 0) {
        for (int i = 0; i < Groups.length; i++) {
          if (element.Param_Saisie_ID.compareTo(Groups[i]) == 0) {
            if (element.Param_Saisie_ID == "DIAMLONG") {
              LargeurCol = 280;
              LargeurCol2 = gColors.MediaQuerysizewidth - LargeurCol - 60;
            }
            RowSaisies.add(RowSaisieGroup(element, gColors.AbrevTxt(GroupLibs[i]), LargeurCol, LargeurCol2, H2));
          }
        }
      } else {
        bool Trv = false;
        for (int i = 0; i < GroupDets.length; i++) {
          if (GroupDets[i].contains(element.Param_Saisie_ID)) Trv = true;
        }



        if(Srv_DbTools.DESC_Lib != "PIA" && element.Param_Saisie_ID == "PREM") Trv =true;
//          print("©©©©©©©©©©©©©©©©©©©©© Srv_DbTools.DESC_Lib ${Srv_DbTools.DESC_Lib} ${element.Param_Saisie_ID}");
        if (!Trv) {
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      }
    };



    return Container(
      width: gColors.MediaQuerysizewidth,
      height: RowSaisies.length * 46 + 2,


      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: gColors.white,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: RowSaisies.length,
          itemBuilder: (context, index) {
            return
              Container(
                color: iDesc == index ? gColors.greyLight : Colors.white,
                child: RowSaisies[index],
              )
              ;
          },
          separatorBuilder: (BuildContext context,int index) => Container(
              height: 1, width: double.infinity, color: gColors.greyDark),
        ),
      ),
    );


    Srv_DbTools.ListParam_Saisie.sort(Srv_DbTools.affSortComparison);
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];
      // PARAM INDICE > 0
      if (i > 0)
        RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
    }

    return Container(
        width: gColors.MediaQuerysizewidth,
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
            color: gColors.greyDark,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: gColors.white,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: RowSaisies.length,
                itemBuilder: (context, index) {
                  return RowSaisies[index];
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: gColors.greyDark,
                ),
              ),
            )));
  }

  Widget RowSaisie(Param_Saisie param_Saisie, double LargeurCol,
      double LargeurCol2, double H2) {
    Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);


    double IcoWidth = 30;
    String MajAuto = "";
//    if (wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0)
    {
      switch (param_Saisie.Param_Saisie_ID) {
        case "PRS":
          DbTools.getNF074_Gammes_PRS();
          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(p ${Srv_DbTools.ListParam_Saisie_Param.length})";
            print(
                "${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
          }
          break;
        case "CLF":
          DbTools.getNF074_Gammes_CLF();
          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(c) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print(
                "${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
          }
          break;
        case "MOB":
          DbTools.getNF074_Gammes_MOB().then((result) {
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = "(m) ${Srv_DbTools.ListParam_Saisie_Param.length}";
              print(
                  "${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
            }
          });
          break;

        case "PDT":
          DbTools.getNF074_Gammes_PDT();

          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(d) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print(
                "${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
          }
          break;
        case "POIDS":
          DbTools.getNF074_Gammes_POIDS();
          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(P) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print(
                "${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
          }
          break;
        case "GAM":
          DbTools.getNF074_Gammes_GAM();

          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(g) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print(
                "${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
          }
          break;
      }
    }

    if (param_Saisie.Param_Saisie_Icon.compareTo("") == 0) LargeurCol += 40;
    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        print(
            " onTap ${wParc_Desc.toString()} ${wParc_Desc.ParcsDesc_Lib}");
        print(
            "BTN CALL Client_Groupe_Parc_Inter_Equip_Saisie_Dialog ${wParc_Desc.toString()} ${wParc_Desc.ParcsDesc_Type}");

        await Client_Groupe_Parc_Inter_Equip_Saisie_Dialog.Dialogs_Saisie(
            context, onSaisie, param_Saisie, wParc_Desc);

        print("retour ${wParc_Desc.ParcsDesc_Type}");
        if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ext") await UpdateNCERT_REF();

        setState(() {});
      },
      child: Row(
        children: [
          Container(
            height: 45,

            width: 10,
          ),
          param_Saisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container(
                  width: 0,
                )
              : Image.asset(
                  "assets/images/${param_Saisie.Param_Saisie_Icon}.png",
                  height: IcoWidth,
                  width: IcoWidth,
                ),
          param_Saisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container()
              : Container(
                  width: 10,
                ),
          Container(
            width: LargeurCol,
            height: 20,
            padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              "${param_Saisie.Param_Saisie_Label}",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          BtnCard("${wParc_Desc.ParcsDesc_Lib} >", LargeurCol2),
        ],
      ),
    );
  }

  Widget BtnCard(String? wText, double LargeurCol2) {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: LargeurCol2,
      height: 31,
      child: Card(
        color: gColors.transparent,
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

  @override
  Widget buildBottom(BuildContext context) {
    //print(" buildBottom CODF ${DbTools.gParc_Ent.Parcs_NCERT}   ${DbTools.gParc_Ent.Parcs_CodeArticle}  ${DbTools.gParc_Ent.Parcs_CODF}   ");

    print("***********>>>   buildBottom ${DbTools.gParc_Ent.Parcs_CodeArticle} ${DbTools.gParc_Ent.Parcs_NCERT}");



    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
        color: gColors.greyDark,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  gColors.AffZoomImage(context, wImageArt!);
                },
                child: Container(
                    height: 42,

                    width: gColors.MediaQuerysizewidth,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text("NCERT ${DbTools.gParc_Ent.Parcs_NCERT}     "),
                        Text("REF ${DbTools.gParc_Ent.Parcs_CodeArticle}     "),
                        Text("CODF ${DbTools.gParc_Ent.Parcs_CODF}     "),
                        Text("Gamme ${Srv_DbTools.GAM_ID}   "),
                        Spacer(),
                        Container(
                          child: wImageArt!,
                          height: 42,
                          width: 100,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
