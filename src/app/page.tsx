export default function Home() {
  return (
    <div className="flex flex-1 items-center justify-center">
      <main className="flex flex-col items-center gap-6 text-center px-6">
        <h1 className="text-4xl font-bold tracking-tight">
          LUANA PARK SHIRAHAMA
        </h1>
        <p className="text-lg text-zinc-600 dark:text-zinc-400">
          販売・顧客管理 統合システム（デモ）
        </p>
        <div className="flex gap-3 text-sm text-zinc-500">
          <span>ダイビング</span>
          <span>|</span>
          <span>キャンプ</span>
          <span>|</span>
          <span>コテージ</span>
          <span>|</span>
          <span>事業D</span>
        </div>
      </main>
    </div>
  );
}
