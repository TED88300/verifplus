

class Site {
  int?    SitesId = 0;
  int?    Sites_ClientId = 0;
  String? Sites_Nom = "";
  String? Sites_Adresse1 = "";
  String? Sites_Adresse2 = "";
  String? Sites_Cp = "";
  String? Sites_Ville = "";
  String? Sites_TelF = "";
  String? Sites_TelP = "";
  String? Sites_Mail = "";


  Site({
    this.SitesId,
    this.Sites_ClientId,
    this.Sites_Nom,
    this.Sites_Adresse1,
    this.Sites_Adresse2,
    this.Sites_Cp,
    this.Sites_Ville,
    this.Sites_TelF,
    this.Sites_TelP,
    this.Sites_Mail,
  });





  Map<String, dynamic> toMap() {
    return {
      'SitesId': SitesId,
      'Sites_ClientId': Sites_ClientId,
      'Sites_Nom': Sites_Nom,
      'Sites_Adresse1': Sites_Adresse1,
      'Sites_Adresse2': Sites_Adresse2,
      'Sites_Cp': Sites_Cp,
      'Sites_Ville': Sites_Ville,
      'Sites_TelF': Sites_TelF,
      'Sites_TelP': Sites_TelP,
      'Sites_Mail': Sites_Mail,
    };
  }

  @override
  String toString() {
    return 'Site{SitesId: $SitesId, Sites_ClientId : $Sites_ClientId Sites_Nom: $Sites_Nom}';
  }
}
