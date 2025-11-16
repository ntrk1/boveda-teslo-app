

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';


import 'package:teslo_shop/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: Enviroment.apiUrl
  )
);


class LoginDatasource extends AuthDatasource {
  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login',
      data: {
        'email': email,
        'password': password
      });
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustormError(e.response?.data['message']
        ?? 'Credenciales incorrectas' );
      }
      if (e.type == DioExceptionType.connectionTimeout)
       {throw CustormError('Sin conexion');}
       if (e.type == DioExceptionType.connectionError)
       {throw CustormError('Error sockets');}
      throw Exception();
    } catch (e) {
      throw CustormError('Error customizado');
  }
  }
  @override
  Future<User> checkStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status', 
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if(e.type == DioExceptionType.connectionTimeout) {
        CustormError('Timeout');
      }
      if(e.response?.statusCode == 401) {
        throw CustormError('Dispositivo no autorizado');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }


  @override
  Future<User> registrer(String email, String password, String fullName) {
    // TODO: implement registrer
    throw UnimplementedError();
  }
  
}
