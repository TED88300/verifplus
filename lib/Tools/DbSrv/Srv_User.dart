class UserH {
  String User_Nom = "";
  String User_Prenom = "";
  double H = 0;

  UserH(String User_Nom, String User_Prenom, double H) {
    this.User_Nom = User_Nom;
    this.User_Prenom = User_Prenom;
    this.H = H;
  }

  factory UserH.fromJson(Map<String, dynamic> json) {
    UserH wUserH = UserH(
      json['User_Nom'],
      json['User_Prenom'],
      double.parse(json['H']),
    );
    return wUserH;
  }
}

class User {
  int UserID = 0;
  bool User_Actif = true;
  String User_Token_FBM = "";
  String User_Matricule = "";
  String User_Nom = "";
  String User_Prenom = "";
  String User_Adresse1 = "";
  String User_Adresse2 = "";
  String User_Cp = "";
  String User_Ville = "";
  String User_Tel = "";
  String User_Mail = "";
  String User_PassWord = "";
  String User_Service = "";
  String User_Fonction = "";
  String User_Famille = "";
  String User_Depot = "";
  int User_NivHabID = 0;
  bool User_Niv_Isole = true;
  String User_TypeUser = "";
  String User_Art_Fav = "";

  String User_DCL_Ent_Validite = "";
  String User_DCL_Ent_LivrPrev = "";
  String User_DCL_Ent_ModeRegl = "";
  String User_DCL_Ent_MoyRegl = "";
  int    User_DCL_Ent_Valo = 1;
  String User_DCL_Ent_PrefAff = "";
  String User_DCL_Ent_RelAuto = "";
  String User_DCL_Ent_RelAnniv = "";
  String User_DCL_Ent_CopRel = "";

  static UserInit() {
    return User(0, false, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0, false, "", "", "", "", "", "", 0, "", "", "", "");
  }

  User(
    int UserID,
    bool User_Actif,
    String User_Token_FBM,
    String User_Matricule,
    String User_Nom,
    String User_Prenom,
    String User_Adresse1,
    String User_Adresse2,
    String User_Cp,
    String User_Ville,
    String User_Tel,
    String User_Mail,
    String User_PassWord,
    String User_Service,
    String User_Fonction,
    String User_Famille,
    String User_Depot,
    int User_NivHabID,
    bool User_Niv_Isole,
    String User_TypeUser,
    String User_Art_Fav,
    String User_DCL_Ent_Validite,
    String User_DCL_Ent_LivrPrev,
    String User_DCL_Ent_ModeRegl,
    String User_DCL_Ent_MoyRegl,
    int User_DCL_Ent_Valo,
    String User_DCL_Ent_PrefAff,
    String User_DCL_Ent_RelAuto,
    String User_DCL_Ent_RelAnniv,
    String User_DCL_Ent_CopRel,
  ) {
    this.UserID = UserID;
    this.User_Actif = User_Actif;
    this.User_Token_FBM = User_Token_FBM;
    this.User_Matricule = User_Matricule;
    this.User_Nom = User_Nom;
    this.User_Prenom = User_Prenom;
    this.User_Adresse1 = User_Adresse1;
    this.User_Adresse2 = User_Adresse2;
    this.User_Cp = User_Cp;
    this.User_Ville = User_Ville;
    this.User_Tel = User_Tel;
    this.User_Mail = User_Mail;
    this.User_PassWord = User_PassWord;
    this.User_Service = User_Service;
    this.User_Fonction = User_Fonction;
    this.User_Famille = User_Famille;
    this.User_Depot = User_Depot;

    this.User_NivHabID = User_NivHabID;
    this.User_Niv_Isole = User_Niv_Isole;
    this.User_TypeUser = User_TypeUser;
    this.User_Art_Fav = User_Art_Fav;

    this.User_DCL_Ent_Validite = User_DCL_Ent_Validite;
    this.User_DCL_Ent_LivrPrev = User_DCL_Ent_LivrPrev;
    this.User_DCL_Ent_ModeRegl = User_DCL_Ent_ModeRegl;
    this.User_DCL_Ent_MoyRegl = User_DCL_Ent_MoyRegl;
    this.User_DCL_Ent_Valo = User_DCL_Ent_Valo;
    this.User_DCL_Ent_PrefAff = User_DCL_Ent_PrefAff;
    this.User_DCL_Ent_RelAuto = User_DCL_Ent_RelAuto;
    this.User_DCL_Ent_RelAnniv = User_DCL_Ent_RelAnniv;
    this.User_DCL_Ent_CopRel = User_DCL_Ent_CopRel;
  }

