import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
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

  const Client_Groupe_Parc_Inter_Equip({Key? key, required this.onMaj}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_EquipState createState() => Client_Groupe_Parc_Inter_EquipState();
}

class Client_Groupe_Parc_Inter_EquipState extends State<Client_Groupe_Parc_Inter_Equip> {
  Image? wImageArt;
  Image? wImageGam;

  bool isLoadImage = false;
  Uint8List blankBytes = const Base64Codec().decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");

  Future initImg() async {
    wImageArt = Image.memory(
      blankBytes,
      height: 1,
    );

    wImageGam = Image.memory(
      blankBytes,
      height: 1,
    );


    String wImgPath = "${Srv_DbTools.SrvImg}ArticlesImg_Ebp_${DbTools.gParc_Ent.Parcs_CodeArticle}.jpg";

    print("❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath ArticlesImg_Ebp_ wImgPath $wImgPath");

    gObj.pic = await gObj.networkImageToByte(wImgPath);
    print("❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath ArticlesImg_Ebp_ length ${gObj.pic.length}");
    if (gObj.pic.isNotEmpty) {
      wImageArt = Image.memory(
        gObj.pic,
      );
      print("❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath ArticlesImg_Ebp_ H W ${wImageArt!.height} ${wImageArt!.width}");
    }
    else
      {
        wImgPath = "${Srv_DbTools.SrvImg}Gamme_${Srv_DbTools.GAM_ID}.jpg";

        print("❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖❖ initLib wImgPath Gamme_$wImgPath");
        gObj.pic = await gObj.networkImageToByte(wImgPath);
        if (gObj.pic.isNotEmpty) {
          wImageGam = Image.memory(
            gObj.pic,
          );
        }

      }
  }

  @override
  void initLib() async {
    await initImg();
    isLoadImage = true;
    UpdateChaine();
    setState(() {});
  }

  Future Reload(String paramSaisieId) async {
    print(" Reload Param_Saisie_ID $paramSaisieId");
    await UpdateChaine();

    print("$paramSaisieId ListParam_Saisie_Param lenght  ${Srv_DbTools.ListParam_Saisie_Param.length}");

    setState(() {});
  }

  Future UpdateNCERT_REF() async {
    print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶*>>> UpdateNCERT_REF");

    List<NF074_Gammes> lnf074Gammes = await DbTools.getNF074_Gammes_Get_DESC();
    DbTools.gParc_Ent.Parcs_NCERT = "";
    DbTools.gParc_Ent.Parcs_CODF = "";
    DbTools.gParc_Ent.Parcs_CodeArticle = "";
    for (int i = 0; i < lnf074Gammes.length; i++) {
      NF074_Gammes element = lnf074Gammes[i];
      print("¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶*>>>   lNF074_Gammes > ${element.NF074_Gammes_GAM} /C ${element.NF074_Gammes_NCERT} /R ${element.NF074_Gammes_REF}");
      DbTools.gParc_Ent.Parcs_NCERT = element.NF074_Gammes_NCERT;
      DbTools.gParc_Ent.Parcs_CodeArticle = element.NF074_Gammes_REF;
      DbTools.gParc_Ent.Parcs_CODF = element.NF074_Gammes_CODF;
      break;
    }
    print(" UpdateNCERT_REF");
    await DbTools.updateParc_Ent(DbTools.gParc_Ent);

    await initImg();
    setState(() {

    });
  }

  Future UpdateChaine() async {
    //      print("   UpdateChaine");

    DbTools.glfParcs_Desc = await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);
    print("   getParcs_Desc ${Srv_DbTools.gIntervention.Intervention_Parcs_Type}");

    print("   getParcs_Desc ${DbTools.gParc_Ent.ParcsId!}");
    print("   getParcs_Desc ${DbTools.gParc_Ent.ParcsId!}");
    print("   getParcs_Desc ${DbTools.gParc_Ent.ParcsId!}");

