# /ship コマンド

現在のタスクをコミット→push→PR作成まで一気通貫で実行する。

## 手順
1. `Project_Memory/task.json` から `in_progress` のタスクを1つ特定
2. 変更ファイルを `git status` で確認
3. `github-operator` エージェントを呼び出し、以下を実行させる:
   - ブランチが main の場合は `feat/<task-id>-<desc>` を新規作成してチェックアウト
   - `git add -A` → コミット(Conventional Commits 準拠)
   - `git push -u origin HEAD`
   - `gh pr create` で PR 作成
4. PR 番号を受け取ったら `playbook.md` に記録
5. CI の結果を `gh pr checks` で確認し、グリーンなら task.json を `done` にする
   - 赤い場合は `in_progress` のまま、エラー内容を playbook に記録して停止

## 注意
- 1回の /ship で扱うタスクは1つだけ
- 未コミットの無関係な変更があったら停止して人間に判断を仰ぐ
- デモに影響する変更(DB スキーマ等)は playbook に明記
