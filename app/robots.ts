import type { MetadataRoute } from "next";
export default function robots(): MetadataRoute.Robots { return { rules:{userAgent:"*",allow:"/",disallow:["/#admin","/#operations","/#customer"]},sitemap:"https://carwash.example/sitemap.xml" }; }
