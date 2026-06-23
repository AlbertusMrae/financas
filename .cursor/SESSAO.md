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
**Módulo em andamento:** Módulo 4 — Flutter + Supabase (integração e debug)

### O que foi feito nessa sessão

#### Feature: código de convite com expiração de 15 min
- Planejamento completo da feature (schema, domínio, datasource, provider, telas)
- **Supabase migration:** colunas `codigo_convite TEXT` e `codigo_expira_em TIMESTAMPTZ` adicionadas em `casais`
- **`Casal` entity:** `conMelancia` e `conUva` tornados nullable; adicionados `codigoConvite`, `codigoExpiraEm`, getters `codigoAtivo` e `precisaDeParceiro`
- **`CasalModel`:** `fromJson` atualizado para campos nullable e novos campos
- **`AuthRepository`:** métodos `gerarCodigoConvite` e `entrarNoCasalPorCodigo` adicionados
- **`AuthRemoteDataSource`:** implementação dos dois métodos (geração com `Random.secure`, validação de expiração, limpeza do código após uso)
- **`AuthRepositoryImpl`:** delegação dos dois novos métodos
- **Use cases:** `GerarCodigoConviteUseCase` e `EntrarNoCasalPorCodigoUseCase` criados
- **`AuthProvider`:** estado `codigoConvite`, métodos `gerarCodigo()` e `entrarComCodigo()`, `_mensagemErroConvite()`
- **`injection_container.dart`:** novos use cases registrados
- **`CriarConjugeScreen`:** checkbox "Tenho um código de convite" com fork — se marcado entra no casal existente; se não, cria casal novo
- **`HomeScreen`:** ícone `group_add` visível só enquanto falta parceiro; dialog com código em destaque, botão copiar e contador regressivo de 15 min que fecha ao expirar

#### Debug e correções de RLS no Supabase
Foram encontrados e corrigidos 6 problemas encadeados via análise de logs:

1. **`conjuges_select` com recursão infinita (1ª ocorrência)** — policy consultava a própria tabela `conjuges` em subconsulta; corrigida para consultar `casais`
2. **Policy `conjuges_insert` ausente** — usuário não conseguia criar seu próprio registro
3. **Policy `casais_insert` ausente** — usuário não conseguia criar um casal
4. **`con_melancia_id` / `con_uva_id` NOT NULL** — schema não permitia inserir casal com FKs nulas; colunas tornadas nullable
5. **`casais_update` com dependência circular** — PATCH retornava 204 mas sem atualizar; policy simplificada para `auth.uid() IS NOT NULL`
6. **Recursão circular entre `conjuges_select` ↔ `casais_select` (2ª ocorrência)** — as duas policies se referenciavam mutuamente causando loop infinito; solução: função `SECURITY DEFINER` `public.meu_casal_id()` que lê `casal_id` do usuário sem acionar RLS, quebrando o ciclo completamente ✅

#### Função criada no Supabase
```sql
CREATE OR REPLACE FUNCTION public.meu_casal_id()
RETURNS uuid LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = public AS $$
  SELECT casal_id FROM public.conjuges WHERE id = auth.uid() LIMIT 1
$$;
```

#### Estado atual do RLS (políticas ativas — ✅ testado e funcionando)
| Tabela | Operação | Condição |
|---|---|---|
| `conjuges` | SELECT | `auth.uid() = id` OU `casal_id = meu_casal_id()` |
| `conjuges` | INSERT | `auth.uid() = id` |
| `conjuges` | UPDATE | `auth.uid() = id` |
| `casais` | SELECT | FK direta OU `id = meu_casal_id()` |
| `casais` | INSERT | `auth.uid() IS NOT NULL` |
| `casais` | UPDATE | `auth.uid() IS NOT NULL` (MVP — restringir depois) |

### Onde paramos

- **Criação de conta + completar perfil funcionando** ✅
- **Fluxo completo de autenticação validado** em dispositivo
- `HomeScreen` ainda é placeholder ("Em breve") — navegação por abas não construída

### Pendências
- [ ] Testar fluxo completo de código de convite (ConMelancia gera → ConUva entra com código)
- [ ] Construir `HomeScreen` com navegação por abas (`NavigationBar`) integrando as 4 features
- [ ] Revisar e integrar telas de financas, lista_compras e notas com seus providers
- [ ] Restringir `casais_update` RLS quando MVP estiver estável (hoje está `auth.uid() IS NOT NULL`)
- [ ] Supabase Realtime (4.6) — sync em tempo real entre ConMelancia e ConUva
- [ ] Atualizar testes (`cadastro_form_test.dart`, `login_form_test.dart`, `auth_provider_perfil_test.dart`)

---

## Histórico de sessões anteriores

### Sessão 2026-06-22 (início)
- Análise do estado real do projeto (muito além do que o SESSAO.md registrava)
- Identificação de que Módulos 1–4 estavam praticamente implementados no código
- `flutter pub get` pendente para resolver import de `provider`

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
