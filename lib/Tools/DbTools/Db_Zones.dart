

class Zone {
  int?    ZonesId = 0;
  int?    Zones_ClientId = 0;
  String? Zones_Nom = "";
  String? Zones_Adresse1 = "";
  String? Zones_Adresse2 = "";
  String? Zones_Cp = "";
  String? Zones_Ville = "";
  String? Zones_TelF = "";
  String? Zones_TelP = "";
  String? Zones_Mail = "";


  Zone({
    this.ZonesId,
    this.Zones_ClientId,
    this.Zones_Nom,
    this.Zones_Adresse1,
    this.Zones_Adresse2,
    this.Zones_Cp,
    this.Zones_Ville,
    this.Zones_TelF,
    this.Zones_TelP,
    this.Zones_Mail,
  });





  Map<String, dynamic> toMap() {
    return {
      'ZonesId': ZonesId,
      'Zones_ClientId': Zones_ClientId,
      'Zones_Nom': Zones_Nom,
      'Zones_Adresse1': Zones_Adresse1,
      'Zones_Adresse2': Zones_Adresse2,
      'Zones_Cp': Zones_Cp,
      'Zones_Ville': Zones_Ville,
      'Zones_TelF': Zones_TelF,
      'Zones_TelP': Zones_TelP,
      'Zones_Mail': Zones_Mail,
    };
  }

  @override
  String toString() {
    return 'Zone{ZonesId: $ZonesId, Zones_ClientId : $Zones_ClientId Zones_Nom: $Zones_Nom}';
  }
}
