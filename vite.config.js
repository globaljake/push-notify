import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";

export default defineConfig({
  plugins: [elmPlugin({})],
  publicDir: "public",
  build: {
    emptyOutDir: true,
    outDir: "dist",
    manifest: false,
    brotliSize: true,
    rollupOptions: {
      input: {
        app: "index.html",
      },
      // output: {
      //   assetFileNames: "assets/[name].[ext]",
      //   entryFileNames: "assets/[name].js",
      // },
    },
  },
});
