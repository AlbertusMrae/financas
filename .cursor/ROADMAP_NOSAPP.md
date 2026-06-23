# ROADMAP_NOSAPP.md — Currículo de estudos
> Mapa vivo dos conceitos que o projeto exige. Marque ✅ quando o conceito estiver sólido. Adicione novos conforme o projeto crescer.

---

## Como usar

Cada conceito está vinculado a uma parte real do NósApp.
Estudamos na ordem — não avançamos para Clean Architecture sem POO sólido.

---

## Módulo 1 — POO Fundamentals
> Base para tudo. Sem isso, Clean Architecture não faz sentido.

| # | Conceito | Onde aparece no NósApp | Status |
|---|---|---|---|
| 1.1 | Classes e objetos | `Conjuge`, `Casal`, `Carteira` | ✅ estudado |
| 1.2 | Atributos e métodos | atributos das entidades | ✅ estudado |
| 1.3 | Construtores | todas as entidades | ✅ estudado |
| 1.4 | Encapsulamento (`_` privado) | datasources, repository impl | ✅ estudado |
| 1.5 | Getters | getters calculados nas entidades | ✅ estudado |
| 1.6 | Setters com validação | validações de domínio | ✅ estudado |
| 1.7 | Herança (`extends`) | `ConMelancia` / `ConUva` como `Conjuge` | ✅ estudado |
| 1.8 | `super` no construtor | construtores com herança | ✅ estudado |
| 1.9 | `@override` e `super.metodo()` | sobrescrita de métodos | ✅ estudado |
| 1.10 | Classes abstratas | conceito estudado; sem uso direto no MVP (over engineering) | ✅ estudado |
| 1.11 | Interfaces (`interface class`) | `AuthRepository`, `FinancasRepository`, etc. | ✅ estudado |
| 1.12 | Polimorfismo | `RepositoryImpl` tratado como `Repository` nos UseCases | ✅ estudado |
| 1.13 | `implements` vs `extends` | `RepositoryImpl implements Repository` | ✅ estudado |

---

## Módulo 2 — Dart intermediário
> Necessário para o código do projeto ser idiomático.

| # | Conceito | Onde aparece no NósApp | Status |
|---|---|---|---|
| 2.1 | `final` vs `const` vs `var` | em todas as entidades | ✅ estudado |
| 2.2 | Null safety (`?`, `!`, `??`) | `parteConMelancia?`, `parteConUva?`, `fotoUrl?` | ✅ estudado |
| 2.3 | `List`, `Map`, `Set` | listas de lançamentos, carteiras | ✅ estudado |
| 2.4 | `async`/`await`/`Future` | chamadas ao Supabase | ⬜ pendente |
| 2.5 | Arrow functions (`=>`) | getters curtos nas entidades | ✅ estudado |
| 2.6 | `factory` constructor | `ConjugeModel.fromJson()` | ⬜ pendente |
| 2.7 | Enums | `TipoCarteira`, `TipoLancamento` | ⬜ pendente |
| 2.8 | Mixins | (quando surgir necessidade) | ⬜ pendente |

---

## Módulo 3 — Clean Architecture
> Aplicada ao NósApp camada por camada.

| # | Conceito | Onde aparece no NósApp | Status |
|---|---|---|---|
| 3.1 | Visão geral das camadas | estrutura de pastas definida e criada | ✅ concluído |
| 3.2 | Entidades (Domain) | `Conjuge`, `Casal`, `Carteira`, `Lancamento`, `Nota`, `ItemCompra` | ⬜ implementar |
| 3.3 | Repository interface (Domain) | `AuthRepository`, `FinancasRepository`, etc. | ⬜ implementar |
| 3.4 | Use Cases (Domain) | `RegistrarLancamentoUseCase`, etc. | ⬜ implementar |
| 3.5 | Models / DTOs (Data) | `ConjugeModel.fromJson()` | ⬜ implementar |
| 3.6 | Repository Impl (Data) | `FinancasRepositoryImpl` | ⬜ implementar |
| 3.7 | DataSource (Data) | `FinancasRemoteDataSource` | ⬜ implementar |
| 3.8 | Provider (Presentation) | `FinancasProvider` | ⬜ implementar |
| 3.9 | Injeção de dependência manual | `injection_container.dart` | ⬜ implementar |

---

## Módulo 4 — Flutter + Supabase
> UI e integração com backend.

| # | Conceito | Onde aparece no NósApp | Status |
|---|---|---|---|
| 4.1 | StatelessWidget e StatefulWidget | widgets do app | ✅ estudado |
| 4.2 | Provider com ChangeNotifier | `FinancasProvider`, `NotasProvider`, etc. | ⬜ pendente |
| 4.3 | Consumer e context.watch | telas que ouvem os providers | ⬜ pendente |
| 4.4 | Supabase Auth | tela de login | ⬜ pendente |
| 4.5 | Supabase CRUD | datasources | ⬜ pendente |
| 4.6 | Supabase Realtime | sync entre ConMelancia e ConUva | ⬜ pendente |

---

## Ordem de estudo recomendada

```
✅ 1.1–1.13   (POO completo)
       ↓
2.7 → 2.4 → 2.6        (Dart necessário para implementar)
       ↓
3.2 → 3.3 → 3.4        (implementar Domain)
       ↓
3.5 → 3.6 → 3.7        (implementar Data)
       ↓
3.8 → 3.9              (implementar Presentation)
       ↓
4.2 → 4.3 → 4.4 → 4.5 → 4.6  (Flutter + Supabase)
```
