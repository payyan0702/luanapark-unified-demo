#!/usr/bin/env bash
# setup-files.sh
# luanapark-unified-demo プロジェクトの設計ファイル一式を生成するスクリプト
# 使い方: プロジェクトルート(luanapark-unified-demo/)で `bash setup-files.sh` を実行
#
# 生成されるファイル:
#   CLAUDE.md / README.md / .gitignore / .env.example
#   SPEC/03-architecture.md / SPEC/07-demo-delivery.md / SPEC/README.md
#   Project_Memory/playbook.md / Project_Memory/task.json
#   .claude/agents/github-operator.md / .claude/commands/ship.md
#   .github/workflows/ci.yml / .github/workflows/demo-deploy.yml
#   .github/pull_request_template.md

set -euo pipefail

echo "==> luanapark-unified-demo 設計ファイルを生成します"

# ディレクトリ作成
mkdir -p SPEC Project_Memory
mkdir -p .claude/agents .claude/commands .claude/skills
mkdir -p .github/workflows .github/ISSUE_TEMPLATE
mkdir -p docs/screenshots
mkdir -p fixtures
mkdir -p scripts/migrate scripts/demo
mkdir -p prisma

echo "  [1/14] CLAUDE.md"
cat > CLAUDE.md << 'FILE_EOF'
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
FILE_EOF

echo "  [2/14] README.md"
cat > README.md << 'FILE_EOF'
# LUANA PARK Unified — デモ実装

Camp & Lodge LUANA PARK SHIRAHAMA(ルアナパーク白浜)向けの
販売・顧客管理統合システムの **GitHub デモ実装**です。
対象事業: ダイビング / キャンプ / コテージ / 事業D。

> ⚠️ これはデモ用のリポジトリです。すべてのデータは架空のダミーです。

