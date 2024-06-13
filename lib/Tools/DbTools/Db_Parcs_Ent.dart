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
  String? Parcs_CODF = "";
  String? Parcs_NCERT = "";
  String? Livr = "";
  String? Devis = "";
  String? Action = "";

  int?   Parcs_Update = 1;
  bool? Parcs_MaintPrev = true;
  bool? Parcs_Install = true;
  bool? Parcs_MaintCorrect = true;

  String? Parcs_Date_Desc = "";
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
    this.Parcs_CODF,
    this.Parcs_NCERT,
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

  static Parc_EntInit(int Parcs_InterventionId, String Parcs_Type, int Parcs_order) {


    print("Parc_EntInit Parcs_InterventionId ${Parcs_InterventionId}");
    print("Parc_EntInit Parcs_Type ${Parcs_Type}");
    print("Parc_EntInit Parcs_order ${Parcs_order}");



    Parc_Ent wParc_Ent = Parc_Ent();
    wParc_Ent.ParcsId = null;
    wParc_Ent.Parcs_InterventionId = Parcs_InterventionId;



    wParc_Ent.Parcs_Type = Parcs_Type;
    wParc_Ent.Parcs_order = Parcs_order;
    wParc_Ent.Parcs_Date_Rev = "";
    wParc_Ent.Parcs_QRCode = "";
    wParc_Ent.Parcs_FREQ_Id    = "";
    wParc_Ent.Parcs_FREQ_Label = "";
    wParc_Ent.Parcs_ANN_Id    = "";
    wParc_Ent.Parcs_ANN_Label = "";
    wParc_Ent.Parcs_FAB_Id    = "";
    wParc_Ent.Parcs_FAB_Label = "";
    wParc_Ent.Parcs_NIV_Id    = "";
    wParc_Ent.Parcs_NIV_Label = "";
    wParc_Ent.Parcs_ZNE_Id    = "";
    wParc_Ent.Parcs_ZNE_Label = "";
    wParc_Ent.Parcs_EMP_Id    = "";
    wParc_Ent.Parcs_EMP_Label = "";
    wParc_Ent.Parcs_LOT_Id    = "";
    wParc_Ent.Parcs_LOT_Label = "";
    wParc_Ent.Parcs_SERIE_Id    = "";
    wParc_Ent.Parcs_SERIE_Label = "";
    wParc_Ent.Parcs_Audit_Note = "";
    wParc_Ent.Parcs_Verif_Note = "";
    wParc_Ent.Parcs_Intervention_Timer = 0;
    wParc_Ent.Parcs_Update = 0;
    wParc_Ent.Parcs_UUID = "";
    wParc_Ent.Parcs_UUID_Parent = "";
    wParc_Ent.Parcs_CodeArticle = "";
    wParc_Ent.Parcs_CODF = "";
    wParc_Ent.Parcs_NCERT = "";


    wParc_Ent.Parcs_Date_Desc = "";
    wParc_Ent.Parcs_Install = false;
    wParc_Ent.Parcs_MaintCorrect = false;
    wParc_Ent.Parcs_MaintPrev = false;


    wParc_Ent.Parcs_Cols = [];

    wParc_Ent.Livr = "";
    wParc_Ent.Devis = "";
    wParc_Ent.Action = "";

    return wParc_Ent;
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
      'Parcs_CODF':     Parcs_CODF,
      'Parcs_NCERT':     Parcs_NCERT,
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
    Parc_Ent wParc_Ent = Parc_Ent(
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
      Parcs_CODF: map["Parcs_CODF"],
      Parcs_NCERT: map["Parcs_NCERT"],
      Livr: map["Livr"],
      Devis: map["Devis"],
      Action: map["Action"],
    );
    return wParc_Ent;
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
    Parcs_CODF: Parcs_CODF,
    Parcs_NCERT: Parcs_NCERT,
    Livr: Livr,
    Devis: Devis,
    Action: Action,

  );

  @override
  String toString() {
    return 'Parc_Ent {ParcsId: $ParcsId, Parcs_order $Parcs_order, Parcs_InterventionId : $Parcs_InterventionId, '
        'Parcs_Date_Rev ${Parcs_Date_Rev}, '
        'Parcs_Intervention_Timer ${Parcs_Intervention_Timer}, '

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
        'Parcs_CODF $Parcs_CODF, '
        'Parcs_NCERT $Parcs_NCERT, '
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
