# PROJETO.md — NósApp
> Contexto geral do projeto. Atualize sempre que houver mudança de escopo, decisão de produto ou nova funcionalidade planejada.

---

## Sobre o app

**Nome:** NósApp
**Plataforma:** Flutter (mobile — Android e iOS)
**Backend:** Supabase (PostgreSQL + Auth + Realtime)
**Objetivo:** Aplicativo de casal para organizar a vida a dois — finanças, lista de compras e notas compartilhadas.

---

## Usuários

| Nome | Username | Papel |
|---|---|---|
| Alberto | ConMelancia 🍉 | Desenvolvedor e usuário |
| Luan | ConUva 🍇 | Usuário (namorado) |

---

## Funcionalidades — MVP

### 🔐 Auth
- Login com e-mail via Supabase Auth
- Contas separadas por usuário
- Sync em tempo real entre os dois celulares

### 💰 Finanças — 3 carteiras
- Carteira individual ConMelancia — só ele lança, só afeta ele
- Carteira individual ConUva — só ele lança, só afeta ele
- Carteira do casal — qualquer um lança
- Cada um pode ver a carteira do outro (somente leitura)
- Ao lançar na carteira do casal, é possível distribuir o valor por cônjuge:
  - `parteConMelancia: DistribuicaoItem?` — null = sem parte pra ele
  - `parteConUva: DistribuicaoItem?` — null = sem parte pra ele
  - Os dois null = lançamento fica só no caixa do casal
  - Um preenchido e outro null = esse cônjuge tem parte, resto fica no casal
  - Os dois preenchidos = distribuição completa entre os dois
- Lançamento é sempre único — nunca se duplica entre carteiras
- Nas listagens individuais, filtro opcional "incluir casal" exibe lançamentos do casal com a fatia de cada um destacada

### 🛒 Lista de compras
- Uma lista simples compartilhada
- Os dois adicionam e marcam itens

### 📝 Notas — 3 blocos
- Bloco ConMelancia — só ele edita
- Bloco ConUva — só ele edita
- Bloco Casal — os dois editam
- Mesma entidade `Nota` para os três, identificada por `proprietarioId`

---

## Decisões de produto

- Lançamento é sempre único — sem duplicação entre carteiras
- `proprietarioId` identifica dono de carteira e nota (pode ser id de Conjuge ou de Casal)
- `TipoCarteira` enum distingue carteira individual de carteira do casal
- Cada um lança só na própria carteira individual
- Qualquer um pode lançar na carteira do casal
- Distribuição usa valores reais (não percentual)
- Sem módulo de tarefas no MVP — fica para Fase 2

---

## Fase 2 (futuro)
- Tarefas compartilhadas (criar, concluir, atribuir responsável)
- Histórico de tarefas concluídas
- Resumo financeiro mensal
- Notificações de tarefas atrasadas

---

## Stack técnica

| Camada | Tecnologia |
|---|---|
| Frontend | Flutter + Dart |
| Estado | Provider (ChangeNotifier) |
| Backend | Supabase (PostgreSQL) |
| Auth | Supabase Auth |
| Realtime | Supabase Realtime |
| Arquitetura | Clean Architecture (feature-first) |

---

## Objetivo de aprendizado

Este projeto é o veículo de estudo de Alberto em:
- Programação Orientada a Objetos (POO) em profundidade
- Lógica de programação aplicada a problemas reais
- Clean Architecture com Flutter/Dart
- Integração Flutter + Supabase
