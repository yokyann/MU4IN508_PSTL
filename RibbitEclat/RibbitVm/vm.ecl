let input = array_create 9000 ;; 

(* Constantes pour les types *)
let pair_type = 0;;
let procedure_type = 1;;
let symbol_type = 2;;
let string_type = 3;;
let vector_type = 4;;
let singleton_type = 5;;


let instr_jc = 0;;
let instr_set = 1;;
let instr_get = 2;;
let instr_const = 3;;
let instr_if = 4;;
let instr_halt = 5;;

type word = 
  | Nil of int<32>
  | Int of int<32>
  | Triplet of int<32>  
;;

type rib = word * word * word ;;


let size_ram = 9000;;
let alloc_limit = size_ram / 2 -1;;

let ram = array_create size_ram ;; 
let tab_pointer = array_create 1;;
let pc2 = array_create 1;;
let st2 = array_create 1;;
let stbl2 = array_create 1;;
let pos2 = array_create 1;;
let spr2 = array_create 1;;

(* program counter : indice dans la ram *)
let pc = 0;;
(* le sommet de pile qui indique l'indice dasn la ram *)
let sp = size_ram;;
let st = 0;;
let stbl = 0;;
let pos = 0;;
let spr = sp;;

tab_pointer.(0) <- sp;;

pc2.(0) <- pc;;
st2.(0) <- st;;
stbl2.(0) <- stbl;;
pos2.(0) <- pos;;
spr2.(0) <- spr;;

let make_rib (a,b,c) : rib = (a, b, c);;

let is_rib_w (r:word) : bool = match r with 
  | Triplet _ -> true 
  | _ -> false
end
;;
let my_rib: rib = (Int(1), Nil(0), Triplet(255));;

(* let is_int (n:rib) : bool =
  let (a, b, c) = n in
  match a with
  | Int _ -> match b with
             | Nil _ -> match c with
                        | Nil _ -> true
                        | _ -> false
                        end
             | _ -> false
              end
  | _ -> false
  end
;; *)

let int_val (n) = 
  match n with 
  | Int(i) -> i
  | _ -> fatal_error ("expected an Integer")
  end
;;

let rib_eq (a,b) : bool = 
  let (a1, a2, a3) = a in 
  let (b1, b2, b3) = b in 
  a1 = b1 && a2 = b2 && a3 = b3
;;

let get_int_triplet (x : word) = 
  match x with 
    Triplet i -> i 
  |_ -> fatal_error("expected a triplet 1")
end
;; 

let get_rib (r : word ) : rib =
  match r with 
  | Triplet i -> ram.(i)
  | _ -> fatal_error("get_rib expected a triplet")
end
;;

let print_separator () = 
  print_string ",";;

let print_open_bracket () = 
  print_string "[";;

let print_close_bracket () = 
  print_string "]";;

let rec print_value v = 
  match v with
  | Int i -> print_int i
  | Nil _ -> print_string "Nil"
  | Triplet t -> 
      let (a, b, c) = get_rib (Triplet t) in
      print_open_bracket ();
      print_value a; print_separator ();
      print_value b; print_separator ();
      print_value c;
      print_close_bracket ()
  end
;;

let print_rib rib =
  let (a, b, c) = rib in
  print_open_bracket ();
  print_value a; print_separator ();
  print_value b; print_separator ();
  print_value c;
  print_close_bracket ()
;;


let print_r (ri:rib) :unit= 
  let (car, cdr, tag) = ri in 
    print_string " car : "; print_value car ; 
    print_string " cdr : "; print_value cdr;
    print_string " tag : "; print_value tag;
    print_newline ();;

(* j'ai enleve la verification pour nil parce que je dois tout changer en unit *)
let word_eqv (a, b) : bool =
  match a with
  | Int ia -> 
      match b with
      | Int ib -> ia = ib
      | _ -> false
      end
      | Triplet ta -> 
        match b with
        | Triplet tb -> ta = tb
        | _ -> false
      end
      | _ -> false
end
;;

let get_car (rib:rib) : word= 
  let(a,b,c) = rib in 
  a;;

let set_car (rib,w) = 
  let(a,b,c) = rib in
  (w,b,c);; 

let set_car_triplet (rib,newval) = 
  match rib with 
  | Triplet (i) -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag); newval
  | _ -> fatal_error ("set car triplet expected a triplet")
end
;;

let get_car_triplet (rib : word) : word =
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v1
  | _ -> fatal_error("get_car_triplet expected a triplet")
end
;;

let get_car_triplet_s (rib : word) : word =
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v1
  | _ -> fatal_error("get_car_triplet expected a triplet")
end
;;

let get_cdr (rib : rib) : word=
  let (_,cdr,_) = rib in
  cdr
;;

let set_cdr_triplet (rib,newval) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, newval, tag); newval
  | _ -> fatal_error "set cdr triplet expected a triplet"
