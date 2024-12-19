import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Audit_Saisie.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Client_Groupe_Parc_Inter_Audit extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;

  const Client_Groupe_Parc_Inter_Audit({Key? key, required this.onMaj, required this.x_t}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_AuditState createState() => Client_Groupe_Parc_Inter_AuditState();
}

class Client_Groupe_Parc_Inter_AuditState extends State<Client_Groupe_Parc_Inter_Audit> {
  final txtController = TextEditingController();

  @override
  void initLib() async {
    txtController.text = DbTools.gParc_Ent.Parcs_Audit_Note!;

    print("ListParam_Saisie AUDIT <<< ${Srv_DbTools.ListParam_Audit_Base.length}");

    for (int i = 0; i < Srv_DbTools.ListParam_Audit_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Audit_Base[i];
      Parc_Desc wParc_Desc = await  DbTools.getParcs_Desc_Id_Type_Add(DbTools.gParc_Ent.ParcsId!, element.Param_Saisie_ID);
    }
    DbTools.glfParcs_Desc = await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);
    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  void onSaisie() async {
    widget.onMaj();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),


    child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                height: 1,
                color: gColors.greyDark,
              ),
              buildIcoTitre(context),
              buildDesc(context),
              Container(height: 1, color: gColors.greyDark),
              buildNote(context),
              Container(height: 93),


            ],
          )),
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
            "assets/images/Audit_titre.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Container(
            height: 20,
            padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              "Audit Situation avant vérif",
              style: gColors.bodyTitle1_B_Gr,
            ),
          ),
        ],
      ),
    );
  }




  Widget buildNote(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 1),
        color: gColors.white,
        child: Container(
          width: 638,
          height: 150,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: gColors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: txtController,
            style: gColors.bodyTitle1_N_Gr,
            autofocus: false,
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              border: InputBorder.none,
            ),
            onChanged: (value) async {
              await HapticFeedback.vibrate();
              DbTools.gParc_Ent.Parcs_Audit_Note = value;
              print(" updateParc_Ent K");
              DbTools.updateParc_Ent(DbTools.gParc_Ent);
            },
          ),
        ));
  }

  @override
  Widget buildDesc(BuildContext context) {
    double LargeurCol = 290;
    double LargeurCol2 = gColors.MediaQuerysizewidth - LargeurCol - 60;
    double H2 = 4;
    List<Widget> RowSaisies = [];
    Srv_DbTools.ListParam_Audit_Base.sort(Srv_DbTools.affSortComparison);
    for (int i = 0; i < Srv_DbTools.ListParam_Audit_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Audit_Base[i];
      RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
    }
    return Expanded(
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
          color: gColors.greyDark,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
          )),
    );
  }

  Widget RowSaisie(Param_Saisie param_Saisie, double LargeurCol, double LargeurCol2, double H2) {
    Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);
    double IcoWidth = 30;
    Param_Saisie_Param wParam_Saisie_Param = Srv_DbTools.getParam_Saisie_ParamMem_Lib(param_Saisie.Param_Saisie_ID, wParc_Desc.ParcsDesc_Lib!);
    if (param_Saisie.Param_Saisie_Icon.compareTo("") == 0) LargeurCol += 40;
    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        print("onTap ${wParc_Desc.toString()} ${wParc_Desc.ParcsDesc_Lib}");
        await Client_Groupe_Parc_Inter_Audit_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, param_Saisie, wParc_Desc);

        setState(() {});
      },
      child: Row(
        children: [
          Container(
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
          BtnCard("${wParc_Desc.ParcsDesc_Lib} >", LargeurCol2, wParam_Saisie_Param.Param_Saisie_Param_Color),
        ],
      ),
    );
  }

  Widget BtnCard(String? wText, double LargeurCol2, String color) {
    Color wColor = gColors.getColor(color);

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
                color: wText.contains("---") ? Colors.black : wColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
