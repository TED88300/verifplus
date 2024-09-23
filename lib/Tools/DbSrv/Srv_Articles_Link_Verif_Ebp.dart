
class Result_Article_Link_Verif_Indisp {
  String Articles_Link_Verif_TypeVerif = "";

  static Result_Article_Link_VerifInit() {
    return Result_Article_Link_Verif_Indisp("");
  }

  Result_Article_Link_Verif_Indisp(String Articles_Link_Verif_TypeVerif) {
    this.Articles_Link_Verif_TypeVerif = Articles_Link_Verif_TypeVerif;
  }

  factory Result_Article_Link_Verif_Indisp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Result_Article_Link_Verif_Indisp wResult_Article_Link_Verif_Indisp = Result_Article_Link_Verif_Indisp(
      json['Articles_Link_Verif_TypeVerif'],
    );
    return wResult_Article_Link_Verif_Indisp;
  }

  String Desc() {
    return '$Articles_Link_Verif_TypeVerif';
  }
}



class Result_Article_Link_Verif {
  String ParentID = "";
  String TypeChildID = "";
  String ChildID = "";
  double Qte = 0;

  String? Fact = "";
  String? Livr = "";

  bool isOU = false;

  static Result_Article_Link_VerifInit() {
    return Result_Article_Link_Verif("", "", "", 0, "Fact.", "Livré", false);
  }

  Result_Article_Link_Verif(String ParentID, String TypeChildID, String ChildID, double Qte, String Fact, String Livr, bool isOU) {
    this.ParentID = ParentID;
    this.TypeChildID = TypeChildID;
    this.ChildID = ChildID;
    this.Qte = Qte;
    this.Fact = Fact;
    this.Livr = Livr;
    this.isOU = isOU;
  }

  factory Result_Article_Link_Verif.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Result_Article_Link_Verif wResult_Article_Link_Verif = Result_Article_Link_Verif(
      json['ParentID'],
      json['TypeChildID'],
      json['ChildID'],
      double.parse(json['Qte']),
      json['Fact'],
      json['Livr'],
      false,
    );
    return wResult_Article_Link_Verif;
  }

  String Desc() {
    return '$ParentID, $TypeChildID, $ChildID, $Qte, $Fact, $Livr';
  }
}

class Article_Link_Verif_Ebp {
  int    Articles_Link_VerifId            = 0;
  String Articles_Link_Verif_ParentID     = "";
  String Articles_Link_Verif_TypeChildID  = "";
  String Articles_Link_Verif_ChildID      = "";
  String Articles_Link_Verif_TypeVerif    = "";
  double Articles_Link_Verif_Qte          = 0;

  String Articles_Link_Verif_Indisponible      = "";
  String Articles_Link_Verif_ChildID_Lib      = "";

  static Article_Link_Verif_EbpInit() {
    return Article_Link_Verif_Ebp(0, "", "", "", "", 0, "");
  }

  Article_Link_Verif_Ebp(int    Articles_Link_VerifId, String Articles_Link_Verif_ParentID, String Articles_Link_Verif_TypeChildID, String Articles_Link_Verif_ChildID,String Articles_Link_Verif_TypeVerif, double Articles_Link_Verif_Qte,String Articles_Link_Verif_Indisponible) {
    this.Articles_Link_VerifId           =  Articles_Link_VerifId;
    this.Articles_Link_Verif_ParentID    =  Articles_Link_Verif_ParentID;
    this.Articles_Link_Verif_TypeChildID =  Articles_Link_Verif_TypeChildID;
    this.Articles_Link_Verif_ChildID     =  Articles_Link_Verif_ChildID;
    this.Articles_Link_Verif_TypeVerif	 =  Articles_Link_Verif_TypeVerif;
    this.Articles_Link_Verif_Qte	       =  Articles_Link_Verif_Qte;
    this.Articles_Link_Verif_Indisponible	       =  Articles_Link_Verif_Indisponible;


  }

  factory Article_Link_Verif_Ebp.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Article_Link_Verif_Ebp warticlesLinkVerifEbp = Article_Link_Verif_Ebp(
      int.parse(json['Articles_Link_VerifId']),
      json['Articles_Link_Verif_ParentID'],
      json['Articles_Link_Verif_TypeChildID'],
      json['Articles_Link_Verif_ChildID'],
      json['Articles_Link_Verif_TypeVerif'],
      double.parse(json['Articles_Link_Verif_Qte']),
      json['Articles_Link_Verif_Indisponible'],

    );

    return warticlesLinkVerifEbp;
  }

  String Desc() {
    return '$Articles_Link_VerifId, '
        '$Articles_Link_VerifId          , '

        '$Articles_Link_Verif_ParentID   , '
        '$Articles_Link_Verif_TypeChildID, '
        '$Articles_Link_Verif_ChildID    , '
        '$Articles_Link_Verif_TypeVerif	      , '
        '$Articles_Link_Verif_Qte	      , '
        '$Articles_Link_Verif_Indisponible	      , '

    ;

  }
}