end
;;

let get_cdr_triplet (rib:word) : word = 
  match rib with 
  | Triplet(t) -> let (v1, v2, v3) = ram.(t) in 
      v2
  | _ -> fatal_error "get_cdr_triplet expected a triplet"
end;;
  
let get_tag (rib:rib) : word= 
  let(_,_,tag) = rib in 
  tag;;


let get_tag_triplet (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v3
  | _ -> fatal_error("get_tag_triplet expected a triplet")
end;;

let set_tag_triplet (rib,newval) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, cdr, newval); newval
  | _ -> fatal_error "set cdr triplet expected a triplet"
end;;

let make_rib_of_ints (a,b,c) = (Int a, Int b, Int c);;
let false_rib : rib = make_rib_of_ints (0,0,5);;
let true_rib : rib = make_rib_of_ints (0,0,5);;
let nil_rib : rib = make_rib_of_ints (0,0,5);;

let tos = fun () -> get_car(ram.(tab_pointer.(0)));;

let pop () =
  let current_sp = tab_pointer.(0) in
  let x = get_car (ram.(current_sp)) in
  if is_rib_w (get_cdr(ram.(current_sp))) then
    tab_pointer.(0) <- get_int_triplet (get_cdr (ram.(current_sp)))
  else
    ram.(spr2.(0)-1) <- (Nil(0), get_cdr(ram.(current_sp)), get_tag(ram.(current_sp)));
    tab_pointer.(0) <- spr2.(0)-1;
    spr2.(0) <- spr2.(0)-1;
  x
;;



let popr () = 
  let x = pop() in get_rib (x)
;;

let push_rib(rib : rib) : unit =
  let i = spr2.(0) in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- rib;
    tab_pointer.(0)<- i-1; spr2.(0)<- i-1) 
    else(
      ram.(i-1) <- rib;
      ram.(i-2) <- (Triplet (i-1), Triplet (tab_pointer.(0)), Int(pair_type)); 
      tab_pointer.(0) <- i-2;
      spr2.(0) <- i-2) 
  else
    fatal_error ("stack overflow")
    (* gc *)
  ;;
  
let push_word (car : word) : unit =
  let i = spr2.(0) in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then (ram.(i-1) <- (car, Int (0), Int (pair_type)); tab_pointer.(0) <- tab_pointer.(0)-1; spr2.(0)<-spr2.(0)-1) else
      (ram.(i-1) <- (car, Triplet (i), Int (pair_type)); tab_pointer.(0) <- i-1; spr2.(0) <- i-1)
  else
    fatal_error ("stack overflow")
    (* gc *)
  ;;

let prim0 f =
  let result2 = f () in
  push_word result2;;

let prim1 f =
  let x = pop () in 
  let result2 = f(x) in
  push_word result2;;


let prim1_rib f =
  let result2 = pop () in
  let result2_after_f = f result2 in
  push_rib result2_after_f;;

let prim2 f =
  let x = pop () in
  let y = pop () in
  let result2_after_f = f(x,y) in
  push_word result2_after_f
