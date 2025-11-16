



import 'package:teslo_shop/features/auth/auth.dart';

abstract class AuthDatasource {
 Future<User> login(String email, String password);
 Future<User> registrer(String email, String password, String fullName);
 Future<User> checkStatus(String token);
}