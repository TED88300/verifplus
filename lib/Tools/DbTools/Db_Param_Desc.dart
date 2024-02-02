
class Param_Desc {
  int?      Param_DescId = 0;
  String?   Param_Desc_Type = "";
  String?   Param_Desc_Id = "";
  String?   Param_Desc_Label = "";
  String?   Param_Desc_Aide = "";

  Param_Desc({
    this.Param_DescId,
    this.Param_Desc_Type,
    this.Param_Desc_Id,
    this.Param_Desc_Label,
    this.Param_Desc_Aide,

  });

  Map<String, dynamic> toMap() {
    return {
      'Param_DescId': Param_DescId,
      'Param_Desc_Type': Param_Desc_Type,
      'Param_Desc_Id': Param_Desc_Id,
      'Param_Desc_Label': Param_Desc_Label,
      'Param_Desc_Aide': Param_Desc_Aide,

    };
  }

  @override
  String toString() {
    return 'Inter{IntersId: $Param_DescId}';
  }
}