;;

let prim3 f =
  let x = pop () in
  let y = pop () in
  let z = pop () in
  let result2_after_f = f(x,y,z) in
  push_rib result2_after_f;;

let to_bool = fun x -> 
  if x then true_rib else false_rib 
;;

(* let getchar () =
  try
    input_char stdin |> int_of_char
  with End_of_file -> -1
;; *)

(* let putchar c =
  print_string "putchar ";
  let char_to_print = char_of_int c in
  print_string char_to_print;
  flush stdout;
  c;; *)

let close () =
  let tos = tos() in
  let x = get_car_triplet (tos) in
  let y = get_cdr (ram.(tab_pointer.(0))) in
  let (car, cdr, tag) = ram.(tab_pointer.(0)) in 
   ram.(tab_pointer.(0)) <- (x, y, Int(1));
   ram.(tab_pointer.(0)) <- (Triplet (tab_pointer.(0)),cdr, tag);
   tab_pointer.(0) <- tab_pointer.(0) - 1
;;

let prim2_bool f =
  let x = pop () in
  let y = pop () in
  let result2 = f(x,y) in
  let bool_result2 = to_bool result2 in
  push_rib bool_result2
;;
(* primitives.(5) <- prim1_rib (fun x -> match x with
  | Triplet _ -> true_rib 
  | _ -> (Triplet 1, Triplet 2, Int 5)
end);; *)
let ignore (x) =
  ();;

let apply_prim2 (index) =
  match index with
  | 0 -> prim3 (fun (z, y, x) -> make_rib (x, y, z))
  | 1 -> prim3 (fun x -> x)
  | 3 -> prim2 (fun (y, x) -> y)
  | 4 -> close ()
  | 5 -> prim1_rib (fun x -> 
    match x with
    | Triplet _ -> true_rib 
    | _ -> (Triplet 1, Triplet 2, Int 5)
    end)
  | 6 -> prim1 get_car_triplet
  | 7 -> prim1 get_cdr_triplet 
  | 8 -> prim1 get_tag_triplet
  | 9 -> prim2 (fun (y, x) -> set_car_triplet (x, y))
  | 10 -> prim2 (fun (y, x) -> set_cdr_triplet (x, y))
  | 11 -> prim2 (fun (y, x) -> set_tag_triplet (x, y))
  | 12 -> prim2_bool (fun (y, x) -> word_eqv (x, y))
  | 13 -> prim2_bool (fun (y, x) -> match x with
                                  | Int a -> match y with
                                    | Int b -> a < b
                                    | _ -> fatal_error "< arguments must be Ints"
                                  end
                                  | _ -> fatal_error "< arguments must be Ints"
                                end)

  | 14 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a + b)
                                | _ -> fatal_error "+ arguments must be Ints"
                              end
                              | _ -> fatal_error "+ arguments must be Ints" end)
  | 15 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a - b)
                                | _ -> fatal_error "- arguments must be Ints"
                              end
                              | _ -> fatal_error "- arguments must be Ints" end) 
  | 16 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a * b)
                                | _ -> fatal_error "* arguments must be Ints"
                              end
                              | _ -> fatal_error "* arguments must be Ints" end) 
  | 17 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a / b)
                                | _ -> fatal_error "quotient arguments must be Ints"
                              end
                              | _ -> fatal_error "quotient arguments must be Ints" end) 
  
  (* | 18 -> prim0 (function () -> Int (getchar ()));
  | 19 -> prim1 (function Int ch -> Int (putchar ch) | _ -> fatal_error "putchar argument must be Int");  
  | 20 -> prim1 (function Int status -> exit status | _ -> fatal_error "exit argument must be Int")            *)
  | _ -> fatal_error "Invalid primitive index"
end;; 


let get_rib_sym (w : word) =
  match w with 
    Triplet i -> ram.(i)
  | _ -> fatal_error "get_rib_sym" 
end
;;

