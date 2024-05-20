let sub(i:int<8>) =
    let update(s) = s - i in
    reg update last 10;;

let main(i) = 
    let x = sub(i) in
    x;;
    