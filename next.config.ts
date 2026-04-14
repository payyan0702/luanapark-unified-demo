import type { NextConfig } from "next";

const isDemo = process.env.NEXT_PUBLIC_DEMO_MODE === "true";
const repo = "luanapark-unified-demo";

const nextConfig: NextConfig = {
  output: "export",
  basePath: isDemo ? `/${repo}` : "",
  assetPrefix: isDemo ? `/${repo}/` : "",
  images: { unoptimized: true },
  trailingSlash: true,
};

export default nextConfig;