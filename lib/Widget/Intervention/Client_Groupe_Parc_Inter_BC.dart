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
import 'package:verifplus/pdf/Aff_Bdc.dart';

class Client_Groupe_Parc_Inter_BC extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;

  const Client_Groupe_Parc_Inter_BC({Key? key, required this.onMaj, required this.x_t}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_BCState createState() => Client_Groupe_Parc_Inter_BCState();
}

class Client_Groupe_Parc_Inter_BCState extends State<Client_Groupe_Parc_Inter_BC> {

  bool affEdtFilter = false;
  double icoWidth = 40;
  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';


  static List<Parc_Art> searchParcs_Art = [];


  @override
  Future initLib() async {
    print("initLib");
    DbTools.lParcs_Art = await DbTools.getParcs_ArtSoBL(Srv_DbTools.gIntervention.InterventionId!);
    List<Parc_Art> wlParcs_Art = await DbTools.getParcs_ArtInterSumBL(Srv_DbTools.gIntervention.InterventionId!);
    DbTools.lParcs_Art.addAll(wlParcs_Art);
    print("DbTools.lParcs_Art ${DbTools.lParcs_Art.length}");
    Filtre();
  }

  void Filtre() async {
    searchParcs_Art.clear();

    if (filterText.isEmpty)
      searchParcs_Art.addAll(DbTools.lParcs_Art);
    else {
      for (int jj = 0; jj < DbTools.lParcs_Art.length; jj++) {
        Parc_Art wParc_Art = DbTools.lParcs_Art[jj];
        if(wParc_Art.Desc().contains(filterText))
          searchParcs_Art.add(wParc_Art);
      }
    }
    setState(() {});
  }

  void initState() {
    DbTools.lParcs_Art.clear();
    initLib();
    super.initState();
  }

  void onSaisie() async {
    widget.onMaj();
    await initLib();
  }

  @override
  Widget build(BuildContext context) {
    print("build BC");
    Srv_DbTools.getParam_Saisie_ParamMem("Fact");
    print("initLib ${Srv_DbTools.ListParam_Saisie_Param.length}");

    String wTitre2 = "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom == Srv_DbTools.gIntervention.Site_Nom)
      wTitre2 = "";

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 55),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20.0),
                width: 60,
                height: 50,

              ),


              new ElevatedButton(
                onPressed: () async {
                  await HapticFeedback.vibrate();

                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_Bdc()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gColors.primaryGreen,
                    side: const BorderSide(
                      width: 1.0,
                      color: gColors.primaryGreen,
                    )),
                child: Text('Imprimer', style: gColors.bodyTitle1_B_W),
              ),

              Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 21.0),
                  child: FloatingActionButton(
                      elevation: 10.0,
                      child: new Icon(Icons.add),
                      backgroundColor: gColors.secondary,
                      onPressed: () async {
                        await Client_Groupe_Parc_Inter_Article_Dialog.Dialogs_Saisie(context, onSaisie, "SO");
                        await initLib();
                      })),



            ],
          ),
        ),
      ),


      body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: wTitre2, wTimer: 0),
              Entete_Btn_Search(),
              Container(
                height: 1,
                color: gColors.greyDark,
              ),

              buildIcoTitre(context),
              (DbTools.lParcs_Art.length == 0 ) ? Container() :
              Expanded(
                child:              buildDesc(context),
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
        padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

          Spacer(),
          Text(
            "${Srv_DbTools.gIntervention.Intervention_Type}/${Srv_DbTools.gIntervention.Intervention_Parcs_Type} - ${Srv_DbTools.gIntervention.Intervention_Status} - Cr N° : ${Srv_DbTools.gIntervention.InterventionId} -Anthony FUNDONI",
            style: gColors.bodySaisie_B_G,
            textAlign: TextAlign.center,
          ),
          Spacer(),

        ]),
      ),
    );
  }


  Widget buildIcoTitre(BuildContext context) {
    double IcoWidth = 30;

    return Container(
      width: 640,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
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
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "BC : Liste des pièces facturées",
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

    return
//      Expanded(child:
      Container(
        width: 640,
        height: 770,
        color: gColors.greyDark,
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
            color: gColors.greyDark,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
    if (art.wImgeTrv)
      return art.wImage!;


    String wImgPath = "${Srv_DbTools.SrvImg}ArticlesImg_Ebp_${art.ParcsArt_Id}s.jpg";
    gObj.pic = await gObj.networkImageToByte(wImgPath);

    if (gObj.pic.length > 0) {
      art.wImgeTrv = true;
      art.wImage =  Image.memory(
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
    return new FutureBuilder(
      future: GetImage(art),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 30);
        }
      },
    );
  }

  Widget RowSaisie(Parc_Art parc_Art, double H2) {

    Color wColor = Colors.green;

    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Param.length; i++) {
      Param_Saisie_Param eP = Srv_DbTools.ListParam_Saisie_Param[i];
      if (eP.Param_Saisie_Param_Label.compareTo(parc_Art.ParcsArt_Fact!) == 0) {
        wColor = gColors.getColor(eP.Param_Saisie_Param_Color);
        break;
      }
    }
    String ParcsArt_Livr = parc_Art.ParcsArt_Livr!.substring(0,1);
    if (ParcsArt_Livr.compareTo("R") != 0) ParcsArt_Livr = "";

    return Container(
        color: Colors.white,
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            print("onTap ");
            print("onTap ${parc_Art.toString()} ");

            if (parc_Art.ParcsArt_lnk == "SO") {
              await Client_Groupe_Parc_Inter_Piece_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, onSaisie, parc_Art);
            } else {
              await Client_Groupe_Parc_Inter_Article_View_Dialog.Dialogs_Saisie(context, parc_Art);
            }




            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              buildImage(context, parc_Art),
              Container(
                width: 10,
              ),
              Container(
                width: 100,
                height: 20,
                padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${parc_Art.ParcsArt_Id}",
                  style: parc_Art.ParcsArt_Livr!.substring(0,1).compareTo("R")==0 ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                  child: Text(
                    "[${parc_Art.ParcsArt_Livr!.substring(0,1)}] ${parc_Art.ParcsArt_Lib}",
                    style: parc_Art.ParcsArt_Livr!.substring(0,1).compareTo("R")==0 ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                  ),
                ),
              ),
              Container(
                width: 110,
                height: 20,
                padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${parc_Art.ParcsArt_Fact}",
                  style: gColors.bodyTitle1_B_Gr.copyWith(
                    color: wColor,
                  ),
                ),
              ),


              Container(
                width: 40,
                height: 20,
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Text(
                  "${parc_Art.Qte}",
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
    return Container(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),

          Spacer(),

          EdtFilterWidget(),
        ]));
  }


  Widget EdtFilterWidget() {
    return !affEdtFilter
        ? InkWell(
        child: Padding(
          padding: EdgeInsets.only(right: 8),
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
        : Container(
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
