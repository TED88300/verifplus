class Adresse {
  int AdresseId = -1;
  int Adresse_ClientId = -1;
  String Adresse_Code = "";
  String Adresse_Type = "";
  String Adresse_Nom = "";
  String Adresse_Adr1 = "";
  String Adresse_Adr2 = "";
  String Adresse_Adr3 = "";
  String Adresse_Adr4 = "";
  String Adresse_CP = "";
  String Adresse_Ville = "";
  String Adresse_Pays = "";
  String Adresse_Acces = "";

  String Adresse_Rem = "";

  bool Adresse_isUpdate = true;


  static AdresseInit() {
    return Adresse(0, 0, "", "", "", "", "", "", "", "", "", "","","", false);
  }

  Adresse(
    int    AdresseId,
    int    Adresse_ClientId,
    String Adresse_Code,
    String Adresse_Type,
    String Adresse_Nom,
    String Adresse_Adr1,
    String Adresse_Adr2,
    String Adresse_Adr3,
    String Adresse_Adr4,
    String Adresse_CP,
    String Adresse_Ville,
    String Adresse_Pays,
      String Adresse_Acces,
    String Adresse_Rem,
      bool Adresse_isUpdate,
  ) {
    this.AdresseId = AdresseId;
    this.Adresse_ClientId = Adresse_ClientId;
    this.Adresse_Code = Adresse_Code;
    this.Adresse_Type = Adresse_Type;
    this.Adresse_Nom = Adresse_Nom;
    this.Adresse_Adr1 = Adresse_Adr1;
    this.Adresse_Adr2 = Adresse_Adr2;
    this.Adresse_Adr3 = Adresse_Adr3;
    this.Adresse_Adr4 = Adresse_Adr4;
    this.Adresse_CP = Adresse_CP;
    this.Adresse_Ville = Adresse_Ville;
    this.Adresse_Pays = Adresse_Pays;
    this.Adresse_Acces = Adresse_Acces;
    this.Adresse_Rem = Adresse_Rem;
    this.Adresse_isUpdate = Adresse_isUpdate;
  }

  Map<String, dynamic> toMap() {

    return {
      'AdresseId': AdresseId,
      'Adresse_ClientId': Adresse_ClientId,
      'Adresse_Code': Adresse_Code,
      'Adresse_Type': Adresse_Type,
      'Adresse_Nom': Adresse_Nom,
      'Adresse_Adr1': Adresse_Adr1,
      'Adresse_Adr2': Adresse_Adr2,
      'Adresse_Adr3': Adresse_Adr3,
      'Adresse_Adr4': Adresse_Adr4,
      'Adresse_CP': Adresse_CP,
      'Adresse_Ville': Adresse_Ville,
      'Adresse_Pays': Adresse_Pays,
      'Adresse_Acces': Adresse_Acces,
      'Adresse_Rem': Adresse_Rem,
      'Adresse_isUpdate': Adresse_isUpdate,
    };
  }


  factory Adresse.fromJson(Map<String, dynamic> json) {
//    print("json $json");
    Adresse wUser = Adresse(int.parse(json['AdresseId']),
        int.parse(json['Adresse_ClientId']),
        json['Adresse_Code'],
        json['Adresse_Type'],
        json['Adresse_Nom'],
        json['Adresse_Adr1'],
        json['Adresse_Adr2'],
        json['Adresse_Adr3'],
        json['Adresse_Adr4'],
        json['Adresse_CP'],
        json['Adresse_Ville'],
        json['Adresse_Pays'],
        json['Adresse_Acces'],
        json['Adresse_Rem'],
        true,
    );
    return wUser;
  }

  String Desc() {
    return '$AdresseId        '
        '$Adresse_ClientId '
        '$Adresse_Code     '
        '$Adresse_Type     '
        '$Adresse_Nom     '
        '$Adresse_Adr1     '
        '$Adresse_Adr2     '
        '$Adresse_Adr3     '
        '$Adresse_Adr4     '
        '$Adresse_CP       '
        '$Adresse_Ville    '
        '$Adresse_Pays     '
        '$Adresse_Acces     '
        '$Adresse_isUpdate      ';
  }
}
