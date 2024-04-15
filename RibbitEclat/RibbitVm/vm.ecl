let input = ");'u?>vD?>vRD?>vRA?>vRA?>vR:?>vR=!(:lkm!':lkv6y";;
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


let size_ram = 90000;;
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

let int_val (n : word) = 
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
  | Triplet (i) -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag)
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

let set_cdr (rib,w) = 
  let(a,b,c) = rib in
  (a,w,c);; 


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

let set_tag (rib,newval) = 
  let (car,cdr,tag) = rib in
  (car,cdr,newval)
;;
  
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
  push_word result2_after_f;;

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

let ignore (x) =
  ();;



(* let primitives_size = 20;; (* Taille hypothétique *)
let primitives = array_create primitives_size;;

primitives.(0) <- (prim3 (fun (z,y,x) -> make_rib (x,y,z)));;
primitives.(1) <- prim1_word (fun x -> x);;
(* primitives.(2) <- (fun () -> let x = pop () in ignore(x));; *)
primitives.(3) <- prim2 (fun (y,x) -> y);;
primitives.(4) <- close();;
primitives.(5) <- prim1_rib choose_rib_type;;
primitives.(6) <- prim1_fields get_car;;
primitives.(7) <- prim1_fields get_cdr;;
primitives.(8) <- prim1_fields get_tag;;
primitives.(9) <- prim2_fields (fun (y,x) -> set_car (x,y));;
primitives.(10) <- prim2_fields (fun (y,x) -> set_cdr (x,y));;
primitives.(11) <- prim2_fields (fun (y,x) -> set_tag (x,y));;
primitives.(12) <- prim2_bool (fun (y,x) -> word_eqv (x,y));; 
primitives.(13) <- prim2_bool (fun (y,x) -> match x with
                                        | Int a -> match y with 
                                          | Int b -> a < b
                                          | _ -> fatal_error "< arguments must be Ints"
                                            end
                                        | _ -> fatal_error "< arguments must be Ints"
                                          end );;
primitives.(14) <- prim2 (fun (y,x) ->
  match x with
  | Int a -> 
      match y with
      | Int b -> Int (a + b)
      | _ -> fatal_error "+ arguments must be Ints"
      end
  | _ -> fatal_error "+ arguments must be Ints"
  end
);;
primitives.(15) <- prim2 (fun (y,x) ->
  match x with
  | Int a -> (
      match y with
      | Int b -> Int (a - b)
      | _ -> fatal_error "- arguments must be Ints"
    end
      )
  | _ -> fatal_error "- arguments must be Ints"
end);;

primitives.(16) <- prim2 (fun (y,x) ->
  match x with
  | Int a -> (
      match y with
      | Int b -> Int (a * b)
      | _ -> fatal_error "* arguments must be Ints"
    end
    )
  | _ -> fatal_error "* arguments must be Ints"
end);;
primitives.(17) <- prim2 (fun (y,x) ->
  match x with
  | Int a -> (
      match y with
      | Int b -> Int (a / b)
      | _ -> fatal_error "* quotient arguments must be Ints"
    end
    )
  | _ -> fatal_error "* quotient arguments must be Ints"
end);; *)
(* primitives.(18) <- prim0 (fun () -> Int (getchar ()));; *)
(* primitives.(19) <- prim1_word (fun Int(ch) -> Int (putchar ch) | _ -> fatal_error "putchar argument must be Int");;
primitives.(20) <- prim1_word (fun Int(status) -> exit status | _ -> fatal_error "exit argument must be Int");; *)


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
       list_tail ((get_int_triplet (cdr )),(i-1))
     else
       get_cdr (ram.(ptr)))
;;



let main() = 
print_string "Test";;

