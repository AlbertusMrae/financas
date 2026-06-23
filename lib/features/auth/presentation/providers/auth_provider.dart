import 'package:flutter/foundation.dart';

import '../../domain/entities/casal.dart';
import '../../domain/entities/conjuge.dart';
import '../../domain/entities/papel_no_casal.dart';
import '../../domain/usecases/buscar_casal_opcional_usecase.dart';
import '../../domain/usecases/buscar_casal_usecase.dart';
import '../../domain/usecases/buscar_conjuge_opcional_usecase.dart';
import '../../domain/usecases/completar_perfil_conjuge_usecase.dart';
import '../../domain/usecases/registrar_conta_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required this.signInUseCase,
    required this.buscarConjugeOpcionalUseCase,
    required this.buscarCasalOpcionalUseCase,
    required this.buscarCasalUseCase,
    required this.registrarContaUseCase,
    required this.completarPerfilConjugeUseCase,
    required this.logoutUseCase,
  });

  final SignInUseCase signInUseCase;
  final BuscarConjugeOpcionalUseCase buscarConjugeOpcionalUseCase;
  final BuscarCasalOpcionalUseCase buscarCasalOpcionalUseCase;
  final BuscarCasalUseCase buscarCasalUseCase;
  final RegistrarContaUseCase registrarContaUseCase;
  final CompletarPerfilConjugeUseCase completarPerfilConjugeUseCase;
  final LogoutUseCase logoutUseCase;

  Conjuge? conjuge;
  Casal? casal;
  bool carregando = false;
  String? erro;

  /// Sessão Auth ok, mas falta `conjuges`/`casais` no banco.
  bool precisaCompletarPerfil = false;

  Future<void> login({required String email, required String senha}) async {
    carregando = true;
    erro = null;
    precisaCompletarPerfil = false;
    notifyListeners();

    try {
      await signInUseCase(email: email, senha: senha);
      await _resolverPerfilAposSessao();
    } catch (e) {
      erro = _mensagemErroLogin(e);
      conjuge = null;
      casal = null;
      precisaCompletarPerfil = false;
    }

    carregando = false;
    notifyListeners();
  }

  /// Retorna `true` se abriu sessão e o fluxo deve ir para home ou onboarding.
  /// Retorna `false` se o projeto exige confirmação de e-mail antes da sessão.
  Future<bool> cadastrar({required String email, required String senha}) async {
    carregando = true;
    erro = null;
    precisaCompletarPerfil = false;
    notifyListeners();

    try {
      final sessaoImediata = await registrarContaUseCase(
        email: email,
        senha: senha,
      );
      if (!sessaoImediata) {
        carregando = false;
        notifyListeners();
        return false;
      }
      await _resolverPerfilAposSessao();
    } catch (e) {
      erro = _mensagemErroCadastro(e);
      conjuge = null;
      casal = null;
      precisaCompletarPerfil = false;
    }

    carregando = false;
    notifyListeners();
    return erro == null;
  }

  Future<void> completarPerfil({
    required String nome,
    required PapelNoCasal papel,
  }) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      conjuge = await completarPerfilConjugeUseCase(nome: nome, papel: papel);
      casal = await buscarCasalUseCase();
      precisaCompletarPerfil = false;
    } catch (e) {
      erro = _mensagemErroGenerico(e);
      casal = null;
    }

    carregando = false;
    notifyListeners();
  }

  /// Carrega `conjuge` e `casal` após sign-in ou sign-up com sessão.
  Future<void> _resolverPerfilAposSessao() async {
    conjuge = await buscarConjugeOpcionalUseCase();
    if (conjuge == null) {
      casal = null;
      precisaCompletarPerfil = true;
      return;
    }

    casal = await buscarCasalOpcionalUseCase();
    if (casal == null) {
      erro =
          'Seu cadastro está incompleto no servidor (casal). Entre em contato com o suporte.';
      conjuge = null;
      casal = null;
      precisaCompletarPerfil = false;
      try {
        await logoutUseCase();
      } catch (_) {}
      return;
    }

    precisaCompletarPerfil = false;
  }

  String _mensagemErroLogin(Object e) {
    final texto = e.toString().toLowerCase();
    if (texto.contains('invalid login credentials') ||
        texto.contains('invalid_credentials')) {
      return 'E-mail ou senha incorretos.';
    }
    if (texto.contains('network') || texto.contains('socket')) {
      return 'Sem conexão. Verifique a internet e tente novamente.';
    }
    return 'Não foi possível entrar. Tente novamente.';
  }

  String _mensagemErroCadastro(Object e) {
    final texto = e.toString().toLowerCase();
    if (texto.contains('user already registered') ||
        texto.contains('already been registered')) {
      return 'Este e-mail já está cadastrado.';
    }
    if (texto.contains('password') && texto.contains('least')) {
      return 'A senha não atende aos requisitos mínimos.';
    }
    if (texto.contains('network') || texto.contains('socket')) {
      return 'Sem conexão. Verifique a internet e tente novamente.';
    }
    return 'Não foi possível criar a conta. Tente novamente.';
  }

  String _mensagemErroGenerico(Object e) {
    final texto = e.toString().toLowerCase();
    if (texto.contains('network') || texto.contains('socket')) {
      return 'Sem conexão. Verifique a internet e tente novamente.';
    }
    return 'Não foi possível concluir. Tente novamente.';
  }

  Future<void> logout() async {
    carregando = true;
    notifyListeners();

    try {
      await logoutUseCase();
      conjuge = null;
      casal = null;
      precisaCompletarPerfil = false;
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
