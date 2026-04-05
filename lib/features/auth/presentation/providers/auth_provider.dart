import 'package:flutter/foundation.dart';
import '../../domain/entities/conjuge.dart';
import '../../domain/entities/casal.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthProvider({required this.loginUseCase, required this.logoutUseCase});

  Conjuge? conjuge;
  Casal? casal;
  bool carregando = false;
  String? erro;

  Future<void> login({required String email, required String senha}) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      conjuge = await loginUseCase(email: email, senha: senha);
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    carregando = true;
    notifyListeners();

    try {
      await logoutUseCase();
      conjuge = null;
      casal = null;
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
