(* (+ 8 9) *)
let input = "#+,!tes-1dleif,1gra,,,,bir;)mts>m?mki#!':nlkm!(:nlku!):nlkv1{"

(* somme des n premiers nombres *)
let input2 = "#di,!tes-1dleif,1gra,,,,bir;)lk>m?mki#!):nlkl!':nlkm!(:nlku{"

(* Constantes pour les types *)
let pair_type = 0
let procedure_type = 1
let symbol_type = 2
let string_type = 3
let vector_type = 4
let singleton_type = 5


(* type de base : soit un triplet soit un int *)
type t = Rib of t * t * t | Integer of int

let make_rib_of_ints a b c =
  Rib (Integer a, Integer b, Integer c)
  (* creation d'un triplet de Rib *)
let make_rib a b c =
  Rib (a, b, c)


let is_rib = function Rib _ -> true | _ -> false
let is_int = function Integer _ -> true | _ -> false
let int_val = function Integer i -> i
  | _ -> invalid_arg "int_val expects an Integer"
let int_val_orelse i def =
  match i with
  |  Integer i -> i
  | _ -> def
let rib_eq a b =
  match a, b with
  | Integer x, Integer y -> x = y
  | Rib _, Rib _ -> a == b
  | _ -> false
let get_car = function Rib (car,_,_) -> car
  | _ -> invalid_arg "get_car expects a rib"
let set_car rib newval =
  match rib with
  | Rib (car,cdr, tag) -> Rib (newval, cdr, tag)
  | _ -> invalid_arg "set_car expects a rib"
let get_cdr = function Rib (_,cdr,_) -> cdr
  | _ -> invalid_arg "get_cdr expects a rib"
let set_cdr rib newval =
  match rib with
  | Rib (car,cdr, tag) -> Rib (car, newval, tag)
  | _ -> invalid_arg "set_cdr expects a rib"
let get_tag = function Rib (_,_,tag) -> tag
  | _ -> invalid_arg "get_tag expects a rib"
let set_tag rib newval =
  match rib with
  | Rib (car,cdr, tag) -> Rib (car, cdr, newval)
  | _ -> invalid_arg "set_tag expects a rib"
let false_rib = make_rib_of_ints 0 0 5
let true_rib = make_rib_of_ints 0 0 5
let nil_rib = make_rib_of_ints 0 0 5




(* primitive  *)
(* creation d'un rib constitué de 3 integer *)
let make_rib_of_ints a b c = Rib (Integer a, Integer b, Integer c)                (* primitive (rib a b c) *)

let id x = x                                                                      (* primitive (id x) *)                         
let arg1 x y = x                                                                  (*(primitive (arg1 x y))*)
let arg2 x y = y                                                                  (*(primitive (arg2 x y))*)
(* let close  *)
let is_rib rib =                                                                   (* primitive (is_rib x) *)
  match rib with
    Rib _ -> true 
    | _ -> false
let get_field0 rib =                                                               (* primitive (get_field0 x) *)
  match rib with
    Rib (a, _, _) -> a
    | _ -> invalid_arg "not a Rib"
let get_field1 rib =                                                               (* primitive (get_field1 x) *)
  match rib with
    Rib (_, b, _) -> b 
    | _ -> invalid_arg "not a Rib"
let get_field2 rib =                                                               (* primitive (get_field2 x) *)
  match rib with
    Rib (_, _, c) -> c  
    | _ -> invalid_arg "not a Rib"
let field0_set rib a =                                                             (* primitive (field0_set x a) *)
  match rib with
    Rib (_, b, c) -> Rib (a, b, c) 
    | _ -> invalid_arg "not a Rib"
let field1_set rib b =                                                              (* primitive (field1_set x b) *)
  match rib with
    Rib (a, _, c) -> Rib (a, b, c) 
    | _ -> invalid_arg "not a Rib"
let field2_set rib c =                                                             (* primitive (field2_set x c) *)
  match rib with
    Rib (a, b, _) -> Rib (a, b, c) 
    | _ -> invalid_arg "not a Rib"
let eqv a b  =                                                                      (* primitive (eqv a b) *)
  match a, b with
  | Integer x, Integer y -> x = y
  | Rib _, Rib _ -> a = b
  | _ -> false
let lt a b =                                                                        (* primitive (lt a b) *)
  match a, b with
  | Integer x, Integer y -> x < y
  | _ -> invalid_arg "not an Integer"
let add a b =                                                                       (* primitive (add a b) *)
  match a, b with
  | Integer x, Integer y -> Integer (x + y)
  | _ -> invalid_arg "not an Integer"
let sub a b =                                                                       (* primitive (sub a b) *)
  match a, b with
  | Integer x, Integer y -> Integer (x - y)
  | _ -> invalid_arg "not an Integer"
let mul a b =                                                                       (* primitive (mul a b) *)
  match a, b with
  | Integer x, Integer y -> Integer (x * y)
  | _ -> invalid_arg "not an Integer"
let quotient a b =                                                                  (* primitive (quotient a b) *)
  match a, b with
  | Integer x, Integer y -> Integer (x / y)
  | _ -> invalid_arg "not an Integer"

let is_int rib = 
  match rib with
    Integer _ -> true | 
    _ -> false
(* valeur du int *)
let int_val rib =
  match rib with 
    Integer i -> i | 
    _ -> invalid_arg "not an Integer"

let is_primitive rib = 
  match rib with 
  | Rib (Integer 1, _, Integer 1) -> true (* id primitive *)
  | _ -> false
let get_operation rib =
  if not (is_primitive rib) then 
    match rib with
    | Rib (Integer 0, Integer _, Integer 0) -> 5
    | Rib (Integer 0, Integer _, Integer _) -> 0
    | Rib (Integer 1, Integer _, Integer _) -> 1
    | Rib (Integer 2, Integer _, Integer _) -> 2
    | Rib (Integer 3, Integer _, Integer _) -> 3
    | Rib (Integer 4, Integer _, Integer _) -> 4
    | _ -> invalid_arg "not a operation Rib"
  else invalid_arg "not a operation Rib"  
  

let pop stack =
  match stack with
  | Rib (car,cdr,_) ->
     cdr;
  | _ -> invalid_arg "Top of stack is not a rib"
let push stack x = make_rib x stack (Integer 0)
let prim0 f stack = f () |> push stack
let prim1 f stack = pop stack |> f |> push stack

let prim1_close f stack = pop stack |> f stack |> push stack
let prim2 f stack =
  let x = pop stack in
  let y = pop stack in
  f x y |> push stack
let prim3 f stack =
  let x = pop stack in
  let y = pop stack in
  let z = pop stack in
  f x y z |> push stack

let close rib stack = make_rib (get_car rib) stack (Integer 1)

let to_bool = function true -> true_rib | false -> false_rib

let getchar () =
  try
    input_char stdin |> int_of_char
  with End_of_file -> -1

let putchar c =
  char_of_int c |> print_char;
  flush stdout;
  c

let primitives = [|
  (* @@(primitives (gen body) *)
      prim3 (fun z y x -> make_rib x y z);                                    (* @@(primitive (rib a b c))@@ *)
      prim1 (function x -> x);                                                (* @@(primitive (id x))@@ *)
      (function (stack) -> pop (stack));                                      (* @@(primitive (arg1 x y))@@ *)
      prim2 (fun y x -> y);                                                   (* @@(primitive (arg2 x y))@@ *)
      prim1_close (close)  ;                                                  (* @@(primitive (close rib))@@ *)
      prim1 (function Rib _ -> true_rib | _ -> false_rib);                    (* @@(primitive (rib? rib) (use bool2scm))@@ *)
      prim1 get_car;                                                          (* @@(primitive (field0 rib))@@ *)
      prim1 get_cdr;                                                          (* @@(primitive (field1 rib))@@ *)
      prim1 get_tag;                                                          (* @@(primitive (field2 rib))@@ *)
      prim2 (fun y x -> set_car x y);                                      (* @@(primitive (field0-set! rib))@@ *)
      prim2 (fun y x -> set_cdr x y);                                      (* @@(primitive (field1-set! rib))@@ *)
      prim2 (fun y x -> set_tag x y);                                      (* @@(primitive (field2-set! rib))@@ *)
      prim2 (fun y x -> to_bool (rib_eq x y));                                (* @@(primitive (eqv? x y) (use bool2scm))@@ *)
      (*  @@(primitive (< x y) @@ *)
      prim2 (fun y x -> match x, y with
                        | Integer a, Integer b -> to_bool (a < b)
                        | _ -> invalid_arg "< arguments must be Integers");
      (*  )@@ *)
      (*  @@(primitive (+ x y) @@ *)
      prim2 (fun y x -> match x, y with
                        | Integer a, Integer b -> Integer (a + b)
                        | _ -> invalid_arg "+ arguments must be Integers");
      (*  )@@ *)
      (*  @@(primitive (- x y) @@ *)
      prim2 (fun y x -> match x, y with
                        | Integer a, Integer b -> Integer (a - b)
                        | _ -> invalid_arg "- arguments must be Integers");
      (*  )@@ *)
      (*  @@(primitive ( * x y) @@ *)
      prim2 (fun y x -> match x, y with
                        | Integer a, Integer b -> Integer (a * b)
                        | _ -> invalid_arg "* arguments must be Integers");
      (*  )@@ *)
      (*  @@(primitive (quotient x y) @@ *)
      prim2 (fun y x -> match x, y with
                        | Integer a, Integer b -> Integer (a / b)
                        | _ -> invalid_arg "quotient arguments must be Integers");
      (*  )@@ *)
      prim0 (function () -> Integer (getchar ()));                                                                (* @@(primitive (getchar))@@ *)
      prim1 (function Integer ch -> Integer (putchar ch) | _ -> invalid_arg "putchar argument must be Integer");  (* @@(primitive (putchar x))@@ *)
      prim1 (function Integer status -> exit status | _ -> invalid_arg "exit argument must be Integer")           (* @@(primitive (exit x))@@ *)
  (*  )@@ *)
    |]
  
(* retourne le prochain octet du flux converti en entier. *)
let get_byte index =
  let input_bytes = Bytes.of_string input in
  if index >= Bytes.length input_bytes then
    None
  else
    let byte = Bytes.get input_bytes (index) in
    Some (int_of_char byte)
          
        
let get_code index =
  let x = get_byte (index+1) in
  match x with
  | Some x -> (if (x)<0 then 57 else (x-35))
  | None -> invalid_arg "end of input"
    
let rec get_int n index=
  let x = get_code (index+1) in
  let n = n * 46 in
  if x < 46 then n + x else get_int (n + x - 46) (index+1)
let rec list_tail lst i =
  if i = 0 then lst else list_tail (get_cdr lst) (i - 1)
  
(* Decodage de la RVM *)
let rec run (pc : t)  stack = 
  let codes = [| 20; 30; 0; 10; 11; 4|]
  and instr = get_car (pc)
  and opnd = get_cdr (pc)
  and next = get_cdr (pc)  
  in
  match instr with 
  (* halt *)
    Integer 5 -> ()
   (* set *)
    | Integer 1 -> (
    if is_rib opnd then
      (* ?? la ref de opnd est modifié mais jsp si cest utile pour apres *)
      let opnd = field0_set opnd (get_car stack) in
      run (next) (get_cdr stack)
    else
      let 
      nstack = field0_set (list_tail stack (int_val opnd)) (get_car stack) in
      run (next) (get_cdr nstack))
      (* get *)
    | Integer 2 -> (
      let nstack =push stack (get_car opnd) in
      run (next) (nstack)) 
    (* const *)
    | Integer 3 -> (
      let nstack = push stack opnd in
      run (next) (nstack))
    (* if *)
    | Integer 4 -> (
      (* code en scheme *)
      run (if (eqv (get_car stack) false_rib) then next else opnd) (get_cdr stack))

    (* jump *)
    (* call *)
    | _ -> invalid_arg "Not yet implemented"
   (* push *)

let input_bytes = Bytes.of_string input;;
let taille = Bytes.length input_bytes ;;


  
