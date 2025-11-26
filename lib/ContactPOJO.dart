class ContactPOJO {
  int? id;
  String? name;
  String? phone;

  ContactPOJO({this.id,required this.name,required this.phone});

  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phone};
  }

  factory ContactPOJO.fromMap(Map<String, dynamic> map) {
    return ContactPOJO(id: map['id'], name: map['name'], phone: map['phone']);
  }
  }
