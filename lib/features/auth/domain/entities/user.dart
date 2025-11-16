

class User {
    final String id;
    final String email;
    final String fullName;
    final List<String> roles;
    final String token;

    User({
        required this.id,
        required this.email,
        required this.roles,
        required this.token,
        required this.fullName,
    });

    bool get isAdmin {
      return roles.contains('admin');
    }
}