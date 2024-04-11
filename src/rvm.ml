(* RVM code that prints HELLO! *)
(* @@(replace ");'u?>vD?>vRD?>vRA?>vRA?>vR:?>vR=!(:lkm!':lkv6y" (encode 92) @@ *)
let input = ");'u?>vD?>vRD?>vRA?>vRA?>vR:?>vR=!(:lkm!':lkv6y";;
(* )@@ *)

Printf.printf "input :\n%s\n" input;;

let count_symtbl input = 
  let rec loop i count = 
    if i < String.length input then
      if input.[i] = ',' then
        loop (i + 1) (count + 2 + 1)
      else
      if input.[i] = ';' then
        count+2+1
      else
        loop (i + 1) count+1
    else
      count
  in
  loop 0 0


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
  | Triplet of int  

type rib = word * word * word 

type ram = rib array

let size_ram = 900000
let alloc_limit = size_ram / 2 -1

(* la mémoire *)
let ram : ram = Array.make size_ram (Nil, Nil, Nil)  (* Déclaration de la variable globale ram *)
(* program counter : indice dans la ram *)
let pc = ref (-1)
(* le sommet de pile qui indique l'indice dasn la ram *)
let sp = ref size_ram
let st = ref (-1)
let stbl = ref (-1)
let pos = ref 0

let make_rib (a:word) (b:word) (c: word) : rib = (a, b, c)


let is_rib r : bool = match r with 
  | (_,_,_) -> true 
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

let print_value (v : word) : unit =
  match v with
  | Int i -> Printf.printf "Int %d" i
  | Triplet t -> Printf.printf "Triplet %d " t;
  | Nil -> Printf.printf "Nil"   
    
  
let rib_eq (a:rib) (b:rib) : bool = 
  let (a1, a2, a3) = a in 
  let (b1, b2, b3) = b in 
  a1 = b1 && a2 = b2 && a3 = b3

  let get_int_triplet (x : word) = 
    match x with 
      Triplet i -> i 
    |_ -> invalid_arg "expected a triplet 1" 
  let get_rib (r : word ) : rib =
    match r with 
    | Triplet i -> ram.(i)
    | _ -> invalid_arg "get_rib expected a triplet"
  let rec print_rib (rib : rib) : unit =
  
    let print_value (v : word) : unit =
      match v with
      | Int i -> Printf.printf "%d" i
      | Triplet t -> print_rib (get_rib (Triplet t))
      | Nil -> Printf.printf "Nil"   in
    let print_separator () = Printf.printf "," in
    let print_open_bracket () = Printf.printf "[" in
    let print_close_bracket () = Printf.printf "]" in
    match rib with
    | (a, b, c) ->
        print_open_bracket ();
        print_value a; print_separator ();
        print_value b; print_separator ();
        print_value c;
        print_close_bracket ()
                 

        let print_r (ri:rib) :unit= 
        match ri with 
          (car, cdr, tag) -> (
            Printf.printf "\n car : ";print_value car ; 
            Printf.printf " cdr : "; print_value cdr;
            Printf.printf " tag : "; print_value tag;
            Printf.printf " FINIIINININ \n")
  
let word_eqv (a:word) (b:word) : bool = 
  if is_rib_w a then
    print_r (get_rib a)
  else
    print_value (a);
  Printf.printf " <- aaaaa\n";

  if is_rib_w b then
    print_r (get_rib b)
  else
    print_value (b);
  Printf.printf " <- bbbb\n";
  a = b

let get_car (rib : rib) : word= match rib with 
    (car, _,_ ) -> car

let set_car (rib : rib) (w : word) = 
  match rib with
  | (car, cdr, tag) -> (w, cdr, tag)



let set_car_triplet (rib : word) (newval:word) = 
  match rib with 
  | Triplet i -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag); newval
  | _ -> invalid_arg "set car triplet expected a triplet"
let get_car_triplet (rib : word) : word =
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v1
  | _ -> invalid_arg "get_car_triplet expected a triplet"

let get_car_triplet_s (rib : word) : word =
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v1
  | _ -> invalid_arg "get_car_triplet expected a triplet"
  

let get_cdr (rib : rib) : word= match rib with 
    (_, cdr,_ ) -> cdr
  (* | _ -> invalid_arg "get_cdr expects a rib" *)

let set_cdr (rib : rib) (w : word) = 
  match rib with
  | (car, cdr, tag) -> (car, w, tag)

let set_cdr_triplet (rib : word) (newval : word) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, newval, tag); newval
  | _ -> invalid_arg "set cdr triplet expected a triplet"



let get_cdr_triplet (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v2
  | _ -> invalid_arg "get_cdr_triplet expected a triplet"

let get_tag (rib : rib) : word= match rib with 
    (_, _,tag) -> tag
  (* | _ -> invalid_arg "get_tag expects a rib" *)

let get_tag_triplet (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v3
  | _ -> invalid_arg "get_tag_triplet expected a triplet"

let set_tag (rib : rib) (newval : word) = 
  match rib with
  | (car, cdr, tag) -> (car, cdr, newval)
let set_tag_triplet (rib : word) (newval : word) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, cdr, newval); newval
  | _ -> invalid_arg "set cdr triplet expected a triplet"


let make_rib_of_ints a b c = (Int a, Int b, Int c)                (* primitive (rib a b c) *)

let false_rib : rib = make_rib_of_ints 0 0 5
let true_rib : rib = make_rib_of_ints 0 0 5
let nil_rib : rib = make_rib_of_ints 0 0 5

let tos  = function () -> get_car ram.(!sp)

let pop ()  =
  let x = get_car ram.(!sp) in 
  (if is_rib_w (get_cdr ram.(!sp)) then
    sp := get_int_triplet (get_cdr ram.(!sp))
  else
    ram.(!sp) <- (Nil, get_cdr ram.(!sp),  get_tag ram.(!sp)));
  x 
  
let popr () = 
  let x = ram.(!sp) in
  sp := get_int_triplet (get_cdr ram.(!sp));
  if is_rib_w (get_car x) then 
    get_rib (get_car x)
  else
    x
  
let push_rib(rib : rib) : unit =
  let i = !sp in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- rib;
       sp := i-1) 
    else(
      ram.(i-1) <- rib;
      ram.(i-2) <- (Triplet (i-1), Triplet i, Int pair_type); 
      sp := i-2) 
  else
    invalid_arg "stack overflow &"
    (* gc *)


let push_word (car : word) : unit =
  let i = !sp in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then (ram.(i-1) <- (car, Int 0, Int pair_type); sp := !sp-1) else
      (ram.(i-1) <- (car, Triplet (i), Int pair_type); sp := i-1)
  else
    invalid_arg "stack overflow é"
    (* gc *)

let prim0 f = function () -> f () |> push_word

let prim1_word f = function () -> pop () |> f |> push_word
let prim1_rib f = function () -> pop () |> f |> push_rib
let prim2 f = function () ->
  let x = pop () in
  let y = pop () in
  f x y |> push_word
let prim3 f = function () ->
  let x = pop () in
  let y = pop () in
  let z = pop () in
  f x y z |> push_rib
  

let to_bool = function true -> true_rib | false -> (Triplet 1, Triplet 2, Int 5)

