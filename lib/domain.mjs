export const workflow = ["received","queued","preparation","exterior","interior","drying","quality","ready","delivered"];
export const specialStatuses = new Set(["paused","authorization_required","delayed","cancelled"]);

export function canTransition(from,to,role="operator") {
  if (from === "delivered" || from === "cancelled") return false;
  if (to === "cancelled") return role === "supervisor" || role === "admin";
  if (specialStatuses.has(to)) return to !== "cancelled";
  const current=workflow.indexOf(from), next=workflow.indexOf(to);
  return current >= 0 && next === current + 1;
}

export function estimateCompletion(receivedAt, serviceMinutes, queueMinutes=0, adjustmentMinutes=0) {
  const duration=Math.max(0,serviceMinutes+queueMinutes+adjustmentMinutes);
  return new Date(new Date(receivedAt).getTime()+duration*60_000);
}

export function applyPromotion(total,promotion,now=new Date()) {
  const starts=new Date(promotion.startsAt), ends=new Date(promotion.endsAt);
  if(promotion.status!=="active"||now<starts||now>ends) return { total, discount:0, reason:"not_applicable" };
  const discount=promotion.type==="percentage"?total*(promotion.value/100):promotion.value;
  return { total:Math.max(0,total-discount),discount:Math.min(total,discount),reason:"applied" };
}

export function publicLookup(orders,code,phone) {
  const normalize=value=>String(value).replace(/\D/g,"");
  const order=orders.find(item=>item.code===String(code).toUpperCase()&&normalize(item.phone)===normalize(phone));
  if(!order)return null;
  return { code:order.code,vehicle:`${order.brand} ${order.model}`,plate:`${order.plate.slice(0,1)}••• ${order.plate.slice(-3)}`,status:order.status,estimatedAt:order.estimatedAt };
}

export function canReadOrder(actor,order){return actor.role!=="customer"||actor.customerId===order.customerId;}
