
(* Constantes pour les types *)
let pair_type = 0
let procedure_type = 1
let symbol_type = 2
let string_type = 3
let vector_type = 4
let singleton_type = 5


  (* type de base : soit un triplet soit un int *)
type t = Rib of t * t * t | Integer of int

(* primitive  *)
(* creation d'un rib constitué de 3 integer *)
let make_rib_of_ints a b c = Rib (Integer a, Integer b, Integer c)                (* primitive (rib a b c) *)
(* creation d'un triplet de Rib *)
let make_rib a b c =
  match a, b, c with
  | Rib _, Rib _, Rib _ -> Rib (a, b, c)
  | _ -> invalid_arg "make_rib expects three ribs" 
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
let getchar rib =                                                                   (* primitive (getchar rib) *)
  match rib with
  | Rib (char, _, _) -> char
  | _ -> invalid_arg "not a Rib"
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
  