let rec list_tail (ptr,i) =
  if 0 = i then 
    Triplet (ptr)
  else
    (if is_rib_w (get_cdr (ram.(ptr))) then
       let (car, cdr, tag) = ram.(ptr) in
       list_tail ((get_int_triplet (cdr)),(i-1))
     else
       get_cdr (ram.(ptr)))
;;

let get_byte = fun () ->
  let c = input.(pos2.(0)) in
  pos2.(0) <- pos2.(0) + 1; c;;

let get_code () =
  let x = (get_byte ()) - 35 in if x < 0 then 57 else x
;;

let rec get_int n =
  let x = get_code () in
  let n = n * 46 in
  if x < 46 then n + x else get_int (n + x - 46)
;;

let is_pair (n) = 
  let (a, b, c) = n in
  let l = 0 in
  match c with   
  | Int(l) -> true
  | _ -> false
end 
;;

let not_nil_cdr (w : word)  =
  match w with 
    Nil _ -> false
  | _ -> true
end;;

let i_accum (stbl,st) = if st > stbl then st else stbl;;

let push_symtbl_rib (rib : rib) :unit =
  let i = i_accum (st2.(0),stbl2.(0)) in
  if i < size_ram then
    (ram.(i+1) <- rib)
  else
    fatal_error "stack overflow push_symtbl_rib"
    (* gc *)
;;

let push2_symtbl_word (car,tag) : unit =
  let i = i_accum (st2.(0),stbl2.(0)) in
  if i < alloc_limit then
    (* premier elemn de stack *)
    if i = -1 then (ram.(i+2) <- (car, Int 0, tag)) else
      (ram.(i+2) <- (car, Triplet (i+1), tag))
  else
    fatal_error "stack overflow push2_symtbl_word"
    (* gc *)
;;

let push_word_stbl (car : word) : unit =
  let i = (get_int_triplet car) in
  if i < alloc_limit then
    
    (* premier elemn de stack *)
    if stbl2.(0) = -1 then ( (ram.(i+1) <- (car, Int 0, Int pair_type); stbl2.(0) <- i+1) )else
      (ram.(i+1) <- (car, Triplet (stbl2.(0)), Int pair_type); stbl2.(0) <- i+1)
  else
    fatal_error "stack overflow push_word_stbl "
    (* gc *)
  ;;

let length lst =
  let rec aux (l,acc) =
    if is_pair l then
      match (get_cdr l) with
      | Int _ -> acc +1
      | Triplet i -> aux ((get_rib (Triplet i)),(acc + 1))
      | _ -> fatal_error "length"
    end
    else
      acc
  in
  aux (lst,0)
;;

let push_symtbl (rib:rib) : unit =
  let i = i_accum (st2.(0),stbl2.(0)) in
  if i < alloc_limit then
      (ram.(i+1) <- rib;
      st2.(0) <- i+1)
  else
    fatal_error "stack overflow push_symtbl"
    (* gc *)
;;


let create_sym (i)= 
  let len = length (ram.(i)) in
  push_symtbl_rib (make_rib ((Triplet i),(Int len),(Int string_type)));
  push2_symtbl_word ((Triplet 3),(Int symbol_type));
  let x = i_accum (st2.(0),stbl2.(0)) in 
  push_word_stbl (Triplet (x+2)) 
;;

let push_symtbl_word_accum (car,cdr) =
  let i = i_accum (stbl2.(0),st2.(0)) in
  if i < alloc_limit then
    (
      ram.(i+1) <- (car, cdr, Int pair_type);
      st2.(0) <- i+1)
  else
    fatal_error "stack overflow push_symtbl_word_accum"
    (* gc *)
  ;;


let build_symtbl () : unit =
push_symtbl nil_rib;

let rec loop1 n :unit =
  if 0 < n then 
    ( 
      push_symtbl nil_rib;
      create_sym(st2.(0));
      loop1 (n-1)) 
  else 
    let rec loop3 (i:int<32>) = 
      let x = get_byte () in 
      if x = 44 then ( 
        create_sym(i); 
        loop3(st2.(0))) else
      if x=59 then 
        create_sym(i)
      else(
        push_symtbl_word_accum ((Int x),(Triplet (i))); 
        loop3 (st2.(0)))
    in
    loop3 (st2.(0))
