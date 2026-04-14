import {
  Waves,
  Tent,
  Home as HomeIcon,
  Sparkles,
  CalendarCheck,
  Users,
  TrendingUp,
  Activity,
} from "lucide-react";

// ── デモ用ダミーデータ(全て架空) ──────────────────────────
const kpis = [
  {
    label: "本日の予約",
    value: "38",
    unit: "件",
    delta: "+12%",
    icon: CalendarCheck,
    tone: "teal",
  },
  {
    label: "本日の売上",
    value: "¥284,500",
    unit: "",
    delta: "+8.4%",
    icon: TrendingUp,
    tone: "amber",
  },
  {
    label: "今月の顧客数",
    value: "1,247",
    unit: "名",
    delta: "+156",
    icon: Users,
    tone: "sky",
  },
  {
    label: "施設稼働率",
    value: "82",
    unit: "%",
    delta: "+5pt",
    icon: Activity,
    tone: "emerald",
  },
];

const businesses = [
  {
    key: "diving",
    name: "ダイビング",
    icon: Waves,
    todayReservations: 12,
    todaySales: "¥96,800",
    occupancy: 75,
    color: "from-sky-500 to-cyan-600",
    accent: "text-sky-600",
    ring: "ring-sky-200",
  },
  {
    key: "camp",
    name: "キャンプ",
    icon: Tent,
    todayReservations: 18,
    todaySales: "¥132,000",
    occupancy: 88,
    color: "from-emerald-600 to-teal-700",
    accent: "text-emerald-700",
    ring: "ring-emerald-200",
  },
  {
    key: "cottage",
    name: "コテージ",
    icon: HomeIcon,
    todayReservations: 6,
    todaySales: "¥48,000",
    occupancy: 100,
    color: "from-amber-500 to-orange-600",
    accent: "text-amber-700",
    ring: "ring-amber-200",
  },
  {
    key: "other",
    name: "事業D",
    icon: Sparkles,
    todayReservations: 2,
    todaySales: "¥7,700",
    occupancy: 40,
    color: "from-slate-500 to-slate-700",
    accent: "text-slate-700",
    ring: "ring-slate-200",
  },
];

const recentReservations = [
  {
    time: "14:00",
    customer: "山田 太郎 様",
    business: "ダイビング",
    party: 2,
    status: "確定",
    tone: "bg-emerald-100 text-emerald-800",
  },
  {
    time: "15:30",
    customer: "佐藤 花子 様",
    business: "キャンプ(H-1)",
    party: 4,
    status: "確定",
    tone: "bg-emerald-100 text-emerald-800",
  },
  {
    time: "16:00",
    customer: "鈴木 一郎 様",
    business: "コテージ",
    party: 3,
    status: "チェックイン済",
    tone: "bg-sky-100 text-sky-800",
  },
  {
    time: "17:00",
    customer: "高橋 美咲 様",
    business: "キャンプ(C-5)",
    party: 2,
    status: "確定",
    tone: "bg-emerald-100 text-emerald-800",
  },
  {
    time: "18:30",
    customer: "田中 健 様",
    business: "ダイビング",
    party: 1,
    status: "仮予約",
    tone: "bg-amber-100 text-amber-800",
  },
];