let getchar () =
  try
    input_char stdin |> int_of_char
  with End_of_file -> -1

let putchar c =
  Printf.printf "putchar ";
  char_of_int c |> print_char;
  flush stdout;
  c


let close () =
  let tos = tos() in
  let x = get_car_triplet tos in
  let y = get_cdr ram.(!sp) in
  let (car, cdr, tag) = ram.(!sp)
  in
   ram.(!sp) <- (x, y, Int 1);
   ram.(!sp-1) <- (Triplet !sp,cdr, tag);
    sp := !sp - 1

let prim1_fields f = function () ->
  let x = popr () in
  print_r x;
  Printf.printf " printes dans prim1\n"; 
  let y = f x in
  push_word y

let prim2_fields (f: word -> word -> word) = function () ->
  let x = pop () in
  let y = pop () in
  f x y |> push_word

let prim2_bool f = function () ->
  let x = pop () in
  let y = pop () in
  f x y |> to_bool |> push_rib
let primitives = [|
(* @@(primitives (gen body) *)
  prim3 (fun z y x -> make_rib x y z);                                    (* @@(primitive (rib a b c))@@ *)
  prim1_word(function x -> x);                                                (* @@(primitive (id x))@@ *)
  (function () -> pop () |> ignore);                                      (* @@(primitive (arg1 x y))@@ *)
  prim2 (fun y x -> y);                                                   (* @@(primitive (arg2 x y))@@ *)
  close;          (* @@(primitive (close rib))@@ *)
  prim1_rib (function Triplet _ -> true_rib | _ -> (Triplet 1, Triplet 2, Int 5));                    (* @@(primitive (rib? rib) (use bool2scm))@@ *)
  prim1_fields get_car ;                                                          (* @@(primitive (field0 rib))@@ *)
  prim1_fields get_cdr;                                                          (* @@(primitive (field1 rib))@@ *)
  prim1_fields get_tag;                                                          (* @@(primitive (field2 rib))@@ *)
  prim2_fields (fun y x -> set_car_triplet x y);                                      (* @@(primitive (field0-set! rib))@@ *)
  prim2_fields (fun y x -> set_cdr_triplet x y);                                      (* @@(primitive (field1-set! rib))@@ *)
  prim2_fields (fun y x -> set_tag_triplet x y);                                      (* @@(primitive (field2-set! rib))@@ *)
  prim2_bool (fun y x -> word_eqv x y);                             (* @@(primitive (eqv? x y) (use bool2scm))@@ *)
    (*  @@(primitive (< x y) @@ *)
  prim2_bool (fun y x -> match x, y with
      | Int a, Int b -> (a < b)
      | _ -> invalid_arg "< arguments must be Ints");
    (*  )@@ *)
    (*  @@(primitive (+ x y) @@ *)
  prim2 (fun y x -> match x, y with
      | Int a, Int b -> Int (a + b)
      | _ -> invalid_arg "+ arguments must be Ints");
    (*  )@@ *)
    (*  @@(primitive (- x y) @@ *)
  prim2 (fun y x -> match x, y with
      | Int a, Int b -> Int (a - b)
      | _ -> invalid_arg "- arguments must be Ints");
    (*  )@@ *)
    (*  @@(primitive ( * x y) @@ *)
  prim2 (fun y x -> match x, y with
      | Int a, Int b -> Int (a * b)
      | _ -> invalid_arg "* arguments must be Ints");
    (*  )@@ *)
    (*  @@(primitive (quotient x y) @@ *)
  prim2 (fun y x -> match x, y with
      | Int a, Int b -> Int (a / b)
      | _ -> invalid_arg "quotient arguments must be Ints");
    (*  )@@ *)
  prim0 (function () -> Int (getchar ()));                                                                (* @@(primitive (getchar))@@ *)
  prim1_word (function Int ch -> Int (putchar ch) | _ -> invalid_arg "putchar argument must be Int");  (* @@(primitive (putchar x))@@ *)
  prim1_word (function Int status -> exit status | _ -> invalid_arg "exit argument must be Int")           (* @@(primitive (exit x))@@ *)
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
let get_rib_sym (w : word) =
  match w with 
    Triplet i -> ram.(i)
  | _ -> invalid_arg "get_rib_sym"    
           

let rec list_tail (ptr:int) i =
  Printf.printf "list tail %d\n" i;
  print_r ram.(ptr);
  Printf.printf "\n";
  if 0 = i then 
    Triplet ptr
  else
    (if is_rib_w (get_cdr (ram.(ptr))) then
       let (car, cdr, tag) = ram.(ptr) in
       list_tail (get_int_triplet (cdr )) (i-1)
     else
       get_cdr (ram.(ptr)))



let get_byte = function () ->
  let c = String.get input (!pos) in
  (pos := !pos + 1;
   int_of_char c)
  
let get_code () =
  let x = (get_byte ()) - 35 in if x < 0 then 57 else x

let rec get_int n =
  let x = get_code () in
  let n = n * 46 in
  if x < 46 then n + x else get_int (n + x - 46)

let is_pair (x:rib) = 
  match x with 
  | (Int _, Triplet _, Int 0) -> true
  | (Int _, Int _ , Int 0) -> true
  | Triplet _,  Int _ , Int 0 -> true
  | Triplet _, Triplet _, Int 0 -> true
  | _ -> false

let not_nil_cdr (w : word)  =
  match w with 
    Nil -> false
  | _ -> true


let i_accum stbl st = if st > stbl then st else stbl     

        
let push2_symtbl_rib(rib : rib) (tag : word): unit =
  let i = !st in
  if i < size_ram then
    (* premier elemn de stack *)
    if i = -1 then 
      (ram.(i+1) <- rib;
       ram.(i+2) <- (Triplet (i+1), Int 0, tag);
       st := i+2) 
    else(
      ram.(i+1) <- rib;
      ram.(i+2) <- (Triplet (i+1), Triplet i, tag); 
      st := i+2) 
  else
    invalid_arg "stack overflow 7"
    (* gc *)

let push_symtbl_rib (rib : rib) :unit =
  let i = i_accum !st !stbl in
  if i < size_ram then
    (ram.(i+1) <- rib)
  else
    invalid_arg "stack overflow 6"
    (* gc *)

let push_symtbl_word (w : word) :unit =
  let i = !st in
  if i < size_ram then
    (* premier elemn de stack *)
    if i = -1 then 
      (ram.(i+1) <- (w, Int 0, Int pair_type);
       st := i+1) 
    else(
      ram.(i+1) <- (w, Triplet i, Int pair_type); 
      st := i+1) 
  else
    invalid_arg "stack overflow 5"
    (* gc *)




let push2_symtbl_word (car : word)(tag : word) : unit =
  let i = i_accum !st !stbl in
  if i < alloc_limit then
    (* premier elemn de stack *)
    if i = -1 then (ram.(i+2) <- (car, Int 0, tag)) else
      (ram.(i+2) <- (car, Triplet (i+1), tag))
  else
    invalid_arg "stack overflow 4"
    (* gc *)

let push2_symtbl_cdr (cdr : word) (tag : word) : unit =
  let i = !st in
  if i < alloc_limit then
    (* premier elemn de stack *)
    if i = -1 then (ram.(i+1) <- (Int 0, cdr, tag);  st := i+1) else
      (ram.(i+1) <- (Triplet i, cdr, tag); st := i+1)
  else
    invalid_arg "stack overflow 3"
    (* gc *)

let push_rib_stbl(rib : rib) : unit =
  let i = !stbl in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- rib;
       stbl := i-1) 
    else(
      ram.(i-1) <- rib;
      ram.(i-2) <- (Triplet (i-1), Triplet i, Int pair_type); 
      stbl := i-2) 
  else
    invalid_arg "stack overflow 1"
    (* gc *)


let push_word_stbl (car : word) : unit =
  let i = (get_int_triplet car) in
  if i < alloc_limit then
    
    (* premier elemn de stack *)
    if !stbl = -1 then ( (ram.(i+1) <- (car, Int 0, Int pair_type); stbl := i+1) )else
      (ram.(i+1) <- (car, Triplet (!stbl), Int pair_type); stbl := i+1)
  else
    invalid_arg "stack overflow 2 "
    (* gc *)

let get_cdr_sym (rib : rib) =
  (match rib with 
     (_, cdr, _) -> cdr)

let get_car_sym (rib : rib) =
  (match rib with 
     (car, _, _) -> car)

let get_rib_sym (w : word) =
  match w with 
    Triplet i -> ram.(i)
  | _ -> invalid_arg "get_rib_sym"


let rec chars2str(lst : rib) : unit =
  if is_pair lst && not_nil_cdr (get_cdr_sym lst) then
    if is_rib_w (get_cdr_sym lst) then
    
      (let next = get_cdr_sym lst in
       chars2str (get_rib_sym next))
    else
      (let c = get_car_sym lst in
       match c with
       | Int i -> Printf.printf "%c" (char_of_int i)
       | _ -> invalid_arg "chars2str")
  else
    (invalid_arg "chars2str arg")

let length lst =
  let rec aux l acc =
    if is_pair l then
      match get_cdr l with
      | Int _ -> acc +1
      | Triplet i -> aux (get_rib_sym (Triplet i)) (acc + 1)
      | _ -> invalid_arg "length"
    else
      acc
  in
  aux lst 0


let push_symtbl (rib:rib) : unit =
  let i = i_accum !st !stbl in
  if i < alloc_limit then
    (* premier elemn de stack *)
      (ram.(i+1) <- rib;
      st := i+1)
  else
    invalid_arg "stack overflow 10"
    (* gc *)

let create_sym (i:int)= 
  (* rib *list = alloc_rib(name, lst_length(name), STRING_TAG); *)
  let len = length ram.(i) in
  

  push_symtbl_rib (make_rib (Triplet i) (Int len) (Int string_type));

  (* rib *sym = alloc_rib(FALSE, TAG_RIB(list), SYMBOL_TAG); *)
  push2_symtbl_word (Triplet 3) (Int symbol_type);
  let x = i_accum !st !stbl in 

  (* rib *root = alloc_rib(TAG_RIB(sym), symbol_table, PAIR_TAG); *)
  push_word_stbl (Triplet (x+2)) 
      

let push_symtbl_word_accum (car: word) (cdr:word) =
  (* Printf.printf "\n%d\n" !stbl; *)
  let i = i_accum !stbl !st in
  if i < alloc_limit then
    (* premier elemn de stack *)
    if i = -1 then 
      (ram.(i+1) <- (car, cdr, Int pair_type);
       st := i+1) 
    else(
      ram.(i+1) <- (car, cdr, Int pair_type);
      st := i+1) 
  else
    invalid_arg "stack overflow 11"
    (* gc *)
    
let build_symtbl () : unit =

  (* Caraceres de fin de chaine *)
  push_symtbl nil_rib;

  let rec loop1 n :unit =
    if 0 < n then 
      ( 
        if !stbl > -1 then
          (Printf.printf "symbol table avant n>0 %d\n" n;
          print_rib (ram.(!stbl));
          Printf.printf "\n");
        push_symtbl nil_rib;
        create_sym(!st);
        Printf.printf "symbol table n>0 %d\n" n;
        print_rib (ram.(!stbl));
        Printf.printf "\n";
        loop1 (n-1)) 
    else 
      (* i = index dans la symtbl du premier caractere de la liste des symboles *)
      let rec loop3 (i:int) = 
        (* Printf.printf"in";  *)
        (* récupère le byte *)
        let x = get_byte () in 
        (* Printf.printf "\n hello %c\n" (char_of_int x); *)
        (* on a ',' séparation des symboles *)
        if x = 44 then ( create_sym(i); 
        Printf.printf "symbol table n=44\n";
        print_rib (ram.(!stbl));
        Printf.printf "\n";
        loop3(!st)) else
        (* ';' Fin de la liste des symboles *)
        if x=59 then 
          ( create_sym(i);
            Printf.printf "symbol table x=59\n";
            print_rib (ram.(!stbl));
            Printf.printf "\n";
          )
        else
          (push_symtbl_word_accum (Int x) (Triplet (i)); loop3 (!st))
      in
      loop3 (!st)
  in
  let n = get_int 0 in (
    loop1 n)
  
let get_rib_sym (w : word) =
  match w with 
    Triplet i -> ram.(i)
  | _ -> invalid_arg "get_rib_sym"    

           

let rec print_rib (rib : rib) : unit =
  let print_value (v : word) : unit =
    match v with
    | Int i -> Printf.printf "%d" i
    | Triplet t -> print_rib (get_rib (Triplet t))
    | Nil -> Printf.printf "Nil"
  in
  match rib with
  | (a, b, c) ->
      Printf.printf "[";
      print_value a; Printf.printf ",";
      print_value b; Printf.printf ",";
      print_value c;
      Printf.printf "]"
        

let set_global (value:rib) = (
  push_symtbl_rib value;
  set_car_triplet (get_car_triplet (Triplet !stbl)) (Triplet !st);)


let push2_stack_word(w : word) (tag : word): unit =
  let i = !sp in
  Printf.printf "push2_stack_word %d\n" i;
  if i < size_ram then print_r ram.(i) else ();
  Printf.printf "\n";
  if i > alloc_limit then
      (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- (w, Int 0, tag);
       sp := i-1) 
    else(
      ram.(i-1) <- (w, Triplet (i), tag);
      sp := i-1) 
  else
    invalid_arg "stack overflow 12"
      (* gc *)



let push_stack (rib : rib) : unit =
  let i = !sp in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- rib;
       sp := i-1) 
    else(
      ram.(i-1) <- rib;
      ram.(i-2) <- (Triplet (i-1), Triplet i, Int pair_type); 
      sp := i-2) 
  else
    invalid_arg "stack overflow 13"
    (* gc *)
