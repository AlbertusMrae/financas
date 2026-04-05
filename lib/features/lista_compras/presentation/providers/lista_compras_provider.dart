import 'package:flutter/foundation.dart';
import '../../domain/entities/item_compra.dart';
import '../../domain/usecases/buscar_itens_usecase.dart';
import '../../domain/usecases/adicionar_item_usecase.dart';
import '../../domain/usecases/marcar_item_usecase.dart';

class ListaComprasProvider extends ChangeNotifier {
  final BuscarItensUseCase buscarItensUseCase;
  final AdicionarItemUseCase adicionarItemUseCase;
  final MarcarItemUseCase marcarItemUseCase;

  ListaComprasProvider({
    required this.buscarItensUseCase,
    required this.adicionarItemUseCase,
    required this.marcarItemUseCase,
  });

  List<ItemCompra> itens = [];
  bool carregando = false;
  String? erro;

  Future<void> buscarItens() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      itens = await buscarItensUseCase();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> adicionarItem({required ItemCompra item}) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      await adicionarItemUseCase(item: item);
      await buscarItens();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> marcarItem({required String id, required bool marcado}) async {
    try {
      await marcarItemUseCase(id: id, marcado: marcado);
      await buscarItens();
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }
}
