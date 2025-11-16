
import 'package:teslo_shop/features/auth/auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({
    AuthDatasource? datasource}) 
    : datasource = datasource ?? LoginDatasource();
  @override
  Future<User> checkStatus(String token) {
    return datasource.checkStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
     return datasource.login(email, password);
  }

  @override
  Future<User> registrer(String email, String password, String fullName) {
     return datasource.registrer(email, password, fullName);
  }
}
