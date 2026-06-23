# GUIA_TELAS.md — NósApp
> Guia completo para o Cursor criar as telas do NósApp. Siga a ordem, os providers, e as regras de negócio descritas aqui.

---

## Contexto do projeto

- **App:** NósApp — aplicativo de casal
- **Usuários:** ConMelancia 🍉 (Alberto) e ConUva 🍇 (Luan)
- **Stack:** Flutter + Provider (ChangeNotifier) + Supabase
- **Arquitetura:** Clean Architecture feature-first
- **Estado:** Gerenciado por providers globais definidos em `lib/injection_container.dart`

### Providers disponíveis globalmente

```dart
authProvider         // AuthProvider
financasProvider     // FinancasProvider
listaComprasProvider // ListaComprasProvider
notasProvider        // NotasProvider
```

Acesse nas telas via:
```dart
context.watch<AuthProvider>()     // reconstrói quando muda
context.read<AuthProvider>()      // só lê, sem rebuild
```

Registre todos os providers no `main.dart` usando `MultiProvider`:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider.value(value: authProvider),
    ChangeNotifierProvider.value(value: financasProvider),
    ChangeNotifierProvider.value(value: listaComprasProvider),
    ChangeNotifierProvider.value(value: notasProvider),
  ],
  child: const NosApp(),
)
```

---

## Regras gerais de implementação

- Use `StatelessWidget` sempre que possível
- Use `Consumer<T>` ou `context.watch<T>()` para ouvir mudanças de estado
- Mostre `CircularProgressIndicator` quando `provider.carregando == true`
- Mostre mensagem de erro quando `provider.erro != null`
- Chame `buscar*` no `initState` usando `WidgetsBinding.instance.addPostFrameCallback`
- Prefira `debugPrint` a `print`
- Use `const` em widgets fixos
- Navegação com `Navigator.push` / `Navigator.pop`

---

## Ordem de criação das telas

```
1. login_screen.dart
2. home_screen.dart  (navegação central)
3. carteiras_screen.dart
4. lancamentos_screen.dart
5. lista_compras_screen.dart
6. notas_screen.dart
```

---

## 1. Login Screen

**Arquivo:** `lib/features/auth/presentation/screens/login_screen.dart`

**Responsabilidade:** autenticar o usuário via e-mail e senha.

**Widgets necessários:**
- Campo de e-mail (`TextFormField`)
- Campo de senha (`TextFormField`, obscureText: true)
- Botão "Entrar"
- Indicador de carregamento
- Mensagem de erro

**Lógica:**
```dart
final provider = context.read<AuthProvider>();
await provider.login(email: email, senha: senha);

if (provider.erro == null) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
}
```

**Telas relacionadas:** `cadastro_screen.dart` (cadastro no Auth), `criar_conjuge_screen.dart` (primeiro acesso sem `conjuges`/`casais`), link “Criar conta” na login. Navegação pós-auth com `precisaCompletarPerfil` em `AuthProvider`.

---

## 2. Home Screen

**Arquivo:** `lib/features/auth/presentation/screens/home_screen.dart`

**Responsabilidade:** tela principal com navegação entre as features via `BottomNavigationBar`.

**Abas:**
| Index | Label | Tela |
|---|---|---|
| 0 | Finanças | `CarteirasScreen` |
| 1 | Compras | `ListaComprasScreen` |
| 2 | Notas | `NotasScreen` |

**Lógica:**
- Use `IndexedStack` para preservar estado entre abas
- Exiba o nome do usuário logado no `AppBar`: `context.watch<AuthProvider>().conjuge?.nome`
- Botão de logout no `AppBar`:
```dart
context.read<AuthProvider>().logout().then((_) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
});
```

---

## 3. Carteiras Screen

**Arquivo:** `lib/features/financas/presentation/screens/carteiras_screen.dart`

**Responsabilidade:** listar as 3 carteiras (ConMelancia, ConUva, Casal).

**Lógica de carregamento:**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<FinancasProvider>().buscarCarteiras();
  });
}
```

**Exibição:**
- Para cada `Carteira` em `provider.carteiras`, exiba um card com:
  - `carteira.nome`
  - `carteira.saldo` formatado em R$
  - Badge visual distinguindo `TipoCarteira.individual` de `TipoCarteira.casal`

**Regra de negócio — botão de lançamento:**
- Carteira individual: exibe botão "+" **somente** se `carteira.proprietarioId == authProvider.conjuge?.id`
- Carteira do casal: exibe botão "+" para qualquer usuário logado

**Ao clicar no "+":**
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => LancamentosScreen(carteira: carteira),
));
```

---

## 4. Lancamentos Screen

**Arquivo:** `lib/features/financas/presentation/screens/lancamentos_screen.dart`

**Responsabilidade:** listar lançamentos de uma carteira e registrar novo lançamento.

**Recebe:** `Carteira carteira` como parâmetro no construtor.

**Lógica de carregamento:**
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<FinancasProvider>().buscarLancamentos(carteiraId: carteira.id);
});
```

