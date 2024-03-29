class Groupe {
  int     GroupeId         = -1;
  int     Groupe_ClientId  = -1;
  String  Groupe_Code      = "";
  String  Groupe_Nom      = "";
  String  Groupe_Adr1       = "";
  String  Groupe_Adr2       = "";
  String  Groupe_Adr3       = "";
  String  Groupe_Adr4       = "";
  String  Groupe_CP         = "";
  String  Groupe_Ville      = "";
  String  Groupe_Pays       = "";
  String  Groupe_Acces        = "";
  String  Groupe_Rem        = "";
  String  Livr        = "";
  bool    Groupe_isUpdate = true;

  static GroupeInit() {
    return Groupe(0, 0, "", "", "", "", "", "", "", "", "", "", "", "", false );
  }

  Groupe(
      int     GroupeId         ,
      int     Groupe_ClientId  ,
      String  Groupe_Code      ,
      String  Groupe_Nom      ,
      String  Groupe_Adr1      ,
      String  Groupe_Adr2      ,
      String  Groupe_Adr3      ,
      String  Groupe_Adr4      ,
      String  Groupe_CP        ,
      String  Groupe_Ville     ,
      String  Groupe_Pays      ,
      String  Groupe_Acces       ,
      String  Groupe_Rem       ,
      String  Livr       ,
      bool    Groupe_isUpdate,

  ) {
    this.GroupeId        = GroupeId       ;
    this.Groupe_ClientId = Groupe_ClientId;
    this.Groupe_Code     = Groupe_Code    ;
    this.Groupe_Nom     = Groupe_Nom    ;
    this.Groupe_Adr1     = Groupe_Adr1    ;
    this.Groupe_Adr2     = Groupe_Adr2    ;
    this.Groupe_Adr3     = Groupe_Adr3    ;
    this.Groupe_Adr4     = Groupe_Adr4    ;
    this.Groupe_CP       = Groupe_CP      ;
    this.Groupe_Ville    = Groupe_Ville   ;
    this.Groupe_Pays     = Groupe_Pays    ;
    this.Groupe_Acces      = Groupe_Acces     ;
    this.Groupe_Rem      = Groupe_Rem     ;
    this.Livr      = Livr     ;
    this.Groupe_isUpdate = Groupe_isUpdate     ;
  }

  Map<String, dynamic> toMap() {
    return {
      'GroupeId': GroupeId,
      'Groupe_ClientId': Groupe_ClientId,
      'Groupe_Code': Groupe_Code,
      'Groupe_Nom': Groupe_Nom,
      'Groupe_Adr1': Groupe_Adr1,
      'Groupe_Adr2': Groupe_Adr2,
      'Groupe_Adr3': Groupe_Adr3,
      'Groupe_Adr4': Groupe_Adr4,
      'Groupe_CP': Groupe_CP,
      'Groupe_Ville': Groupe_Ville,
      'Groupe_Pays': Groupe_Pays,
      'Groupe_Acces': Groupe_Acces,
      'Groupe_Rem': Groupe_Rem,
      'Livr': Livr,
      'Groupe_isUpdate': Groupe_isUpdate,
    };
  }


  factory Groupe.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Groupe wUser = Groupe(
      int.parse(json['GroupeId']),
      int.parse(json['Groupe_ClientId']),
      json['Groupe_Code'],
      json['Groupe_Nom'],
      json['Groupe_Adr1'],
      json['Groupe_Adr2'],
      json['Groupe_Adr3'],
      json['Groupe_Adr4'],
      json['Groupe_CP'],
      json['Groupe_Ville'],
      json['Groupe_Pays'],
      json['Groupe_Acces'],
        json['Groupe_Rem'],
      json['Livr'],
      true
    );
    return wUser;
  }

  String Desc() {
    return
            '$GroupeId        '
            '$Groupe_ClientId '
            '$Groupe_Code     '
                '$Groupe_Nom     '
            '$Groupe_Adr1     '
            '$Groupe_Adr2     '
            '$Groupe_Adr3     '
                '$Groupe_Adr4     '
            '$Groupe_CP       '
            '$Groupe_Ville    '
            '$Groupe_Pays     '
            '$Groupe_Acces      '
                '$Groupe_Rem      '
    '$Livr      ';
  }
}
