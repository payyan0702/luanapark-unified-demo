# CLAUDE.md — luanapark-unified-demo

**言語**: 日本語。コード・コミットメッセージ・PR タイトルは英語。

## プロジェクト概要
Camp & Lodge LUANA PARK SHIRAHAMA(ルアナパーク白浜)向けの
販売・顧客管理統合システムの **GitHub デモ実装**。
対象事業: ダイビング / キャンプ / コテージ / 事業D(未確定)

クライアントは最終的に GitHub 上でデモを確認する前提。
外部SaaS依存を最小化し、`git clone && npm install && npm run dev` だけで動く構成にする。

主要機能: 予約管理 / 顧客管理 / 売上分析 / バックオフィス連携 / 社内チャット(将来)

## 最重要原則
- **GitHub だけで完結**。Supabase/Vercel などの外部アカウントを前提にしない。
- **ローカルで即動く**。クローン直後に seed が走り、ダミーデータで画面が動く状態にする。
- **PR ベースで進める**。main への直接 push は禁止。1タスク = 1ブランチ = 1PR。
- **業務を止めない設計を示す**。CSV 移行は必ず dry-run 経由。

## 開発方針(3層構造)
- `SPEC/` = 設計の真実。無断で書き換えない。
- `Project_Memory/` = 作業記憶。毎ターン更新。
- `.claude/` = 実行の仕組み(agents / skills / commands)。

## GitHub ワークフロー
1. `task.json` のタスク id と GitHub Issue 番号を対応させる
2. 作業開始時に `feat/<task-id>-<short-desc>` ブランチを切る
3. 実装 → commit → push
4. `/ship` コマンドで PR を作成(`github-operator` が gh CLI を使用)
5. CI(lint/typecheck/test/build)がグリーンになったらマージ
6. `task.json` を `done` に更新し、`playbook.md` の次の一手を書き直す

## 技術スタック
- Frontend: Next.js 14 (App Router) + TypeScript + Tailwind + shadcn/ui
- Backend: Next.js API Routes
- DB: SQLite (better-sqlite3) + Prisma ORM
- Auth: NextAuth (Credentials Provider, ローカル完結)
- Test: Vitest + Playwright(最小限)
- CI: GitHub Actions
- デモ配信: GitHub Pages (静的エクスポート + モックAPI) ※本番DBは使わない

## サブエージェントの使い分け
- `agents/migration-engineer` — CSV→DB 移行の委任
- `agents/backend-builder` — Prisma スキーマと API Routes の委任
- `agents/frontend-builder` — 画面実装の委任
- `agents/github-operator` — gh CLI でブランチ/PR/Issue を操作

## 禁止事項
- 本物の個人情報を fixtures/ に置かない(必ずダミー生成)
- main へ直接 push しない
- 外部 SaaS のアカウントを前提とした実装を入れない
- .env や credentials をコミットしない(.env.example のみ可)
- 1PRに複数タスクを詰め込まない