let codes = [| 20; 30; 0; 10; 11; 4 |]



let push_heap_rib (rib : rib) : unit =
  let i = !pc in
  if i < size_ram then
    (* premier elemn de stack *)
    if i = -1 then 
      (ram.(i+1) <- rib;
       pc := i+1) 
    else(
      ram.(i+1) <- rib;
      ram.(i+2) <- (Triplet (i+1), Triplet i, Int pair_type);
      pc := i+2) 
  else
    invalid_arg "stack overflow 14"
    (* gc *)

let push_heap_word (w : word) : unit =
  let i = !pc in
  if i < size_ram then
    (* premier elemn de stack *)
    if i = -1 then 
      (ram.(i+1) <- (w, Int 0, Int pair_type);
       pc := i+1) 
    else(
      ram.(i+1) <- (w, Triplet i, Int pair_type);
      pc := i+1) 
  else
    invalid_arg "stack overflow 15"
    (* gc *)


let push_heap_r (rib : rib) : unit =
  let i = !pc in
  if i < size_ram then
    (* premier elemn de stack *)
    (ram.(i+1) <- rib;
     pc := i+1) 
  else
    invalid_arg "stack overflow 16"
    (* gc *)
    
let print_value (v : word) : unit =
  match v with
  | Int i -> Printf.printf "Int %d" i
  | Triplet t -> Printf.printf "Triplet %d " t;
  | Nil -> Printf.printf "Nil"     

