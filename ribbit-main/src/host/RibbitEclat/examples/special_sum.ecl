

(*
j'ai voulu essayer de faire sans recursion avec juste le constructeur reg mais je
crois qu'on a pas le choix 
*)

let special_sum(n)=
    let rec special_sum_aux(n,acc) = 
        if n = 0 then acc
        else special_sum_aux(n-1,acc+n)
    in
    special_sum_aux(n,0);;
