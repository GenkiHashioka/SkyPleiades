# CLAUDE.md

@AGENTS.md

ここから下は、Claude Code にだけ関係すること。共通のルールは上で取り込んだ `AGENTS.md` に書く（[ADR 0002](docs/decisions/0002-agents-md-as-single-source.md)）。

## Codex プラグインのコマンド

Claude は先生役、Codex はレビュー役（[ADR 0001](docs/decisions/0001-claude-teaches-codex-reviews.md)）。レビューのコマンドは、本人が実装のあとに実行する。

```
/codex:review --base main
/codex:adversarial-review --base main <観点>
```

- `/codex:adversarial-review` は、設計判断を含む PR でだけ実行する
- `--wait`（終わるまで待つ）か `--background`（裏で動かし、`/codex:status` で進み具合を見る）を付けると、どちらで動かすかの質問を省ける
- `/codex:rescue` は使わない。review gate は無効のままにする
- Codex が使えないとき（利用上限など）は、`/code-review` で代わりにする
- Codex の指摘は、Claude が解説する。Claude の説明と食い違うときは、どちらかに寄せず、両方の理由を並べて示す

## セッションの区切り

- **Claude Code のセッションは、1 つの Issue につき 1 つにする。** 話題が Issue の範囲を外れたら、Claude から `/handoff` と `/clear` を勧める
- **セッションを終えるときは、本人が `/handoff` で引き継ぎを書き、`/clear` する**
- **Issue を終えたら、引き継ぎの中で残す価値のあるものを journal に移し、引き継ぎのファイルを削除する**
- `/handoff` と、新しいセッションの始めに引き継ぎを読み込むフック（SessionStart フック）は、Issue #3 で用意する

## 下書きのファイル

- コミットメッセージや、Issue・PR の本文の下書きは、Claude のスクラッチパッド（セッションごとの一時フォルダ）に置く
- 本人が使い終えたと伝えたら、Claude が削除する