  Map<String, dynamic> toMap() {
    return {
      'UserID': UserID,
      'User_Actif': User_Actif.toString(),
      'User_Token_FBM': User_Token_FBM,
      'User_Matricule': User_Matricule,
      'User_Nom': User_Nom,
      'User_Prenom': User_Prenom,
      'User_Adresse1': User_Adresse1,
      'User_Adresse2': User_Adresse2,
      'User_Cp': User_Cp,
      'User_Ville': User_Ville,
      'User_Tel': User_Tel,
      'User_Mail': User_Mail,
      'User_PassWord': User_PassWord,
      'User_Service': User_Service,
      'User_Fonction': User_Fonction,
      'User_Famille': User_Famille,
      'User_Depot': User_Depot,
      'User_NivHabID': User_NivHabID,
      'User_Niv_Isole': User_Niv_Isole.toString(),
      'User_TypeUser': User_TypeUser,
      'User_Art_Fav': User_Art_Fav,
      'User_DCL_Ent_Validite': User_DCL_Ent_Validite,
      'User_DCL_Ent_LivrPrev': User_DCL_Ent_LivrPrev,
      'User_DCL_Ent_ModeRegl': User_DCL_Ent_ModeRegl,
      'User_DCL_Ent_MoyRegl': User_DCL_Ent_MoyRegl,
      'User_DCL_Ent_Valo': User_DCL_Ent_Valo,
      'User_DCL_Ent_PrefAff': User_DCL_Ent_PrefAff,
      'User_DCL_Ent_RelAuto': User_DCL_Ent_RelAuto,
      'User_DCL_Ent_RelAnniv': User_DCL_Ent_RelAnniv,
      'User_DCL_Ent_CopRel': User_DCL_Ent_CopRel
    };
  }