in
let n = get_int 0 in (
  loop1 n)
;;

let set_global (value:rib) = 
  push_symtbl_rib value;
  set_car_triplet (get_car_triplet ((Triplet (stbl2.(0)))),(Triplet (st2.(0))));;


let push_heap_r (rib : rib) : unit =
  let i = pc2.(0) in
  if i < size_ram then
    (ram.(i+1) <- rib;
      pc2.(0) <- i+1) 
  else
    fatal_error "stack overflow push_heap_r"
    (* gc *)
  ;;

let get_next_stack = fun () ->
  if is_rib_w (get_cdr_triplet (Triplet (tab_pointer.(0)))) then
    tab_pointer.(0) <- get_int_triplet (get_cdr_triplet (Triplet (tab_pointer.(0))))
  else
    (let (car, cdr, tag) = ram.(tab_pointer.(0)) in 
    ram.(spr2.(0)-1) <- (Nil 0, cdr, tag);
    tab_pointer.(0) <- spr2.(0)-1;
    spr2.(0) <- spr2.(0)-1)
  ;;


let push_heap_copy (rib : rib) : unit =
  let i = pc2.(0) in
  let rec push_heap_stack (w : word) : unit =
    let i = pc2.(0) in
    if i < size_ram then
      (
        let (car, cdr, tag) = get_rib w in
        match car with
        | Int _ -> match cdr with
                   | Int _ -> match tag with
                              | Int _ -> 
                                ram.(i+1) <- (car, cdr, tag);
                                pc2.(0) <- i+1
                              | _ -> fatal_error "Expected Int for tag"
                              end
                   | _ -> fatal_error "Expected Int for cdr"
                    end
        | Triplet t -> 
            match cdr with
            | Int _ -> 
                match tag with
                | Int _ ->
                    if t > stbl2.(0) then
                      (
                        push_heap_stack car;
                        ram.(pc2.(0)+1) <- (Triplet (pc2.(0)), cdr, tag);
                        pc2.(0) <- pc2.(0) + 1
                     )
                    else
                      (
                        ram.(i+1) <- (car, cdr, tag);
                        pc2.(0) <- i+1
                      )
                | _ -> fatal_error "Expected Int for tag"
                  end
            | _ -> fatal_error "Expected Int for cdr"
              end
        | Triplet t -> 
              match cdr with
              | Triplet y -> 
                  match tag with
                  | Int _ ->
                      if (t > stbl2.(0)) && (y > stbl2.(0)) then
                        (
                          push_heap_stack car;
                          let k = pc2.(0) in
                          push_heap_stack cdr;
                          ram.((pc2.(0))+1) <- (Triplet k, Triplet (pc2.(0)), tag);
                          pc2.(0) <- pc2.(0) + 1
                        )
                      else if (t > stbl2.(0)) && (y < stbl2.(0)) then
                        (
                          push_heap_stack car;
                          ram.((pc2.(0))+1) <- (Triplet (pc2.(0)), cdr, tag)
                        )
                      else if (t < stbl2.(0)) && (y > stbl2.(0)) then
                        (
                          push_heap_stack cdr;
                          ram.((pc2.(0))+1) <- (car, Triplet (pc2.(0)), tag)
                        )
                      else if (t < stbl2.(0)) && (y < stbl2.(0)) then
                        (
                          ram.(i+1) <- (car, cdr, tag);
                          pc2.(0) <- i+1
                        )
                  | _ -> fatal_error "Expected Int for tag"
                      end
              | _ -> fatal_error "Expected Triplet for cdr"
                  end
        | Triplet t -> 
              match cdr with
              | Triplet y -> 
                  match tag with
                  | Triplet u ->
                      if (t > stbl2.(0)) && (y > stbl2.(0)) && (u > stbl2.(0)) then
                        (
                          push_heap_stack car;
                          let k = pc2.(0) in
                          push_heap_stack cdr;
                          let j = pc2.(0) in
                          push_heap_stack tag;
                          ram.((pc2.(0))+1) <- (Triplet k, Triplet j, Triplet (pc2.(0)));
                          pc2.(0) <- pc2.(0) + 1
                        )
                      else if (t > stbl2.(0)) && (y > stbl2.(0) )&& (u < stbl2.(0)) then
                        (
                          push_heap_stack car;
                          let k = pc2.(0) in
                          push_heap_stack cdr;
                          ram.((pc2.(0))+1) <- (Triplet k, Triplet (pc2.(0)), tag);
                          pc2.(0) <- pc2.(0) + 1
                          )
                      else if (t > stbl2.(0)) && (y < stbl2.(0)) &&( u > stbl2.(0)) then
                        (
                          push_heap_stack car;
                          let k = pc2.(0) in
                          push_heap_stack tag;
                          ram.((pc2.(0))+1) <- (Triplet k, cdr, Triplet (pc2.(0)));
                          pc2.(0) <- pc2.(0) + 1
                          )
                      else if (t < stbl2.(0)) && (y > stbl2.(0)) && (u > stbl2.(0)) then
                        (
                          push_heap_stack cdr;
                          let k = pc2.(0) in
                          push_heap_stack tag;
                          ram.((pc2.(0))+1) <- (car, Triplet k, Triplet (pc2.(0)));
                          pc2.(0) <- pc2.(0) + 1
                          )
                      else if (t < stbl2.(0)) && (y > stbl2.(0)) &&( u < stbl2.(0)) then
                        (
                          push_heap_stack cdr;
                          ram.((pc2.(0))+1) <- (car, Triplet (pc2.(0)), tag);
                          pc2.(0) <- pc2.(0) + 1
                        )
                      else if (t < stbl2.(0)) &&( y < stbl2.(0)) && (u > stbl2.(0)) then
                        (
                          push_heap_stack tag;
                          ram.((pc2.(0))+1) <- (car, cdr, Triplet (pc2.(0)));
                          pc2.(0) <- pc2.(0) + 1
                        )
                      else if (t < stbl2.(0)) && (y < stbl2.(0) )&& (u < stbl2.(0)) then
                        (
                          ram.(i+1) <- (car, cdr, tag);
                          pc2.(0) <- i+1
                        )
                  | _ -> fatal_error "Expected Triplet for tag"
                      end
              | _ -> fatal_error "Expected Triplet for cdr"
                end
        | Int _ -> 
              match cdr with
              | Triplet t -> 
                  match tag with
                  | Int _ ->
                      if t > stbl2.(0) then
                        (
                          push_heap_stack cdr;
                          ram.((pc2.(0))+1) <- (car, Triplet (pc2.(0)), tag);
                          pc2.(0) <- pc2.(0) + 1
                        )
                      else
                        (
                          ram.(i+1) <- (car, cdr, tag);
                          pc2.(0) <- i+1
                        )
                  | _ -> fatal_error "Expected Int for tag"
                      end 
              | _ -> fatal_error "Expected Triplet for cdr"
                    end
        | Int _ -> 
            match cdr with
            | Triplet t -> 
                match tag with
                | Triplet y ->
                    if (t > stbl2.(0)) && (y > stbl2.(0)) then
                      (
                        push_heap_stack cdr;
                        let k = pc2.(0) in
                        push_heap_stack tag;
                        ram.(pc2.(0)+1) <- (car, Triplet k, Triplet (pc2.(0)));
                        pc2.(0) <- pc2.(0) + 1
                      )
                    else if( t > stbl2.(0)) && (y < stbl2.(0) )then
                      (
                        push_heap_stack cdr;
                        ram.(pc2.(0)+1) <- (car, Triplet (pc2.(0)), tag);
                        pc2.(0) <- pc2.(0) + 1
                      )
                    else if (t < stbl2.(0)) && (y > stbl2.(0)) then
                      (
                        push_heap_stack tag;
                        ram.(pc2.(0)+1) <- (car, cdr, Triplet( pc2.(0)));
                        pc2.(0) <- pc2.(0) + 1
                      )
                    else if (t < stbl2.(0)) && (y < stbl2.(0)) then
                      (
                        ram.(i+1) <- (car, cdr, tag);
                        pc2.(0) <- i+1
                      )
                | _ -> fatal_error "Expected Triplet for tag"
                end
            | _ -> fatal_error "Expected Triplet for cdr"
              end
      | Int _ -> 
        match cdr with
        | Int _ -> 
            match tag with
            | Triplet t ->
                if t > stbl2.(0) then
                  (
                    push_heap_stack tag;
                    ram.(pc2.(0)+1) <- (car, cdr, Triplet (pc2.(0)));
                    pc2.(0) <- pc2.(0) + 1
                  )
                else
                  (
                    ram.(i+1) <- (car, cdr, tag);
                    pc2.(0) <- i+1
                  )
            | _ -> fatal_error "Expected Triplet for tag"
            end
        | _ -> fatal_error "Expected Int for cdr"
        end
      | Triplet t -> 
        match cdr with
        | Int _ -> 
            match tag with
            | Triplet y ->
                if t > stbl2.(0) && y > stbl2.(0) then
                  (
                    push_heap_stack car;
                    let k = pc2.(0) in
                    push_heap_stack tag;
                    ram.(pc2.(0)+1) <- (Triplet k, cdr, Triplet (pc2.(0)));
                    pc2.(0) <- pc2.(0) + 1
                  )
                else if t > stbl2.(0) && y < stbl2.(0) then
                  (
                    push_heap_stack car;
                    ram.(pc2.(0)+1) <- (Triplet (pc2.(0)), cdr, tag);
                    pc2.(0) <- pc2.(0) + 1
                  )
                else if t < stbl2.(0) && y > stbl2.(0) then
                  (
                    push_heap_stack tag;
                    ram.(pc2.(0)+1) <- (car, cdr, Triplet( pc2.(0)));
                    pc2.(0) <- pc2.(0) + 1
                  )
                else if t < stbl2.(0) && y < stbl2.(0) then
                  (
                    ram.(i+1) <- (car, cdr, tag);
                    pc2.(0) <- i+1
                  )
            | _ -> fatal_error "Expected Triplet for tag"
            end
        | _ -> fatal_error "Expected Int for cdr"
        end
          
        | _ -> print_string "wait"
      end
      )
    else
      fatal_error "stack overflow push_heap_copy"
      (* gc *)
    in
  if i < size_ram then
    (
      let (car, cdr, p) = rib in 
      match p with 
      | Int _ -> 
        (ram.(i+1) <- rib;
         pc2.(0) <- i+1)
      | Triplet t -> 
        push_heap_stack (Triplet t);
        ram.(pc2.(0)+1) <- (car, cdr, Triplet (pc2.(0)));
        pc2.(0) <- pc2.(0)+1
      | _ -> fatal_error "push_heap_copy"
      end
    )
  else
    fatal_error "stack overflow push_heap_copy"
    (* gc *)
  ;;

