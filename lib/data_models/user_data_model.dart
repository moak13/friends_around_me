class UserDataModel {
  String id;
  String? email;
  String? firstName;
  String? lastName;

  UserDataModel({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  UserDataModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return UserDataModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
