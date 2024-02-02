

class Client {
  int?    ClientsId = 0;
  String? Clients_Nom = "";
  String? Clients_Adresse1 = "";
  String? Clients_Adresse2 = "";
  String? Clients_Cp = "";
  String? Clients_Ville = "";
  String? Clients_TelF = "";
  String? Clients_TelP = "";
  String? Clients_Mail = "";


  Client({
    this.ClientsId,
    this.Clients_Nom,
    this.Clients_Adresse1,
    this.Clients_Adresse2,
    this.Clients_Cp,
    this.Clients_Ville,
    this.Clients_TelF,
    this.Clients_TelP,
    this.Clients_Mail,
  });

  Map<String, dynamic> toMap() {
    return {

      'ClientsId': ClientsId,
      'Clients_Nom': Clients_Nom,
      'Clients_Adresse1': Clients_Adresse1,
      'Clients_Adresse2': Clients_Adresse2,
      'Clients_Cp': Clients_Cp,
      'Clients_Ville': Clients_Ville,
      'Clients_Tel': Clients_TelF,
      'Clients_Tel': Clients_TelP,
    };
  }

  @override
  String toString() {
    return 'Client{ClientsId: $ClientsId, Clients_Nom: $Clients_Nom}';
  }
}
