import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterRequestModel {
  late String? id;
  late String? fullName;
  late String? businessName;
  late String? email;
  late String? location;
  late String? phoneNumber;
  late int? userType;
  late String password;
  bool enabledUser;
  bool admin;
  String comment;

  RegisterRequestModel(
      {this.fullName,
      this.email,
      this.id = '',
      this.businessName = '',
      this.location,
      this.comment = '',
      this.enabledUser = true,
      this.admin = false,
      this.password = '',
      this.userType,
      this.phoneNumber});
  // 3
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _registerFromJson(json);
  // 4
  Map<String, dynamic> toJson() => _registerToJson(this);

  factory RegisterRequestModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      {SnapshotOptions? options}) {
    final data = snapshot.data();
    print(data);
    return RegisterRequestModel(
      id: snapshot.id,
      admin: (data!['admin'] as bool),
      fullName: (data['fullName'] as String),
      email: (data['email'] as String),
      businessName: (data['businessName'] as String),
      location: (data['location'] as String),
      enabledUser: (data['enabledUser'] as bool),
      userType: (data['userType'] as int),
      phoneNumber: (data['phoneNumber'] as String),
    );
  }
}

RegisterRequestModel _registerFromJson(Map<String, dynamic> json) {
  return RegisterRequestModel(
    fullName: json['fullName'] as String,
    businessName:
        json['businessName'] != null ? json['businessName'] as String : '',
    email: json['email'] as String,
    location: json['location'] as String,
    phoneNumber: json['phoneNumber'] as String,
    userType: json['userType'] as int,
    enabledUser:
        json['enabledUser'] != null ? json['enabledUser'] as bool : true,
    comment: json['comment'] != null ? json['comment'] as String : '',
  );
}

// 2
Map<String, dynamic> _registerToJson(RegisterRequestModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'businessName': instance.businessName,
      'email': instance.email,
      'admin': false,
      'location': instance.location,
      'phoneNumber': instance.phoneNumber,
      'userType': instance.userType,
      'enabledUser': instance.enabledUser,
      'comment': instance.comment,
    };