  static User fromMap(Map<String, dynamic> map) {

    String userDclEntValidite      = "${map['User_DCL_Ent_Validite']}";
    String userDclEntLivrprev      = "${map["User_DCL_Ent_LivrPrev"]}";
    String userDclEntModeregl      = "${map["User_DCL_Ent_ModeRegl"]}";
    String userDclEntMoyregl       = "${map["User_DCL_Ent_MoyRegl"]}";
    String userDclEntPrefaff       = "${map["User_DCL_Ent_PrefAff"]}";
    String userDclEntRelauto       = "${map["User_DCL_Ent_RelAuto"]}";
    String userDclEntRelanniv      = "${map["User_DCL_Ent_RelAnniv"]}";
    String userUserDclEntCoprel   = "${map["User_User_DCL_Ent_CopRel"]}";


    if (userDclEntValidite    == "null") userDclEntValidite     = "";
    if (userDclEntLivrprev    == "null") userDclEntLivrprev     = "";
    if (userDclEntModeregl    == "null") userDclEntModeregl     = "";
    if (userDclEntMoyregl     == "null") userDclEntMoyregl      = "";
    if (userDclEntPrefaff     == "null") userDclEntPrefaff      = "";
    if (userDclEntRelauto     == "null") userDclEntRelauto      = "";
    if (userDclEntRelanniv    == "null") userDclEntRelanniv     = "";
    if (userUserDclEntCoprel == "null") userUserDclEntCoprel  = "";


    return User(
      map["UserID"],
      map['User_Actif'].toString() == 'true',
      map["User_Token_FBM"],
      map["User_Matricule"],
      map["User_Nom"],
      map["User_Prenom"],
      map["User_Adresse1"],
      map["User_Adresse2"],
      map["User_Cp"],
      map["User_Ville"],
      map["User_Tel"],
      map["User_Mail"],
      map["User_PassWord"],
      map["User_Service"],
      map["User_Fonction"],
      map["User_Famille"],
      map["User_Depot"],
      map["User_NivHabID"],
      map['User_Niv_Isole'].toString() == 'true',
      map["User_TypeUser"],
      map["User_Art_Fav"],
        userDclEntValidite,
        userDclEntLivrprev,
        userDclEntModeregl,
        userDclEntMoyregl,
        int.tryParse("${map["User_DCL_Ent_Valo"]}") ?? 1,
        userDclEntPrefaff,
        userDclEntRelauto,
        userDclEntRelanniv,
        userUserDclEntCoprel
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    int iuserActif = int.parse(json['User_Actif'].toString());
    bool buserActif = (iuserActif == 1);
    int iuserNivIsole = int.parse(json['User_Niv_Isole'].toString());
    bool buserNivIsole = (iuserNivIsole == 1);


    String userDclEntValidite      = "${json['User_DCL_Ent_Validite']}";
    String userDclEntLivrprev      = "${json["User_DCL_Ent_LivrPrev"]}";
    String userDclEntModeregl      = "${json["User_DCL_Ent_ModeRegl"]}";
    String userDclEntMoyregl       = "${json["User_DCL_Ent_MoyRegl"]}";
    String userDclEntPrefaff       = "${json["User_DCL_Ent_PrefAff"]}";
    String userDclEntRelauto       = "${json["User_DCL_Ent_RelAuto"]}";
    String userDclEntRelanniv      = "${json["User_DCL_Ent_RelAnniv"]}";
    String userUserDclEntCoprel   = "${json["User_User_DCL_Ent_CopRel"]}";


    if (userDclEntValidite    == "null") userDclEntValidite     = "";
    if (userDclEntLivrprev    == "null") userDclEntLivrprev     = "";
    if (userDclEntModeregl    == "null") userDclEntModeregl     = "";
    if (userDclEntMoyregl     == "null") userDclEntMoyregl      = "";
    if (userDclEntPrefaff     == "null") userDclEntPrefaff      = "";
    if (userDclEntRelauto     == "null") userDclEntRelauto      = "";
    if (userDclEntRelanniv    == "null") userDclEntRelanniv     = "";
    if (userUserDclEntCoprel == "null") userUserDclEntCoprel  = "";












    User wUser = User(
      int.parse(json['UserID'].toString()),
      buserActif,
      json['User_Token_FBM'],
      json['User_Matricule'],
      json['User_Nom'],
      json['User_Prenom'],
      json['User_Adresse1'],
      json['User_Adresse2'],
      json['User_Cp'],
      json['User_Ville'],
      json['User_Tel'],
      json['User_Mail'],
      json['User_PassWord'],
      json['User_Service'],
      json['User_Fonction'],
      json['User_Famille'],
      json['User_Depot'],
      int.parse(json['User_NivHabID'].toString()),
      buserNivIsole,
      json['User_TypeUser'],
      json['User_Art_Fav'],
        userDclEntValidite,
        userDclEntLivrprev,
        userDclEntModeregl,
        userDclEntMoyregl,
        int.tryParse("${json["User_DCL_Ent_Valo"]}") ?? 1,
        userDclEntPrefaff,
        userDclEntRelauto,
        userDclEntRelanniv,
        userUserDclEntCoprel
    );
    return wUser;
  }

  String Desc() {
    return '$UserID $User_Matricule $User_Nom $User_Prenom $User_Adresse1 $User_Adresse2 $User_Cp $User_Ville $User_Mail $User_Service $User_Fonction $User_Famille $User_Depot $User_NivHabID $User_Niv_Isole $User_TypeUser';
  }
}
