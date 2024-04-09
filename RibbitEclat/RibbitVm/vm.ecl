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
  | Nil of int<8>
  | Int of int<8>
  | Triplet of int<8>  
;;

type rib = word * word * word ;;


let size_ram = 90000;;
let alloc_limit = size_ram / 2 -1;;

let ram = array_create size_ram ;; 

(* program counter : indice dans la ram *)
let pc = -1;;
(* le sommet de pile qui indique l'indice dasn la ram *)
let sp = size_ram;;
let st = -1;;
let stbl = -1;;
let pos = 0;;

let make_rib (((a,b)),c) : rib = (a, b, c);;

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

let word_eqv (a,b) : bool = a = b;;

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

let tos = get_car(ram.(sp));;

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

(* let pop (sp, ram) =
  let x = get_car(ram.(sp)) in
  let new_sp = 
    if is_rib_w (get_cdr(ram.(sp))) then
      get_int_triplet (get_cdr(ram.(sp)))
    else
      sp - 1 in
  (x, new_sp, ram);; *)

let main() = 
    print_string "Test";;