**Exibição de cada lançamento:**
- Descrição
- Valor formatado em R$ (verde para entrada, vermelho para saída)
- Data formatada
- Se `parteConMelancia != null`: exibir "🍉 R$ X"
- Se `parteConUva != null`: exibir "🍇 R$ X"

**Formulário de novo lançamento (BottomSheet ou tela separada):**

Campos:
- Descrição (`TextFormField`)
- Valor (`TextFormField`, teclado numérico)
- Tipo: Entrada / Saída (`SegmentedButton` ou dois radio buttons)
- Data (`DatePicker`, default hoje)

**Somente se `carteira.tipo == TipoCarteira.casal`**, exibir seção de distribuição:
- Toggle "Distribuir para ConMelancia 🍉" → se ativo, campo de valor para `parteConMelancia`
- Toggle "Distribuir para ConUva 🍇" → se ativo, campo de valor para `parteConUva`

**Ao salvar:**
```dart
final lancamento = LancamentoModel(
  id: const Uuid().v4(),
  carteiraId: carteira.id,
  descricao: descricao,
  valor: valor,
  tipo: tipo,
  data: data,
  parteConMelancia: parteConMelancia, // null se não distribuído
  parteConUva: parteConUva,           // null se não distribuído
  criadoEm: DateTime.now(),
);

await context.read<FinancasProvider>().registrarLancamento(lancamento: lancamento);
```

> Adicione `uuid` ao pubspec.yaml para gerar IDs: `uuid: ^4.4.0`

---

## 5. Lista Compras Screen

**Arquivo:** `lib/features/lista_compras/presentation/screens/lista_compras_screen.dart`

**Responsabilidade:** exibir e gerenciar a lista de compras compartilhada.

**Lógica de carregamento:**
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<ListaComprasProvider>().buscarItens();
});
```

**Exibição:**
- `ListView` com um `CheckboxListTile` por item
- Itens marcados aparecem com texto tachado (`TextDecoration.lineThrough`)
- Separar visualmente itens pendentes dos marcados

**Marcar item:**
```dart
context.read<ListaComprasProvider>().marcarItem(
  id: item.id,
  marcado: !item.marcado,
);
```

**Adicionar item (FAB → dialog ou bottom sheet):**
```dart
final item = ItemCompraModel(
  id: const Uuid().v4(),
  casalId: context.read<AuthProvider>().casal!.id,
  descricao: descricao,
  marcado: false,
);

await context.read<ListaComprasProvider>().adicionarItem(item: item);
```

---

## 6. Notas Screen

**Arquivo:** `lib/features/notas/presentation/screens/notas_screen.dart`

**Responsabilidade:** exibir os 3 blocos de notas (ConMelancia, ConUva, Casal).

**Lógica de carregamento:**
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<NotasProvider>().buscarNotas();
});
```

**Exibição:**
- 3 cards ou abas: "🍉 Minha nota", "🍇 Nota do Luan", "💑 Nota do casal"
- Identifique cada nota pelo `proprietarioId`:
  - `== authProvider.conjuge?.id` → nota do usuário logado
  - `== casal.conUva.id` (ou conMelancia, dependendo de quem logou) → nota do parceiro
  - `== casal.id` → nota do casal

**Regra de edição:**
- Nota do usuário logado: campo editável (`TextFormField` multilinha)
- Nota do casal: editável por qualquer um
- Nota do parceiro: somente leitura (`Text`, sem campo de edição)

**Ao salvar:**
```dart
final nota = NotaModel(
  id: notaExistente?.id ?? const Uuid().v4(),
  proprietarioId: proprietarioId,
  titulo: titulo,
  conteudo: conteudo,
  atualizadaEm: DateTime.now(),
  criadaEm: notaExistente?.criadaEm ?? DateTime.now(),
);

await context.read<NotasProvider>().salvarNota(nota: nota);
```

> Use `upsert` no datasource (já está implementado) — então o mesmo método serve para criar e atualizar.

---

## Estrutura de arquivos esperada após as telas

```
lib/features/auth/presentation/screens/
  login_screen.dart
  home_screen.dart

lib/features/financas/presentation/screens/
  carteiras_screen.dart
  lancamentos_screen.dart

lib/features/lista_compras/presentation/screens/
  lista_compras_screen.dart

lib/features/notas/presentation/screens/
  notas_screen.dart
```

---

## Dependências adicionais necessárias

Adicione ao `pubspec.yaml` antes de criar as telas:

```yaml
dependencies:
  uuid: ^4.4.0
  intl: ^0.19.0   # para formatar datas e valores monetários
```

Rode `flutter pub get` após adicionar.

---

## Formatação de valores monetários

Use o pacote `intl` para formatar saldos e valores:

```dart
import 'package:intl/intl.dart';

final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
formatador.format(carteira.saldo); // "R$ 1.250,00"
```

---

## Observações finais

- Não crie lógica de negócio nas telas — tudo passa pelo provider
- Não acesse o Supabase diretamente nas telas
- Não duplique estado — confie no provider como fonte única da verdade
- O `casal` está disponível em `authProvider.casal` após o login — busque-o logo após autenticar
