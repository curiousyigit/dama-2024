import 'package:weight_app/data/models/user.dart';

class UsersResponse {
  final List<User> users;
  final int currentPage;
  final int lastPage;

  UsersResponse({required this.users, required this.currentPage, required this.lastPage});

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    var usersList = (json['data'] as List).map((item) => User.fromJson(item)).toList();
    return UsersResponse(
      users: usersList,
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}