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
