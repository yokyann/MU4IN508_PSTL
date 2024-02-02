module Rib = struct
  (* type de base : soit un triplet soit un int *)
  type t = Rib of t * t * t | Integer of int

  (* creation d'un rib constitué de 3 integer *)
  let make_rib_of_ints a b c = Rib (Integer a, Integer b, Integer c)
  (* creation d'un triplet de Rib *)
  let make_rib a b c =
    match a, b, c with
    | Rib _, Rib _, Rib _ -> Rib (a, b, c)
    | _ -> invalid_arg "make_rib expects three ribs"
  
  let is_rib rib = 
    match rib with
      Rib _ -> true | 
      _ -> false
  let is_int rib = 
    match rib with
      Integer _ -> true | 
      _ -> false
  (* valeur du int *)
  let int_val rib =
    match rib with 
      Integer i -> i | 
      _ -> invalid_arg "not an Integer"

  let rib_eq a b =
    match a, b with
    | Integer x, Integer y -> x = y
    | Rib _, Rib _ -> a = b
    | _ -> false

  let get_indicator rib =
    match rib with
    | Rib (Integer _, _, id) -> id
    | _ -> invalid_arg "not a Rib"

  let is_primitive rib = 
    match rib with 
    | Rib (Integer 1, _, Integer 1) -> true
    | _ -> false

  let get_operation rib =
    if not (is_primitive rib) then 
      match rib with
      | Rib (Integer 0, Integer _, Integer 0) -> 
      | Rib (Integer 0, Integer _, Integer _) -> 0
      | Rib (Integer 1, Integer _, Integer _) -> 1
      | Rib (Integer 2, Integer _, Integer _) -> 2
      | Rib (Integer 3, Integer _, Integer _) -> 3
      | Rib (Integer 4, Integer _, Integer _) -> 4
      | _ -> invalid_arg "not a operation Rib"
      | Rib _,_,_ -> "not a operation Rib"
    else invalid_arg "not a operation Rib"  
    


  end

open Rib

(* test *)

let rib1 = make_rib_of_ints 0 0 3
