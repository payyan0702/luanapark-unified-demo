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
