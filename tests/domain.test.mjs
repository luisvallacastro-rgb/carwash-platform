import assert from "node:assert/strict";
import test from "node:test";
import { applyPromotion, canReadOrder, canTransition, estimateCompletion, publicLookup } from "../lib/domain.mjs";

test("permite solo la siguiente etapa operativa",()=>{assert.equal(canTransition("queued","preparation"),true);assert.equal(canTransition("queued","drying"),false);assert.equal(canTransition("delivered","ready"),false)});
test("reserva la cancelación para supervisión",()=>{assert.equal(canTransition("queued","cancelled","operator"),false);assert.equal(canTransition("queued","cancelled","supervisor"),true)});
test("calcula recepción, cola y ajuste",()=>{assert.equal(estimateCompletion("2026-07-18T10:00:00Z",45,15,5).toISOString(),"2026-07-18T11:05:00.000Z")});
test("aplica promociones activas y rechaza vencidas",()=>{const active={status:"active",type:"percentage",value:20,startsAt:"2026-07-01",endsAt:"2026-08-01"};assert.deepEqual(applyPromotion(50,active,new Date("2026-07-18")),{total:40,discount:10,reason:"applied"});assert.equal(applyPromotion(50,{...active,endsAt:"2026-07-02"},new Date("2026-07-18")).discount,0)});
test("consulta pública exige código y teléfono y enmascara placa",()=>{const orders=[{code:"CW-8472",phone:"7788-1122",brand:"Toyota",model:"Corolla",plate:"P123482",status:"interior",estimatedAt:"11:40"}];assert.equal(publicLookup(orders,"CW-8472","7000-0000"),null);assert.equal(publicLookup(orders,"CW-8472","77881122").plate,"P••• 482")});
test("un cliente no lee órdenes ajenas",()=>{const order={customerId:"customer-1"};assert.equal(canReadOrder({role:"customer",customerId:"customer-2"},order),false);assert.equal(canReadOrder({role:"admin"},order),true)});
