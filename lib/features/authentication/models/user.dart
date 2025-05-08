import 'dart:convert';

class CurrentUser {
  CurrentUser(
      {required this.name,
      required this.age,
      required this.role,
      required this.email,
      required this.address,
      required this.job,
      required this.phone,
      required this.interests
      });

  final String name;
  final int age;
  final String role;
  final String email;
  final String phone;
  final String job;
  final String address;
  final List<String> interests ;

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      name: json['name'],
      age: json['age'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      job: json['job'],
      address: json['address'],
      interests: List<String>.from(json['interests']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'role': role,
      'email' : email,
      'phone' : phone,
      'job' : job ,
      'address' : address,
      'interests' : interests ,
    };
  }

  static CurrentUser fromJsonString(String jsonString) {
    return CurrentUser.fromJson(json.decode(jsonString));
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}