let get_cdr_triplet_sym (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v2
  | _ -> invalid_arg "get_cdr_triplet_sym expected a triplet"

let push_heap_r (rib : rib) : unit =
  let i = !pc in
  if i < size_ram then
    (* premier elemn de stack *)
    if i = !stbl then 
      (ram.(i+1) <- rib;
       pc := i+1) 
    else(
      ram.(i+1) <- rib;
      pc := i+1) 
  else
    invalid_arg "stack overflow 17"
    (* gc *)
 
let push_heap_copy (rib : rib) : unit =
  let i = !pc in
  let rec push_heap_stack (w : word) : unit =
    let i = !pc in
    if i < size_ram then
      (
        let (car, cdr, tag) = get_rib w in
        match (car, cdr, tag) with
        | (Int _, Int _, Int _) -> 
          (ram.(i+1) <- (car, cdr, tag);
           pc := i+1)
        | (Triplet t, Int _, Int _) ->
          if t > !stbl then 
          (push_heap_stack (car);
          ram.(!pc+1) <- (Triplet (!pc), cdr, tag);
          pc := !pc+1)
          else
          (ram.(i+1) <- (car, cdr, tag);
           pc := i+1)
        | (Triplet t, Triplet y, Int _) ->
          if t > !stbl && y > !stbl then (
          push_heap_stack (car);
          let k = !pc in
          push_heap_stack (cdr);
          ram.(!pc+1) <- (Triplet k, Triplet !pc, tag);
          pc := !pc+1);
          if t > !stbl && y < !stbl then (
          push_heap_stack (car);
          ram.(!pc+1) <- (Triplet !pc, cdr, tag)
          );
          if t < !stbl && y > !stbl then (
          push_heap_stack (cdr);
          ram.(!pc+1) <- (car, Triplet !pc, tag)
          );
          if t < !stbl && y < !stbl then (
          ram.(i+1) <- (car, cdr, tag);
          pc := i+1)
        | (Triplet t, Triplet y, Triplet u) ->
          if t> !stbl && y > !stbl && u > !stbl then (
            push_heap_stack (car);
            let k = !pc in
            push_heap_stack (cdr);
            let j = !pc in
            push_heap_stack (tag);
            ram.(!pc+1) <- (Triplet k, Triplet j, Triplet !pc);
            pc := !pc+1);
          if t> !stbl && y > !stbl && u < !stbl then (
            push_heap_stack (car);
            let k = !pc in
            push_heap_stack (cdr);
            ram.(!pc+1) <- (Triplet k, Triplet !pc, tag);
            pc := !pc+1);
          if t> !stbl && y < !stbl && u > !stbl then (
            push_heap_stack (car);
            let k = !pc in
            push_heap_stack (tag);
            ram.(!pc+1) <- (Triplet k, cdr, Triplet !pc);
            pc := !pc+1);
          if t> !stbl && y < !stbl && u < !stbl then (
            push_heap_stack (car);
            ram.(!pc+1) <- (Triplet !pc, cdr, tag);
            pc := !pc+1);
          if t< !stbl && y > !stbl && u > !stbl then (
            push_heap_stack (cdr);
            let k = !pc in
            push_heap_stack (tag);
            ram.(!pc+1) <- (car, Triplet k, Triplet !pc);
            pc := !pc+1);
          if t< !stbl && y > !stbl && u < !stbl then (
            push_heap_stack (cdr);
            ram.(!pc+1) <- (car, Triplet !pc, tag);
            pc := !pc+1);
          if t< !stbl && y < !stbl && u > !stbl then (
            push_heap_stack (tag);
            ram.(!pc+1) <- (car, cdr, Triplet !pc);
            pc := !pc+1);
          if t< !stbl && y < !stbl && u < !stbl then (
            ram.(i+1) <- (car, cdr, tag);
            pc := i+1)

        | (Int _, Triplet t, Int _) ->
          if t > !stbl then (
            push_heap_stack (cdr);
            ram.(!pc+1) <- (car, Triplet !pc, tag);
            pc := !pc+1
          )
          else
            (ram.(i+1) <- (car, cdr, tag);
             pc := i+1)
        | (Int _, Triplet t, Triplet y) ->
          if t > !stbl && y > !stbl then (
            push_heap_stack (cdr);
            let k = !pc in
            push_heap_stack (tag);
            ram.(!pc+1) <- (car, Triplet k, Triplet !pc);
            pc := !pc+1);
          if t > !stbl && y < !stbl then (
            push_heap_stack (cdr);
            ram.(!pc+1) <- (car, Triplet !pc, tag);
            pc := !pc+1);
          if t < !stbl && y > !stbl then (
            push_heap_stack (tag);
            ram.(!pc+1) <- (car, cdr, Triplet !pc);
            pc := !pc+1);
          if t < !stbl && y < !stbl then (
            ram.(i+1) <- (car, cdr, tag);
            pc := i+1)
        | (Int _, Int _, Triplet t) ->
          if t > !stbl then (
            push_heap_stack (tag);
            ram.(!pc+1) <- (car, cdr, Triplet !pc);
            pc := !pc+1)
          else
            (ram.(i+1) <- (car, cdr, tag);
             pc := i+1)
        | (Triplet t, Int _, Triplet y) ->
          if t > !stbl && y > !stbl then (
            push_heap_stack (car);
            let k = !pc in
            push_heap_stack (tag);
            ram.(!pc+1) <- (Triplet k, cdr, Triplet !pc);
            pc := !pc+1);
          if t > !stbl && y < !stbl then (
            push_heap_stack (car);
            ram.(!pc+1) <- (Triplet !pc, cdr, tag);
            pc := !pc+1);
          if t < !stbl && y > !stbl then (
            push_heap_stack (car);
            let k = !pc in
            push_heap_stack (tag);
            ram.(!pc+1) <- (Triplet k, cdr, Triplet !pc);
            pc := !pc+1);
          if t < !stbl && y < !stbl then (
            ram.(i+1) <- (car, cdr, tag);
            pc := i+1)
          
        | _ -> Printf.printf "wait"
      )
    else
      invalid_arg "stack overflow 19"
      (* gc *)
    in
  if i < size_ram then
    (
      let (car, cdr, p) = rib in 
      match p with 
      | Int _ -> 
        (ram.(i+1) <- rib;
         pc := i+1)
      | Triplet t -> 
        push_heap_stack (Triplet t);
        ram.(!pc+1) <- (car, cdr, Triplet !pc);
        pc := !pc+1
      | _ -> invalid_arg "push_heap_copy"

    )
  else
    invalid_arg "stack overflow 19"
    (* gc *)

let push_stack_car (rib : rib) : unit = 
  let i = !sp in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- rib;
       sp := i-1) 
    else(
      let (_, cdr, tag) = ram.(i) in
      ram.(i) <- rib;
      ram.(i-1) <- (Triplet (i), cdr, tag);
      sp := i-1;

    )
      
  else
    invalid_arg "stack overflow 18"
    (* gc *) 

