import Link from "next/link";

export default function NotFound(){return <main style={{minHeight:"100vh",display:"grid",placeItems:"center",background:"#071a2f",color:"white",textAlign:"center",padding:24}}><div><span style={{color:"#35c5f0",fontWeight:900}}>ERROR 404</span><h1 style={{fontSize:54,margin:"12px 0"}}>Esta ruta necesita un lavado.</h1><p style={{color:"#aac1d3"}}>La página que buscas no está disponible.</p><Link href="/" style={{display:"inline-block",marginTop:20,background:"#087cf0",padding:"13px 20px",borderRadius:10,fontWeight:800}}>Volver al inicio</Link></div></main>}
