# SESSAO.md — Diário de bordo e instruções ao Claude
> Atualize ao final de cada sessão. Este arquivo é o que o Claude lê primeiro para retomar o contexto exato de onde paramos.

---

## Instruções permanentes ao Claude

Você é o professor e parceiro de desenvolvimento de Alberto (Albertinho / ConMelancia 🍉), Dev Jr em uma empresa de PDV (Jiffy) no Brasil.

**Sobre o aluno:**
- Está aprendendo POO do zero, partindo de uma base de lógica de programação já consolidada
- Aprende melhor com explicações profundas do *porquê*, não só do *como*
- Questiona ativamente quando algo não está claro — responda com precisão técnica
- Quer entender cada conceito antes de avançar — não pule etapas
- Usa Flutter 3.41.4 e Dart 3.11.1
- O contexto de exemplos deve ser sempre o NósApp
- Os usuários do app são ConMelancia (Alberto) e ConUva (Luan) — use esses nomes nos exemplos

**Como conduzir as aulas:**
- Um conceito por vez, explicado até estar sólido
- Sempre mostre o conceito isolado primeiro, depois no contexto do NósApp
- Aponte antipadrões quando aparecerem — não deixe passar
- Corrija com tabela de erros e nota quando for exercício
- Prefira `debugPrint` a `print`
- Use `final` e `const` onde adequado — corrija se o aluno não usar

**Fluxo padrão de aula:**
1. Teoria com analogia do mundo real
2. Exemplo simples isolado
3. Exemplo no contexto do NósApp
4. Exercício prático
5. Correção com tabela de erros (severidade) e nota

---

## Sessão atual

**Data:** 2026-06-22
**Módulo em andamento:** Módulo 4 — Flutter + Supabase (em integração final)

### O que foi feito (estado real do código)

O projeto avançou significativamente desde a última sessão registrada. O estado atual é:

**Módulo 1 (POO)** — 100% concluído ✅

**Módulo 2 (Dart intermediário)**
- 2.4 `async/await/Future` ✅ — usado em todos os datasources e usecases
- 2.5 Arrow functions ✅
- 2.6 `factory` constructor ✅ — `ConjugeModel.fromJson()`, `CasalModel.fromJson()`, etc.
- 2.7 Enums ✅ — `PapelNoCasal`, `TipoCarteira`, `TipoLancamento` implementados

**Módulo 3 (Clean Architecture)** — todas as 4 features implementadas ✅
- Entidades: `Conjuge`, `Casal`, `PapelNoCasal`, `Carteira`, `Lancamento`, `DistribuicaoItem`, `Nota`, `ItemCompra`
- Repository interfaces: `AuthRepository`, `FinancasRepository`, `ListaComprasRepository`, `NotasRepository`
- Use Cases auth: `SignInUseCase`, `RegistrarContaUseCase`, `LogoutUseCase`, `BuscarConjugeOpcionalUseCase`, `BuscarCasalOpcionalUseCase`, `BuscarCasalUseCase`, `CompletarPerfilConjugeUseCase`
- Use Cases financas: `BuscarCarteirasUseCase`, `BuscarLancamentosUseCase`, `RegistrarLancamentoUseCase`
- Use Cases lista_compras: `BuscarItensUseCase`, `AdicionarItemUseCase`, `MarcarItemUseCase`
- Use Cases notas: `BuscarNotasUseCase`, `SalvarNotaUseCase`
- Models: `ConjugeModel`, `CasalModel`, `LancamentoModel`, `CarteiraModel`, `NotaModel`, `ItemCompraModel`
- Repository Impl: todas as 4 features
- DataSources: `AuthRemoteDataSource`, `FinancasRemoteDataSource`, `ListaComprasRemoteDataSource`, `NotasRemoteDataSource`
- Providers: `AuthProvider`, `FinancasProvider`, `ListaComprasProvider`, `NotasProvider`
- Injeção de dependência: `injection_container.dart` com wiring manual completo

**Módulo 4 (Flutter + Supabase)**
- 4.2 Provider + ChangeNotifier ✅ — todos os providers com `notifyListeners`
- 4.3 Consumer / context.watch ✅ — usado nas telas de auth
- 4.4 Supabase Auth ✅ — sign in, sign up, logout integrados
- 4.5 Supabase CRUD ✅ — datasources fazem select/insert/update no Supabase
- Telas existentes: `LoginScreen`, `CadastroScreen`, `CriarConjugeScreen`, `HomeScreen` (placeholder), `CarteirasScreen`, `LancamentosScreen`, `ListaComprasScreen`, `NotasScreen`
- `main.dart` completo: inicializa Supabase via `.env`, registra todos os providers no `MultiProvider`

### Onde paramos

- Feature de **Auth está completa** (login, cadastro, onboarding de cônjuge/casal, logout)
- As demais features (financas, lista_compras, notas) têm toda a camada de dados e domínio implementada, e telas criadas
- A `HomeScreen` é um placeholder (`'Em breve'`) — a navegação principal por abas ainda não foi construída
- O fluxo de navegação pós-login (`auth_navigation.dart`) existe mas pode precisar de revisão

### Pendências
- [ ] Construir `HomeScreen` com navegação por abas (BottomNavigationBar ou NavigationBar) integrando as 4 features
- [ ] Revisar e integrar as telas de financas, lista_compras e notas com seus providers (context.watch / Consumer)
- [ ] Supabase Realtime (4.6) — sync em tempo real entre ConMelancia e ConUva
- [ ] Testes das telas (`cadastro_form_test.dart`, `login_form_test.dart`, `auth_provider_perfil_test.dart` já existem mas podem estar desatualizados)
- [ ] Atualizar ROADMAP_NOSAPP.md com os itens já concluídos

---

## Histórico de sessões anteriores

### Sessão 2026-04-05
- Escopo do MVP definido do zero
- Modelo de domínio completo definido e debatido (4 features, todas as entidades)
- Arquitetura feature-first confirmada
- Estrutura de pastas criada no projeto Flutter
- POO 1.10 a 1.13 estudados: classes abstratas, interfaces, polimorfismo, implements vs extends
- Usuários renomeados para ConMelancia 🍉 e ConUva 🍇

### Sessão 2026-03-27
- Introdução a Clean Architecture (conceito geral, camadas, estrutura de pastas)
- POO do zero: classes, objetos, atributos, métodos, construtores
- Encapsulamento, getters, setters com validação
- Herança, super, @override
- Criação dos arquivos de contexto do projeto

### Sessões pré-NósApp (resumo)
- Aulas 1–10: variáveis, funções, condicionais, listas, loops, classes básicas, null safety, widget tree, StatelessWidget vs StatefulWidget, formulários e validação
- Aula 11: introdução a setState
- Padrões de erro recorrentes: falta de `const` em widgets fixos, `print` em vez de `debugPrint`
