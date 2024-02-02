

class Intervention {
  int?    InterventionId = 0;
  int?    Intervention_SiteId = 0;
  String?    Intervention_Date = "";
  String?    Intervention_Type = "";
  String?    Intervention_Status = "";

  String?    Intervention_Remarque = "";
  String?    Livr = "";

  Intervention({
      this.InterventionId,
      this.Intervention_SiteId,
      this.Intervention_Date,
      this.Intervention_Type,
    this.Intervention_Status,
      this.Intervention_Remarque,
    this.Livr,
  });

  Map<String, dynamic> toMap() {
    return {
      'InterventionId': InterventionId,
      'Intervention_SiteId': Intervention_SiteId,
      'Intervention_Date': Intervention_Date,
      'Intervention_Type': Intervention_Type,
      'Intervention_Status': Intervention_Status,
      'Intervention_Remarque': Intervention_Remarque,
      'Livr': Livr,
    };
  }

  @override
  String toString() {
    return 'Inter{IntersId: $InterventionId}';
  }
}