let decode = function () ->(
    Printf.printf ("DECODE\n");
  (* Graphe d'instruction *)
    let rec decode_loop () : word = 
      (* if !sp != size_ram then(
        Printf.printf "\n LA STACK \n";
        print_rib (ram.(!sp));
        Printf.printf "\n"); *)
      let sym (n:int) = 
        let l = (list_tail (!stbl) (n))in
        Printf.printf("here\n");
        let car = get_car_triplet l in 
        Printf.printf("here\n");

        car
      in
      
      let add_instruction (op:int) (opnd :word) =
    (* TODO *)
    (* (_set-car! stack (_rib op opnd (_car stack))) *)
        let x = make_rib (Int op) opnd (tos()) in
        push_stack_car x;
        decode_loop ()
      in

      let add_instr_if = function () ->
        let s = get_cdr_triplet (Triplet !sp) in
        let x = make_rib (Int 4) (get_car_triplet (Triplet !sp)) (get_car_triplet (s)) in
        (* mettre cdr(stack) à la place de stack *)
        let (_, cdr, tag) = ram.(get_int_triplet s) in
        ram.(get_int_triplet s) <- x;
        ram.(!sp) <- (s, cdr, tag);
        decode_loop()

      in
    (* calcul opnd *)
      let calcul_opnd (n:int) (d:int) (op:int) :word= 
        if (n< d) then 
          (
            if op <3 then (
                Printf.printf "\n op<3 \n";
              sym n) 
            else (
                Printf.printf "\n op>=3 \n";
              (Int n)))
        else
        if n = d then (
          Printf.printf "\n n=d \n";  
          Int (get_int 0)) 
        else
          (
          Printf.printf "\n n!=d \n";
          sym (get_int ((n-d)-1)))

      
      in
      let x = get_code () in
      let rec loop (op:int) (n:word) = 
        let d = codes.(op) 
        in
        if (d+2) < (int_val n) then
          ( 
            Printf.printf "\n d+2 < n \n";
            loop (op + 1) (Int ((int_val n)-(d+3))))
        else
        if 90 < x then (*if *)(
          Printf.printf "\n x > 90 \n";
          (* print_rib (ram.(!sp));
          Printf.printf "\n"; *)
          add_instr_if ())
        else 
          (  
            Printf.printf "\n x <= 90 \n";        
            (* jump ou call *)
            if op = 0 then (  
              Printf.printf "\n op = 0 \n";
              push2_stack_word (Int 0) (Int 0) 
            )else (
              Printf.printf "\n op !=0 \n"
              );
            let opnd = calcul_opnd (int_val n) d (op) in

            if 4 < op then
              (

                Printf.printf "\n 4 < op \n";
                let p = pop() in 
                Printf.printf "\n ppppppppppppppppp \n";
                print_rib (get_rib p);
                push_heap_copy (make_rib opnd (Int 0) (p)) ;

                push_heap_r nil_rib;
                push_heap_r (make_rib (Triplet (!pc-1)) (Triplet !pc) (Int procedure_type));
                
                if ram.(!sp) = (Nil, Int 0, Int 0) then
                  (
                    Triplet !pc)
                else (
                  add_instruction (instr_const) (Triplet !pc))
              )
            else(
              Printf.printf "\n 4 >= op \n";
            if (0<op) then
              (
                Printf.printf "\n 0 < op \n";
                add_instruction (op-1) opnd)
            else
              (
                Printf.printf "\n 0 >= op \n";
                add_instruction (0) opnd)
          ) )
      
      in 

      loop (0) (Int x)
    in
    let main_proc = decode_loop() in 
    

    let d = (get_car_triplet main_proc) in  let f = get_tag_triplet d in 
    pc := get_int_triplet f

  )

let get_var opnd = 
  match opnd with 
  | Triplet _ -> get_car_triplet opnd
  | Int i -> get_car_triplet (list_tail !sp i)
  | _ -> invalid_arg "get_var"
(* 
let set_var stack opnd value : unit =
  if is_rib_w opnd then
let ropnd = get_rib opnd in
set_car ropnd value
else
  set_car (list_tail stack (int_val opnd)) value *)

let setup_stack = function () ->
  
  let r = make_rib (Int instr_halt) (Int 0) (Int pair_type) in
  ram.(!sp) <- r;

  ram.(!sp-1) <- (Int 0, Int 0, Triplet !sp);

  sp := !sp - 1



let show_stack = function () -> 

  print_value (get_tag ram.(!sp));
  print_r (ram.(!sp));
  match get_tag ram.(!sp) with
  | Int i -> if i!= 0 then Printf.printf "stack[] empty\n" else ()
  | Triplet t -> 
      if ram.(t) = (Int 5, Int 0, Int 0 ) then Printf.printf "stack[] fini\n" else 
        (
          Printf.printf "[ ";
          let rec loop i b=
            match get_tag ram.(i) with
            | Int _ -> Printf.printf " ]" 
            | Triplet t -> 
                if b=1 then (Printf.printf ", " ;
                             print_value ((get_car_triplet (Triplet i)));
                             loop (get_int_triplet (get_cdr_triplet (Triplet i))) 1)
                else 
                  (print_rib ram.(get_int_triplet (get_car_triplet (Triplet i)));
                   loop (get_int_triplet (get_cdr_triplet (Triplet i))) 1)
    
            | _ -> invalid_arg "show_stack"
          in loop !sp 0)
  | _ -> invalid_arg "show_stack"

let rec show_rib (rib:rib) (depth:int) = 
  if depth > 3 then 
    if is_rib_w (Triplet !sp) then 
      Printf.printf("[Array]")
    else ()
  else
  if is_rib_w (Triplet !sp) then 
    (Printf.printf("[");
     show_rib (get_rib (get_car_triplet (Triplet !sp))) (depth+1);
     Printf.printf(",");
     show_rib (get_rib (get_cdr_triplet (Triplet !sp))) (depth+1);
     Printf.printf(",");
     show_rib (get_rib (get_tag_triplet (Triplet !sp))) (depth+1);
     Printf.printf("]"))

  else
    print_r rib


let show_opnd opnd = 
  match opnd with 
  | Int i -> Printf.printf "\nopnd = Int %d" i
  | Triplet t -> let (car, cdr, tag) = ram.(t) in 
      if tag = Int 2 then (Printf.printf "\n sym : "; print_rib ram.(t); Printf.printf "\n") else
        Printf.printf "Triplet %d " t
  | _ -> invalid_arg "show_opnd"

let rec show_rib (rib:word) depth = 
  if depth > 3 then 
    if is_rib_w (Triplet !sp) then 
      Printf.printf("[Array]")
    else ()
  else
  if is_rib_w (Triplet !sp) then 
    (Printf.printf("[");
     show_rib ((get_car_triplet (Triplet !sp))) (depth+1);
     Printf.printf(",");
     show_rib ((get_cdr_triplet (Triplet !sp))) (depth+1);
     Printf.printf(",");
     show_rib ((get_tag_triplet (Triplet !sp))) (depth+1);
     Printf.printf("]"))
  else
    print_value rib

let advance_pc = function () -> 
  let tag = get_tag_triplet (Triplet !pc) in
  match tag with 
  | Int i -> pc := !stbl; Printf.printf "\ntag est un int \n"
  | Triplet t -> pc := get_int_triplet tag
  | _ -> invalid_arg "advance_pc"

let get_cont  = function () ->
  let rec loop (s:word) : word =
    match get_tag_triplet s with
    | Int x -> 
      loop (get_cdr_triplet s)
    | Triplet t -> s
    | _ -> invalid_arg "get_cont 2"
  in loop (Triplet !sp)
  

(* Decodage de la RVM *)
let rec run (p : int)=  
  let calcul_i vari p = 
    if vari = 1 then 
      (int_val ((get_car_triplet  (Triplet (!sp))))+p+3)
    else
      (p+3)
    in
  Printf.printf "\nNEWWWWW %d\n" p ;
  let instr = get_car_triplet (Triplet !pc)
  and opnd = get_cdr_triplet (Triplet !pc)
  and next = get_tag_triplet (Triplet !pc)  
  in 
  Printf.printf "\ninstr\n";
  print_value instr;
  Printf.printf "\nopnd\n";
  print_value opnd;
  Printf.printf "\nnext\n";
  print_value next;

  print_r ram.(899819);
  Printf.printf "\n";
  if is_rib_w (get_cdr_triplet (Triplet 899819)) then
    if is_rib_w (get_car_triplet (get_cdr_triplet (Triplet 899819))) then(
      Printf.printf " \n car cdr 0 0 -- RIB 899819 ";
      print_r (get_rib (get_car_triplet (get_cdr_triplet (Triplet 899819)))))
    else ()
  else ();
  
  Printf.printf " \nRIB 899819 ";

  
  match instr with 
  | Int 3 -> 
      Printf.printf "--- const ";
      print_value opnd;
      Printf.printf "\ngenre la \n";
      show_stack();
      Printf.printf "Printing la stack before\n";
      print_r ram.(!sp);
      Printf.printf "\n";
      push2_stack_word opnd (Int 0);
      Printf.printf "Printing la stack after\n";
      print_r ram.(!sp);
      Printf.printf "\n";
      Printf.printf "cdr stack\n";
      print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp)));
      Printf.printf "\npc1\n";
      print_r ram.(!pc);
      (* print_r ram.(get_int_triplet (get_tag_triplet (Triplet !pc))); *)
      Printf.printf "\n";
      advance_pc();
      Printf.printf "pc2\n";
      print_r ram.(!pc);
      if is_rib_w (get_cdr_triplet (Triplet !pc)) then(
        Printf.printf "cdr pc %d\n" (get_int_triplet (get_cdr_triplet (Triplet !pc)));
        print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !pc)));
        if is_rib_w (get_car_triplet (get_cdr_triplet(Triplet !pc))) then(
          Printf.printf "car cdr pc %d\n" (get_int_triplet (get_car_triplet (get_cdr_triplet (Triplet !pc))));
          print_r ram.(get_int_triplet (get_car_triplet (get_cdr_triplet(Triplet !pc))));
          if is_rib_w (get_cdr_triplet (get_car_triplet (get_cdr_triplet(Triplet !pc)))) then(
            Printf.printf "cdr car cdr pc %d\n" (get_int_triplet (get_cdr_triplet (get_car_triplet (get_cdr_triplet (Triplet !pc)))));
            print_r ram.(get_int_triplet (get_cdr_triplet (get_car_triplet (get_cdr_triplet(Triplet !pc)))));
            
          )
            
          else ();
        )
          
        else ();
        
        )
        
      else ();
      
      (* print_r ram.(get_int_triplet (get_tag_triplet (Triplet !pc))); *)
      Printf.printf "\n";
      run(p)
  | Int 0 -> 
      if next = Int 0 then 
        (
      Printf.printf "--- jump\n"; Printf.printf "STOP\n"
        ) 
      else(
        Printf.printf "--- call\n");

        Printf.printf "print opnd dans call/jump\n";
        print_r (get_rib (opnd)); 
        Printf.printf "\n";
        Printf.printf "print stack dans call/jump\n";
        print_r ram.(!sp);
        Printf.printf "\n";
        if is_rib_w (get_cdr_triplet (Triplet !sp)) then(
          print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp)));
          if is_rib_w (get_cdr_triplet (get_cdr_triplet(Triplet !sp))) then(
            print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))));
            if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))) then(
              print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))));
              if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))) then(
                print_r ram.(get_int_triplet(get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))));
              
              )
              
            else ();
            )
              
            else ();
          )
            
          else ();
          
          )
          
        else ();

        let proc = get_var opnd in
        Printf.printf "\nproc : \n";
        show_opnd proc;
        print_r ram.(get_int_triplet proc);
        Printf.printf "\n car";
        if is_rib_w (get_car_triplet (proc)) then(
          print_r ram.(get_int_triplet (get_car_triplet (proc)))
        )          
        else ();
        Printf.printf "\n cdr";

        if is_rib_w (get_cdr_triplet (proc)) then(
          print_r ram.(get_int_triplet (get_cdr_triplet (proc)))
        )          
        else ();
        Printf.printf "\n tag";

        if is_rib_w (get_tag_triplet (proc)) then(
          print_r ram.(get_int_triplet (get_tag_triplet (proc)))
        )          
        else ();
        
        let code = get_car_triplet proc in 
        print_value code;
        Printf.printf " <-printed code\n";
        let nargs = int_val (pop()) in 
        
        Printf.printf " %d <- nargs\n" nargs;
        
        (match code with 
        | Int i -> (
          (* Calling a primitive *)
          primitives.(i) () ;
          Printf.printf ("stack apres primitivves\n");
          print_r ram.(!sp);
          Printf.printf "\nokokokokoko 899868\n";
          if is_rib_w (get_cdr_triplet (Triplet !sp)) then(
            print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp)));
            if is_rib_w (get_cdr_triplet (get_cdr_triplet(Triplet !sp))) then(
              print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))));
              if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))) then(
                print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))));
                if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))) then(
                  print_r ram.(get_int_triplet(get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))));
                
                )
                
              else ();
              )
                
              else ();
            )
              
            else ();
            
            )
            
          else ();
          if is_rib_w (get_car_triplet (Triplet !sp)) then
            print_r ram.(get_int_triplet (get_car_triplet (Triplet !sp)))
          else ();
          Printf.printf "\n";
          if next = Int 0 then (
            (* jump *)
            Printf.printf "je jump\n";
            pc := get_int_triplet (get_cont());

            let (car, cdr, tag) = ram.(!sp) in 
            Printf.printf "je jump le pc get cont\n";
              print_r ram.(!pc);
              print_r ram.(get_int_triplet (get_car_triplet (Triplet !pc)));
              ram.(!sp) <- (car, get_car (ram.(!pc)), tag);
              )
          else
            (

            );
          advance_pc();

          Printf.printf ("stack apres call ou jump\n");
          print_r ram.(!sp);
          Printf.printf "\nokokokokoko 899868\n";
          if is_rib_w (get_cdr_triplet (Triplet !sp)) then
            (Printf.printf "\cdr de stack\n";
            print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp))))
          else ();
          if is_rib_w (get_car_triplet (Triplet !sp)) then
            print_r ram.(get_int_triplet (get_car_triplet (Triplet !sp)))
          else ();
          Printf.printf "\n pc : \n";
          print_r ram.(!pc);
          Printf.printf "\n";
          run(p))
        | Triplet t -> (
          Printf.printf "code is a Triplet\n";
          print_r ram.(t);
          Printf.printf "\n";
          (* Printf.printf "code Triplet im printing tag\n";
          print_r (get_rib (get_tag_triplet (Triplet t))); *)
          Printf.printf "\n";
          
          let nparams = (int_val (get_car_triplet code)) lsr 1 in
          ram.(p+1) <- (Int nparams, Int 0, Int 0);
          Printf.printf "nparams : %d\n" nparams;
          
          (* @@(feature arity-check *)
            let vari = int_val (get_car_triplet code) land 1 in  
            Printf.printf "vari : %d\n" vari;
            if (vari = 0  && nparams != (nargs)) || (vari != 0 && nparams > ( nargs)) then
              failwith "*** Unexpected number of arguments nargs: %d nparams: %d vari: %d\n" nargs nparams vari
            else
              ();
            
          (* )@@ 
           @@(feature rest-param (use arity-check) *)
            if vari = 1 then
              (
                let rec rest_loop rest it= 
                  if 0<it then 
                    ( 
                      Printf.printf"not tested yet\n";

                      Printf.printf "\nhere\n";
                      let ite = get_int_triplet rest in
                      Printf.printf "\nhere2\n";

                      let (car, cdr, tag) = ram.(!sp) in
                      let (car2, cdr2, tag2) = ram.(get_int_triplet (get_cdr_triplet (Triplet !sp))) in
                      ram.(!sp) <- (car2, cdr2, tag2);
                      ram.(get_int_triplet (get_cdr_triplet (Triplet !sp))) <- (car, cdr, tag);
                      ram.(ite+1) <- (car, rest, Int pair_type); 
                      rest_loop (Triplet (ite+1)) (it-1) 
                    )
                  else
                    (
                      Printf.printf"testing\n";
                      ram.(!sp-1) <- (rest, Triplet !sp, Int 0);
                      sp := !sp -1;
                      ram.(p+1) <- (Int (nparams+1), Int 0, Int 0);
                    ); 
                in
                ram.(p+2) <- nil_rib;
                rest_loop (Triplet (p+2)) (nargs-nparams);
              );
              Printf.printf "\nherehere\n";

                (* nouveau p dans car de Triplet sp *)
              let np = calcul_i vari (p) in
              Printf.printf "\nhereb np=%d et p =%d\n" np p;
              print_r ram.(np);
              let new_cont = make_rib (Int 0) (proc) (Int 0) in
              Printf.printf "\nherec\n";
                let nc = !sp-1 in
              ram.(nc) <- new_cont;
              Printf.printf "\nhered new cont\n";
              print_r ram.(nc);

              let rec loop nparams new_stack= 
                if 0 < nparams then 
                  (
                    let (car, cdr, tag) = ram.(!sp) in
                    
                    let (car2, cdr2, tag2) = ram.(get_int_triplet (get_cdr_triplet (Triplet !sp))) in
                    let k = get_int_triplet (new_stack) in

                    ram.(!sp) <- (car2, cdr2, tag2);
                    ram.(get_int_triplet (cdr)) <- (car, cdr, tag);

                    ram.(k-1) <- (car, new_stack, Int 0);
                    Printf.printf "printing sp dans loop\n";

                    print_r ram.(!sp);
                    Printf.printf "\nokokokokoko 899868\n";
                    if is_rib_w (get_cdr_triplet (Triplet !sp)) then
                      print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp)))
                    else ();
                    loop (nparams-1) (Triplet (k-1)))
                else
                  (
                    (* non-tail call ? *)
                    if is_rib_w next then 
                      (
                        (* call *)
                        Printf.printf "hihihcall\n";
                        print_r ram.(nc);
                        let (car, cdr, tag) = ram.(nc) in 
                        ram.(nc) <- ((Triplet !sp), cdr, next);
                        Printf.printf "hihihcall 2\n";
                        print_r ram.(nc)
                      ) 
                    else (
                      (* jump *)
                      let k = get_cont() in
                      let (car, cdr, tag) = ram.(nc) in
                      ram.(nc) <- ((get_car_triplet k), cdr, (get_tag_triplet k));
                    );
                    pc := get_int_triplet (get_tag_triplet (code));
                    sp := get_int_triplet (new_stack);
                    Printf.printf "new stack  \n";
                    print_r ram.(!sp);
                    Printf.printf "\nokokokokoko 899868\n";
                    if is_rib_w (get_cdr_triplet (Triplet !sp)) then(
                      print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp)));
                      if is_rib_w (get_cdr_triplet (get_cdr_triplet(Triplet !sp))) then(
                        print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))));
                        if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))) then(
                          print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))));
                          if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))) then(
                            print_r ram.(get_int_triplet(get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))));
                          
                          )
                          
                        else ();
                        )
                          
                        else ();
                      )
                        
                      else ();
                      
                      )
                      
                    else ();
                    Printf.printf "\npccccc0\n";
                    print_r ram.(!pc);
                    Printf.printf "\n";
                    if is_rib_w (get_cdr_triplet (Triplet !pc)) then(
                      print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !pc)));
                      if is_rib_w (get_cdr_triplet (get_cdr_triplet(Triplet !pc))) then(
                        print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !pc))));
                        if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !pc)))) then(
                          print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !pc)))));
                          if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !pc))))) then(
                            print_r ram.(get_int_triplet(get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !pc))))));
                          
                          )
                          
                        else ();
                        )
                          
                        else ();
                      )
                        
                      else ();
                      
                      )
                      
                    else ();
                    run(np);
                  );
                  
                in
                let nparams = int_val (get_car_triplet (Triplet (p+1)))in
                Printf.printf "nparams : %d\n" nparams;
                loop nparams (Triplet (nc));
          Printf.printf "te";
          
          )
        
        | _ -> Printf.printf "failing with " ;print_value instr ;Printf.printf " "; failwith "not yet implemened")
        

  | Int 1 -> 
    Printf.printf "\n--- set \n";
    (* Printf.printf "rib opnd\n";
    print_r (get_rib opnd); *)
    Printf.printf "\n";
    (* Printf.printf "rib stack\n";
    print_rib ram.(!sp); *)
    Printf.printf "\n";
    let x = tos() in 
    (* Printf.printf "tos %d \n" (get_int_triplet x);
    print_r (get_rib x);
    Printf.printf "\n"; *)

    (match opnd with
      Int i -> let lt = list_tail !sp i in
        let (car, cdr, tag) = ram.(get_int_triplet lt) in 
        Printf.printf "regarde1 ";
        print_r ram.(get_int_triplet lt); 
        Printf.printf "\n";
        if is_rib_w x then 
          (
        ram.(p+1) <- get_rib x;
        ram.(get_int_triplet lt) <- (Triplet (p+1), cdr, tag)
          )
        else
          (
            ram.(get_int_triplet lt) <- (x, cdr, tag)
          ) 
    | Triplet t -> let (car, cdr, tag) = ram.(t) in 
      Printf.printf "regarde2 ";print_r ram.(t); Printf.printf "\n";
      if is_rib_w x then 
        (
      ram.(p+1) <- get_rib x;
      ram.(t) <- (Triplet (p+1), cdr, tag)
        )
      else
        (
          ram.(t) <- (x, cdr, tag)
        ) ;
      Printf.printf "regarde3 %d " (p+1);print_r ram.(p+1); Printf.printf "\n";
    | _ -> invalid_arg "run");

    ignore(pop());
    Printf.printf "Printing la stack after le tes\n";
    print_r ram.(!sp);
    advance_pc();
    run(p+1)
  | Int 2 -> 
    Printf.printf "\n--- get\n";
    Printf.printf "rib opnd\n";
    print_value opnd;
    if is_rib_w opnd then (
      print_r (get_rib opnd);
    if is_rib_w (get_car (get_rib opnd)) then
      print_r ram.(get_int_triplet (get_car (get_rib opnd)))
    else ();
    )
    else ();

    Printf.printf "\n";
    Printf.printf "rib stack\n";
    print_r ram.(!sp);
    Printf.printf "\nokokokokoko 899868\n";
    if is_rib_w (get_cdr_triplet (Triplet !sp)) then
      print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp)))
    else ();
    if is_rib_w (get_car_triplet (Triplet !sp)) then
      print_r ram.(get_int_triplet (get_car_triplet (Triplet !sp)))
    else ();
    
    (* print_r ram.(get_(list_tail (!sp) (3))); *)
    Printf.printf "\n";


    let x = get_var opnd in
    Printf.printf "\n899872 :";
    print_r ram.(899872);
    
    (* Printf.printf "get_opnd %d \n" (get_int_triplet x); *)
    (* print_r ram.(get_int_triplet x); *)
    Printf.printf "\n value de x : ";
    print_value x;
    Printf.printf "\n185 :";
    print_r ram.(185);

    (* print_r ram.(54); *)
    (* ;
    print_r ram.(get_int_triplet (get_cdr_triplet_sym (Triplet 54))); *)
    (* Printf.printf "\n";
    Printf.printf "Triplet 53\n";
    (* print_r ram.(53); *)
    Printf.printf "Triplet 48\n"; *)
    (* print_r ram.(48); *)
    push2_stack_word x (Int 0);
    Printf.printf "rib stack teg\n";
    print_r ram.(!sp);
    Printf.printf "\n";
    Printf.printf " cdr";
    if is_rib_w (get_cdr_triplet (Triplet !sp)) then(
      print_r ram.(get_int_triplet (get_cdr_triplet (Triplet !sp)));
      if is_rib_w (get_cdr_triplet (get_cdr_triplet(Triplet !sp))) then(
        print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))));
        if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))) then(
          print_r ram.(get_int_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp)))));
          if is_rib_w (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))) then(
            print_r ram.(get_int_triplet(get_cdr_triplet (get_cdr_triplet (get_cdr_triplet (get_cdr_triplet(Triplet !sp))))));
          
          )
          
        else ();
        )
          
        else ();
      )
        
      else ();
      
      );
      
    Printf.printf "\n";
    advance_pc();
    run(p)
  | Int 4 -> 
    Printf.printf "--- IF\n";
    Printf.printf "rib stack\n";
    print_r ram.(!sp);
    Printf.printf "\nrib pc\n";
    print_r ram.(!pc);
    Printf.printf "\n";
    let tos = pop() in Printf.printf "op\n";
    print_value tos;
    Printf.printf "\n GET RIB TOS\n";
    (* print_rib (get_rib tos); *)
    print_value tos;
    Printf.printf "\n";
    if is_rib_w tos then 
      (
    Printf.printf "is rib\n";
        print_rib (get_rib tos);
        Printf.printf "\n";
    if (rib_eq (get_rib tos) (get_rib(Triplet 3))) then 
      (Printf.printf "\nfalse\n";
      pc := get_int_triplet (get_tag_triplet (Triplet !pc)))
    else
      (Printf.printf "\ntrue\n";
      pc := get_int_triplet (get_cdr_triplet (Triplet !pc)));
    
      )
    else 
      ((Printf.printf "\ntrue\n";
      pc := get_int_triplet (get_cdr_triplet (Triplet !pc)));
    );
    run(p)

  | Int 5 -> 
    Printf.printf "--- HALT\n";
    Printf.printf "stack final ";
    print_r ram.(!sp);
    Printf.printf "\n";
    Printf.printf "pc final ";
    print_r ram.(!pc);
    Printf.printf "\n";


  | _ -> failwith "not yet implemented in run "

