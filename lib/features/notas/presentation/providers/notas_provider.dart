import 'package:flutter/foundation.dart';
import '../../domain/entities/nota.dart';
import '../../domain/usecases/buscar_notas_usecase.dart';
import '../../domain/usecases/salvar_nota_usecase.dart';

class NotasProvider extends ChangeNotifier {
  final BuscarNotasUseCase buscarNotasUseCase;
  final SalvarNotaUseCase salvarNotaUseCase;

  NotasProvider({
    required this.buscarNotasUseCase,
    required this.salvarNotaUseCase,
  });

  List<Nota> notas = [];
  bool carregando = false;
  String? erro;

  Future<void> buscarNotas() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      notas = await buscarNotasUseCase();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvarNota({required Nota nota}) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      await salvarNotaUseCase(nota: nota);
      await buscarNotas();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
