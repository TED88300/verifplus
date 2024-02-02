

class Inter {
  int?    IntersId = 0;
  int?    Inters_ArticleId = 0;
  String? Inters_Article = "";
  int?    Inters_Qte = 0;
  int?    Inters_Fact = 0;
  bool?   Inters_sel = false;



  Inter(
    this.IntersId,
    this.Inters_ArticleId,
    this.Inters_Article,
    this.Inters_Qte,
    this.Inters_Fact,
      this.Inters_sel,

  );

  Map<String, dynamic> toMap() {
    return {

      'IntersId': IntersId,
      'Inters_ArticleId': Inters_ArticleId,
      'Inters_Article': Inters_Article,
      'Inters_Qte': Inters_Qte,
      'Inters_Fact': Inters_Fact,
      'Inters_sel': Inters_sel,

    };
  }

  @override
  String toString() {
    return 'Inter{IntersId: $IntersId}';
  }
}
