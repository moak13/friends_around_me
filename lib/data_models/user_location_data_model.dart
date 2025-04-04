class UserLocationDataModel {
  final String? id;
  final String? userId;
  final String? userFirstName;
  final String? userLastName;
  final double? latitude;
  final double? longitude;

  UserLocationDataModel({
    this.id,
    this.userId,
    this.userFirstName,
    this.userLastName,
    this.latitude,
    this.longitude,
  });

  factory UserLocationDataModel.fromJson(Map<String, dynamic> json) {
    return UserLocationDataModel(
      id: json['id'],
      userId: json['userId'],
      userFirstName: json['userFirstName'],
      userLastName: json['userLastName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  UserLocationDataModel copyWith({
    String? id,
    String? userId,
    String? userFirstName,
    String? userLastName,
    double? latitude,
    double? longitude,
  }) {
    return UserLocationDataModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userFirstName: userFirstName ?? this.userFirstName,
      userLastName: userLastName ?? this.userLastName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
