import '../../domain/entities/item_compra.dart';

class ItemCompraModel extends ItemCompra {
  const ItemCompraModel({
    required super.id,
    required super.casalId,
    required super.descricao,
    required super.marcado,
  });

  factory ItemCompraModel.fromJson(Map<String, dynamic> json) {
    return ItemCompraModel(
      id: json['id'] as String,
      casalId: json['casal_id'] as String,
      descricao: json['descricao'] as String,
      marcado: json['marcado'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'casal_id': casalId,
      'descricao': descricao,
      'marcado': marcado,
    };
  }
}
