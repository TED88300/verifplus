class Api_Adresse {
  String? type;
  String? version;
  List<Features>? features;
  String? attribution;
  String? licence;
  String? query;
  int? limit;

  Api_Adresse(
      {this.type,
        this.version,
        this.features,
        this.attribution,
        this.licence,
        this.query,
        this.limit});

  Api_Adresse.fromJson(Map<dynamic, dynamic> json) {
    type = json['type'];
    version = json['version'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
    licence = json['licence'];
    query = json['query'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['version'] = version;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    data['attribution'] = attribution;
    data['licence'] = licence;
    data['query'] = query;
    data['limit'] = limit;
    return data;
  }
}

class Features {
  String? type;
  Geometry? geometry;
  Properties? properties;

  Features({this.type, this.geometry, this.properties});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    geometry = json['geometry'] != null
        ? Geometry.fromJson(json['geometry'])
        : null;
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Properties {
  String? label;
  double? score;
  String? housenumber;
  String? id;
  String? name;
  String? postcode;
  String? citycode;
  double? x;
  double? y;
  String? city;
  String? context;
  String? type;
  double? importance;
  String? street;

  Properties(
      {this.label,
        this.score,
        this.housenumber,
        this.id,
        this.name,
        this.postcode,
        this.citycode,
        this.x,
        this.y,
        this.city,
        this.context,
        this.type,
        this.importance,
        this.street});

  Properties.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    score = json['score'];
    housenumber = json['housenumber'];
    id = json['id'];
    name = json['name'];
    postcode = json['postcode'];
    citycode = json['citycode'];
    x = json['x'];
    y = json['y'];
    city = json['city'];
    context = json['context'];
    type = json['type'];
    importance = json['importance'];
    street = json['street'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['score'] = score;
    data['housenumber'] = housenumber;
    data['id'] = id;
    data['name'] = name;
    data['postcode'] = postcode;
    data['citycode'] = citycode;
    data['x'] = x;
    data['y'] = y;
    data['city'] = city;
    data['context'] = context;
    data['type'] = type;
    data['importance'] = importance;
    data['street'] = street;
    return data;
  }
}
