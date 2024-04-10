class LocationModel {
  final String name;
  final String address;
  final String availability;
  final String phoneNumber;
  final String landlineNumber;

  LocationModel({
    required this.name, 
    required this.address, 
    required this.availability,
    required this.landlineNumber,
    required this.phoneNumber
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      address: json['address'],
      availability: json['availability'],
      phoneNumber: json['phoneNumber'],
      landlineNumber: json['landlineNumber']
    );
  }
}