(*$ ./eclat ../examples/gcd.ecl \
            -main=facto \
            -arg="(5,1);(3,1)" \
            -relax
*)

(*fonction factorielle*)
let rec facto(n,arg) = 
    if n = 0 then arg 
    else facto(n-1,n*arg);; 