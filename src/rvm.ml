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



let instr_jc = 0
let instr_set = 1
let instr_get = 2
let instr_const = 3
let instr_if = 4
let instr_halt = 5

(* type de base : soit un triplet soit un int *)
(* type t = Rib of t * t * t | Int of int *)


type word = 
    Nil
  | Int of int
  (*contient l'adresse (la position) i d'un rib dans la mémoire (un tableau de rib)*)
  | Triplet of int  

type rib = word * word * word 

type ram = rib array

let size_ram = 100
let ram : ram = Array.make size_ram (Nil, Nil, Nil)  (* Déclaration de la variable globale ram *)

let ptr_of_val (r : rib) :int = 
  (* cherche l'inidice de r dans la ram *)
  let rec aux i = 
    if i = size_ram then invalid_arg "rib not found" else
    if ram.(i) = r then i else aux (i+1)
  in aux 0

let make_rib (a:word) (b:word) (c: word) : rib = (a, b, c)

let make_rib_ribs (a:rib) (b:rib) (c: rib) : rib = 
  let ai = ptr_of_val a in 
  let bi = ptr_of_val b in 
  let ci = ptr_of_val c in 
  (Triplet ai, Triplet bi, Triplet ci)

let is_rib r : bool = match r with 
  | (_,_,_) -> true 
  | _ -> false 
let is_rib_w (r:word) : bool = match r with 
  | Triplet _ -> true 
  | _ -> false

let is_int (n:rib) = 
  match n with 
  | ( Int _, Nil, Nil ) -> true
  | _ -> false
let int_val (n : word) = 
  match n with 
  | Int i -> i
  | _ -> invalid_arg "expected an Integer"
let int_val_orelse i def =
  match i with
  |  Int i -> i
  | _ -> def


let rib_eq (a:rib) (b:rib) : bool = ptr_of_val(a) = ptr_of_val(b)


let get_car (rib : rib) : word= match rib with 
    (car, _,_ ) -> car
  | _ -> invalid_arg "get_car expects a rib"


let set_car_triplet (rib : word) (newval:word) = 
  match rib with 
  | Triplet i -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag)
  | _ -> invalid_arg "set car triplet expected a triplet"
let get_car_triplet (rib : word) : word =
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
    v1
  | _ -> invalid_arg "get_car_triplet expected a triplet"


let set_car (rib:rib) (newval:word) =
  let i = ptr_of_val rib in
  let (_, v1, v2) = ram.(i) in
  ram.(i) <- (newval, v1, v2)

let get_cdr (rib : rib) : word= match rib with 
    (_, cdr,_ ) -> cdr
  | _ -> invalid_arg "get_car expects a rib"

let set_cdr_triplet (rib : word) (newval : word) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, newval, tag)
  | _ -> invalid_arg "set cdr triplet expected a triplet"


let get_rib (r : word ) : rib =
  match r with 
  | Triplet i -> ram.(i)
  | _ -> invalid_arg "get_rib expected a triplet"

