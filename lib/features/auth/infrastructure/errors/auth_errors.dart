

class WrongCredentials implements Exception{}
class InvalidToken implements Exception{}
class ConnectionTimeout implements Exception{}
class CustormError implements Exception {
  final String message;
 // final int errorCode;

  CustormError(this.message);
  
}