import type { MetadataRoute } from "next";
export default function sitemap(): MetadataRoute.Sitemap { return [{ url:"https://carwash.example", changeFrequency:"weekly", priority:1 },{ url:"https://carwash.example/#track",changeFrequency:"daily",priority:.8 }]; }
