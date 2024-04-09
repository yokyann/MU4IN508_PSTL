
let static tab = 0^10

let special_sum(tab) =
    let update_aux(i) = i + 1 
    let update(s) = s + tab[i] in
    reg update last 0
    reg update_aux last 0;;

let main(n) =     
    let rec aux(i) = 
        if i < n then (tab[i] <- i + 1 
        aux(i+1))
    in 
    special_sum(tab);;


(*
j'ai voulu essayer de faire sans recursion avec juste le constructeur reg mais je
crois qu'on a pas le choix 
*)
(*
let special_sum(n)=
    let rec special_sum_aux(n,acc) = 
        if n = 0 then acc
        else special_sum_aux(n-1,acc+n)
    in
    special_sum_aux(n,0);;
*)