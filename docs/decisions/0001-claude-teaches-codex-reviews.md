# 0001 - Claude Code を先生役、Codex をレビュー役に分ける

**ステータス**: 採用
**日付**: 2026-11-25

## 背景

SkyPleiades は、Claude Code と Codex の 2 つの AI を使って開発する。Codex は、公式プラグイン（`codex-plugin-cc`）を通して Claude Code の中から呼び出す。

役割を決めずに 2 つの AI を使うと、次の問題が起きる。

- 同じ説明やレビューを 2 回受けることになり、時間と利用枠を消費する
- 説明した AI 自身がレビューすると、説明したときと同じ見落としをしやすい
- 両方が先生役になると、言うことが食い違ったときに、どちらを基準にするかがあいまいになる

このプロジェクトでは、コードは原則として本人が書く。AI の役割も、この前提に合わせて決める。

前のプロジェクトの KotlinTodo では、同じ問題に対して [ADR 0026](https://github.com/GenkiHashioka/kotlin-todo/blob/main/docs/decisions/0026-claude-teaches-codex-reviews.md) で役割を分け、運用してきた。SkyPleiades でもこの分け方を引き継ぐ。ただし、ADR 0026 の決定 5「ルールは両方の指示ファイルに書く」は引き継がず、[ADR 0002](0002-agents-md-as-single-source.md) で別に決める。

## 決定

### 1. Claude Code を先生役にする

概念・責務・選択肢の説明、設計メモや journal の下書き、Codex の指摘の解説、本人の説明の抜けの指摘を担う。

### 2. Codex をレビュー役にする

実装したあとに、本人がレビューのコマンド（`/codex:review --base main`）を実行する。設計判断を含む PR では、前提そのものを疑うレビューのコマンド（`/codex:adversarial-review --base main <観点>`）も実行する。すべての PR で両方を実行することはしない。

### 3. Codex にコードを書かせる機能は使わない

調査や修正を Codex に任せるコマンド（`/codex:rescue`）は使わない。Claude の応答のたびに Codex のレビューを自動で走らせる設定（review gate）は無効のままにする。

### 4. 指摘を採用するかは本人が決める

2 つの AI の指摘が食い違ったときは、どちらかに寄せず、両方の理由を並べて本人が判断する。Codex が使えないとき（利用上限など）は、Claude Code のレビューのコマンド（`/code-review`）で代わりにする。

## 得られるもの

- **説明とレビューを別のモデルが担う**：説明した側と同じ見落としを、別の視点で拾える
- **説明の基準が 1 つになる**：先生役は Claude Code だけなので、指針が食い違いにくい
- **レビューのタイミングを本人が決める**：レビューのコマンドは本人しか実行しないため、AI が勝手に進める状態にならない
- **コードを代わりに書かせる経路を閉じる**：「本人が書く」方針と矛盾する機能を使わないことが、明文化される

## 犠牲にするもの

- **Codex から先生としての説明を受ける機会は減る**
- **深いレビューの漏れが起きうる**：`/codex:adversarial-review` は設計判断を含む PR に限るため、どの PR が当てはまるかの判断を誤ると、深いレビューを受けずに進む
- **手順が増える**：レビューのたびに、本人がコマンドを実行する必要がある

## 検討した代替案

- **Codex を先生役、Claude Code をレビュー役にする**：プラグインは Claude Code の中から Codex を呼ぶ形で、Codex のコマンドは 1 回ごとに完結する使い方を想定している。会話を続けながら教わる先生役は、会話の主体である Claude Code の方が合う。却下
- **1 つの AI に説明とレビューの両方を任せる**：説明した側がレビューすると同じ見落としをしやすく、別のモデルを使う意味がなくなる。却下
- **すべての PR で `/codex:review` と `/codex:adversarial-review` の両方を実行する**：小さな PR では指摘が重なりやすく、利用枠も早く尽きる。却下
- **review gate を有効にする**：Claude はコードを書かないため、応答ごとのレビューにはほぼ対象がなく、利用枠だけを消費する。却下
- **ルールをユーザー全体の設定（`~/.claude/CLAUDE.md`、`~/.codex/AGENTS.md`）に置く**：仕事のリポジトリにも適用されてしまう。また、Git で管理されないため、PR でレビューできない。却下

## 関連

- [ADR 0002 - 共通のルールは日本語の AGENTS.md に一本化し、CLAUDE.md から取り込む](0002-agents-md-as-single-source.md)
- KotlinTodo の [ADR 0026](https://github.com/GenkiHashioka/kotlin-todo/blob/main/docs/decisions/0026-claude-teaches-codex-reviews.md) — この ADR の元になった判断
- `AGENTS.md` の「AI の役割」
- `CLAUDE.md` の Codex プラグインのコマンド