let codes_size = 6;;
let codes = array_create codes_size;;
codes.(0) <- 20;;
codes.(1) <- 30;;
codes.(2) <- 0;;
codes.(3) <- 10;;
codes.(4) <- 11;;
codes.(5) <- 4;;

let sym n =
  let l = list_tail ((stbl2.(0)), n) in
  let car = get_car_triplet l in
  car
;;



let add_instruction (op,opnd) =
  let x = make_rib (Int op, opnd, tos ()) in
  let (car, cdr, tag) = ram.(tab_pointer.(0)) in
  let i = spr2.(0) in
  ram.(i-1) <- x;
  ram.(tab_pointer.(0)) <- (Triplet (i-1), cdr, tag);
  spr2.(0) <- i-1
;;

let calcul_opnd (n,d,op) =
  if n < d then (
    if op < 3 then (sym n) else (Int n))
  else( if n = d then(
    Int (get_int 0))
  else(
    sym (get_int (n-d-1))))
;;

let rec loop (op,n) = 
  let d = codes.(op) 
  in
  if (d+2) < (int_val n) then
    ( 
      loop ((op + 1),(Int ((int_val n)-(d+3))))
  )
  else
  if 90 < get_code () then (
    let tos = tos() in
    get_next_stack();
    add_instruction (4,tos))
  else 
    (  
      if op = 0 then (  
        (
        push_word (Int 0) 
        )
        
      )else (
        print_newline ()
        );
      let opnd = calcul_opnd ((int_val n),d,op) in

      if 4 < op then
        (
          let p = pop() in 
          push_heap_copy (make_rib (opnd,(Int 0),(p))) ;

          push_heap_r nil_rib;
          push_heap_r (make_rib ((Triplet (pc2.(0)-1)),(Triplet (pc2.(0))),(Int procedure_type))) 
          
          (* let (car, cdr, tag) = ram.(tab_pointer.(0)) in
          if car = Nil 0 then
            if cdr = Int 0 then
              if tag = Int 0 then
                Triplet (pc2.(0))
              else
                add_instruction (instr_const, Triplet (pc2.(0)))
            else
              add_instruction (instr_const, Triplet (pc2.(0)))
          else
            add_instruction (instr_const, Triplet (pc2.(0))) *)
          
          )
      else(
        if (0<op) then
          (
            add_instruction ((op-1),opnd))
        else
          (
            add_instruction (0,opnd))
    ) )
