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
