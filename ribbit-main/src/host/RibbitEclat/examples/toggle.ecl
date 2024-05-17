
(* ./eclat ../examples/toggle.ecl -main=special_counter -arg="(5,false);(5,false);(5,true)" -relax *)

(* let special_counter((max_value,reset))  : int<32> =
  let update_counter((current_value)) : int<32> =
    if reset then
      0
    else if current_value = (max_value - 1) then
      0
    else
      current_value + 1
  in
  reg update_counter last 0;; *)



(* 
  let idle = 0;;
  let running = 1;;
  let paused = 2;;
  
  let fsm(current_state, start, pause) =
    match current_state with
    | 0 -> if start then running else idle
    | 1 -> if pause then paused else running
    | 2 -> if start then running else paused
    | _ -> idle
    end;;
    
  let main() =
    let initial_state = idle in
    let start_signal = true in
    let pause_signal = false in
    
    let next_state = fsm(initial_state, start_signal, pause_signal) in
    fsm(next_state, false, true)
  ;;
   *)
  


   let rec pgcd(a, b) =
    if b = 0 then a
    else pgcd(b, a mod b)
  ;;
  
  let main() =
    pgcd(48, 18)
  ;;
  