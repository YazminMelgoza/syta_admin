class AdministratorModel {
  String name;
  String uid;
  String locationId;

  AdministratorModel({
    required this.name,
    required this.uid,
    required this.locationId
  });

  factory AdministratorModel.fromMap(Map<String, dynamic> map) {
    return AdministratorModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      locationId: map['locationId'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'locationId': locationId
    };
  } 
}