    if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ext") {
      for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
        Param_Saisie paramSaisie = Srv_DbTools.ListParam_Saisie[i];
        Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, paramSaisie.Param_Saisie_ID);

        bool MajAuto = false;
        if (wparcDesc.ParcsDesc_Lib!.compareTo("---") == 0) {
          switch (paramSaisie.Param_Saisie_ID) {
            case "PRS":
              await DbTools.getNF074_Gammes_PRS();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.PRS_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "CLF":
              await DbTools.getNF074_Gammes_CLF();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.CLF_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "MOB":
              await DbTools.getNF074_Gammes_MOB();
              //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.MOB_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
              break;
            case "PDT":
              await DbTools.getNF074_Gammes_PDT();
              //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.PDT_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "POIDS":
              await DbTools.getNF074_Gammes_POIDS();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.POIDS_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "GAM":
              await DbTools.getNF074_Gammes_GAM();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.GAM_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
          }

          if (MajAuto) {
            print("   MajAuto updateParc_Desc");
            wparcDesc.ParcsDesc_Id = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_ParamId.toString();
            wparcDesc.ParcsDesc_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
            await DbTools.updateParc_Desc(wparcDesc, "---");
            await UpdateChaine();
            widget.onMaj();
            await Reload(paramSaisie.Param_Saisie_ID);
          }
          print("UpdateChaine ${wparcDesc.ParcsDesc_Type}");
        }
      }
      if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ext") await UpdateNCERT_REF();
    } else if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ria") {
      for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
        Param_Saisie paramSaisie = Srv_DbTools.ListParam_Saisie[i];
        Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, paramSaisie.Param_Saisie_ID);

        bool MajAuto = false;
        print("UpdateChaine DEB ${wparcDesc.ParcsDesc_Type}");

        if (wparcDesc.ParcsDesc_Lib!.compareTo("---") == 0) {
          switch (paramSaisie.Param_Saisie_ID) {
            case "TYPE2":
              await DbTools.getRIA_Gammes_TYPE();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.TYPE_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "ARM":
              await DbTools.getRIA_Gammes_ARM();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.ARM_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "INOX":
              await DbTools.getRIA_Gammes_INOX();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.INOX_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "DIAM":
              await DbTools.getRIA_Gammes_DIAM();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.DIAM_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "LONG":
              await DbTools.getRIA_Gammes_LONG();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.LONG_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;

            case "DIF":
              await DbTools.getRIA_Gammes_DIF();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.DIF_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
            case "DISP":
              await DbTools.getRIA_Gammes_DISP();
              if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
                MajAuto = true;
                Srv_DbTools.DISP_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
                //      print(" MajAuto get ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
              }
              break;
          }

          if (MajAuto) {
            print("   MajAuto updateParc_Desc");
            wparcDesc.ParcsDesc_Id = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_ParamId.toString();
            wparcDesc.ParcsDesc_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
            await DbTools.updateParc_Desc(wparcDesc, "---");
            await UpdateChaine();
            widget.onMaj();
            await Reload(paramSaisie.Param_Saisie_ID);
          }
          print("UpdateChaine FIN ${wparcDesc.ParcsDesc_Type}");
        }
      }
    }
  }

  @override
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
    print("Client_Groupe_Parc_Inter_Entete_Dialog wImgPath $wImgPath");
    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.isNotEmpty) {
      wImageGam = Image.memory(
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 2,
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
        for (var champ in Champs) {
          if (champ.compareTo("NIV") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_NIV_Label!;
          } else if (champ.compareTo("ZNE") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_ZNE_Label!;
          } else if (champ.compareTo("EMP") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_EMP_Label!;
          } else if (champ.compareTo("LOT") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_LOT_Label!;
          } else if (champ.compareTo("SERIE") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_SERIE_Label!;
          } else if (champ.compareTo("ANN") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_ANN_Label!;
          } else if (champ.compareTo("AFAB") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_FAB_Label!;
          } else if (champ.compareTo("DIAM") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_FAB_Label!;
          } else if (champ.compareTo("LONG") == 0) {
            if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
            GroupLib = GroupLib + DbTools.gParc_Ent.Parcs_FAB_Label!;
          }
        }
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

    return SizedBox(
      width: gColors.MediaQuerysizewidth,
      height: RowSaisies.length * 47,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: gColors.white,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: RowSaisies.length,
          itemBuilder: (context, index) {
            return RowSaisies[index];
          },
          separatorBuilder: (BuildContext context, int index) => Container(height: 1, width: double.infinity, color: gColors.greyDark),
        ),
      ),
    );
  }

  Widget RowSaisieEntGroup(Param_Saisie paramSaisie, String wText, double LargeurCol, double LargeurCol2, double H2) {
//    print("RowSaisieEntGroup DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");
    double IcoWidth = 30;

    if (wText.isEmpty) {
      wText = "---";
    }

    return SizedBox(
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
// ENTETE GROUP
            Client_Groupe_Parc_Inter_Entete_Dialog.param_Saisie = paramSaisie;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff = ""; //DescAff;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff2 = ""; //DescAff2;
            await Client_Groupe_Parc_Inter_Entete_Dialog.Dialogs_Entete(context, onSaisie);
            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              paramSaisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container(
                      width: IcoWidth,
                    )
                  : Image.asset(
                      "assets/images/${paramSaisie.Param_Saisie_Icon}.png",
                      height: IcoWidth,
                      width: IcoWidth,
                    ),
              paramSaisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container()
                  : Container(
                      width: 10,
                    ),
              Container(
                width: LargeurCol,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  paramSaisie.Param_Saisie_Label,
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ),
              BtnCard("$wText >", LargeurCol2),
            ],
          ),
        ));
  }

  Widget RowSaisieGroup(Param_Saisie paramSaisie, String wText, double LargeurCol, double LargeurCol2, double H2) {
     print("RowSaisieGroup DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");
    double IcoWidth = 30;
    if (wText.isEmpty) {
      wText = "---";
    }

    return SizedBox(
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
// ENTETE GROUP
            Client_Groupe_Parc_Inter_Entete_Dialog.param_Saisie = paramSaisie;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff = ""; //DescAff;
            Client_Groupe_Parc_Inter_Entete_Dialog.DescAff2 = ""; //DescAff2;
            await Client_Groupe_Parc_Inter_Desc_Dialog.Dialogs_Desc(context, onSaisie, paramSaisie);
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
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  paramSaisie.Param_Saisie_Label,
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ),
              BtnCard("$wText >", LargeurCol2),
            ],
          ),
        ));
  }
  //

  Widget RowSaisieEnt(Param_Saisie paramSaisie, double LargeurCol, double LargeurCol2, double H2) {
    Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, paramSaisie.Param_Saisie_ID);

    //print("RowSaisieEnt DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");


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

    if (wparcDesc.ParcsDesc_Lib!.isEmpty) {
      wparcDesc.ParcsDesc_Lib = "---";
    }
    //   print("RowSaisieEnt DbTools.gParc_Ent ${DbTools.gParc_Ent.toString()}");

    double IcoWidth = 30;
    return Container(
        color: (wparcDesc.ParcsDesc_Type!.compareTo("FREQ") == 0) ? gColors.greyLight : Colors.white,
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            print("RowSaisie CALL Client_Groupe_Parc_Inter_Equip_Saisie_Dialog ${wparcDesc.toString()}");
            await Client_Groupe_Parc_Inter_Equip_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie, wparcDesc);

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

            DbTools.updateParc_Ent(DbTools.gParc_Ent);
            onSaisie();

            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              paramSaisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container(
                      width: IcoWidth,
                    )
                  : Image.asset(
                      "assets/images/${paramSaisie.Param_Saisie_Icon}.png",
                      height: IcoWidth,
                      width: IcoWidth,
                    ),
              paramSaisie.Param_Saisie_Icon.compareTo("") == 0
                  ? Container()
                  : Container(
                      width: 10,
                    ),
              Container(
                width: LargeurCol,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  paramSaisie.Param_Saisie_Label,
                  style: gColors.bodyTitle1_B_Gr,
                ),
              ),
              BtnCard("${wparcDesc.ParcsDesc_Lib} >", LargeurCol2),
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

    return SizedBox(
        width: gColors.MediaQuerysizewidth,
        height: 45,
        child: Container(
            padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
            color: gColors.greyDark,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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

        for (var champ in Champs) {
          Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, champ);

          if (GroupLib.isNotEmpty) GroupLib = "$GroupLib / ";
          GroupLib = GroupLib + wparcDesc.ParcsDesc_Lib!;
        }
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

        if (Srv_DbTools.DESC_Lib != "PIA" && element.Param_Saisie_ID == "PREM") Trv = true;
//          print("©©©©©©©©©©©©©©©©©©©©© Srv_DbTools.DESC_Lib ${Srv_DbTools.DESC_Lib} ${element.Param_Saisie_ID}");
        if (!Trv) {
          RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
        }
      }
    }

    return SizedBox(
      width: gColors.MediaQuerysizewidth,
      height: RowSaisies.length * 46 + 2,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: gColors.white,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: RowSaisies.length,
          itemBuilder: (context, index) {
            return Container(
              color: iDesc == index ? gColors.greyLight : Colors.white,
              child: RowSaisies[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Container(height: 1, width: double.infinity, color: gColors.greyDark),
        ),
      ),
    );

    Srv_DbTools.ListParam_Saisie.sort(Srv_DbTools.affSortComparison);
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Saisie[i];
      // PARAM INDICE > 0
      if (i > 0) RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
    }

    return SizedBox(
        width: gColors.MediaQuerysizewidth,
        child: Container(
            padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
            color: gColors.greyDark,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: gColors.white,
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
            )));
  }

  Widget RowSaisie(Param_Saisie paramSaisie, double LargeurCol, double LargeurCol2, double H2) {
    Parc_Desc wparcDesc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, paramSaisie.Param_Saisie_ID);

    double IcoWidth = 30;
    String MajAuto = "";
