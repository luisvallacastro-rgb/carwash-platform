import type { Metadata, Viewport } from "next";
import { headers } from "next/headers";
import "./globals.css";

export async function generateMetadata(): Promise<Metadata> {
  const requestHeaders = await headers();
  const host = requestHeaders.get("x-forwarded-host") ?? requestHeaders.get("host") ?? "localhost:3000";
  const protocol = requestHeaders.get("x-forwarded-proto") ?? (host.startsWith("localhost") ? "http" : "https");
  const origin = `${protocol}://${host}`;
  return {
    metadataBase: new URL(origin),
    title: { default: "CarWash | Tu auto limpio y listo a tiempo", template: "%s | CarWash" },
    description: "Lavado y detallado profesional con seguimiento del servicio en tiempo real.",
    openGraph: { title: "CarWash — Brilla más. Espera menos.", description: "Consulta el avance de tu vehículo desde tu celular y recógelo justo a tiempo.", locale: "es_SV", type: "website", images: [{ url: `${origin}/og.png`, width: 1734, height: 907, alt: "CarWash: tu auto limpio y tu tiempo intacto" }] },
    twitter: { card: "summary_large_image", title: "CarWash — Brilla más. Espera menos.", description: "Seguimiento del lavado en tiempo real.", images: [`${origin}/og.png`] },
    robots: { index: true, follow: true },
    icons: { icon: "/favicon.svg", shortcut: "/favicon.svg" }, manifest: "/manifest.webmanifest",
  };
}

export const viewport: Viewport = { width: "device-width", initialScale: 1, themeColor: "#071a2f" };

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="es"><body>{children}</body></html>;
}
