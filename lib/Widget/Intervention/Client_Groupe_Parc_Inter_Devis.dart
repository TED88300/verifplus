import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Article.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Article_View.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Piece_Saisie.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_Devis extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;

  const Client_Groupe_Parc_Inter_Devis({Key? key, required this.onMaj, required this.x_t}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_DevisState createState() => Client_Groupe_Parc_Inter_DevisState();
}

class Client_Groupe_Parc_Inter_DevisState extends State<Client_Groupe_Parc_Inter_Devis> {
  bool affEdtFilter = false;
  double icoWidth = 40;
  TextEditingController ctrlFilter = TextEditingController();
  String filterText = '';

  static List<Parc_Art> searchParcs_Art = [];

  @override
  Future initLib() async {
    print("initLib");

    DbTools.lParcs_Art = await DbTools.getParcs_ArtSoDevis(Srv_DbTools.gIntervention.InterventionId);
    List<Parc_Art> wlparcsArt = await DbTools.getParcs_ArtInterSumDevis(Srv_DbTools.gIntervention.InterventionId);
    DbTools.lParcs_Art.addAll(wlparcsArt);

    print("DbTools.lParcs_Art ${DbTools.lParcs_Art.length}");
    Filtre();
  }

  void Filtre() async {
    searchParcs_Art.clear();

    if (filterText.isEmpty) {
      searchParcs_Art.addAll(DbTools.lParcs_Art);
    } else {
      for (int jj = 0; jj < DbTools.lParcs_Art.length; jj++) {
        Parc_Art wparcArt = DbTools.lParcs_Art[jj];
        if (wparcArt.Desc().contains(filterText)) searchParcs_Art.add(wparcArt);
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    DbTools.lParcs_Art.clear();
    initLib();
    super.initState();
  }


  void onDelete() async {
    await initLib();
  }

  void onSaisie() async {
    widget.onMaj();
    await initLib();
  }

  @override
  Widget build(BuildContext context) {
    print("build DEVIS");
    Srv_DbTools.getParam_Saisie_ParamMem("Fact");
    print("initLib ${Srv_DbTools.ListParam_Saisie_Param.length}");

    String wTitre2 = "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom == Srv_DbTools.gIntervention.Site_Nom) wTitre2 = "";

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 0, bottom: 60.0),
          child: FloatingActionButton(
              elevation: 10.0,
              backgroundColor: gColors.secondary,
              onPressed: () async {
                await Client_Groupe_Parc_Inter_Article_Dialog.Dialogs_SaisieDevis(context, onSaisie, "SO");
                await initLib();
              },
              child: const Icon(Icons.add))),

      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gObj.InterventionTitleWidget(Srv_DbTools.gClient.Client_Nom.toUpperCase(), wTitre2: wTitre2, wTimer: 0),
              Entete_Btn_Search(),
              Container(
                height: 1,
                color: gColors.greyDark,
              ),
              buildIcoTitre(context),
              (DbTools.lParcs_Art.isEmpty)
                  ? Container()
                  : Expanded(
                      child: buildDesc(context),
                    ),
            ],
          )),
    );
  }

  static Widget InterventionTitleWidget2() {
    return Material(
      elevation: 4,
      child: Container(
        width: 640,
        height: 57,
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Text(
            "${Srv_DbTools.gIntervention.Intervention_Type}/${Srv_DbTools.gIntervention.Intervention_Parcs_Type} - ${Srv_DbTools.gIntervention.Intervention_Status} - Cr N° : ${Srv_DbTools.gIntervention.InterventionId} -Anthony FUNDONI",
            style: gColors.bodySaisie_B_G,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ]),
      ),
    );
  }

  Widget buildIcoTitre(BuildContext context) {
    double IcoWidth = 30;

    return Container(
      width: 640,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Verif_titre.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Devis",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDesc(BuildContext context) {
    double H = 4;
    double H2 = 4;

    List<Widget> RowSaisies = [];

    for (int i = 0; i < searchParcs_Art.length; i++) {
      Parc_Art element = searchParcs_Art[i];

      RowSaisies.add(RowSaisie(element, H2));
    }

    return Container(
      width: 640,
      height: 770,
      color: gColors.greyDark,
      child: Container(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          color: gColors.greyDark,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            color: gColors.white,
            child: ListView.separated(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: RowSaisies.length,
              itemBuilder: (context, index) {
                return RowSaisies[index];
              },
              separatorBuilder: (BuildContext context, int index) => Container(height: 1, width: double.infinity, color: gColors.greyDark),
            ),
          )),
    );
  }

  Future<Image> GetImage(Parc_Art art) async {
    if (art.wImgeTrv) return art.wImage!;

    await Srv_DbTools.getArticlesImg_Ebp( art.ParcsArt_Id!);
    gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);

    if (gObj.pic.isNotEmpty) {
      art.wImgeTrv = true;
      art.wImage = Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: 30,
        height: 30,
      );
      return art.wImage!;
    }

    return Image.asset(
      "assets/images/Audit_det.png",
      height: 30,
      width: 30,
    );
  }

  Widget buildImage(BuildContext context, Parc_Art art) {
    return FutureBuilder(
      future: GetImage(art),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return Container(width: 30);
        }
      },
    );
  }

  Widget RowSaisie(Parc_Art parcArt, double H2) {
    Color wColor = Colors.green;

    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Param.length; i++) {
      Param_Saisie_Param eP = Srv_DbTools.ListParam_Saisie_Param[i];
      if (eP.Param_Saisie_Param_Label.compareTo(parcArt.ParcsArt_Fact!) == 0) {
        wColor = gColors.getColor(eP.Param_Saisie_Param_Color);
        break;
      }
    }
    String parcsartLivr = parcArt.ParcsArt_Livr!.substring(0, 1);
    if (parcsartLivr.compareTo("R") != 0) parcsartLivr = "";

    print(" wParc_Art SO ${parcArt.Desc()} ${parcArt.Qte}");

    return Container(
        color: Colors.white,
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            print("onTap ");
            print("onTap ${parcArt.toString()} ");

            if (parcArt.ParcsArt_lnk == "SO") {
              await Client_Groupe_Parc_Inter_Piece_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, onSaisie, parcArt);
            } else {
              await Client_Groupe_Parc_Inter_Article_View_Dialog.Dialogs_Saisie(context, parcArt);
            }

            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              buildImage(context, parcArt),
              Container(
                width: 10,
              ),
              Container(
                width: 100,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${parcArt.ParcsArt_Id}",
                  style: parcArt.ParcsArt_Livr!.substring(0, 1).compareTo("R") == 0 ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                  child: Text(
                    "[${parcArt.ParcsArt_Livr!.substring(0, 1)}] ${parcArt.ParcsArt_Lib}",
                    style: parcArt.ParcsArt_Livr!.substring(0, 1).compareTo("R") == 0 ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                  ),
                ),
              ),
              Container(
                width: 110,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${parcArt.ParcsArt_Fact}",
                  style: gColors.bodyTitle1_B_Gr.copyWith(
                    color: wColor,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Text(
                  "${parcArt.ParcsArt_Qte}",
                  style: gColors.bodyTitle1_B_Gr,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 10,
              ),
            ],
          ),
        ));
  }

  @override
  Widget Entete_Btn_Search() {
    return SizedBox(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),
          const Spacer(),
          EdtFilterWidget(),
        ]));
  }

  Widget EdtFilterWidget() {
    return !affEdtFilter
        ? InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(
                "assets/images/Btn_Loupe.png",
                height: icoWidth,
                width: icoWidth,
              ),
            ),
            onTap: () async {
              affEdtFilter = !affEdtFilter;
              setState(() {});
            })
        : SizedBox(
            width: 320,
            child: Row(
              children: [
                InkWell(
                    child: Image.asset(
                      "assets/images/Btn_Loupe.png",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                    onTap: () async {
                      affEdtFilter = !affEdtFilter;
                      setState(() {});
                    }),
                Expanded(
                    child: TextField(
                  onChanged: (text) {
                    filterText = text;
                    Filtre();
                  },
                  controller: ctrlFilter,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        ctrlFilter.clear();
                        filterText = "";
                        Filtre();
                      },
                      icon: Image.asset(
                        "assets/images/Btn_Clear.png",
                        height: icoWidth,
                        width: icoWidth,
                      ),
                    ),
                  ),
                ))
              ],
            ));
  }
}
