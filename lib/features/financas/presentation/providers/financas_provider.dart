import 'package:flutter/foundation.dart';
import '../../domain/entities/carteira.dart';
import '../../domain/entities/lancamento.dart';
import '../../domain/usecases/buscar_carteiras_usecase.dart';
import '../../domain/usecases/buscar_lancamentos_usecase.dart';
import '../../domain/usecases/registrar_lancamento_usecase.dart';

class FinancasProvider extends ChangeNotifier {
  final BuscarCarteirasUseCase buscarCarteirasUseCase;
  final BuscarLancamentosUseCase buscarLancamentosUseCase;
  final RegistrarLancamentoUseCase registrarLancamentoUseCase;

  FinancasProvider({
    required this.buscarCarteirasUseCase,
    required this.buscarLancamentosUseCase,
    required this.registrarLancamentoUseCase,
  });

  List<Carteira> carteiras = [];
  List<Lancamento> lancamentos = [];
  bool carregando = false;
  String? erro;

  Future<void> buscarCarteiras() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      carteiras = await buscarCarteirasUseCase();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> buscarLancamentos({required String carteiraId}) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      lancamentos = await buscarLancamentosUseCase(carteiraId: carteiraId);
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> registrarLancamento({required Lancamento lancamento}) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      await registrarLancamentoUseCase(lancamento: lancamento);
      await buscarLancamentos(carteiraId: lancamento.carteiraId);
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
