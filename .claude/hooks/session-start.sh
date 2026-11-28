#!/usr/bin/env bash
# SessionStart フック。現在ブランチと、対応する引き継ぎファイルを Claude に渡す。
# additionalContext は Claude のコンテキストに入り、systemMessage 画面に 1 行表示される。

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
handoff_dir="$project_dir/.claude/handoff"

context="## 作業中のブランチ"

branch="$(git -C "$project_dir" branch --show-current 2>/dev/null)"
context+=$'\n'"- $project_dir: ${branch:-(detached)}"

handoff_name="${branch//\//-}.md"
handoff_file="$handoff_dir/$handoff_name"

if [ -n "$branch" ] && [ "$branch" != "main" ] && [ -f "$handoff_file" ]; then
  context+=$'\n\n'"## 引き継ぎ: $branch（.claude/handoff/$handoff_name）"$'\n'"$(cat "$handoff_file")"
  message="引き継ぎを読み込みました: $branch"
else
  context+=$'\n\n'"引き継ぎファイルはない。新しい Issue なら、Issue と関連する ADR を読んでから始める。"
  message="引き継ぎファイルなし"
fi

CONTEXT="$context" MESSAGE="$message" node -e '
console.log(JSON.stringify({
  systemMessage: process.env.MESSAGE,
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: process.env.CONTEXT,
  },
}));
'
