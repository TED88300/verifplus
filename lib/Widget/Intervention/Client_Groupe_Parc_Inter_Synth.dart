import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Piece_Saisie.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_Synth extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;

  const Client_Groupe_Parc_Inter_Synth({Key? key, required this.onMaj, required this.x_t}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_SynthState createState() => Client_Groupe_Parc_Inter_SynthState();
}

class Client_Groupe_Parc_Inter_SynthState extends State<Client_Groupe_Parc_Inter_Synth> with AutomaticKeepAliveClientMixin{

  List<Parc_Art> lParcs_Art = [];

  @override
  Future initLib() async {
    print("initLib");
    lParcs_Art = await DbTools.getParcs_ArtAll(DbTools.gParc_Ent.ParcsId!);

    setState(() {});
  }

  void initState() {
    lParcs_Art.clear();
    initLib();
    super.initState();
    FBroadcast.instance().register("Gen_Articles", (value, callback) {
      print(" SYNTH FBroadcast Gen_Articles ");
      initLib();
    });

  }

  void onSaisie() async {
    widget.onMaj();
    await initLib();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print("build SYNTH");
    Srv_DbTools.getParam_Saisie_ParamMem("Fact");

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
         //     buildEnt(context),
              Container(
                height: 1,
                color: gColors.greyDark,
              ),
              buildIcoTitre(context),
              buildDesc(context),
            ],
          )),
    );
  }

  @override
  Widget buildEnt(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 5, 10, 8),
      color: gColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${widget.x_t}",
            style: gColors.bodyTitle1_N_Gr,
          ),
        ],
      ),
    );
  }

  Widget buildIcoTitre(BuildContext context) {
    double IcoWidth = 30;

    return Container(
      width: 640,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,

      child:
      Row(
        children: [

          Image.asset(
            "assets/images/Verif_titre.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),

          Expanded(child:
          Container(

            height: 20,
            padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              "Synthèse",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),),


        ],
      ),
    );
  }

  @override
  Widget buildDesc(BuildContext context) {
    double H = 4;
    double H2 = 4;

    List<Widget> RowSaisies = [];

    for (int i = 0; i < lParcs_Art.length; i++) {
      Parc_Art element = lParcs_Art[i];
      RowSaisies.add(RowSaisie(element, H2));
    }

    return
//      Expanded(child:
      Container(
          width: 640,
          height: 610,
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
              color: gColors.greyDark,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: gColors.greyLight,
                child: ListView.separated(
                  padding: const EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  itemCount: RowSaisies.length,
                  itemBuilder: (context, index) {
                    return RowSaisies[index];
                  },
                  separatorBuilder: (BuildContext context, int index) => Container(height: 1, width: double.infinity, color: gColors.greyDark),
                ),
              ))
      //),
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
    double IcoWidth = 30;

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
            await Client_Groupe_Parc_Inter_Piece_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, parc_Art);
            print("Retour Saisie SYNTH");

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
                    "[${parc_Art.ParcsArt_Type!}] [${parc_Art.ParcsArt_Livr!.substring(0,1)}] ${parc_Art.ParcsArt_Lib}",
                    style: parc_Art.ParcsArt_Livr!.substring(0,1).compareTo("R")==0 ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                  ),
                ),
              ),

              Container(
                width: 110,
                height: 20,
                padding: EdgeInsets.fromLTRB(0, 2, 8, 0),

                child: Text(
                  "${gColors.AbrevTxt(parc_Art.ParcsArt_Fact!)}",
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
                  "${parc_Art.ParcsArt_Qte}",
                  style: gColors.bodyTitle1_N_Gr,
                  textAlign: TextAlign.end,
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
  bool get wantKeepAlive => true;

}