let set_global (value:word) = 
  let car = get_car_triplet_s (Triplet !stbl) in
  let (_, cdr, tag) = ram.(get_int_triplet car) in
  ram.(get_int_triplet car) <- (value, cdr, tag);
  stbl := get_int_triplet (get_cdr_triplet (Triplet !stbl))

;;
(* cloture *)
push_symtbl nil_rib;

push_symtbl nil_rib;
push_symtbl nil_rib;
push_symtbl (Triplet 1, Triplet 2, Int singleton_type);
Printf.printf("build symtbl\n");;
build_symtbl ();; 
Printf.printf("end build symtbl\n");;

ram;;
!st;;
!stbl;;


Printf.printf "\n";;
ram.(0)<- (make_rib (Int 0) (Triplet !stbl) (Int 1));;
pc := !stbl;;
Printf.printf "\nsymtbl avant\n";;
print_rib ram.(!stbl);;
Printf.printf "\n";;

Printf.printf("decode\n");;

decode();;
Printf.printf("end decode\n");;

Printf.printf "\nle pc  %d\n" !pc;;
(* print_rib ram.(!pc);; *)
Printf.printf "\nhuh\n";;
print_r ram.(!pc);;




Printf.printf "\n";;
set_global (Triplet 0);;
set_global (Triplet 3);;
set_global (Triplet 1);;
set_global (Triplet 2);;
(* Printf.printf "\nsymtbl apres\n";;
print_rib ram.(!stbl);; *)

let (car, cdr, tag) = ram.(0) in ram.(0) <- (car, (Triplet !stbl), tag);;

Printf.printf "\n";;

Printf.printf "\nle pc apres %d\n" !pc;;
(* print_rib ram.(!pc);; *)

Printf.printf "\n";;

print_r ram.(0);;
Printf.printf "huh\n";;
print_r ram.(!sp);;
Printf.printf "\n";;
Printf.printf "stbl %d\n" !stbl;;

Printf.printf "stack at %d\n" !sp;;
print_r ram.(!sp);;
ram.(!sp) <- (Int 5, Int 0, Int 0);;
ram.(!sp-1) <- (Int 0, Int 0, Triplet !sp);;
sp := !sp - 1;;
Printf.printf "stack is %d\n" !sp;;
print_rib ram.(!sp);;
Printf.printf "\n";;


run(!pc);;