//    if (wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0)
    {
      switch (paramSaisie.Param_Saisie_ID) {
        case "PRS":
          DbTools.getNF074_Gammes_PRS();
          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(p ${Srv_DbTools.ListParam_Saisie_Param.length})";
            print("${paramSaisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wparcDesc.ParcsDesc_Lib} >");
          }
          break;
        case "CLF":
          DbTools.getNF074_Gammes_CLF();
          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(c) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print("${paramSaisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wparcDesc.ParcsDesc_Lib} >");
          }
          break;
        case "MOB":
          DbTools.getNF074_Gammes_MOB().then((result) {
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = "(m) ${Srv_DbTools.ListParam_Saisie_Param.length}";
              print("${paramSaisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wparcDesc.ParcsDesc_Lib} >");
            }
          });
          break;

        case "PDT":
          DbTools.getNF074_Gammes_PDT();

          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(d) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print("${paramSaisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wparcDesc.ParcsDesc_Lib} >");
          }
          break;
        case "POIDS":
          DbTools.getNF074_Gammes_POIDS();
          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(P) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print("${paramSaisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wparcDesc.ParcsDesc_Lib} >");
          }
          break;
        case "GAM":
          DbTools.getNF074_Gammes_GAM();

          if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
            MajAuto = "(g) ${Srv_DbTools.ListParam_Saisie_Param.length}";
            print("${paramSaisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wparcDesc.ParcsDesc_Lib} >");
          }
          break;
      }
    }

    if (paramSaisie.Param_Saisie_Icon.compareTo("") == 0) LargeurCol += 40;
    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        print(" onTap ${wparcDesc.toString()} ${wparcDesc.ParcsDesc_Lib}");
        print("BTN CALL Client_Groupe_Parc_Inter_Equip_Saisie_Dialog ${wparcDesc.toString()} ${wparcDesc.ParcsDesc_Type}");

        await Client_Groupe_Parc_Inter_Equip_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie, wparcDesc);

        print("retour ${wparcDesc.ParcsDesc_Type}");
        if (Srv_DbTools.gIntervention.Intervention_Parcs_Type == "Ext") await UpdateNCERT_REF();

        setState(() {});
      },
      child: Row(
        children: [
          const SizedBox(
            height: 45,
            width: 10,
          ),
          paramSaisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container(
                  width: 0,
                )
              : Image.asset(
                  "assets/images/${paramSaisie.Param_Saisie_Icon}.png",
                  height: IcoWidth,
                  width: IcoWidth,
                ),
          paramSaisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container()
              : Container(
                  width: 10,
                ),
          Container(
            width: LargeurCol,
            height: 20,
            padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              paramSaisie.Param_Saisie_Label,
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
          BtnCard("${wparcDesc.ParcsDesc_Lib} >", LargeurCol2),
        ],
      ),
    );
  }

  Widget BtnCard(String? wText, double LargeurCol2) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                color: wText.contains("---") ? Colors.black : gColors.primaryGreen,
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

    print("***********>>>   buildBottom ${DbTools.gParc_Ent.Parcs_CodeArticle} ${DbTools.gParc_Ent.Parcs_NCERT} GAM_ID ${Srv_DbTools.GAM_ID}");

    String wTxt = "NCERT : ${DbTools.gParc_Ent.Parcs_NCERT}     REF : ${DbTools.gParc_Ent.Parcs_CodeArticle}     Gamme : ${Srv_DbTools.GAM_Lib}";

    Article_Ebp warticleEbp = Srv_DbTools.IMPORT_Article_Ebp( DbTools.gParc_Ent.Parcs_CodeArticle!);

    String wTxt2 = warticleEbp.Article_descriptionCommercialeEnClair;


    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
        color: gColors.greyDark,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  gColors.AffZoomImageArticle(context, wImageArt!, wTxt2, wTxt);
                },
                child: SizedBox(
                    height: 42,
                    width: gColors.MediaQuerysizewidth,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Text(wTxt),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: wImageArt!,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),

                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
