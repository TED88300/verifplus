import 'package:flutter/cupertino.dart';

class Parc_Ent_Count {
  String ParamType = "";
  String ParamTypeOg = "";
  int ParamTypeOg_count = 0;
}

  class Parc_Ent {
  int?    ParcsId = 0;
  int?    Parcs_order = 0;
  int?    Parcs_InterventionId = 0;
  String? Parcs_Type = "";
  String? Parcs_Date_Rev = "";
  String? Parcs_QRCode = "";

  String? Parcs_FREQ_Id = "";
  String? Parcs_FREQ_Label = "";
  String? Parcs_ANN_Id = "";
  String? Parcs_ANN_Label = "";
  String? Parcs_FAB_Id = "";
  String? Parcs_FAB_Label = "";
  String? Parcs_NIV_Id = "";
  String? Parcs_NIV_Label = "";
  String? Parcs_ZNE_Id = "";
  String? Parcs_ZNE_Label = "";
  String? Parcs_EMP_Id = "";
  String? Parcs_EMP_Label = "";
  String? Parcs_LOT_Id = "";
  String? Parcs_LOT_Label = "";
  String? Parcs_SERIE_Id = "";
  String? Parcs_SERIE_Label = "";
  String? Parcs_Audit_Note = "";
  String? Parcs_Verif_Note = "";
  int?   Parcs_Intervention_Timer = 0;
  String? Parcs_UUID = "";
  String? Parcs_UUID_Parent = "";
  String? Parcs_CodeArticle = "";
  String? Parcs_CodeArticleES = "";
  String? Parcs_CODF = "";
  String? Parcs_NCERT = "";
  String? Parcs_FAB = "";
  String? Parcs_NoSpec = "";
  String? Livr = "";
  String? Devis = "";
  String? Action = "";

  int?   Parcs_Update = 1;
  bool? Parcs_MaintPrev = true;
  bool? Parcs_Install = true;
  bool? Parcs_MaintCorrect = true;

  String? Parcs_Date_Desc = "";
  String? Parcs_Date_DescBig = "";
  String? Parcs_Date_Desc2 = "";
  String? Parcs_Date_Desc3 = "";


  String? Parcs_Img = "";
  Widget?  Parcs_ImgWidget = Container();
  String? Parcs_VRMC = "";
  List<String?>? Parcs_Cols = [];





  Parc_Ent({
    this.ParcsId,
    this.Parcs_order,
    this.Parcs_InterventionId,
    this.Parcs_Type,
    this.Parcs_Date_Rev,
    this.Parcs_QRCode,
    this.Parcs_FREQ_Id,
    this.Parcs_FREQ_Label,
    this.Parcs_ANN_Id,
    this.Parcs_ANN_Label,
    this.Parcs_FAB_Id,
    this.Parcs_FAB_Label,
    this.Parcs_NIV_Id,
    this.Parcs_NIV_Label,
    this.Parcs_ZNE_Id,
    this.Parcs_ZNE_Label,
    this.Parcs_EMP_Id,
    this.Parcs_EMP_Label,
    this.Parcs_LOT_Id,
    this.Parcs_LOT_Label,
    this.Parcs_SERIE_Id,
    this.Parcs_SERIE_Label,
    this.Parcs_Audit_Note,
    this.Parcs_Verif_Note,
    this.Parcs_Intervention_Timer,
    this.Parcs_UUID,
    this.Parcs_UUID_Parent,
    this.Parcs_CodeArticle,
    this.Parcs_CodeArticleES,
    this.Parcs_CODF,
    this.Parcs_NCERT,
    this.Parcs_NoSpec,
    this.Livr,
    this.Devis,
    this.Action,

    this.Parcs_Update,


    this.Parcs_MaintPrev,
    this.Parcs_Install,
    this.Parcs_MaintCorrect,

    this.Parcs_Date_Desc,
    this.Parcs_Cols,



  });

  static Parc_EntInit(int parcsInterventionid, String parcsType, int parcsOrder) {





    Parc_Ent wparcEnt = Parc_Ent();
    wparcEnt.ParcsId = null;
    wparcEnt.Parcs_InterventionId = parcsInterventionid;



    wparcEnt.Parcs_Type = parcsType;
    wparcEnt.Parcs_order = parcsOrder;
    wparcEnt.Parcs_Date_Rev = "";
    wparcEnt.Parcs_QRCode = "";
    wparcEnt.Parcs_FREQ_Id    = "";
    wparcEnt.Parcs_FREQ_Label = "";
    wparcEnt.Parcs_ANN_Id    = "";
    wparcEnt.Parcs_ANN_Label = "";
    wparcEnt.Parcs_FAB_Id    = "";
    wparcEnt.Parcs_FAB_Label = "";
    wparcEnt.Parcs_NIV_Id    = "";
    wparcEnt.Parcs_NIV_Label = "";
    wparcEnt.Parcs_ZNE_Id    = "";
    wparcEnt.Parcs_ZNE_Label = "";
    wparcEnt.Parcs_EMP_Id    = "";
    wparcEnt.Parcs_EMP_Label = "";
    wparcEnt.Parcs_LOT_Id    = "";
    wparcEnt.Parcs_LOT_Label = "";
    wparcEnt.Parcs_SERIE_Id    = "";
    wparcEnt.Parcs_SERIE_Label = "";
    wparcEnt.Parcs_Audit_Note = "";
    wparcEnt.Parcs_Verif_Note = "";
    wparcEnt.Parcs_Intervention_Timer = 0;
    wparcEnt.Parcs_Update = 0;
    wparcEnt.Parcs_UUID = "";
    wparcEnt.Parcs_UUID_Parent = "";
    wparcEnt.Parcs_CodeArticle = "";
    wparcEnt.Parcs_CodeArticleES = "";
    wparcEnt.Parcs_CODF = "";
    wparcEnt.Parcs_NCERT = "";
    wparcEnt.Parcs_NoSpec = "";

    wparcEnt.Parcs_Date_Desc = "";
    wparcEnt.Parcs_Install = false;
    wparcEnt.Parcs_MaintCorrect = false;
    wparcEnt.Parcs_MaintPrev = false;


    wparcEnt.Parcs_Cols = [];

    wparcEnt.Livr = "";
    wparcEnt.Devis = "";
    wparcEnt.Action = "";

    return wparcEnt;
  }

  Map<String, dynamic> toMap() {

    return {
      'ParcsId': ParcsId,
      'Parcs_order': Parcs_order,
      'Parcs_InterventionId': Parcs_InterventionId,
      'Parcs_Type': Parcs_Type,
      'Parcs_Date_Rev': Parcs_Date_Rev,
      'Parcs_QRCode': Parcs_QRCode,
      'Parcs_FREQ_Id':  Parcs_FREQ_Id,
      'Parcs_FREQ_Label':     Parcs_FREQ_Label,
      'Parcs_ANN_Id':  Parcs_ANN_Id,
      'Parcs_ANN_Label':     Parcs_ANN_Label,
      'Parcs_FAB_Id':  Parcs_FAB_Id,
      'Parcs_FAB_Label':     Parcs_FAB_Label,
      'Parcs_NIV_Id':  Parcs_NIV_Id,
      'Parcs_NIV_Label':     Parcs_NIV_Label,
      'Parcs_ZNE_Id':  Parcs_ZNE_Id,
      'Parcs_ZNE_Label':     Parcs_ZNE_Label,
      'Parcs_EMP_Id':  Parcs_EMP_Id,
      'Parcs_EMP_Label':     Parcs_EMP_Label,
      'Parcs_LOT_Id':  Parcs_LOT_Id,
      'Parcs_LOT_Label':     Parcs_LOT_Label,
      'Parcs_SERIE_Id':  Parcs_SERIE_Id,
      'Parcs_SERIE_Label':     Parcs_SERIE_Label,
      'Parcs_Audit_Note':     Parcs_Audit_Note,
      'Parcs_Verif_Note':     Parcs_Verif_Note,
      'Parcs_UUID':     Parcs_UUID,
      'Parcs_UUID_Parent':     Parcs_UUID_Parent,
      'Parcs_CodeArticle':     Parcs_CodeArticle,
      'Parcs_CodeArticleES':     Parcs_CodeArticleES,
      'Parcs_CODF':     Parcs_CODF,
      'Parcs_NCERT':     Parcs_NCERT,
      'Parcs_NoSpec':     Parcs_NoSpec,
      'Livr':     Livr,
      'Devis':     Devis,
      'Action':     Action,
      'Parcs_Update': Parcs_Update,



/*
    'Parcs_Date_Desc':     "",
    'Parcs_Install':     true,
    'Parcs_MaintCorrect':     true,
    'Parcs_MaintPrev':     true,
*/

    };
  }

  factory Parc_Ent.fromMap(Map<String, dynamic> map) {
    Parc_Ent wparcEnt = Parc_Ent(
      ParcsId: map["ParcsId"],
      Parcs_order: map["Parcs_order"],
      Parcs_InterventionId: map["Parcs_InterventionId"],
      Parcs_Type: map["Parcs_Type"],
      Parcs_Date_Rev: map["Parcs_Date_Rev"],
      Parcs_QRCode: map["Parcs_QRCode"],
      Parcs_FREQ_Id: map["Parcs_FREQ_Id"],
      Parcs_FREQ_Label: map["Parcs_FREQ_Label"],
      Parcs_ANN_Id: map["Parcs_ANN_Id"],
      Parcs_ANN_Label: map["Parcs_ANN_Label"],
      Parcs_FAB_Id: map["Parcs_FAB_Id"],
      Parcs_FAB_Label: map["Parcs_FAB_Label"],
      Parcs_NIV_Id: map["Parcs_NIV_Id"],
      Parcs_NIV_Label: map["Parcs_NIV_Label"],
      Parcs_ZNE_Id: map["Parcs_ZNE_Id"],
      Parcs_ZNE_Label: map["Parcs_ZNE_Label"],
      Parcs_EMP_Id: map["Parcs_EMP_Id"],
      Parcs_EMP_Label: map["Parcs_EMP_Label"],
      Parcs_LOT_Id: map["Parcs_LOT_Id"],
      Parcs_LOT_Label: map["Parcs_LOT_Label"],
      Parcs_SERIE_Id: map["Parcs_SERIE_Id"],
      Parcs_SERIE_Label: map["Parcs_SERIE_Label"],
      Parcs_Audit_Note: map["Parcs_Audit_Note"],
      Parcs_Verif_Note: map["Parcs_Verif_Note"],
      Parcs_Intervention_Timer: map["Parcs_Intervention_Timer"],
      Parcs_Update: map["Parcs_Update"],
      Parcs_UUID: map["Parcs_UUID"],
      Parcs_UUID_Parent: map["Parcs_UUID_Parent"],
      Parcs_CodeArticle: map["Parcs_CodeArticle"],
      Parcs_CodeArticleES: map["Parcs_CodeArticleES"],
      Parcs_CODF: map["Parcs_CODF"],
      Parcs_NCERT: map["Parcs_NCERT"],
      Parcs_NoSpec: map["Parcs_NoSpec"],
      Livr: map["Livr"],
      Devis: map["Devis"],
      Action: map["Action"],
    );
    return wparcEnt;
  }





  @override
  Parc_Ent copy() => Parc_Ent(
    ParcsId: ParcsId,
    Parcs_order: Parcs_order,
    Parcs_InterventionId: Parcs_InterventionId,
    Parcs_Type: Parcs_Type,
    Parcs_Date_Rev: Parcs_Date_Rev,
    Parcs_QRCode: Parcs_QRCode,
    Parcs_FREQ_Id: Parcs_FREQ_Id,
    Parcs_FREQ_Label: Parcs_FREQ_Label,

    Parcs_ANN_Id: Parcs_ANN_Id,
    Parcs_ANN_Label: Parcs_ANN_Label,
    Parcs_FAB_Id: Parcs_FAB_Id,
    Parcs_FAB_Label: Parcs_FAB_Label,
    Parcs_NIV_Id: Parcs_NIV_Id,
    Parcs_NIV_Label: Parcs_NIV_Label,
    Parcs_ZNE_Id: Parcs_ZNE_Id,
    Parcs_ZNE_Label: Parcs_ZNE_Label,
    Parcs_EMP_Id: Parcs_EMP_Id,
    Parcs_EMP_Label: Parcs_EMP_Label,
    Parcs_LOT_Id: Parcs_LOT_Id,
    Parcs_LOT_Label: Parcs_LOT_Label,
    Parcs_SERIE_Id: Parcs_SERIE_Id,
    Parcs_SERIE_Label: Parcs_SERIE_Label,
    Parcs_Audit_Note: Parcs_Audit_Note,
    Parcs_Verif_Note: Parcs_Verif_Note,
    Parcs_MaintPrev: Parcs_MaintPrev,
    Parcs_Install: Parcs_Install,
    Parcs_MaintCorrect: Parcs_MaintCorrect,
    Parcs_Date_Desc: Parcs_Date_Desc,
    Parcs_Cols: Parcs_Cols,
    Parcs_Intervention_Timer: 0,
    Parcs_Update: 0,
    Parcs_UUID: Parcs_UUID,
    Parcs_UUID_Parent: Parcs_UUID_Parent,
    Parcs_CodeArticle: Parcs_CodeArticle,
    Parcs_CodeArticleES: Parcs_CodeArticleES,
    Parcs_CODF: Parcs_CODF,
    Parcs_NCERT: Parcs_NCERT,
    Parcs_NoSpec: Parcs_NoSpec,
    Livr: Livr,
    Devis: Devis,
    Action: Action,

  );

  @override
  String toString() {
    return 'Parc_Ent {ParcsId: $ParcsId, Parcs_order $Parcs_order, Parcs_InterventionId : $Parcs_InterventionId, '
        'Parcs_Date_Rev $Parcs_Date_Rev, '
        'Parcs_Intervention_Timer $Parcs_Intervention_Timer, '

        'Parcs_QRCode $Parcs_QRCode, '
        'Parcs_FREQ_Id $Parcs_FREQ_Id, Parcs_FREQ_Label $Parcs_FREQ_Label, '
        'Parcs_ANN_Id $Parcs_ANN_Id, Parcs_ANN_Label $Parcs_ANN_Label, '
        'Parcs_FAB_Id $Parcs_FAB_Id, Parcs_FAB_Label $Parcs_FAB_Label, '
        'Parcs_NIV_Id $Parcs_NIV_Id, Parcs_NIV_Label $Parcs_NIV_Label, '
        'Parcs_ZNE_Id $Parcs_ZNE_Id, Parcs_ZNE_Label $Parcs_ZNE_Label, '
        'Parcs_EMP_Id $Parcs_EMP_Id, Parcs_EMP_Label $Parcs_EMP_Label, '
        'Parcs_LOT_Id $Parcs_LOT_Id, Parcs_LOT_Label $Parcs_LOT_Label, '
        'Parcs_SERIE_Id $Parcs_SERIE_Id, '
        'Parcs_SERIE_Label $Parcs_SERIE_Label, '
        'Parcs_Audit_Note $Parcs_Audit_Note, '
        'Parcs_Verif_Note $Parcs_Verif_Note, '
        'Parcs_Intervention_Timer $Parcs_Intervention_Timer, '
        'Parcs_Update $Parcs_Update, '
        'Parcs_UUID $Parcs_UUID, '
        'Parcs_UUID_Parent $Parcs_UUID_Parent, '
        'Parcs_CodeArticle $Parcs_CodeArticle, '
        'Parcs_CodeArticleES $Parcs_CodeArticleES, '
        'Parcs_CODF $Parcs_CODF, '
        'Parcs_NCERT $Parcs_NCERT, '
        'Parcs_NoSpec $Parcs_NoSpec, '
        '> Parcs_MaintPrev $Parcs_MaintPrev, '
        '> Parcs_Install $Parcs_Install, '
        '> Parcs_MaintCorrect $Parcs_MaintCorrect, '
        'Parcs_Date_Desc : $Parcs_Date_Desc, '
        'Parcs_Cols : $Parcs_Cols,'
        'Livr : $Livr,'
        'Devis : $Devis,'
        'Action : $Action,'
        '}';
  }




}