;;

 (* let rec decode_loop () =
  let x = get_code () in
  loop (0,(Int x))
;;

let decode =
  let main_proc = decode_loop () in  
  let d = get_car_triplet main_proc in
  let f = get_tag_triplet d in
  pc2.(0) <- get_int_triplet f
;;
 *)


 let get_var opnd = 
  match opnd with 
  | Triplet _ -> get_car_triplet opnd
  | Int i -> get_car_triplet (list_tail ((tab_pointer.(0)),i))
  | _ -> fatal_error "get_var"
 end;;
 
let setup_stack = fun () ->
  ram.(tab_pointer.(0)) <- (Int 5, Int 0, Int 0);
  ram.(tab_pointer.(0)-1) <- (Int 0, Int 0, Triplet (tab_pointer.(0)));
  tab_pointer.(0) <- tab_pointer.(0) - 1;
  spr2.(0) <- tab_pointer.(0)
;;

let advance_pc = fun () -> 
  let tag = get_tag_triplet (Triplet (pc2.(0))) in
  match tag with 
  | Int i -> pc2.(0) <- stbl2.(0)
  | Triplet t -> pc2.(0) <- get_int_triplet tag
  | _ -> fatal_error "advance_pc"
end;;


let get_cont  = fun () ->
  let rec loop (s) =
    let tag = get_tag_triplet s in 
    match tag with
    | Int x -> loop (get_cdr_triplet s)
    | Triplet t -> s
    | _ -> fatal_error "get_cont 2"
  end
  in loop (Triplet (tab_pointer.(0)))
;;



let set_global (value:word) = 
  let car = get_car_triplet (Triplet (stbl2.(0))) in
  let (_, cdr, tag) = ram.(get_int_triplet car) in
  ram.(get_int_triplet car) <- (value, cdr, tag);
  stbl2.(0) <- get_int_triplet (get_cdr_triplet (Triplet (stbl2.(0))))
;;

ram.(0) <- nil_rib;;
ram.(1) <- nil_rib;;
ram.(2) <- nil_rib;;
ram.(3) <- (Triplet 1, Triplet 2, Int singleton_type);;
stbl2.(0) <- 3;;

let main() = 
print_string "Test";;

