


import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
     this.isFormPosted = false, 
     this.isValid = false,
     this.email = const Email.pure(),
     this.password = const Password.pure(),
     this.isPosting = false, 
    });

  LoginFormState copyWith({
      bool? isPosting,
      bool? isFormPosted,
      bool? isValid,
      Email? email,
      Password? password,
    }) => LoginFormState(
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
      isPosting: isPosting ?? this.isPosting
    );

  @override
  String toString() {
    return '''
      isFormPosted: $isFormPosted
      isValid: $isValid
      email: $email
      password: $password
      isPosting: $isPosting
  ''';
  }
}




class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;
  LoginFormNotifier({
    required this.loginUserCallback}): super(LoginFormState());

  void onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password])
    );
  }
  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email])
    );
  }
  void _touchedEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password])
    );
  }
  void onFormSubmit() async {
    _touchedEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await loginUserCallback(
      state.email.value,
      state.password.value
    );
    state = state.copyWith(isPosting: false);
  }

}

final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});

