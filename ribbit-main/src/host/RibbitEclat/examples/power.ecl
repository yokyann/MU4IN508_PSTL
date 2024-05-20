let power(x,n)=
  let rec power_aux(x,n,acc) =
    if n = 0 then acc
    else power_aux(x,(n-1),(acc * x))
  in
  power_aux(x,n,1);;

let main(x,n) = power(x,n);;