## 🎬 デモを見る
**[👉 GitHub Pages で動くデモを開く](https://payyan0702.github.io/luanapark-unified-demo/)**
※ Phase 2 完了後に公開されます。

## 📸 スクリーンショット
Phase 2 完了後に掲載予定。

## 🚀 クイックスタート

```bash
git clone https://github.com/payyan0702/luanapark-unified-demo.git
cd luanapark-unified-demo
npm install
cp .env.example .env
npx prisma migrate dev
npm run seed
npm run dev
```

ブラウザで http://localhost:3000 を開く。

### デモ用ログイン情報(seed 後に有効)
| ロール | メール | パスワード |
|---|---|---|
| 管理者 | admin@demo.local | password |
| 店長(ダイビング事業) | manager-diving@demo.local | password |
| スタッフ(キャンプ事業) | staff-camp@demo.local | password |

## 🛠 技術スタック
Next.js 14 / TypeScript / Tailwind / shadcn/ui / Prisma / SQLite / NextAuth

## 📂 ディレクトリ
- `SPEC/` — 要件・設計ドキュメント
- `Project_Memory/` — 作業計画(task.json)と playbook
- `.claude/` — Claude Code のエージェント/コマンド/スキル
- `prisma/` — DBスキーマと seed
- `scripts/migrate/` — CSV 移行スクリプト
- `src/app/` — Next.js App Router
- `docs/` — スクリーンショットと操作ガイド

## 🗺 ロードマップ
- Phase 0: 基盤構築(Next.js + Prisma + NextAuth + seed + CI)
- Phase 1: CSV 移行基盤(dry-run 対応)
- Phase 2: MVP 画面(顧客一覧 / 予約カレンダー / 売上入力 / ダッシュボード)

詳細は `SPEC/` 配下のドキュメントを参照。

## 📝 ライセンス
Proprietary(クライアント納品用)
FILE_EOF

echo "  [3/14] .gitignore"
cat > .gitignore << 'FILE_EOF'
# dependencies
node_modules/
.pnp
.pnp.js

# testing
coverage/

# next.js
.next/
out/
build/
dist/

# production
*.tsbuildinfo
next-env.d.ts

# misc
.DS_Store
*.pem
.vscode/
.idea/

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env
.env*.local
.env.development
.env.production

# vercel
.vercel

# prisma / sqlite
prisma/dev.db
prisma/dev.db-journal
*.sqlite
*.sqlite3

# playwright
/test-results/
/playwright-report/
/playwright/.cache/
FILE_EOF

echo "  [4/14] .env.example"
cat > .env.example << 'FILE_EOF'
# Database (SQLite, ローカルファイル)
DATABASE_URL="file:./dev.db"

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="change-me-in-production-xxxxxxxxxxxxxxxx"

# Demo mode flag (GitHub Pages 配信時のみ true)
NEXT_PUBLIC_DEMO_MODE="false"
FILE_EOF

echo "  [5/14] SPEC/README.md"
cat > SPEC/README.md << 'FILE_EOF'
# SPEC

Camp & Lodge LUANA PARK SHIRAHAMA 向け統合管理システムの設計ドキュメント。
このディレクトリのファイルは **設計の真実** として扱い、無断で書き換えない。

## 構成
- `03-architecture.md` — GitHub 完結型アーキテクチャと Prisma スキーマ骨子
- `07-demo-delivery.md` — GitHub でのデモ納品手順

※ 01/02/04/05/06 は Phase 0 完走後に追加予定。
FILE_EOF

echo "  [6/14] SPEC/03-architecture.md"
cat > SPEC/03-architecture.md << 'FILE_EOF'
# 03 — アーキテクチャ(GitHub デモ完結型)

## 方針
クライアント(ルアナパーク白浜)が **GitHub リポジトリを見るだけ**で
デモを確認・起動できる構成にする。外部SaaSのサインアップを要求しない。
本番運用時は SPEC/03-architecture-prod.md で差し替える想定。

## 技術スタック

| 層 | 採用 | 理由 |
|---|---|---|
| Frontend | Next.js 14 (App Router) + TypeScript | SSR可、App Router の学習価値 |
| UI | Tailwind + shadcn/ui | 速い、依存が軽い |
| Backend | Next.js API Routes | 別サーバ不要、1リポジトリで完結 |
| DB | SQLite (better-sqlite3) + Prisma | ファイル1つ、`git clone` で即動く |
| Auth | NextAuth (Credentials) | 外部IdP不要、seed で demo ユーザー投入 |
| Test | Vitest + Playwright | CI と相性◎ |
| CI | GitHub Actions | 無料、タブ切り替え不要 |
| デモ公開 | GitHub Pages | 追加費用ゼロ、URL を README に貼れる |

## データフロー(デモ時)

```
[ユーザー] ──> [Next.js App]
                  │
                  ├─ Server Component ─> Prisma ─> SQLite (file: ./dev.db)
                  └─ API Route ────────> Prisma ─> SQLite
```

シンプルに保つため、Prisma のクエリは Server Component から直接叩いてよい。
API Route は「外部から叩かれる経路」(CSV import、将来の連携)のためだけに用意する。

## Prisma スキーマ骨子

```prisma
// prisma/schema.prisma
generator client { provider = "prisma-client-js" }
datasource db { provider = "sqlite"; url = "file:./dev.db" }

model Store {
  id        String   @id @default(cuid())
  name      String   // "ダイビング" | "キャンプ" | "コテージ" | "事業D"
  address   String?
  users     User[]
  reservations Reservation[]
  sales     Sale[]
  createdAt DateTime @default(now())
}

model User {
  id       String @id @default(cuid())
  email    String @unique
  name     String
  role     String // "admin" | "manager" | "staff"
  storeId  String?
  store    Store? @relation(fields: [storeId], references: [id])
  passwordHash String
}

model Customer {
  id         String   @id @default(cuid())
  legacyId   String?  @unique  // 旧システム顧客ID
  name       String
  phone      String?
  email      String?
  note       String?
  reservations Reservation[]
  sales      Sale[]
  createdAt  DateTime @default(now())
}

model Reservation {
  id         String   @id @default(cuid())
  storeId    String
  customerId String
  startAt    DateTime
  endAt      DateTime
  status     String   // "booked" | "done" | "cancelled"
  store      Store    @relation(fields: [storeId], references: [id])
  customer   Customer @relation(fields: [customerId], references: [id])
}

model Product {
  id       String @id @default(cuid())
  name     String
  category String?
  price    Int
  saleItems SaleItem[]
}

model Sale {
  id         String   @id @default(cuid())
  storeId    String
  customerId String?
  soldAt     DateTime @default(now())
  total      Int
  store      Store    @relation(fields: [storeId], references: [id])
  customer   Customer? @relation(fields: [customerId], references: [id])
  items      SaleItem[]
}

model SaleItem {
  id        String @id @default(cuid())
  saleId    String
  productId String
  qty       Int
  price     Int
  sale      Sale     @relation(fields: [saleId], references: [id])
  product   Product  @relation(fields: [productId], references: [id])
}

model MigrationError {
  id        String   @id @default(cuid())
  sourceFile String
  rowNumber Int
  reason    String
  rawData   String   // JSON
  createdAt DateTime @default(now())
}
```

## 権限(デモ時は簡易版)
- NextAuth の session に `role` と `storeId` を入れる
- Server Component / API Route の入り口で `requireRole()` を呼ぶ
- RLS は本番移行時に Postgres + Supabase に載せ替える想定

## デモ起動フロー

```bash
git clone https://github.com/payyan0702/luanapark-unified-demo.git
cd luanapark-unified-demo
npm install
cp .env.example .env
npx prisma migrate dev
npm run seed          # demo ユーザー + ダミー顧客/予約/売上を投入
npm run dev           # http://localhost:3000
```

## 本番移行時の差分(参考)
| 項目 | デモ | 本番 |
|---|---|---|
| DB | SQLite | PostgreSQL (Supabase or 自前) |
| Auth | Credentials | メール認証 + MFA |
| ホスティング | GitHub Pages / ローカル | Vercel + Supabase Cloud |
| 権限 | アプリ層チェック | Postgres RLS |
| ログ | console | Sentry + Supabase Logs |

Prisma を採用する理由の一つがこの移行性。
`datasource` の provider を `postgresql` に変えるだけでスキーマは流用できる。
FILE_EOF

echo "  [7/14] SPEC/07-demo-delivery.md"
cat > SPEC/07-demo-delivery.md << 'FILE_EOF'
# 07 — GitHub でのデモ納品手順

## 納品物
1. **GitHub リポジトリ**本体(public または private でクライアントを invite)
2. **README.md** にデモ起動手順とスクリーンショット
3. **GitHub Pages** にビルド済みデモ(静的エクスポート版)
4. **docs/demo-walkthrough.md** にクライアント向けの操作ガイド
5. **Releases** にバージョンタグと変更履歴

## README 必須セクション
- プロジェクト概要(何を解決するか)
- スクリーンショット 4-6 枚(顧客一覧/予約カレンダー/売上入力/ダッシュボード)
- クイックスタート(3コマンドで起動)
- デモ用ログイン情報
- 技術スタック
- ディレクトリ構成
- ロードマップ
- ライセンス

## GitHub Pages デプロイ
- `.github/workflows/demo-deploy.yml` で main push 時に自動デプロイ
- Next.js を `output: 'export'` で静的化
- API 依存部分は MSW(Mock Service Worker)で差し替え、ブラウザだけで動くようにする
- `fixtures/` の CSV をビルド時に JSON 化して同梱

## クライアント(ルアナパーク白浜)への提示方法
1. リポジトリ URL を共有
2. README の「デモを見る」ボタン → GitHub Pages URL
3. 深く触りたい場合はローカルクローン手順を案内
4. 機能追加要望は GitHub Issues で受付(テンプレート用意済み)

## バージョニング
- `v0.1.0` = Phase 0 完了(基盤)
- `v0.2.0` = Phase 1 完了(CSV 移行基盤)
- `v0.3.0` = Phase 2 完了(MVP機能)
- `v1.0.0` = 並行稼働開始可能

各リリースで Release Notes を書く(`gh release create` を github-operator に任せる)。

## 要確認事項
- [ ] リポジトリは public / private どちらか(現状 private で作成済み)
- [ ] クライアント側の GitHub アカウントの有無
- [ ] GitHub Pages で良いか、プライベートなら別の配信先か
- [ ] デモ用の個人情報をどう扱うか(完全ダミー推奨)
FILE_EOF

echo "  [8/14] Project_Memory/playbook.md"
cat > Project_Memory/playbook.md << 'FILE_EOF'
# Playbook — luanapark-unified-demo

## 現在のフェーズ
Phase 0(基盤構築)着手直前

## 今の作戦
GitHub でデモを見せる前提なので、**最短で "クローンしたら動く状態"** を作る。
Phase 0 → Phase 1(CSV移行) → Phase 2(MVP画面) の順で、
各フェーズ終わりにリリースタグを打ってクライアントへ共有する。

**今夜のゴール(2026-04-14 06:00 まで)**:
GitHub Pages に何か動くものが上がっている状態。Phase 0 完走が現実ライン。

## 次の最初のアクション
- [ ] タスク 0-1: Next.js プロジェクト初期化(Claude Code に /work で着手させる)
- [ ] 0-1 完了後、0-2(Prisma) → 0-3(NextAuth) → 0-4(seed) の順で
- [ ] 0-5(CI) は 0-1 完了直後から並行着手可能

## 要確認事項(人間判断待ち・朝ボスに相談)
- [ ] このリポジトリ(payyan0702 配下)をボスの組織に移管するか
- [ ] リポジトリは public か private か(現状 private)
- [ ] クライアント(ルアナパーク白浜)の GitHub アカウント確認
- [ ] GitHub Pages でデモ配信して問題ないか(データは全ダミー)
- [ ] 旧システムの実CSVサンプルをいつ頃もらえるか(当面ダミーで進める)
- [ ] リリース希望時期

## 設計判断の記録
- 2026-04-13: バックエンドを Supabase から SQLite + Prisma に変更。
  理由: 「GitHub クローンだけで動く」要件を満たすため。
  本番移行時は Prisma の datasource を postgresql に切り替える前提。
- 2026-04-13: リポジトリ名を `stores-unified-demo` → `luanapark-unified-demo` に変更。
  理由: クライアント名(ルアナパーク白浜)に寄せた納品物にするため。
- 2026-04-13: 対象事業を「売店A/B/C/D」→「ダイビング/キャンプ/コテージ/事業D」に変更。
  理由: ルアナパーク白浜の実事業構成に合わせるため。事業Dは未確定。
- 2026-04-13: 一旦 payyan0702 個人アカウント配下でリポジトリ作成。
  理由: ボスからのリポジトリ招待待ちで時間を溶かさないため。朝移管相談。

## 直近のエラー・学び
- (未記入)
FILE_EOF

echo "  [9/14] Project_Memory/task.json"
cat > Project_Memory/task.json << 'FILE_EOF'
{
  "tasks": [
    {
      "id": "0-1",
      "phase": 0,
      "title": "Next.js 14 + TS + Tailwind プロジェクト初期化",
      "detail": "create-next-app で App Router + TS + Tailwind、shadcn/ui を導入",
      "status": "todo",
      "depends_on": [],
      "github_issue": null,
      "branch": "feat/0-1-init-nextjs"
    },
    {
      "id": "0-2",
      "phase": 0,
      "title": "Prisma + SQLite セットアップ",
      "detail": "prisma init --datasource-provider sqlite、初期スキーマ作成",
      "status": "todo",
      "depends_on": ["0-1"],
      "github_issue": null,
      "branch": "feat/0-2-prisma-sqlite"
    },
    {
      "id": "0-3",
      "phase": 0,
      "title": "NextAuth Credentials プロバイダ実装",
      "detail": "メール+パスワードでログイン、session に role/storeId を格納",
      "status": "todo",
      "depends_on": ["0-2"],
      "github_issue": null,
      "branch": "feat/0-3-nextauth"
    },
    {
      "id": "0-4",
      "phase": 0,
      "title": "seed スクリプト作成",
      "detail": "admin/manager/staff の demo ユーザーとダミー店舗4件(ダイビング/キャンプ/コテージ/事業D)を投入",
      "status": "todo",
      "depends_on": ["0-3"],
      "github_issue": null,
      "branch": "feat/0-4-seed"
    },
    {
      "id": "0-5",
      "phase": 0,
      "title": "GitHub Actions CI セットアップ",
      "detail": "lint / typecheck / test / build を PR で実行",
      "status": "todo",
      "depends_on": ["0-1"],
      "github_issue": null,
      "branch": "chore/0-5-ci"
    },
    {
      "id": "0-6",
      "phase": 0,
      "title": "README にクイックスタート記載",
      "detail": "3コマンドで起動できる手順とダミーログイン情報を明記",
      "status": "todo",
      "depends_on": ["0-4"],
      "github_issue": null,
      "branch": "docs/0-6-readme"
    },
    {
      "id": "1-1",
      "phase": 1,
      "title": "ダミーCSVフィクスチャ生成スクリプト",
      "detail": "scripts/demo/generate-fixtures.ts で顧客500/予約1000/売上2000件を生成。個人情報はすべて架空",
      "status": "todo",
      "depends_on": ["0-2"],
      "github_issue": null,
      "branch": "feat/1-1-fixtures"
    },
    {
      "id": "1-2",
      "phase": 1,
      "title": "CSV→DB 顧客インポート(dry-run対応)",
      "detail": "scripts/migrate/customers.ts --dry-run で件数検証、--apply で投入。エラー行は MigrationError へ",
      "status": "todo",
      "depends_on": ["1-1"],
      "github_issue": null,
      "branch": "feat/1-2-migrate-customers"
    },
    {
      "id": "1-3",
      "phase": 1,
      "title": "CSV→DB 予約・売上インポート",
      "detail": "customers と同じ方式、外部キー整合性チェック",
      "status": "todo",
      "depends_on": ["1-2"],
      "github_issue": null,
      "branch": "feat/1-3-migrate-rest"
    },
    {
      "id": "2-1",
      "phase": 2,
      "title": "顧客一覧・検索画面",
      "detail": "/customers。名前/電話 部分一致、ページネーション、Server Component + Prisma",
      "status": "todo",
      "depends_on": ["1-2"],
      "github_issue": null,
      "branch": "feat/2-1-customer-list"
    },
    {
      "id": "2-2",
      "phase": 2,
      "title": "予約カレンダー画面",
      "detail": "事業別・週表示。FullCalendar または自前",
      "status": "todo",
      "depends_on": ["1-3"],
      "github_issue": null,
      "branch": "feat/2-2-reservation-calendar"
    },
    {
      "id": "2-3",
      "phase": 2,
      "title": "売上入力フォーム",
      "detail": "顧客選択 → 商品追加 → 会計。トランザクションで Sale + SaleItem を作成",
      "status": "todo",
      "depends_on": ["1-3"],
      "github_issue": null,
      "branch": "feat/2-3-sales-form"
    },
    {
      "id": "2-4",
      "phase": 2,
      "title": "日次ダッシュボード",
      "detail": "事業別・今日の売上/予約件数/客数。Server Component で集計",
      "status": "todo",
      "depends_on": ["2-3"],
      "github_issue": null,
      "branch": "feat/2-4-dashboard"
    },
    {
      "id": "2-5",
      "phase": 2,
      "title": "スクリーンショット取得と README 更新",
      "detail": "docs/screenshots/ に 4-6 枚、README から参照。demo-walkthrough.md も執筆",
      "status": "todo",
      "depends_on": ["2-4"],
      "github_issue": null,
      "branch": "docs/2-5-screenshots"
    },
    {
      "id": "2-6",
      "phase": 2,
      "title": "GitHub Pages デモ配信セットアップ",
      "detail": "demo-deploy.yml 有効化、MSW でAPI モック、静的エクスポート確認",
      "status": "todo",
      "depends_on": ["2-5"],
      "github_issue": null,
      "branch": "chore/2-6-gh-pages"
    },
    {
      "id": "2-7",
      "phase": 2,
      "title": "v0.3.0 リリースタグ作成",
      "detail": "gh release create v0.3.0、Release Notes に MVP 完了を記載",
      "status": "todo",
      "depends_on": ["2-6"],
      "github_issue": null,
      "branch": "chore/2-7-release"
    }
  ],
  "status_definition": {
    "todo": "未着手",
    "in_progress": "進行中",
    "done": "完了",
    "blocked": "ブロック中"
  }
}
FILE_EOF

echo "  [10/14] .claude/agents/github-operator.md"
cat > .claude/agents/github-operator.md << 'FILE_EOF'
# Agent: github-operator

## 役割
GitHub 上の操作(ブランチ作成、コミット、PR作成、Issue 管理、Release 発行)を
gh CLI を使って自律実行するサブエージェント。

## 使用ツール
- `gh` CLI(認証済み前提)
- `git` コマンド

## 典型フロー: タスク → PR
1. `Project_Memory/task.json` から `in_progress` のタスクを読む
2. ブランチ名を決める: `feat/<task-id>-<kebab-title>` (例: `feat/2-1-customer-list`)
3. `git checkout -b <branch>` を実行
4. 実装が完了したら `git add -A && git commit -m "<type>(<scope>): <subject>"`
   - type: feat / fix / chore / docs / refactor / test
   - 例: `feat(customers): add list and search page [#12]`
5. `git push -u origin <branch>`
6. `gh pr create` で PR を作成
   - タイトル: タスクのタイトル + Issue番号
   - 本文テンプレート(下記)を使用
7. CI がグリーンになるまで待機
8. レビュー結果を `playbook.md` に記録

## PR 本文テンプレート
```
## 概要
<task.json の title と detail>

## 変更点
-
-

## 関連
- Closes #<issue番号>
- SPEC: SPEC/<file>.md#<section>

## 動作確認
- [ ] ローカルで `npm run dev` 起動確認
- [ ] `npm run test` パス
- [ ] スクリーンショット(UI変更がある場合)

## 備考
<設計判断や要確認事項>
```

## Issue 起票ルール
- SPEC の章ごとに epic Issue を1つ作成
- task.json の各タスクを child issue として作成、epic に紐付け
- ラベル: `phase-0` `phase-1` ... / `type:feat` `type:bug` ...

## 禁止事項
- force push
- main への直接 commit
- 他人の PR を勝手にマージ
- credentials を含むコミット(事前に git-secrets 的チェック)

## エラー時の対処
- `gh` の認証切れ → playbook に記録して停止、人間に `gh auth login` を依頼
- コンフリクト → rebase を試み、解決できなければ停止して報告
FILE_EOF

echo "  [11/14] .claude/commands/ship.md"
cat > .claude/commands/ship.md << 'FILE_EOF'
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
FILE_EOF

echo "  [12/14] .github/workflows/ci.yml"
cat > .github/workflows/ci.yml << 'FILE_EOF'
name: CI
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx prisma generate
      - run: npm run lint
      - run: npm run typecheck
      - run: npm run test
      - run: npm run build
FILE_EOF

echo "  [13/14] .github/workflows/demo-deploy.yml"
cat > .github/workflows/demo-deploy.yml << 'FILE_EOF'
name: Deploy Demo to GitHub Pages
on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run build:demo  # next build (output: export)
        env:
          NEXT_PUBLIC_DEMO_MODE: 'true'
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./out
      - id: deployment
        uses: actions/deploy-pages@v4
FILE_EOF

echo "  [14/14] .github/pull_request_template.md"
cat > .github/pull_request_template.md << 'FILE_EOF'
## 概要
<task.json の title と detail>

## 変更点
-
-

## 関連
- Closes #<issue番号>
- SPEC: SPEC/<file>.md#<section>

## 動作確認
- [ ] ローカルで `npm run dev` 起動確認
- [ ] `npm run test` パス
- [ ] スクリーンショット(UI変更がある場合)

## 備考
<設計判断や要確認事項>
FILE_EOF

# 空ディレクトリを git に追跡させるための .gitkeep
touch docs/screenshots/.gitkeep
touch fixtures/.gitkeep
touch scripts/migrate/.gitkeep
touch scripts/demo/.gitkeep
touch prisma/.gitkeep
touch .claude/skills/.gitkeep
touch .github/ISSUE_TEMPLATE/.gitkeep

echo ""
echo "==> 完了! 以下のファイルが生成されました:"
echo ""
find . -type f \
  -not -path './.git/*' \
  -not -name 'setup-files.sh' \
  | sort
echo ""
echo "==> 次のステップ: git add -A && git status で確認"
