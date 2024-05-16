{-# LANGUAGE LambdaCase,NoMonomorphismRestriction,Strict #-}
module Main where
import Control.Monad
import Data.Char
import Data.Foldable
import Data.IORef
import GHC.IO
import System.Environment
import System.IO
zb=newIORef
sa=readIORef
rb=writeIORef
yb aa t=(aa,t)
data Ha=A !Int | V !(IORef Z) deriving (Eq)
data Z=Z {nb:: !Ha,vb:: !Ha,mb:: !Ha} deriving (Eq)
class Za aa where e::aa->IO Ha
instance Za Ha where e=pure
instance Za Z where e=fmap V . zb
instance Za Int where e=e . A
u xa y ba=e=<<Z<$>e y<*>e ba<*>e xa
qa xa y ba=e=<<Z<$>e xa<*>e y<*>e ba
hb l (V c)=l<$>sa c
ib l (V c)=sa c>>=rb c . l
g=hb nb
ea=hb vb
j=hb mb
ca c f=ib (\la->la {nb=f}) c
pb c f=ib (\la->la {vb=f}) c
gb c f=ib (\la->la {mb=f}) c
pa=u (A 0)
sb=u (A 1)
oc=u (A 2)
cd=u (A 3)
gd=u (A 4)
jb=u (A 5) (A 0) (A 0) 
{-# NOINLINE ma #-}
ma=unsafePerformIO (e=<<jb)
{-# NOINLINE va #-}
va=unsafePerformIO (e=<<jb)
{-# NOINLINE eb #-}
eb=unsafePerformIO (e=<<jb)
kb=foldrM pa eb
kc ub=kb (ord<$>ub)>>=flip cd (length ub)
pc=(=<<) (oc (A 0)) . kc
ka [] b=([],b)
ka (ga:ra) b=let n=bc ga; b'=b * 46 in if n<46 then (ra,b'+n) else ka ra (b'+n-46)
bc ga=let f=ord ga-35 in if f<0 then 57 else f
type Ed=IO ()
x f=q>>=pa f>>=oa
h=q>>= \case V c->sa c>>= \(Z bd k s)->oa k>>pure bd
fa l=h>>=l>>=x
p l=flip (,)<$>h<*>h>>=uncurry l>>=x
tc l=(,,)<$>h<*>h<*>h>>=l>>=x
ic=fmap ord getChar `catchAny` const (pure (-1))
dd=do
 hc<-h>>=g
 q>>=sb hc>>=x
wc =
 [ tc (\(n,t,aa)->e $ Z aa t n)                     
 ,fa pure                                    
 ,void h                                     
 ,p (const pure)                                
 ,dd                                       
 ,fa (pure . (\case A s->ma; s->va))             
 ,fa g                                    
 ,fa ea                                    
 ,fa j                                    
 ,p $ ya ca                             
 ,p $ ya pb                             
 ,p $ ya gb                             
 ,p $ \y ba->ob (y == ba)                        
 ,p $ \(A y) (A ba)->ob (y < ba)               
 ,p $ na (+)                                 
 ,p $ na (-)                                 
 ,p $ na (*)                                 
 ,p $ na fd                                
 ,ic>>=x . A                       
 ,fa (\c@(A f)->putChar (chr f)>>pure c)            
 ]
ya l c f=l c f>>pure f
na l (A aa) (A t)=pure $ A (l aa t)
ob t=pure $ if t then va else ma
xc ad cc=kb . reverse=<<mapM pc (replicate cc "" <> wb ad)
wb ra=case span (/= ',') ra of
 (cb,"")->[reverse cb]
 (cb,k)->reverse cb : wb (drop 1 k)
ac d b=g=<<ab b d
ab= \case 0->pure; b->ea >=> ab (b-1)
ua d []=h
ua d (ga:k)=do
 let n=bc ga; (b,m,da)=qb n 0
 if n>90
 then do
  bb<-h
  i<-q
  g i>>=qa (m-1) bb>>=ca i
  ua d k
 else do
  m<-if m==0 then x (A 0)>>pure (m+1) else pure m
  (k',b)<-if b==da then pure (A<$>ka k 0) 
  else if b>=da then let (k',tb)=ka k (b-da-1) in yb k'<$>ac d tb 
  else if m<3 then yb k<$>ac d b 
  else pure (k,A b)
  b<-if 4<m then do
   t<-h>>=qa b (A 0)
   qa t (A 0) (A 1)
  else pure b
  i<-q
  case i of
   A tb->g b>>=j 
   V c->g i>>=qa (min 4 m-1) b>>=ca i>>ua d k'
qb b m=let da=[20,30,0,10,11,4]!!m in if 2+da<b then qb (b-(da+3)) (m+1) else (b,m,da)
wa d lc=g d>>=flip ca lc>>ea d
w r=do
 o<-ea r
 g r>>= \case
  A 0->do
   o<-ta o>>=g
   n<-g o
   case n of
    V c->do
     ia<-pa (A 0) o
     A yc<-g n
     sc<-foldrM (\s fb->h>>=flip pa fb) ia [1..yc] 
     j r>>= \case
      o@V {}->do
       i<-q
       ca ia i
       gb ia o
      A b->do
       ja<-xb
       ca ia=<<g ja
       gb ia=<<j ja
     oa sc
     j n>>=w
    A b->do
     wc!!b
     j r>>= \case
      V s->j r>>=w
      A s->do
       ja<-xb
       i<-q
       g ja>>=pb i
       j ja>>=w
  A 1->do
   join (ca<$>ta o<*>h)
   j r>>=w
  A 2->do
   ta o>>=g>>=x
   j r>>=w
  A 3->x o>>j r>>=w
  A 4->do
   bb<-h
   (if bb==ma then j else ea) r>>=w
  s->pure ()
ta (A b)=q>>=ab b
ta o=pure o
xb=q>>=lb
 where
 lb= \case
  c ->
   j c>>= \case
    A s->ea c>>=lb
    s->pure c
vc db=do
 let (fc,mc)=span (/= ';') db; ((nc,rc),jc)=(ka fc 0,drop 1 mc)
 d<-xc nc rc
 gc<-ua d jc
 d'<-wa d=<<sb (A 0) d 
 d''<-wa d' ma
 d'''<-wa d'' va
 wa d''' eb
 uc<-u (A 0) (A 5) (A 0)
 dc<-u uc (A 0) (A 0)
 oa dc
 pure gc
{-# NOINLINE i #-}
i=unsafePerformIO . zb $ A 0
q=sa i
oa=rb i
qc="R1llac/pmuj,htgnel-rotcev,?=<gnirts,trats-tni-llac,raaaac,po-tsnoc,?=>rahc,raaadc,_,dna,po-tes,?naeloob,!llif-rotcev,trats-tni-tsnoc,rdaadc,tes,trats-tni-teg,mcl,etouq,dnapxe-dnoc,xam,oludom,esle,trats-corp-tsnoc,radddc,dnoc,rts-ot-tuptuo-htiw,po-teg,cc/llac,adbmal,rdaddc,rdadac,raadac,!tes-rotcev,trats-llac,tel,stropxe-xtc,?>rahc,rotaremun,?tsil,rddddc,roolf,trats-teg,yllamron-margorp-tixe,margorp-daer,ypoc-gnirts,enifed,yllamronba-margorp-tixe,gnirts-ekam,?evitagen,2/be,liat,gniliec,?=<rahc,trats-mys-teg,dnuor,elif-led,trats-mys-llac,trats-tni-tes,nim,rotanimoned,tropxe,trats-tes,trats-mys-pmuj,etacnurt,radaac,slobmys-denretninu,raddac,rdaaac,trats-mys-tsnoc,ro,trohs-mys-llac,reffub,rotcev-ekam,!tes-gnirts,qmem,fer-rav-labolg,po-fi,raaddc,trats-tsnoc,rddadc,teg,*tel,tsnoc,nigeb,trats-mys-tes,!tes,edoc-tegrat-etirw,vne-erudecorp,trats-tni-pmuj,?=>gnirts,certel,trats-fi,radadc,!llif-gnirts,tibbir,dmc-llehs,lbtmys,!tes-rav-labolg,?<rahc,rahc-etirw,?evitisop,?orez,rddaac,po-llac/pmuj,fer-rotcev,fi,sedoc>-gnirts,sfed-teser,tsil>-elbat,tros-tsil,enil-dmc,edoc-etareneg,?ddo,rahcteg,tpxe,?regetni,yrarbil-daer,dcg,elif-tupni-htiw-llac,lper,relipmoc-enilepip,htap-elbatucexe,elif-tpircs,ssenevil,sisylana-ssenevil,?=rahc,noisnetxe-htap-csr,htgnel-elbat,gnirts-ot-tuptuo-htiw,dnibnu-neg,enil-daer,!tros-tsil,elif-morf-tupni-htiw,>,lobmys-denretninu>-gnirts,?qe,rebmun>-gnirts,margorp-elipmoc,vssa,?neve,?erudecorp,elipmoc,=<,lave,?>gnirts,redniamer,elif-ot-tuptuo-htiw,?<gnirts,!tes-evil-xtc,edocne,stropxe-tcartxe,xua-lobmys>-gnirts,tsil-dnapxe,yrotcerid-htap-csr,xua-rebmun>-gnirts,xua-sisylana-ssenevil,stropxe-htiw-srpxe-pmoc,fer-tsil,raadc,repo,rebmem,rahc>-regetni,xua-gnirtsbus,2xua-rebmun>-gnirts,!tes-tsil,xua-pmc-gnirts,radac,elbat-ekam,xua-rahc-daer,edoc-erudecorp,?=gnirts,xtc-ekam,*dnib-pmoc,?tnatsnoc,!tes-elbat,radc,gnirts>-lobmys,raaac,tnemmoc-piks,tsil-etirw,tsil-daer,?ni,tsila>-stropxe,rdaac,raac,xua-tsil-ekam,rdadc,xua-esrever,raddc,xua-?tsil,evil>-stropxe,elif-morf-gnirts,liat-tsil,tixe,xua-dcg,evil-xtc,lobmys>-gnirts,?2erudecorp,tnatsnoc-dnapxe,hcae-rof,lla-daer,ydob-dnapxe,lave-dnapxe-dnoc,pmc-gnirts,elif-morf-daer,!rac-tes,1tsil,xua-gnirts>-rebmun,lobmys-esu,3tsil,nigeb-dnapxe,rotcev>-tsil,2tsil,?rotcev,rdddc,tsil-ekam,sba,enilwen,ecapsetihw-non-rahc-keep,regetni>-rahc,lobmys-daer,poon-neg,?gnirts,lobmys-denretninu>-rts,tsil>-rotcev,fer-elbat,gnirtsbus,ngissa-neg,tes-etc-xtc,cossa,!tes-2dleif,gnirts>-rebmun,enod-ydob-dnapxe,2rahctup,rdddac,?tcejbo-foe,llac-neg,llac-pmoc,?ecnatsni,daer,fer-gnirts,srahc-daer,etanetacnoc-gnirts,rts>-lobmys,rahc-keep,pp,fi-dliub,?evil,dnetxe,erudecorp-ekam,sesualc-dnapxe-dnoc-dnapxe,dnib-pmoc,etirw,*nigeb-dnapxe,!tes-1dleif,dnpo,etc-xtc,gnirts>-maerts,rorre,?llun,txen,qssa,!rdc-tes,tneitouq,?bir,pukool,evil-dda,srahc-etirw,nigeb-pmoc,=>,esrever,htgnel-gnirts,dneppa,vmem,rddac,=,gnirts>-tsil,!tes-0dleif,xeh-daer,tsil>-gnirts,?lobmys,htgnel,rahctup,*,2dleif,rpxe-dnapxe,yalpsid,hguorht-epip,ecalper-gnirts,setyb-ot-edoc-mvr,rid-toor,?lauqe,pam,dnapxe-htap,rahc-daer,0dleif,1dleif,rddc,pmoc,ton,<,+,-,rdac,esolc,dneppa-gnirts,?riap,rac,?vqe,1gra,2gra,rdc,di,snoc,lin,eurt,eslaf,bir;8U0!U08BYU9YTMYS<ki$i$kiXCy!V$8TDG8Bby^8B_~TiX;^{!@7&i&kkA^[$G9@iY#Z$>aZPZ#h-_f7$IlfA^[$G7/fJldb7'Il^~YU+ZB`h1ZBJ`dh/70>>h.ZPh.gh3h4_^Jh/c~Kk^zi$~YTHZ#gJf_|i$Z#aZ#_|!?9@`SYI_G9KYS)^z{!U9(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBi$(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBYBiX9BYBZ#^BYBiY+~Z%ldFiY*(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBi$(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBYBiX9BYBZ#^BYBiY+~Z%ldFYSEe~e_YSERUFFFdiXJbiX$(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBi$(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBYBiX9BYBZ#^BYBiY+~Z%ldFiY*(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBi$(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^LgAWiX8iX.WViXHaViXA_WViWNaViX*_Wa_`iXO(^YA_RUFFiXBeiXI(^^~ATiY&e(^YA_RUFFiXBeiXI(^^~A^~^Lg^~TiX0cBYBiX9BYBZ#^BYBiY+~Z%ldFYSEe~e_iX&~TiX(aYTA__@cDb}(!SE8U2G8U&i$^z^z!VO8PYS8`8PYS<~TiY-`YU4^{!U48S8^8S8RRUiY%FiXM^~TiXFYU*^z!S88U$iS<^z!S<'YS<^(i&~ZG^ZCy!>8T=AYU/8T=A^~^YU.y!U>8<YI_iS)z]18LS_G8T5^8T5vD~YMvS#^JvF^zz!TA7&i&`kA^[$G7&ca_A^[$G7&cg_A^[$G7$aA^[$G/FFZ1aiX?Z@iX>SaG8LZ$YI^Z?^zZ1XBi&IYG`YGeX?i&hR%7'@^~i$/FFZ1aiX?Z@iX>SaG8LZ$YI^Z?^zZ1XBi&IYG`YGeX?i&hR%7'@^~YT,iX6Z?D^~E^zi$70>h-a@eJlcBYKd^@aYS%iX,7.e@ca~^Z-hR%^D^D_~E_|i$7.e@ca70>h-a@eJlcBYKd^@a@^~^Z-hM^D^D_~E_|i$70>h-`@eJlcBYKd`YS%iWP70>h-`@eJlcBYKd`@^~^Z-hH_@_D^D_~i$7&ca_A^[$G7&cg_A^[$G7$aA^[$G/FFZ1aiX?Z@iX>SaG8LZ$YI^Z?^zZ1XBi&IYG`YGeX?i&hR%7'@^~i$/FFZ1aiX?Z@iX>SaG8LZ$YI^Z?^zZ1XBi&IYG`YGeX?i&hR%7'@^~YT,iX6Z?D^~E^zi$70>h-a@eJlcBYKd^@aYS%iX,7.e@ca~^Z-hR%^D^D_~E_|i$7.e@ca70>h-a@eJlcBYKd^@a@^~^Z-hM^D^D_~E_|i$70>h-`@eJlcBYKd`YS%iWP70>h-`@eJlcBYKd`@^~^Z-hH_@_D^D_~KiV4^~E_|i$YU;YU<h<G4X)_X(_{BX5h<BX1h<BYS=iX)G74n^z[$G89^@`3YG_vS[rz0~^YT6iX)^D^z[%G90i&iX290_iX77+X,>ciUMZ3`Z._~CiV.^7+AZ0_iX@7+AX/c^~YS?^7+AX3dX4_iV6~YH^7+AX4d_iW@7+A>cJ_iV,~Kv.^~X-^Z3`Z._~CiWH^7+AZ0_iXG7+AX3dX4_iVE~YH^7+AX4d_iW=7+A>cJ_iW#~Ku^~X-^Z3`Z._~CiW2^7+AZ0_iXN7+AX3dX4_iV&~YH^7+AX4d_iVA~X-^Z3`Z._~CiWC^7+AZ0_iY(7+AAX4e_iVB7+AA>dJ_iW+~KiV4^X3^~YH^7+AX4d_iWJ~X-^Z3`Z._90_iY)73d_iV<'cJ_k~Kv7^X2^~YH^73c_iUP~X,^Z3_~CZ.`k~CiUA^YT7^~Z*^{[&G8U5^z['G7,X4d`JoiW67,>cJ`iW6~Ko_Z._P^YT-^{[(G72e_`(^~YMk`>bJiVI^72e_`(^~YMk`>b^~CcaIYEiVI__Z+iVI^|[)G7.a`^{[*G'``'@`Jl`~YMJliVI^D^X/a_|[+G'X0b`^|[,G89^YS#i$_h>z[-G(i$76n^~CiWC_77l^BZ4_aBYKiW2aX8^76m^~AAi$77l^BZ4_aBYKiW2aX8^76m^~AAZ%k`~X-`77l^BZ4_aBYKiW2aX8^76m^~AA^~^YS?_77l^BZ4_aBYKiW2aX8^76m^~A^~^YH^~CiWH_76l^~CiW2_76k^~CiUA_73^~CiV._Z3_YT7^z[.G(i$71Z.^BX0^~Z*^z[/G(i$75^~YS?^(i$9LJYD`l^~YMm`94JO`l^~YMl`8KJP`l^~YMk`AA^BYT(`ahA:kkk(i$9LJYD`l^~YMm`94JO`l^~YMl`8KJP`l^~YMk`A^~^YS#i$_h?~YH^{[0G(^BX4`^{[1G71Z.YT-^z[2G(^BX4k^z[3G(^BX6n^BX?_`[9Jlh8YS@FZKh8iX#1^~^Z-h>^(w&~Ci&^(w%~Ci%^(w$~Ci$^z[4k[5G9LX=X;YD_^P^z[6G7%`h>A^[$G(_7-XE:gbiWC_@bN`H_D^D^~E^{i$z[7G#X>bYD`O_P^(_~Ck^{[8G7%a@iX-A^[$G(_7)AAb7)AAX-c_~i$7)AAb7)AAX-c_~AAKYDak7)AAb7)AAX-c_~AA^~^KO`k7)AAb7)AAX-c_~A^~^KP_k~^YS#i$_hFDD_@^~E^{i$[$G#::::h.XBngiWCX@kw#iUAliWHkiWHHZ-iX-_iWH{i$z[9G(`[@>h@>>`a_X?k^{[:G90_iX/7@XA::fX;kw#iUAoiWHYG_^YS$^~YS/^7@XA::fX;kw#iUAniWHYG_^SYI_iS)~YS&^7?X@::eX:kw#iUAkiWH@_D^~E^#a_iWH#::eX:kw2iUAIbkiWHkiWH~Kk^~X*^#aX6m_iWH~YH^#bX7l_iW2X7^~AZ-h@_90_iX/7@XA::fX;kw#iUAoiWHYG_^YS$^~YS/^7@XA::fX;kw#iUAniWHYG_^SYI_iS)~YS&^7?X@::eX:kw#iUAkiWH@_D^~E^#a_iWH#::eX:kw2iUAIbkiWHkiWH~Kk^~X*^#aX6m_iWH~YH^#bX7l_iW2X7^~A^~^YOiX%^{[;i&[<YT/i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i$i${!UMJJloiW6!W6JmiV6!V6JliW@!W@Jv.iV,!V,JmiVE!VEJliW=!W=JuiW#!W#JmiV&!V&JliVA!VAJkiV=!V=JmiVB!VBJliWJ!WJJiV4iW+!W+JmiV<!V<JliUP!UPJv7k!V4IJJJJv4v7uov.vS#!VIZ+mvS#!U-(cBX'i%i&b[$G(i$7)`@^BX+i$`D^~E^{[%G(i$7+a_7.i$Z:c_YN`H_~CwW0^7+a@_~CwV'^7.i$YPcS`i-YN`BX,bS_i1H_~CwW*^7-i$aZH_BX-i$aYN_BX-i$aH_~CwU?^(i$70i$d_BZ,>@``^~^Z;h1_Bi$(i$70i$d_BZ,>@``^~^Z;h1_BX/_~h17/i$c^~YSOc_YN`H_~CwV%^7-^H_~CwW;^D^~E^7,^(i$~YSO`^~YH^|[&G(i$8S=YS$_c~YS/^7)@^BX)D^~E^7*^~YH^z['G(k[,Z(g^zi$i$i$i$|!SO5CZ)ka_^{!T)(i$(i$(i$,DH_wW;~EH^~Z/N^~E@^z];(i$9;@a_(^~CD__D_~E_{]('a^>i&^(_~Z;`^{!U=7$_A^[$G(i$7'@^BZ,i&D^~E^zi$z!SF(i&'YSF@_>i&DD^~E^z!T;7$Z(Z(Z(Z(YSFAi&7$Z(Z(Z(Z(YSFA^~^dw(w0w*w+A^[$G7(^(_~C`^YU-Le_bBYU=^zi${!U,(^8T;a_~ZM_wUHYT;i&^{!T>(i&'YT>@_YCD^~E^z]8(_98a@_95a@^~AYS:D_98a@_95a@^~A^~^CD_wW7D^~E^{!S:,wUJ^5LYOS@`iS:i%~i$,wUJ^5LYOS@`iS:i%~CwV5D^~E^5YOS@`iS:i$~i$,wUJ^5LYOS@`iS:i%~i$,wUJ^5LYOS@`iS:i%~CwV5D^~E^5YOS@`iS:i$~CwWDD^~E^5YS:H^~i$,wUJ^5LYOS@`iS:i%~i$,wUJ^5LYOS@`iS:i%~CwV5D^~E^5YOS@`iS:i$~i$,wUJ^5LYOS@`iS:i%~i$,wUJ^5LYOS@`iS:i%~CwV5D^~E^5YOS@`iS:i$~CwWDD^~E^5YS:H^~Cw5D^~E^z]5(_'_YC_98_@_~i$'_YC_98_@_~CwW:D_~E_95_@_~i$'_YC_98_@_~i$'_YC_98_@_~CwW:D_~E_95_@_~CwV'D_~E_Z5a@_D^~E^{!S28S>k-^'_wV'~E@^~E^Z5i&^z]J8S2_8C>>aZ$_wUN~E^{!S;7%i&_A^[$G9JiX<_9J``7+>c>Na_@`7+>c>>i&>>Nc@awW0D_@`~E^H^~i$9J``7+>c>Na_@`7+>c>>i&>>Nc@awW0D_@`~E^H^~i$9J``7+>c>Na_@`7+>c>>i&>>Nc@awW0D_@`~E^H^~E@^~CD_wVM~E^D^~E^{i$z!S>'>i&_wW;z!C8S>^8T>_8Ci$8C>>>>i&>NcwW4>@HbwV'DH`wU?8C>@H`wV'~CDH`wW7~E@_~CwW4^8Ci$8CH_8C>>>i&>>>>i&>NewV5wWEwWEwU?>i&>>i&HawWEwW*~EN_~E@_~CwV5^8Ci%8CH_8C>>>>i&i$>NbwWDH`wU?~EN_~E@_~CwWD^'>>i&YCYNb_wV%'>>i&YC>>Nd@awW0D_wV%~E^H_~CwVM^8S2@_~CwV'^8C>>YPNcSaG'>>i&H`D_wV%zS`G'>i&i$D^zwW*H_~CwUN^8C>@a8C>>>i&>>Nd@awV)>i&D_~i$8C>@a8C>>>i&>>Nd@awV)>i&D_~E@_~E_wW*H_~CwV)^8S;Na'>>i&YS;NcS`G'>i&YCH_D^zwW*~E^^8CA>S`i1>>>i&a>i&>>i&>>YS.eSbi-wW0`wUNYN`~YH^H_~CwW*^'>>i&YS;Nb_wW0H_~CwW0^'>>>i&i$'>>>i&YCZHb~EYS.bYCYNaYCH`wU?~CwU?^'>>i&YCYNb_wV%H_~CwV%^8S>H_~CwW;^D^~E^(^~YH^z!TM(^Bi$(^BZ=@^BYBiX3~Z%nbBi$(^Bi$(^BZ=@^BYBiX3~Z%nbBZ=D^BYBiXK~Z%mbYT:YSN_>i&i$(^Bi$(^BZ=@^BYBiX3~Z%nbBi$(^Bi$(^BZ=@^BYBiX3~Z%nbBZ=D^BYBiXK~Z%mbYT:YSN__~E_@_D^YT@_{!T:'ASaG'_^D^z'A^~^bZ9i&:MiVHbYT+Ai&'ASaG'_^D^z'A^~^bZ9i&:MiVHbYT+A^~^eai&kkYU,a^YS2^{!SN(^8<_G'H_D^'_^~YH^z~E^z!T@7&i$i&_A^[$G'aZ$_7,c>b_@_7,YPAi&7,YPA^~^d@`a@_~i$7,c>b_@_7,YPAi&7,YPA^~^d@`a@_~CwV>D^~E^D^~E^|i$z!VH:kw(iUA]:(_'Z:a@_D^~E^{])(^9)Jlb@`^(`~C_D_~E_|]E7&^6ZEd@bZN>Z2bi$`D`^~E_|]&6b6:Z&f@dbYS4w+aiUA~E@aD`^|!S4(_BYTBZ(YSA``^{!U'#aYS4w*_iUA(_~CiVH_{!T*9&eca6YT*YU'h2gh/ZN>Z2h/eh-@f@dZN>Z2di$b_`DaD_~E_})]78T*geab`^}(!S'#`kiWH8D^~i$#`kiWH8D^~i$#`kiWH8D^~i$#`kiWH8D^~Z*YD^~Cw+O^~CiUAP^~Z*^z]O#YS'a_iWC{]F#a_iUA#k_iUA~CiVH_{!6#b`iWH97f>i&>bwWE>i&aiXD`9EG9Fh.^Z)kZ2_dz_`~YH_@`97gaSbi1Sai-aNaH`~CwW*^9&c@a_~CwV'^#ZFeYS4w0b#d~Z/Z2bZ9i&:Z&iVHNeZNZ:>>Z2gi$i$bckYG_iWHH`~CwW0^6`Hdb:a_iV.MdYNb`McZHa_~CwU?^6ZOg``b8S'e6ZOh-aac8S'e~YT)^~^Z;YSAc`~Ca^Z)lZ2b_YNaH`~CwV%^#cHaiWH~CwW;^D_~E_#d`iW2#dHH_iWH~i$#d`iW2#dHH_iWH~YT)^~^Z;YSA``Z)kZ2__~YH_|!TB8S7`O^{]N#YD`O__{!W)8D^z!SA-O^z]289^z!T+#b>i&`^|].8D^z]388^z!T789^z!S?iTJ!V.wU?!WHwV(!W2wV*!WCwW>!UAwWM]@(iY'7%YIDa@`A^[$G8L_7)YPYPbeYID_@^~E^{i$YI`Z$^~E^{!U/(iXPy!U.-YU:y!U;8U%YPi&`^{!U%7(_c(i&~YM_kYGb[$G(^BZ,b_(^BZ,a_7/f@dc`BZ,ca7/@fdd`BZ,da~X0`^DbD`~Ea~E`}'[%G(_(^7-d@ba`7-@dbba~X.`^D`D^~E_~E^{[&G7%a_A^[$G71_X2eeX1Ief_7)@`Il^~YU#k^{i$Z+m_(^BZ,i&^~YMl_{i$i$i${]=8S+BZ6^z!U&7$i&A^[$G7(>`^8LZ$_~ACf_7(>`^8LZ$_~A^~^ZG^Qbzi${!;/F`iX+_/__~YMvR$YS)ZBIlZ#`_(^~YMkZ#_{!T=7$IlZ#_A^[$G7'Il^9PJl`kb~YMvR$YS)ZB_b(iWO~Kk^zi$z!U*7$IlZ#_A^[$G7'Il^9PZ#d_b~YMvR#YS)ZB_b(iX1~Kk^zi$z]?8S#YT&`_iV9z!S%(^BYT(b_iV9YS@^FZKYU)iV9iX:z!V9YT/!U<-^z!U)8GD^z!T(8S7>Da>ca_9,b^~^ZMD__|!S#(a)^~^ZMD__|!T/'i&i&y!W38U(^z!VL8SCly!VP8SCky!U:'i&iY,y!A(_BYBiX'BYB^BYBiXLBYBiY$BYBiX={!VC(i$z!UI(i$z]08SClBYS+BZ6_BYBiXEBYB^{!U18U1BYS+BZ6YTG^8S+~ZG^ZCBZIvCvR3y!TG7#YTI^z!TI99i&:MiVHai&kkz!VH:kw(iUA]:(_'Z:a@_D^~E^{])(^9)Jlb@`^(`~C_D_~E_|]E9F`^Z)ka_@aD`6ZEd@b>ai$D`^~E_|!S'#`kiWH8D^~i$#`kiWH8D^~i$#`kiWH8D^~i$#`kiWH8D^~Z*YD^~Cw+O^~CiUAP^~Z*^z]O#YS'a_iWC{]F#a_iUA#k_iUA~CiVH_{]&6b6:Z&f@dbw+iUA~E@aD`^|]76Z&:h-w*iUA6Z&f~CiVHfd>aaa^}(!S6'i&^z!S0'YS6`^{!S3'YS0b`^|]<'YS3ca_wU?|!6#b`iWH97f>i&>bwWEawWE`9E>ea_`~YH_@`6ci$6cZ<>NdwW4>@HcwV'DHa6c>@HbwV'~CDHbwW7~E@a_~CwW4^6ci$6cA^6cAYS3Z<>NgwV5wWEwWEYS6YS0`wWEwW*~ENbHa~E@a_~CwV5^6ci%6cA^6cAZ<i$>NdwWD^~ENbHa~E@a_~CwWD^97fNdH`D_`DH`~CwW*^9&c@a_~CwV'^#ZFew0#d~Z/bZ9i&:Z&iVHNeZ:>>fi$i$akYG_iWHH`~CwW0^6:MgZHecMfYNdbiV.Ha_~CwU?^6ZOdZ)lbHbYNa_~ACwVM_97f>i&>bwWEawWE`9E>ea_`~YH_@`6ci$6cZ<>NdwW4>@HcwV'DHa6c>@HbwV'~CDHbwW7~E@a_~CwW4^6ci$6cA^6cAYS3Z<>NgwV5wWEwWEYS6YS0`wWEwW*~ENbHa~E@a_~CwV5^6ci%6cA^6cAZ<i$>NdwWD^~ENbHa~E@a_~CwWD^97fNdH`D_`DH`~CwW*^9&c@a_~CwV'^#ZFew0#d~Z/bZ9i&:Z&iVHNeZ:>>fi$i$akYG_iWHH`~CwW0^6:MgZHecMfYNdbiV.Ha_~CwU?^6ZOdZ)lbHbYNa_~A^~^CwV%^#cHaiWH~CwW;^D_~E_#bZ)k``iW2~YH_|!V.o!WHn!W2m!WCl!UAk]I8F_BYF^{!S+8Fuy!UEiF]'(i$9'a@_BYF^9'a@_BYF^BYFvS#~ACvS#_9'a@_BYF^9'a@_BYF^BYFvS#~A^~^CvE^9'a@_BYFvS;BYFvS#~Ct^9'a@_BYFvS9BYFvS#~Cv0^9'a@_BYFvS5BYFvS#~Cu^9'a@_BYF^~L`D^~E^{!T#(i$(i$8T#@^BZ6D^~E^BYFvC~E^z!B8BZK^9IvS7vF~YTJ^96YS$^BYFvF~YS/^9'i$YI^~YS&^8BYT&^~YH^8FvLBYT#@^BZ6D^BYFvK~E^9IvLvK~Z/^9IvS;vF~Ci%^9IvS-vF~L^z]68B^8FvEBZ'i%YI^BYFvE~YS&^z!T$8T$8S*~Cu^(^~Kk^Qy!S*8S*BQ(^8T$~CvR0^~K_vC(iX5~ZG^Z>y]A9A>`^9A>a^9A>at~CvS;^9A>av0~CvS9^9A>au~CvS5^Q~CvS#^9$_~CvE^(i&~ZG^Qz!S('YS(^BQ(i&~AAKvD`'YS(^BQ(i&~AA^~^CvL_'YS(^BQ(i&~A^~^CvK^Z>y!SP'YSP^ZC(i&BQ~CvL^YS*y!J(_8JIIvRL_YE`v3BQ~i$(_8JIIvRL_YE`v3BQ~KvS.^~K_vS'8JIIvR,_YE`v3BQ~i$(_8JIIvRL_YE`v3BQ~i$(_8JIIvRL_YE`v3BQ~KvS.^~K_vS'8JIIvR,_YE`v3BQ~KvR<^~K_vR58JIIvR%_YE`v3BQ~i$(_8JIIvRL_YE`v3BQ~i$(_8JIIvRL_YE`v3BQ~KvS.^~K_vS'8JIIvR,_YE`v3BQ~i$(_8JIIvRL_YE`v3BQ~i$(_8JIIvRL_YE`v3BQ~KvS.^~K_vS'8JIIvR,_YE`v3BQ~KvR<^~K_vR58JIIvR%_YE`v3BQ~KvR/^~K_vR$Z>z]C8S@`(^~^^YTN^YL>YS(^BQ8LZAi&BQ~CvE^'>i&ZCwW;BQ~CvJ^8S1ZC2YJkk8JkBQ~CvP^Z>BQ~ACvRM_8S1ZC2YJkk8JkBQ~CvP^Z>BQ~A^~^CvS?^(i%BQ~CvS;^(i$BQ~CvS-^Z>BQ~CvF^8SPBQ~CvK^(^~Kk^YS*y]>(^!V3^Qy!T.(^!V3iX4(^~CiX5^!V3^z!:8T.^8T.YU7~CiX4^(^~CiX5^iV3y!V3iX4]G,iX5^z!W17%G(_BZLYDc^BYKPc^OOGi$zOOGi$z!S=(i$8S=@`^BX$D_~E_{!<(i&'S@a_X$D_~E_{!V#i8!T-i9]9#l`^{!TJZDl!WA8KYS-aO_^{!V28S1YS-k^z!W,8T2b`P^|!U@8T9`P^{!WLi8!S$i9!S1#oYG_^z!S/ZDo!UK8KYS-aO_^{!VN8LYPi&YI^z!/8LYPYI`YI^{!T48La8T4>fZBbb`a_Il`~Ka_}']P8T4i&b`^|!T1(k(iX5~E_(l8T1@b@`(l~K`^(iX5~K__D`D^~E_~E^{!S98T1YI`YI^{!UO5YTC`^{!WK5YTF`^{!TF4YS9a_k{!TC4kYS9`^{!T,,kYS9`^{!VK8LYS-vC^z!V18T2b`P^|]B8T9`P^{]#i8!Ii9!L#nYG_^z!S&ZDn!T5i(!S)i(!WGj%!VFiTH!W(iU#!UFi4!U+i,!T3(_(i$(i$8T3IIvR%`YEbu@_~KvR/^~K_vR$D^~E^{!T<8T3k^(i$~Z/^z!TN(i$2_k~^YT<^8T<@^~CvPD^(i$~Z/^YI^z!S5(^8S5_`~Kak>b^JIYEu``vR%Z+u^{]K8LYS5i&^8L>YS5i&I`kvP~Kk^z!U6(^8E__~YU8`YU6Z+m`YE_^(l~Ck_{!VDi(!V;i(!VGi(!W$i(!V?(lz!W'i(!W<8E_Z+YU3``_YS,`YS,^(k~Ck_{!SB8SB_YTE__(_~Ck^{!U38SB`^8SB__~K__YS,`YS,^{!W83b^(^~CKkbKk`(k~Ck^IYE`a_Z+`^{!TE2YEZ+b``^{!S,(^2_k~Kk^z!V@(_(^~K`^{!W9(^(_~K`^{!U85YTK^z!TK,YEZ+m`m^z!VJ4k^z!UD4_kz!UC,k^z]%5K`^{!TH5K__{!U#4__{!Mi,!U55Z*^zBZ4ki#!UHOi#!T?(^!UH>iUH^YTP^8T?Oa_(^~T`O^P_~E_{!S@8T?iUH^z!UGiK!V/i9!T&i8!TP#m_i$z!HZDm!SK(`8SK>ca`Il^~K_k|!S-8SKi&`^{]M(i$9M@a_(^~TD__D_~E_{]-iTL!TL(i$8TL@a_(^~CD__D_~E_{!T6(i$8T6@`^(_~TD`^~E_{!V0iO!O(i$8O@`^(_~CD`^~E_{!SD(^8SDIl`@^~K`k{!T28S7aYSD`^|!T9-YSD`^{!SI(_8SI>aD_@^~E^{]$8SIi&^z!P(_'YPa@_D^~E^{!G(k3YG@_l~E^z!SG9/^9/^8SG@a@^~E^(i$~YTOa^@^~E^{!W&8SG_^z]/,i&^z!W%8S.O^z!W58S.P^z!W/8SHO^z!V-8SHP^z!V+8SJO^z!UL8SJP^z!W?8T8O^z!WF8T8P^z!V88NP^z!W.8T0O^z!W-8T0P^z!UB8SMO^z!V:8SMP^z!V78T%O^z!WI8T%P^z!S.87O^z!SH87P^z!SJ8T'O^z!T88T'P^z!T01P^z!SM8SLO^z!T%8SLP^z!T'88P^z!SL89P^z]H8NO^z!N1O^z!788O^z!189O^z],j4!S7iK!)i8!-i9!'#k`^{!.ZDk!=(i$(i$(i$(i$8=PaP_~TOaO_~TYDaYD_~Z*`(i$~CpYD_~Z*_(^~^C`^{!TOi,!WB5_(^~^Ci%^z!5,i$^z]D0(i$,bYD^~Z*^zz!XC:nn:k:k:ki&vS4vS=vS9!X;:nl:ki&vP!Y#:nki&!XJ:np:k:k:k:k:ki&vR#vS4vS=vS9vR$!X$:np:k:k:k:k:ki&vR$vS;vS:vS6vS/!Y*:nki&!X8:nv::k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS4vS(vS9vS.vS6vS9vS7vCvS,vS/vS;vCvS-vS6vCvS,vS+vS6vS*vCvRBvRKvRG!X.:nv>:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vDvRDvRAvRAvR:vR=vCvS:vS;vS5vS0vS9vS7vCvS;vS(vS/vS;vCvS,vS+vS6vS*vCvRBvRKvRG!XH:nl:ki&vO!XA:nl:ki&vO!WN:nl:ki&vC!X*:nl:ki&vC!XO:nvR$:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS@vR+vS=vS2vS3vR/vJvDvS4vS2vS3vR/vKvDvR2vRGvS=vR3vR4vR/vRGvS=vR3vR4vR6vRGvS=vR3vR4vR6vRGvS=vR3vR4vR9vRGvS=vR3vR4vR9vS=vR3vR4vS<vJvR0vL!Y&:nn:k:k:ki&vS4vS=vS9!XB:nr:k:k:k:k:k:k:ki&vS@vS-vS0vS5vS0vS4vR$!XI:np:k:k:k:k:ki&vR$vS;vS:vS6vS/!X0:nn:k:k:ki&vS4vS=vS9!X9:nr:k:k:k:k:k:k:ki&uvS:vS,vS;vS@vS)vC!Y+:nv8:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vCvR/vS/vS;vS.vS5vS,vS3vCvS,vS+vS6vS*vCvRBvRKvRGvCvMvMvM!X&:nki&!X(:nn:k:k:ki&vS4vS=vS9!Y-:nl:ki&vP!Y%:nn:k:k:ki&vS)vS0vS3!XM:no:k:k:k:ki&vS4vS*vS:vR#!XF:nki&!X?:nl:ki&vR0!X>:nl:ki&vO!X6:nki&!X,:nki&!WP:nki&!X):k:k:k:ki&w&w%w$w#!X2:nv/:k:k:k:k:k:k:k:k:k:k:k:ki&vS+vS,vS;vS*vS,vS7vS?vS,vCvS)vS0vS9!X7:nu:k:k:k:k:k:k:k:k:k:ki&vS7vS6vCvS5vS>vS6vS5vS2vS5vS<!X@:nv5:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS;vS:vS5vS6vS*vCvS,vS+vS6vS*vS5vS,vCvS;vJvS5vS(vS*!XG:nv3:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS;vS,vS.vCvS,vS+vS6vS*vS5vS,vCvS;vJvS5vS(vS*!XN:nv3:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS;vS,vS:vCvS,vS+vS6vS*vS5vS,vCvS;vJvS5vS(vS*!Y(:nv4:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS3vS3vS(vS*vCvS,vS+vS6vS*vS5vS,vCvS;vJvS5vS(vS*!Y):nv4:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS7vS4vS<vS1vCvS,vS+vS6vS*vS5vS,vCvS;vJvS5vS(vS*!X#:nl:ki&vS&!X-:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&:k:ki&v7wSC:k:ki&v6wF:k:ki&v5wU7:k:ki&v4x+:k:ki&v3wE:k:ki&v2w2:k:ki&v1w3:k:ki&v0w4:k:ki&v/w,:k:ki&v.xL:k:ki&ux4:k:ki&twK:k:ki&swD:k:ki&rw8:k:ki&qw9:k:ki&px*:k:ki&ow0:k:ki&nw*:k:ki&mw+:k:ki&lw(:k:ki&kw#!X/:nv7:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vS;vS5vS(vS;vS:vS5vS6vS*vCvS+vS3vS0vS<vS)vCvS;vJvS5vS(vS*!X%:k:k:ki&i&i%i$!X<:ki&k!X3:nv0:k:k:k:k:k:k:k:k:k:k:k:k:ki&uvR/vS:vS;vS9vS6vS7vS?vS,vCvMvMvM!XK:nv1:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&uvR/vS,vS+vS6vS*vCvRBvRKvRGvCvMvMvM!XD:ki&wWE!Y':nki&!XP:nki&!X+:nl:ki&vR$!WO:nm:k:ki&vR$vR#!X1:nki&!X::nn:k:k:ki&vR5vR5vR5!Y,:nki&!X':nv.:k:k:k:k:k:k:k:k:k:k:ki&uvR#vS@vS3vS3vS(vS<vS5vS(vS4vC!XL:nvE:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&vCvS.vS5vS0vS5vS5vS<vS9vCvS@vS9vS;vCvS6vS;vCvS;vS5vS(vS>vCvS;vS/vS.vS0vS4vCvS<vS6vRNvCvMvMvM!Y$:nvO:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&uvR#vS+vS,vS0vS-vS0vS5vS0vS4vCvS;vS6vS5vCvS:vS(vS>vCvS,vS+vS6vS*vCvS+vS,vS;vS(vS9vS,vS5vS,vS.vCvS,vS/vS;vCvS6vS:vCvMvMvM!X=:nvR/:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:k:ki&uvS4vS,vS;vS:vS@vS:vCvS,vS4vS,vS/vS*vRHvCvS:vS0vS/vS;vCvS/vS;vS0vS>vCvS+vS,vS;vS9vS6vS7vS7vS<vS:vCvS;vS6vS5vCvS:vS0vCvS5vS6vS0vS;vS(vS*vS0vS-vS0vS5vS0vRBvCvMvMvM!XE:nl:ki&vC!X4Imk!X5Ilk!(:lkl!+:lkm!*:lkn!0:lko]*:lkp!9:lkq!8:lkr!D:lks!K:lkt]4:lku]L:lkv.!,:lkv/!4:lkv0!3:lkv1!2:lkv2!E:lkv3]+:lkv4!U7:lkv5!F:lkv6!SC:lkv7y" 
main=do
 hSetBuffering stdout NoBuffering
 fb<-getArgs
 db<-case fb of
  [ec]->readFile ec
  s->pure qc
 zc<-vc db
 w zc