// ── ページ ──────────────────────────────────────────────
export default function Home() {
  return (
    <main className="min-h-screen bg-stone-50 text-slate-900">
      {/* ─── Hero ─────────────────────────────────────── */}
      <section className="relative overflow-hidden bg-gradient-to-br from-teal-700 via-teal-600 to-emerald-700 text-white">
        {/* 装飾の光 */}
        <div className="pointer-events-none absolute -top-32 -right-32 h-96 w-96 rounded-full bg-amber-300/20 blur-3xl" />
        <div className="pointer-events-none absolute -bottom-40 -left-20 h-96 w-96 rounded-full bg-sky-300/20 blur-3xl" />

        <div className="relative mx-auto max-w-6xl px-6 py-20 sm:py-28">
          <div className="mb-4 inline-flex items-center gap-2 rounded-full border border-white/30 bg-white/10 px-4 py-1.5 text-xs font-medium tracking-wide backdrop-blur">
            <span className="h-2 w-2 rounded-full bg-emerald-300" />
            DEMO — 架空データで動作中
          </div>

          <h1 className="text-4xl font-bold leading-tight tracking-tight sm:text-5xl lg:text-6xl">
            LUANA PARK SHIRAHAMA
            <br />
            <span className="bg-gradient-to-r from-amber-200 to-white bg-clip-text text-transparent">
              統合管理システム
            </span>
          </h1>

          <p className="mt-6 max-w-2xl text-base leading-relaxed text-white/85 sm:text-lg">
            和歌山・白浜の海と山に囲まれたキャンプ&ロッジの
            <br className="hidden sm:inline" />
            予約・顧客・売上・バックオフィスを一つのダッシュボードへ。
          </p>

          <div className="mt-8 flex flex-wrap gap-2">
            {businesses.map((b) => {
              const Icon = b.icon;
              return (
                <span
                  key={b.key}
                  className="inline-flex items-center gap-2 rounded-full border border-white/25 bg-white/10 px-4 py-2 text-sm backdrop-blur"
                >
                  <Icon className="h-4 w-4" />
                  {b.name}
                </span>
              );
            })}
          </div>
        </div>

        {/* 下端の白グラデで次セクションに馴染ませる */}
        
      </section>

      {/* ─── KPI ─────────────────────────────────────── */}
      <section className="mx-auto mt-10 max-w-6xl px-6">
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {kpis.map((kpi) => {
            const Icon = kpi.icon;
            return (
              <div
                key={kpi.label}
                className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:shadow-md"
              >
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-slate-500">
                    {kpi.label}
                  </span>
                  <Icon className="h-5 w-5 text-slate-400" />
                </div>
                <div className="mt-3 flex items-baseline gap-1">
                  <span className="text-3xl font-bold tracking-tight">
                    {kpi.value}
                  </span>
                  {kpi.unit && (
                    <span className="text-sm text-slate-500">{kpi.unit}</span>
                  )}
                </div>
                <div className="mt-2 text-xs font-medium text-emerald-600">
                  ▲ {kpi.delta} 前日比
                </div>
              </div>
            );
          })}
        </div>
      </section>

      {/* ─── 事業別ダッシュボード ─────────────────────────── */}
      <section className="mx-auto mt-14 max-w-6xl px-6">
        <div className="mb-6 flex items-end justify-between">
          <div>
            <h2 className="text-2xl font-bold tracking-tight">事業別サマリー</h2>
            <p className="mt-1 text-sm text-slate-500">
              本日(2026-04-14)時点の各事業の稼働状況
            </p>
          </div>
          <div className="hidden text-xs text-slate-400 sm:block">
            自動更新 · 5分ごと
          </div>
        </div>

        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {businesses.map((b) => {
            const Icon = b.icon;
            return (
              <div
                key={b.key}
                className="group overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm transition hover:shadow-lg"
              >
                <div
                  className={`bg-gradient-to-br ${b.color} p-5 text-white`}
                >
                  <div className="flex items-center justify-between">
                    <Icon className="h-8 w-8" />
                    <span className="rounded-full bg-white/20 px-2.5 py-0.5 text-xs font-medium backdrop-blur">
                      LIVE
                    </span>
                  </div>
                  <div className="mt-6 text-xl font-bold">{b.name}</div>
                </div>

                <div className="space-y-4 p-5">
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-slate-500">本日の予約</span>
                    <span className={`font-bold ${b.accent}`}>
                      {b.todayReservations} 件
                    </span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-slate-500">本日の売上</span>
                    <span className="font-semibold text-slate-800">
                      {b.todaySales}
                    </span>
                  </div>
                  <div>
                    <div className="mb-1.5 flex items-center justify-between text-xs">
                      <span className="text-slate-500">稼働率</span>
                      <span className="font-semibold text-slate-700">
                        {b.occupancy}%
                      </span>
                    </div>
                    <div className="h-2 overflow-hidden rounded-full bg-slate-100">
                      <div
                        className={`h-full rounded-full bg-gradient-to-r ${b.color}`}
                        style={{ width: `${b.occupancy}%` }}
                      />
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </section>

      {/* ─── 直近の予約 ──────────────────────────────── */}
      <section className="mx-auto mt-14 max-w-6xl px-6">
        <div className="mb-6">
          <h2 className="text-2xl font-bold tracking-tight">本日の予約</h2>
          <p className="mt-1 text-sm text-slate-500">
            チェックイン予定・入店予定をまとめて確認
          </p>
        </div>

        <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
          <table className="w-full text-sm">
            <thead className="border-b border-slate-200 bg-slate-50 text-left text-xs uppercase tracking-wider text-slate-500">
              <tr>
                <th className="px-5 py-3 font-medium">時刻</th>
                <th className="px-5 py-3 font-medium">顧客</th>
                <th className="px-5 py-3 font-medium">事業 / サイト</th>
                <th className="px-5 py-3 font-medium">人数</th>
                <th className="px-5 py-3 font-medium">ステータス</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {recentReservations.map((r, i) => (
                <tr
                  key={i}
                  className="transition hover:bg-slate-50"
                >
                  <td className="px-5 py-4 font-mono text-slate-700">
                    {r.time}
                  </td>
                  <td className="px-5 py-4 font-medium text-slate-900">
                    {r.customer}
                  </td>
                  <td className="px-5 py-4 text-slate-600">{r.business}</td>
                  <td className="px-5 py-4 text-slate-600">{r.party} 名</td>
                  <td className="px-5 py-4">
                    <span
                      className={`inline-flex rounded-full px-2.5 py-1 text-xs font-medium ${r.tone}`}
                    >
                      {r.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      {/* ─── Footer ─────────────────────────────────── */}
      <footer className="mt-20 border-t border-slate-200 bg-white">
        <div className="mx-auto max-w-6xl px-6 py-10 text-center text-xs text-slate-500">
          <div className="font-semibold text-slate-700">
            Camp & Lodge LUANA PARK SHIRAHAMA — 統合管理システム(デモ)
          </div>
          <div className="mt-2">
            本ページは納品前デモです。表示中の数値・顧客情報はすべて架空のダミーデータです。
          </div>
          <div className="mt-1 text-slate-400">
            © 2026 LUANA PARK SHIRAHAMA · Demo build
          </div>
        </div>
      </footer>
    </main>
  );
}