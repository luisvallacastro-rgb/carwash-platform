import assert from "node:assert/strict";
import test from "node:test";

async function render(){const workerUrl=new URL("../dist/server/index.js",import.meta.url);workerUrl.searchParams.set("test",`${process.pid}-${Date.now()}`);const {default:worker}=await import(workerUrl.href);return worker.fetch(new Request("http://localhost/",{headers:{accept:"text/html"}}),{ASSETS:{fetch:async()=>new Response("Not found",{status:404})},DB:{}},{waitUntil(){},passThroughOnException(){}})}
test("renderiza la experiencia CarWash en español",async()=>{const response=await render();assert.equal(response.status,200);const html=await response.text();assert.match(html,/<html[^>]*lang="es"/i);assert.match(html,/Tu auto limpio/);assert.match(html,/Consultar mi vehículo/);assert.match(html,/Lavado premium/);assert.doesNotMatch(html,/codex-preview|Lorem ipsum|Building your site/i)});
test("incluye navegación, promociones y contacto",async()=>{const html=await (await render()).text();for(const text of ["Servicios","Promociones","Cómo funciona","Preguntas frecuentes","Abrir ubicación"])assert.match(html,new RegExp(text,"i"))});
