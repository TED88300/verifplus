import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class DCL_Det_Adresses extends StatefulWidget {
  const DCL_Det_Adresses({super.key});

  @override
  DCL_Det_AdressesState createState() => DCL_Det_AdressesState();
}

class DCL_Det_AdressesState extends State<DCL_Det_Adresses> with SingleTickerProviderStateMixin {
  List<Widget> views = <Widget>[
    const Text('Facturation'),
    const Text('Livraison'),
  ];

  final List<bool> _selectedView = <bool>[true, false];

  List<Widget> widgets = [];
  final pageController = PageController(keepPage: false, initialPage: DbTools.gCurrentIndex4);
  List<Widget> ListWidget = [];
  List<Widget> ListWidget2 = [];

  final groupButtonController = GroupButtonController();

  void Reload() async {
    setState(() {});
  }

  @override
  Future initLib() async {
    ListWidget = [
      AffBtnParam("", "Facturation", "133 rue Servient - 69003 LYON", "DCL_Date"                                          , Colors.blue, gColors.white, "",),
      AffBtnParam("", "Contact\nPrincipal", "Monsieur DUPONT François - RAF\n06 25 48 72 80 / g.deveza@mondialfeu.fr", "" , Colors.blue, gColors.white, "" ),
      AffBtnParam("", "Contact\nSecondaire", "Monsieur GYGY Nathan - Compatble\n06 25 48 72 81 / n.gygy@mondialfeu.fr", "", Colors.blue, gColors.white, ""),
    ];

    ListWidget2 = [
      AffBtnParam("", "Site"      , "Restaurant CHIKIN BIOT", "DCL_Relance.svg"           , Colors.blue  ,gColors.white,  ""),
      AffBtnParam("", "Livraison" , "10rue Descamps - 06410 BIOT", "DCL_Relance.svg"      , Colors.blue  ,gColors.white,  ""),
      AffBtnParam("", "Groupe 1"    , "Sud", "DCL_Relance.svg"                            , Colors.white  ,gColors.black,  "", bMini: true),
      AffBtnParam("", "Zone"      , "Restaurant", "DCL_Relance.svg"                       , Colors.blue  ,gColors.white,  "", bMini: true),
      AffBtnParam("", "Contact\nLivraison"      , "Restaurant", "DCL_Relance.svg"         , Colors.blue  ,gColors.white,  ""),

    ];

    widgets = [
      Facturation(),
      Livraison(),
    ];
    Reload();
  }

  @override
  void initState() {
    super.initState();

    groupButtonController.selectIndex(0);
    _selectedView.clear();
    for (int i = 0; i < views.length; i++) {
      _selectedView.add(i == 0);
    }
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Validite!.isEmpty) {
      Srv_DbTools.gDCL_Ent.DCL_Ent_Validite = Srv_DbTools.ListParam_Param_Validite_devis[0].Param_Param_Text;
    }
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire!.isEmpty) {
      Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire = Srv_DbTools.ListParam_Param_Affaire[0].Param_Param_Text;
    }
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    String wTitre2 = "${Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_ZoneNom}";
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom == Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom) wTitre2 = "";

    double icoWidth = 40;
    double wHeight = 890;
    double wWidth = MediaQuery.of(context).size.width;

    return SimpleDialog(insetPadding: const EdgeInsets.fromLTRB(0, 128, 0, 0), titlePadding: EdgeInsets.zero, contentPadding: EdgeInsets.zero, surfaceTintColor: Colors.transparent, backgroundColor: gColors.white, shadowColor: Colors.transparent,
        children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: wHeight,
          width: wWidth,
          child: Column(children: [
            SizedBox(
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GroupButton(
                        controller: groupButtonController,
                        options: GroupButtonOptions(
                          borderRadius: BorderRadius.circular(8),
                          selectedTextStyle: gColors.bodyTitle1_B_Gr,
                          selectedBorderColor: Colors.white,
                          selectedColor: Colors.white,
                          selectedShadow: const [],
                          unselectedColor: Colors.grey,
                          unselectedBorderColor: Colors.grey,
                          unselectedTextStyle: gColors.bodyTitle1_B_Gr,
                          unselectedShadow: const [],
                          spacing: 10,
                          runSpacing: 10,
                          groupingType: GroupingType.wrap,
                          direction: Axis.horizontal,
                          buttonWidth: 150,
                          buttonHeight: 40,
                          textAlign: TextAlign.center,
                          textPadding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          elevation: 0,
                        ),
                        buttons: const [
                          'Facturation',
                          'Livraison',
                        ],
                        onSelected: (val, index, selected) {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                          setState(() {});
                        }),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: widgets,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(60),
                    ),
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: gColors.white,
                    size: 46,
                  ),
                ),
                onTap: () async {
                  setState(() {});
                },
              )


            ],)





          ])),
    ]);
  }

  void onBottomIconPressed(int index) async {
    groupButtonController.selectIndex(index);
    setState(() {});
  }

  Widget Facturation() {
    return Column(
      children: [
        Expanded(
          child: ListWidget.isEmpty
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: ListWidget.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListWidget[index];
                  },
                ),
        ),
      ],
    );
  }

  Widget Livraison() {
    return Column(
      children: [
        Expanded(
          child: ListWidget2.isEmpty
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: ListWidget2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListWidget2[index];
                  },
                ),
        ),
      ],
    );
  }


  Widget AffBtnParam(String wChamps, String wTitle, String wValue, String ImgL, Color BckGrd, Color ForeGrd, String wParam, {bool bMini = false}) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {},
        child: Column(
          children: [
            bMini ?
            AffLigne(wTitle, "$wValue", BckGrd, ImgL, ForeGrd , true) :
            AffLigne(wTitle, "$wValue", BckGrd, ImgL, ForeGrd, false),
          ],
        ));
  }

  Widget AffLigne(String wTextL, String wTextR, Color BckGrd, String ImgL, Color ForeGrd, bool bMini) {
    double wHeight = bMini ? 50 :100;
    double mTop = 28;
    double icoWidth = 32;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gColors.LinearGradient5,
          width: 1.5,
        ),
      ),
      width: 580,
      height: wHeight,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: BckGrd,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            ),
            width: 100,
            child: Center(
              child: Text(
                wTextL,
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_W.copyWith(color: ForeGrd),
              ),
            ),
          ),
          Container(
            width: 12,
          ),
          Center(
            child: Text(
              wTextR,
              textAlign: TextAlign.left,
              style: gColors.bodyTitle1_N_Gr,
            ),
          ),
        ],
      ),
    );
  }
}
