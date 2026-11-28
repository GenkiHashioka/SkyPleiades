# CLAUDE.md

@AGENTS.md

ここから下は、Claude Code にだけ関係すること。共通のルールは上で取り込んだ `AGENTS.md` に書く（[ADR 0002](docs/decisions/0002-agents-md-as-single-source.md)）。

## Codex プラグインのコマンド

レビューのコマンドは、本人が実装のあとに実行する（[ADR 0001](docs/decisions/0001-claude-teaches-codex-reviews.md)）。

```
/codex:review --base main
/codex:adversarial-review --base main <観点>
```

- `/codex:adversarial-review` は、設計判断を含む PR でだけ実行する
- `--wait`（終わるまで待つ）か `--background`（裏で動かし、`/codex:status` で進み具合を見る）を付けると、どちらで動かすかの質問を省ける
- `/codex:rescue` は使わない。review gate は無効のままにする
- Codex が使えないとき（利用上限など）は、`/code-review` で代わりにする

## セッションの区切り

- **Issue に着手するときは、`/start-issue` を使う。** 本人が `/start-issue <Issue 番号>` と打つか、「#<番号> をはじめましょう」と言ったら、Claude がこのスキルで Issue と関連する ADR を読み、ブランチ名とコマンドを示す
- **Claude Code のセッションは、1 つの Issue につき 1 つにする。** 話題が Issue の範囲を外れたら、Claude から `/handoff` と `/clear` を勧める
- **セッションを終えるときは、本人が `/handoff` で引き継ぎを書き、`/clear` する。** 引き継ぎは `.claude/handoff/` に、ブランチ名の `/` を `-` に置き換えた名前で保存する
- **新しいセッションの始めに、開始時フック（`.claude/hooks/session-start.sh`）が、今のブランチの引き継ぎを読み込む。** 起動したとき、`/clear` したとき、会話が要約されたときに動く。`main` では読み込まない
- **Issue を終えたら、引き継ぎの中で残す価値のあるものを journal に移し、引き継ぎのファイルを削除する**

## `.claude/` のコミット

- `.gitignore` で `.claude/` の中身をすべて外し、`settings.json`、`skills/`、`hooks/` だけを戻している。引き継ぎや `settings.local.json` は、コミットされない
- `.claude/` に共有するフォルダやファイルを増やすときは、`.gitignore` に `!` の行を足す

## 下書きのファイル

- コミットメッセージや、Issue・PR の本文の下書きは、Claude のスクラッチパッド（セッションごとの一時フォルダ）に置く
- 本人が使い終えたと伝えたら、Claude が削除する
