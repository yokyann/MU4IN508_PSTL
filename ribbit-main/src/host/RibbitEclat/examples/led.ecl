let sum(n) = 
    let(rdy,i,acc,s) = reg(fun (rdy,i,acc,s) ->
        if s = 0 then (false,0,0,1)
        else if i<=n then (rdy,i+1,acc+i,s)
            else (true,i,acc,0)) last (false,0,0,0)
            in
            (acc);;