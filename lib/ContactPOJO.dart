class ContactPOJO {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? gender;

  ContactPOJO({this.id,required this.name,required this.phone,this.email,this.address,this.gender});

  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phone, 'email' : email, 'address' : address, 'gender' : gender};
  }

  factory ContactPOJO.fromMap(Map<String, dynamic> map) {
    return ContactPOJO(id: map['id'], name: map['name'], phone: map['phone'], email: map['email'], address: map['address'], gender: map['gender']);
  }
  }
