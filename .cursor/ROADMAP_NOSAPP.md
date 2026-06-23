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
| 1.10 | Classes abstratas | conceito estudado; sem uso direto no MVP | ✅ estudado |
| 1.11 | Interfaces (`interface class`) | `AuthRepository`, `FinancasRepository`, etc. | ✅ estudado |
| 1.12 | Polimorfismo | `RepositoryImpl` tratado como `Repository` nos UseCases | ✅ estudado |
| 1.13 | `implements` vs `extends` | `RepositoryImpl implements Repository` | ✅ estudado |

---

## Módulo 2 — Dart intermediário
> Necessário para o código do projeto ser idiomático.

| # | Conceito | Onde aparece no NósApp | Status |
|---|---|---|---|
| 2.1 | `final` vs `const` vs `var` | em todas as entidades | ✅ estudado |
| 2.2 | Null safety (`?`, `!`, `??`) | `conMelancia?`, `conUva?`, `fotoUrl?`, `codigoConvite?` | ✅ estudado |
| 2.3 | `List`, `Map`, `Set` | listas de lançamentos, carteiras | ✅ estudado |
| 2.4 | `async`/`await`/`Future` | chamadas ao Supabase em todos os datasources | ✅ estudado |
| 2.5 | Arrow functions (`=>`) | getters curtos nas entidades | ✅ estudado |
| 2.6 | `factory` constructor | `ConjugeModel.fromJson()`, `CasalModel.fromJson()` | ✅ estudado |
| 2.7 | Enums | `PapelNoCasal`, `TipoCarteira`, `TipoLancamento` | ✅ estudado |
| 2.8 | Mixins | (quando surgir necessidade) | ⬜ pendente |

---

## Módulo 3 — Clean Architecture
> Aplicada ao NósApp camada por camada.

| # | Conceito | Onde aparece no NósApp | Status |
|---|---|---|---|
| 3.1 | Visão geral das camadas | estrutura de pastas definida e criada | ✅ concluído |
| 3.2 | Entidades (Domain) | `Conjuge`, `Casal`, `Carteira`, `Lancamento`, `Nota`, `ItemCompra` | ✅ concluído |
| 3.3 | Repository interface (Domain) | `AuthRepository`, `FinancasRepository`, etc. | ✅ concluído |
| 3.4 | Use Cases (Domain) | `SignInUseCase`, `GerarCodigoConviteUseCase`, etc. | ✅ concluído |
| 3.5 | Models / DTOs (Data) | `ConjugeModel`, `CasalModel`, `LancamentoModel`, etc. | ✅ concluído |
| 3.6 | Repository Impl (Data) | `AuthRepositoryImpl`, `FinancasRepositoryImpl`, etc. | ✅ concluído |
| 3.7 | DataSource (Data) | `AuthRemoteDataSource`, `FinancasRemoteDataSource`, etc. | ✅ concluído |
| 3.8 | Provider (Presentation) | `AuthProvider`, `FinancasProvider`, etc. | ✅ concluído |
| 3.9 | Injeção de dependência manual | `injection_container.dart` wiring completo | ✅ concluído |

---

## Módulo 4 — Flutter + Supabase
> UI e integração com backend.

| # | Conceito | Onde aparece no NósApp | Status |
|---|---|---|---|
| 4.1 | StatelessWidget e StatefulWidget | widgets do app | ✅ estudado |
| 4.2 | Provider com ChangeNotifier | `AuthProvider`, `FinancasProvider`, etc. | ✅ concluído |
| 4.3 | Consumer e context.watch | telas de auth e onboarding | ✅ concluído |
| 4.4 | Supabase Auth | sign in, sign up, logout, onboarding | ✅ concluído |
| 4.5 | Supabase CRUD | datasources com select/insert/update | ✅ concluído |
| 4.6 | Supabase Realtime | sync em tempo real entre ConMelancia e ConUva | ⬜ pendente |
| 4.7 | Timer e Clipboard | código de convite com countdown e cópia | ✅ concluído |
| 4.8 | RLS (Row Level Security) | políticas de acesso por usuário no Supabase | ✅ concluído (MVP) |

---

## Ordem de estudo recomendada

```
✅ 1.1–1.13   (POO completo)
       ↓
✅ 2.7 → 2.4 → 2.6        (Dart necessário para implementar)
       ↓
✅ 3.2 → 3.3 → 3.4        (Domain implementado)
       ↓
✅ 3.5 → 3.6 → 3.7        (Data implementado)
       ↓
✅ 3.8 → 3.9              (Presentation implementado)
       ↓
✅ 4.2 → 4.3 → 4.4 → 4.5  (Flutter + Supabase funcionando)
       ↓
⬜ 4.6                     (Realtime — próximo passo)
```