let get_cdr_triplet (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
    v2
  | _ -> invalid_arg "get_cdr_triplet expected a triplet"
let set_cdr (rib:rib) (newval:word) =
  let i = ptr_of_val rib in
  let (v0, _, v2) = ram.(i) in
  ram.(i) <- (v0, newval, v2)

let get_tag (rib : rib) : word= match rib with 
    (_, _,tag) -> tag
  | _ -> invalid_arg "get_car expects a rib"

let get_tag_triplet (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
    v3
  | _ -> invalid_arg "get_tag_triplet expected a triplet"

let set_tag (rib :rib) (newval: word) =
  let i = ptr_of_val rib in
  let (v0, v1, _) = ram.(i) in
  ram.(i) <- (v0, v1, newval)


let set_tag_triplet (rib : word) (newval : word) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, cdr, newval)
  | _ -> invalid_arg "set cdr triplet expected a triplet"


let make_rib_of_ints a b c = (Int a, Int b, Int c)                (* primitive (rib a b c) *)

let false_rib : rib = make_rib_of_ints 0 0 5
let true_rib : rib = make_rib_of_ints 0 0 5
let nil_rib : rib = make_rib_of_ints 0 0 5




(* primitive  *)
(* creation d'un rib constitué de 3 Int *)

let pop (stack:rib)  =
  match stack with
  | (car,cdr,_) ->
    let i = ptr_of_val stack in
    match cdr with 
    | Triplet index -> ram.(i) <- ram.(index) ; car
    | Int n -> let (car, cdr, tag) = ram.(i) in
      ram.(i) <- (Int n, Nil, tag) ; car
    | Nil -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (Nil, Nil, tag) ; car
    | _ -> invalid_arg "Top of stack is not a rib"


let popr (stack:rib)  =
  match stack with
  | (car,cdr,_) ->
    let i = ptr_of_val stack in
    match cdr with 
    | Triplet index -> ram.(i) <- ram.(index) ; (match car with 
        | Triplet index -> ram.(index)
        | _ -> invalid_arg "Top of stack is not a rib")
    | Int n -> let (car, cdr, tag) = ram.(i) in
      ram.(i) <- (Int n, Nil, tag) ; (match car with 
          | Triplet index -> ram.(index)
          | _ -> invalid_arg "Top of stack is not a rib")
    | Nil -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (Nil, Nil, tag) ; (match car with 
        | Triplet index -> ram.(index)
        | _ -> invalid_arg "Top of stack is not a rib")
    | _ -> invalid_arg "Top of stack is not a rib"

let push_ram x : unit =
  (* chreche une place dans ram *)
  let rec aux i = 
    if i = size_ram then invalid_arg "ram is full" else
    if ram.(i) = (Nil, Nil, Nil) then i else aux (i+1)
  in
  let i = aux 0 in
  ram.(i) <- x

let push (stack:rib) (x : rib) : unit =
  push_ram x;
  let i = ptr_of_val stack in
  let (car, cdr, tag) = ram.(i) in
  ram.(i) <- (Triplet (ptr_of_val x), Triplet i, tag)

let push_w (stack:rib) (x:word) : unit =
  let i = ptr_of_val stack in
  let (car, cdr, tag) = ram.(i) in
  ram.(i) <- (x, Triplet i, tag)

let prim0 f stack = f () |> push stack
let prim1 f (stack:rib) = popr stack |> f |> push_w stack
let prim1_r f (stack:rib) = popr stack |> f |> push stack
let prim1_w f (stack:rib) = pop stack |> f |> push_w stack

let prim1_close f stack = pop stack |> f stack |> push stack
let prim2 f stack =
  let x = popr stack in
  let y = popr stack in
  f x y |> push stack
let prim3 f stack =
  let x = pop stack in
  let y = pop stack in  
  let z = pop stack in
  f x y z |> push stack

let close (stack: rib) (rib:word) = 
  let i = ptr_of_val stack in 
  make_rib rib (Triplet i) (Int 1)

let to_bool = function true -> true_rib | false -> false_rib

let getchar () =
  try
    input_char stdin |> int_of_char
  with End_of_file -> -1

let putchar c =
  char_of_int c |> print_char;
  flush stdout;
  c

let prim2_r f stack =
  let x = pop stack in
  let y = popr stack in
  f x y |> push_w stack

let prim2_w f stack =
  let x = pop stack in
  let y = pop stack in
  f x y |> push_w stack



let primitives = [|
  (* @@(primitives (gen body) *)
  prim1 get_car;                                                          (* @@(primitive (field0 rib))@@ *)
  prim1 get_cdr;                                                          (* @@(primitive (field1 rib))@@ *)
  prim1 get_tag;                                                          (* @@(primitive (field2 rib))@@ *)
  prim3 (fun z y x -> make_rib x y z);                                    (* @@(primitive (rib a b c))@@ *)
  prim1_r (function x -> x);                                                (* @@(primitive (id x))@@ *)
  (function (stack) -> pop stack |> ignore);                                      (* @@(primitive (arg1 x y))@@ *)
  prim2 (fun y x -> y);                                                   (* @@(primitive (arg2 x y))@@ *)
  prim1_close (close)  ;                                                  (* @@(primitive (close rib))@@ *)
  prim1_r (function (_,_,_) -> true_rib | _ -> false_rib);                    (* @@(primitive (rib? rib) (use bool2scm))@@ *)

  prim2_r (fun y x -> set_car x y; y);                                      (* @@(primitive (field0-set! rib))@@ *)
  prim2_r (fun y x -> set_cdr x y; y);                                      (* @@(primitive (field1-set! rib))@@ *)
  prim2_r (fun y x -> set_tag x y; y);                                      (* @@(primitive (field2-set! rib))@@ *)
  prim2 (fun y x -> to_bool (rib_eq x y));                                (* @@(primitive (eqv? x y) (use bool2scm))@@ *)
  (*  @@(primitive (< x y) @@ *)
  prim2 (fun y x -> match x, y with
      | (Int a, Nil, Nil), (Int b, Nil, Nil) -> to_bool (a < b)
      | _ -> invalid_arg "< arguments must be Ints");
  (*  )@@ *)
  (*  @@(primitive (+ x y) @@ *)
  prim2_w (fun y x -> match x, y with
      | Int a, Int b -> Int (a + b)
      | _ -> invalid_arg "+ arguments must be Ints");
  (*  )@@ *)
  (*  @@(primitive (- x y) @@ *)
  prim2_w (fun y x -> match x, y with
      | Int a, Int b -> Int (a - b)
      | _ -> invalid_arg "- arguments must be Ints");
  (*  )@@ *)
  (*  @@(primitive ( * x y) @@ *)
  prim2_w (fun y x -> match x, y with
      | Int a, Int b -> Int (a * b)
      | _ -> invalid_arg "* arguments must be Ints");
  (*  )@@ *)
  (*  @@(primitive (quotient x y) @@ *)
  (* todo div 0 *)
  prim2_w (fun y x -> match x, y with
      | Int a, Int b -> Int (a / b)
      | _ -> invalid_arg "quotient arguments must be Ints");
  (*  )@@ *)
  prim0 (function () -> (Int (getchar ()), Nil, Nil));                                                                (* @@(primitive (getchar))@@ *)
  prim1_w (function Int ch -> Int (putchar ch) | _ -> invalid_arg "putchar argument must be Int");  (* @@(primitive (putchar x))@@ *)
  prim1_w (function Int status -> exit status | _ -> invalid_arg "exit argument must be Int")           (* @@(primitive (exit x))@@ *)
(*  )@@ *)
|]

(* retourne le prochain octet du flux converti en entier. *)
(* let get_byte index =
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
   if x < 46 then n + x else get_int (n + x - 46) (index+1) *)
let rec list_tail lst i =
  if i = 0 then lst else (
    let (car, cdr, tag )= ram.(ptr_of_val lst) in  
    list_tail (car,cdr, tag) (i - 1))
let decode stack =

  let get_byte =
    let input_stream = Stream.of_string input in
    function () -> (Stream.next input_stream |> int_of_char)
  in
  let get_code () =
    let x = (get_byte ()) - 35 in if x < 0 then 57 else x
  in
  let rec get_int n =
    let x = get_code () in
    let n = n * 46 in
    if x < 46 then n + x else get_int (n + x - 46)

  in
  let rec length lst =
    let (car, cdr, tag) = ram.(ptr_of_val lst) in
    if car = Nil then 0 else 1 + length (get_rib cdr)
  in 
  let rec list_to_string (lst : rib) : rib =
    let i = ptr_of_val lst in
    make_rib (Triplet i) (Int (length lst)) (Int 3)
  in
  let string_to_uninterned_symbol (str : rib) =
    let i = ptr_of_val str in let f = ptr_of_val false_rib in
    make_rib (Triplet f) (Triplet i) (Int 2)
  in
  (* construction de la table des symbole *)
  let build_symtbl  =
    let add_symbol (chars:rib) (symtbl:rib) : rib =
      let sym = string_to_uninterned_symbol (list_to_string chars) in
      push_ram sym;
      let sym = ptr_of_val sym and symtbl = ptr_of_val symtbl in
      make_rib (Triplet sym) (Triplet symtbl) (Int 0)

    in
    let rec loop1 n (symtbl:rib) =
      if 0 < n then loop1 (n-1) (add_symbol nil_rib symtbl) else 
        let rec loop2 (symtbl:rib) =
          let rec loop3 (chars:rib) = 
            let x = get_byte () in
            (* on a la , separates symbols *)
            if x = 44 then loop2 (add_symbol chars symtbl) else
              (* ; terminates symbol list *)
            if x=59 then add_symbol chars symtbl else
              let c = ptr_of_val chars in
              loop3 (make_rib (Int x) (Triplet c) (Int 0))
          in
          loop3 nil_rib
        in
        loop2 symtbl
    in
    let n = get_int 0  and symtbl = nil_rib in
    loop1 n symtbl

  (* Graphe d'instruction *)
  in let symtbl = build_symtbl in
  let rec decode_loop stack = 
    let sym n = 
      get_car (list_tail symtbl n) 
    in
    let add_instruction (op:word) (opnd:word) (stack:rib) =
      let i = ptr_of_val stack in
      let instr = make_rib (op) (opnd) (Triplet i) in
      push_ram instr; let i = ptr_of_val instr in
      set_car stack (Triplet i);
      decode_loop stack in
    let x = get_code () in
    let rec loop (op:word) n = 
      let codes = [| 20; 30; 0; 10; 11; 4 |]
      in
      let calcul_opnd n d op =
        if (n<d ) then 
          if ((int_val op) < 3) then sym n else (Int n)
        else
        if (n = d) then (Int (get_int 0)) else sym (get_int ((n-d)- 1))
      in
      let 
        d = codes.(int_val op) in
      if (d+2) < n then
        loop (Int ((int_val op) + 1)) (n-(d+3))
      else
        (if 90 < x then 
           add_instruction (Int instr_if) (get_car stack) stack  (*if *)
         else 
           (if (int_val op) = 0 then
              let i = ptr_of_val stack in push_w stack (op);
            else
              ()
           );
         let opnd = calcul_opnd n d op in
         if ( 4< int_val op ) then 
           let tmp = make_rib opnd (Int 0) (get_car stack) in
           push_ram tmp;
           let tmp = ptr_of_val tmp in
           let proc = make_rib (Triplet tmp) (Nil) (Int procedure_type) in push_ram proc;
           let ignore = pop stack in 
           (if is_rib stack then
              let ip = ptr_of_val proc in 
              add_instruction (Int instr_const) (Triplet ip) stack  (*const**)
            else
              ())
         else 
         if ( 0 < (int_val op)) then 
           add_instruction (Int ((int_val op)-1)) opnd stack 
         else
           add_instruction (Int 0) opnd stack

        )
    in 
    loop (Int 0) (x)
  in
  let main_proc = decode_loop nil_rib in
  (* set predefined globals (always 4 first in the symbol table) *)
  let set_global (value:rib) = 
    let x = ptr_of_val value in 
    match (get_car symtbl) with
    Triplet i -> let (car, cdr, tag) = ram.(i) in set_car (car, cdr, tag) (Triplet x);
    | _ -> invalid_arg "set_global"
    in 

    let i = ptr_of_val symtbl in
    let p0 = make_rib (Int 0) (Triplet i) (Int procedure_type) in
    push_ram p0;
    set_global p0;  (*rib  = primitive 0*)
    set_global false_rib;
    set_global true_rib;
    set_global nil_rib;
  
  main_proc;









(* Decodage de la RVM *)
let rec run (pc : rib)  stack = 
  let instr = get_car (pc)
  and opnd = get_cdr (pc)
  and next = get_tag (pc)  
  in
  match instr with 
  (* halt *)
    Int 5 -> ()
  (* set *)
  | Int 1 -> (
      if is_rib_w opnd then
        (let opnd_r = get_rib opnd in
         set_car opnd_r (get_car stack) ;
         run (get_rib next) (get_rib (get_cdr stack))) 
        (* (_field0-set! (if (-rib? opnd) opnd (list-tail stack opnd)) (_car stack)) *)

      else
        set_car (list_tail stack (int_val opnd)) (get_car stack);
      run (get_rib next) (get_rib (get_cdr stack)))
  (* get *)
  | Int 2 -> (
      if is_rib_w opnd then
        (let opnd_r = get_rib opnd in
         push stack opnd_r;
         run (get_rib next) (stack)) 

      else
        push stack (list_tail stack (int_val opnd));
      run (get_rib next) (stack))
  (* const *)
  | Int 3 -> (
      push stack (get_rib opnd);
      run (get_rib next) (stack))
  (* if *)
  | Int 4 -> (
      (* run (if (eqv? (_car stack) _false) next opnd) (_cdr stack))) *)
      run (if (rib_eq (get_rib (get_car stack)) false_rib) then (get_rib next) else (get_rib opnd)) (get_rib (get_cdr stack)))

  (* jump *)
  (* call *)
  | _ -> invalid_arg "Not yet implemented"

let input_bytes = Bytes.of_string input;;
let taille = Bytes.length input_bytes ;;


