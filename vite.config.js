import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";

export default defineConfig({
  plugins: [elmPlugin({})],
  publicDir: "public",
  // build: {
  //   emptyOutDir: false,
  //   outDir: "../priv/static",
  //   manifest: false,
  //   brotliSize: true,
  //   rollupOptions: {
  //     input: {
  //       app: "src/index.js",
  //     },
  //     output: {
  //       assetFileNames: "assets/[name].[ext]",
  //       entryFileNames: "assets/[name].js",
  //     },
  //   },
  // },
});
