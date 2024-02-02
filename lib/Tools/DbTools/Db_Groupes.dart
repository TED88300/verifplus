

class Groupe {
  int?    GroupesId = 0;
  int?    Groupes_SitesId = 0;
  String? Groupes_Nom = "";
  String? Groupes_Adresse1 = "";
  String? Groupes_Adresse2 = "";
  String? Groupes_Cp = "";
  String? Groupes_Ville = "";
  String? Groupes_TelF = "";
  String? Groupes_TelP = "";
  String? Groupes_Mail = "";


  Groupe({
    this.GroupesId,
    this.Groupes_SitesId,
    this.Groupes_Nom,
    this.Groupes_Adresse1,
    this.Groupes_Adresse2,
    this.Groupes_Cp,
    this.Groupes_Ville,
    this.Groupes_TelF,
    this.Groupes_TelP,
    this.Groupes_Mail,
  });

  Map<String, dynamic> toMap() {
    return {
      'GroupesId': GroupesId,
      'Groupes_SitesId': Groupes_SitesId,
      'Groupes_Nom': Groupes_Nom,
      'Groupes_Adresse1': Groupes_Adresse1,
      'Groupes_Adresse2': Groupes_Adresse2,
      'Groupes_Cp': Groupes_Cp,
      'Groupes_Ville': Groupes_Ville,
      'Groupes_TelF': Groupes_TelF,
      'Groupes_TelP': Groupes_TelP,
      'Groupes_Mail': Groupes_Mail,
    };
  }

  @override
  String toString() {
    return 'Groupe{GroupesId: $GroupesId, Groupes_SitesId : $Groupes_SitesId Groupes_Nom: $Groupes_Nom}';
  }
}
