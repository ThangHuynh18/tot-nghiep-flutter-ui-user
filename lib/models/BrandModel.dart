// ignore_for_file: file_names
class Brand {
  late String description;
  late bool deleted;
  late String sId;
  late String name;
  late String createdAt;
  late String updatedAt;
  late int iV;

  Brand(
      {required this.description,
        required this.deleted,
        required this.sId,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
        required this.iV});

  Brand.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    deleted = json['deleted'];
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['deleted'] = this.deleted;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}