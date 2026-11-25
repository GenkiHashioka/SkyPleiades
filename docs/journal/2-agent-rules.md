# #2 AI と開発の運用ルールを整える

作成：2026-11-25

## 目的

Claude Code と Codex が、同じルールで動けるようにする。KotlinTodo のルールをもとに、SkyPleiades 用の `AGENTS.md`・`CLAUDE.md` と、その理由の ADR を作る。

## やったこと

- `docs/decisions/` に一覧とテンプレートを置き、ADR を 2 本書いた
  - [ADR 0001](../decisions/0001-claude-teaches-codex-reviews.md)：Claude Code を先生役、Codex をレビュー役に分ける
  - [ADR 0002](../decisions/0002-agents-md-as-single-source.md)：共通のルールは日本語の `AGENTS.md` に一本化し、`CLAUDE.md` から取り込む
- `AGENTS.md` を 13 章で書いた。KotlinTodo から、作業を Issue から始める流れ、AI 開発ツールの積極的な提案、秘密情報をコミットしない決まり、ブログの題材を journal にためる運用を足した
- `CLAUDE.md` は `@AGENTS.md` の取り込みと、Claude Code にだけ関係すること（Codex プラグインのコマンド、セッションの区切り、下書きのファイル）だけにした

## 途中で変えたこと

- **ADR の見出し**：最初は KotlinTodo と同じく `Consequences` の下に「得られるもの／犠牲にするもの／代替案」を入れていた。見出しの説明と小見出しが重なるうえ、代替案は決定の結果ではないので、見出しを日本語の 6 つに平らにした
- **設計書の扱い**：最初の下書きは、KotlinTodo の「設計メモ」（Issue ごとに書き、あとから直さない文書）を前提にしていた。SkyPleiades では基本設計書・詳細設計書を作りこみ、直し続ける正本にするつもりなので、性格が逆になる。設計書の種類は #4 で決めることにし、`AGENTS.md` と ADR 0001 を「設計書」という中立な書き方に直した

## 学び

- 2 つの AI が自動で読むファイルは違う（Claude Code は `CLAUDE.md`、Codex は `AGENTS.md`）。Claude Code には `@ファイルのパス` で別のファイルを取り込む仕組みがあり、Codex にはない。そのため、正本は `AGENTS.md` の側に置くしかない
- Codex プラグインの `--wait` / `--background` は必須ではない。付けないと、どちらで動かすかを聞かれるだけ（プラグイン 1.0.6 のコマンドの説明で確認）
- 書き捨ての文書と直し続ける文書では、「古いものを当時の記録として残す」という決まりが合うかどうかが変わる

## 確認したこと

| 確認 | 結果 | 誰が |
|---|---|---|
| Claude Code の新しいセッションで、`AGENTS.md` が読み込まれる（`/context` の内訳） | 読み込まれていた | 本人 |
| Codex が、ファイルを開かずに `AGENTS.md` の 9 章の内容を答えられる | 答えられた | 本人 |
| `--wait` / `--background` の扱い | プラグインのコマンドの説明に、付けなければ質問すると書かれていた | Claude |
| `/codex:review --base main` | 指摘なし | 本人が実行、Claude が出力を確認 |
| `/codex:adversarial-review --base main`（観点：AGENTS.md と CLAUDE.md の重複・矛盾、ADR との食い違い） | approve。`CLAUDE.md` に役割分担と指摘の扱いの再掲がある、という言及があり、2 か所を削った | 本人が実行、Claude が出力を確認 |

## つまずいたこと

- **Codex のレビューが、モデルを理由に失敗した。** `~/.codex/config.toml` のモデルが `gpt-6.2-sol` でも `gpt-6.2-astra` でも、プラグインのレビューは「このモデルは ChatGPT のアカウントでは使えない」というエラーで止まった。同じ Codex の CLI での会話では `gpt-6.2-astra` が動いた。`gpt-6-astra` に変えるとレビューが通った。プラグインのレビューでだけ 6.2 系が使えない理由は、分かっていない

## 残したこと

- `/handoff`、開始時フック、`/start-issue`：#3
- 設計書の種類と要件の文書：#4
- zenn-articles を Windows にクローンし、journal から題材を集める skill を作る：#3 に着手したあと、zenn-articles 側の作業として行う

## ブログ題材候補

- **CLAUDE.md と AGENTS.md の二重管理をやめる：`@AGENTS.md` で Claude Code と Codex に同じルールを読ませる**
  - 正本を `AGENTS.md` に置く理由と、2 つの AI に読み込まれたことの確かめ方
