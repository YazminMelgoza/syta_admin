class UserModel {
  String name;
  String email;
  String phoneNumber;
  String profilePicture;
  String createdAt;
  String uid;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.createdAt,
    required this.uid
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      createdAt: map['createdAt'] ?? '',
      uid: map['uid'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
      'uid': uid
    };
  } 
}