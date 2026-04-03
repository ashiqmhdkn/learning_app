import 'package:hive/hive.dart';

part 'user.g.dart'; // generated file

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String role;

  @HiveField(4)
  String? phone;

  @HiveField(5)
  late String image;
}