# 設計判断記録（ADR）

「なぜそう決めたか」を、判断ごとに短く切り出して記録する。ルールそのものは `AGENTS.md` と `CLAUDE.md` に書き、その理由はここに書く。

各ファイルはテンプレート（[`TEMPLATE.md`](TEMPLATE.md)）に沿って、番号順に追加する。見出しは日本語にそろえている。一般的な ADR の形との対応は、「背景」が Context、「決定」が Decision、「得られるもの」と「犠牲にするもの」が Consequences にあたる。決定を変えるときは、古い ADR を書き換えず、新しい ADR を追加して古い方のステータスを「廃止」にする。

## 一覧

| # | タイトル |
|---|---|
| 0001 | [Claude Code を先生役、Codex をレビュー役に分ける](0001-claude-teaches-codex-reviews.md) |
| 0002 | [共通のルールは日本語の AGENTS.md に一本化し、CLAUDE.md から取り込む](0002-agents-md-as-single-source.md) |
