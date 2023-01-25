import { defineConfig, loadEnv } from "vite";
import elmPlugin from "vite-plugin-elm";
import { createHtmlPlugin } from "vite-plugin-html";
export default defineConfig(({ mode }) => ({
  plugins: [elmPlugin({}), htmlPlugin(loadEnv(mode, "."))],
  publicDir: "public",
  build: {
    emptyOutDir: true,
    outDir: "dist",
    manifest: false,
    brotliSize: true,
    rollupOptions: { input: { app: "index.html" } },
  },
}));

function htmlPlugin(env) {
  return {
    name: "html-transform",
    transformIndexHtml: {
      enforce: "pre",
      transform: (html) =>
        html.replace(/%(.*?)%/g, (match, p1) => env[p1] ?? match),
    },
  };
}
