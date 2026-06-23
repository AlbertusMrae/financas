# ARQUITETURA.md — NósApp
> Planta baixa técnica do projeto. Atualize sempre que uma nova classe, camada ou decisão arquitetural for implementada.

---

## Estrutura de pastas

```
lib/
├── core/
│   ├── errors/
│   │   └── failures.dart
│   ├── usecases/
│   │   └── usecase.dart
│   └── shared/
│       └── either.dart
│
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── conjuge.dart
│   │   │   │   └── casal.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── conjuge_model.dart
│   │   │   │   └── casal_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── login_screen.dart
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   │
│   ├── financas/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── carteira.dart
│   │   │   │   ├── lancamento.dart
│   │   │   │   └── distribuicao_item.dart
│   │   │   ├── enums/
│   │   │   │   ├── tipo_carteira.dart
│   │   │   │   └── tipo_lancamento.dart
│   │   │   ├── repositories/
│   │   │   │   └── financas_repository.dart
│   │   │   └── usecases/
│   │   │       ├── registrar_lancamento_usecase.dart
│   │   │       ├── buscar_lancamentos_usecase.dart
│   │   │       └── buscar_carteiras_usecase.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── carteira_model.dart
│   │   │   │   └── lancamento_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── financas_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── financas_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── carteiras_screen.dart
│   │       │   └── lancamentos_screen.dart
│   │       ├── providers/
│   │       │   └── financas_provider.dart
│   │       └── widgets/
│   │           ├── carteira_card.dart
│   │           └── lancamento_tile.dart
│   │
│   ├── lista_compras/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── item_compra.dart
│   │   │   ├── repositories/
│   │   │   │   └── lista_compras_repository.dart
│   │   │   └── usecases/
│   │   │       ├── adicionar_item_usecase.dart
│   │   │       ├── marcar_item_usecase.dart
│   │   │       └── buscar_itens_usecase.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── item_compra_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── lista_compras_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── lista_compras_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── lista_compras_screen.dart
│   │       ├── providers/
│   │       │   └── lista_compras_provider.dart
│   │       └── widgets/
│   │           └── item_compra_tile.dart
│   │
│   └── notas/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── nota.dart
│       │   ├── repositories/
│       │   │   └── notas_repository.dart
│       │   └── usecases/
│       │       ├── salvar_nota_usecase.dart
│       │       └── buscar_notas_usecase.dart
│       ├── data/
│       │   ├── models/
│       │   │   └── nota_model.dart
│       │   ├── datasources/
│       │   │   └── notas_remote_datasource.dart
│       │   └── repositories/
│       │       └── notas_repository_impl.dart
│       └── presentation/
│           ├── screens/
│           │   └── notas_screen.dart
│           ├── providers/
│           │   └── notas_provider.dart
│           └── widgets/
│               └── bloco_nota_widget.dart
│
├── injection_container.dart
└── main.dart
```

---

## Camadas e responsabilidades

| Camada | O que faz | Pode depender de |
|---|---|---|
| **Domain** | Entidades, contratos (interfaces), use cases | Nada externo |
| **Data** | Implementa repositórios, DTOs, datasources | Domain |
| **Presentation** | Widgets, screens, providers | Domain (via use cases) |

**Regra de ouro:** Domain nunca importa nada de Data ou Presentation.

---

## Entidades do Domain

### Conjuge
```dart
class Conjuge {
  final String id
  final String nome
  final String email
  final String casalId
  final String? fotoUrl
}
```

### Casal
```dart
class Casal {
  final String id
  final Conjuge conMelancia   // ConMelancia 🍉
  final Conjuge conUva        // ConUva 🍇
  final DateTime criadoEm
}
```

### Carteira
```dart
class Carteira {
  final String id
  final String nome
  final String proprietarioId   // id de Conjuge ou de Casal
  final TipoCarteira tipo       // individual | casal
  final double saldo
  final DateTime criadaEm
}
```

### DistribuicaoItem
```dart
class DistribuicaoItem {
  final String conjugeId
  final double valor
}
```

### Lancamento
```dart
class Lancamento {
  final String id
  final String carteiraId
  final String descricao
  final double valor
  final TipoLancamento tipo         // entrada | saida
  final DateTime data
  final DistribuicaoItem? parteConMelancia   // null = sem parte
  final DistribuicaoItem? parteConUva        // null = sem parte
  final DateTime criadoEm
}
```

> Regra: os dois null = lançamento só do casal.
> Um preenchido = esse cônjuge tem parte, resto fica no casal.
> Os dois preenchidos = distribuição completa.

### Nota
```dart
class Nota {
  final String id
  final String proprietarioId   // id de Conjuge ou de Casal
  final String? titulo
  final String conteudo
  final DateTime atualizadaEm
  final DateTime criadaEm
}
```

### ItemCompra
```dart
class ItemCompra {
  final String id
  final String descricao
  final bool marcado
}
```

---

## Enums

```dart
enum TipoCarteira { individual, casal }
enum TipoLancamento { entrada, saida }
```

---

## Decisões arquiteturais

- **Sem classe abstrata `Proprietario`** — over engineering para o escopo atual. Relação entre dono e recurso resolvida via `proprietarioId: String` + enum `TipoCarteira`
- **`parteConMelancia` e `parteConUva` são campos independentes** — não uma `List<DistribuicaoItem>`. Uma lista mentiria sobre a forma fixa de dois participantes e exigiria validação de tamanho em todo lugar
- **Arquitetura feature-first** — cada feature é um módulo isolado com suas 3 camadas. Debatido e confirmado vs. organização por camada
- **Código antes do Supabase** — entidades do domain guiam o schema do banco, não o contrário

---

## Fluxo de dados

```
Widget → Provider → UseCase → Repository (interface) → RepositoryImpl → Supabase
```

---

## Banco de dados (Supabase)

> A ser definido após implementação das entidades do domain.

---

## Status de implementação

| Componente | Status |
|---|---|
| Estrutura de pastas | ✅ criada |
| Entidade Conjuge | ⬜ não iniciado |
| Entidade Casal | ⬜ não iniciado |
| Entidade Carteira | ⬜ não iniciado |
| Entidade DistribuicaoItem | ⬜ não iniciado |
| Entidade Lancamento | ⬜ não iniciado |
| Entidade Nota | ⬜ não iniciado |
| Entidade ItemCompra | ⬜ não iniciado |
| Enums (TipoCarteira, TipoLancamento) | ⬜ não iniciado |
| AuthRepository (interface) | ⬜ não iniciado |
| FinancasRepository (interface) | ⬜ não iniciado |
| ListaComprasRepository (interface) | ⬜ não iniciado |
| NotasRepository (interface) | ⬜ não iniciado |
| UseCases | ⬜ não iniciado |
| Models / DTOs | ⬜ não iniciado |
| RepositoryImpl | ⬜ não iniciado |
| DataSources | ⬜ não iniciado |
| Providers | ⬜ não iniciado |
| Screens | ⬜ não iniciado |
| Schema Supabase | ⬜ não iniciado |
| injection_container.dart | ⬜ não iniciado |
