(* (+ 8 9) *)
let input = "#rahctup,+,!tes-1dleif,1gra,,,,bir;*lu>m@mts>m?mki#!':nlkm!(:nlku!):nlkv1!*:nlkv6{"
                                                                                                             
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

let size_ram = 50000
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


let rib_eq (a:rib) (b:rib) : bool = 
  let (a1, a2, a3) = a in 
  let (b1, b2, b3) = b in 
  a1 = b1 && a2 = b2 && a3 = b3
let word_eqv (a:word) (b:word) : bool = a = b

let get_car (rib : rib) : word= match rib with 
    (car, _,_ ) -> car

let set_car (rib : rib) (w : word) = 
  match rib with
  | (car, cdr, tag) -> (w, cdr, tag)



let set_car_triplet (rib : word) (newval:word) = 
  match rib with 
  | Triplet i -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag)
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
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, newval, tag)
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
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, cdr, newval)
  | _ -> invalid_arg "set cdr triplet expected a triplet"


let make_rib_of_ints a b c = (Int a, Int b, Int c)                (* primitive (rib a b c) *)

let false_rib : rib = make_rib_of_ints 0 0 5
let true_rib : rib = make_rib_of_ints 0 0 5
let nil_rib : rib = make_rib_of_ints 0 0 5

let tos  = function () -> get_car ram.(!sp)
let get_int_triplet (x : word) = 
  match x with 
    Triplet i -> i 
  |_ -> invalid_arg "expected a triplet 1" 
let get_rib (r : word ) : rib =
  match r with 
  | Triplet i -> ram.(i)
  | _ -> invalid_arg "get_rib expected a triplet"
let pop ()  =
  let x = get_car ram.(!sp) in 
  if is_rib_w (get_cdr ram.(!sp)) then
    sp := get_int_triplet (get_cdr ram.(!sp))
  else
    ram.(!sp) <- (Nil, get_cdr ram.(!sp),  get_tag ram.(!sp)); 
  x 
  
let popr () = 
  let x = pop() in get_rib x

  
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
    invalid_arg "stack overflow"
    (* gc *)


let push_word (car : word) : unit =
  let i = !sp in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then (ram.(i-1) <- (car, Int 0, Int pair_type); sp := !sp-1) else
      (ram.(i-1) <- (car, Triplet (i), Int pair_type); sp := i-1)
  else
    invalid_arg "stack overflow"
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
  

let to_bool = function true -> true_rib | false -> false_rib

let getchar () =
  try
    input_char stdin |> int_of_char
  with End_of_file -> -1

let putchar c =
  char_of_int c |> print_char;
  flush stdout;
  c

let close () =
  let tos = popr () in
  let x = get_car tos in
  let y = get_cdr ram.(!sp) in
  let close = make_rib x y (Int procedure_type) in push_rib close

let prim1_fields f = function () ->
  let x = popr () in
  let y = f x in
  push_word y

let prim2_fields f = function () ->
  let x = pop () in
  let y = popr () in
  f x y |>
  push_rib

let prim2_bool f = function () ->
  let y = pop () in
  let x = pop () in
  f x y |> to_bool |> push_rib

let primitives = [|
(* @@(primitives (gen body) *)
  prim3 (fun z y x -> make_rib x y z);                                    (* @@(primitive (rib a b c))@@ *)
  prim1_word(function x -> x);                                                (* @@(primitive (id x))@@ *)
  (function () -> pop () |> ignore);                                      (* @@(primitive (arg1 x y))@@ *)
  prim2 (fun y x -> y);                                                   (* @@(primitive (arg2 x y))@@ *)
  close;          (* @@(primitive (close rib))@@ *)
  prim1_rib (function Triplet _ -> true_rib | _ -> false_rib);                    (* @@(primitive (rib? rib) (use bool2scm))@@ *)
  prim1_fields get_car ;                                                          (* @@(primitive (field0 rib))@@ *)
  prim1_fields get_cdr;                                                          (* @@(primitive (field1 rib))@@ *)
  prim1_fields get_tag;                                                          (* @@(primitive (field2 rib))@@ *)
  prim2_fields (fun y x -> set_car x y);                                      (* @@(primitive (field0-set! rib))@@ *)
  prim2_fields (fun y x -> set_cdr x y);                                      (* @@(primitive (field1-set! rib))@@ *)
  prim2_fields (fun y x -> set_tag x y);                                      (* @@(primitive (field2-set! rib))@@ *)
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
               

           
let print_value (v : word) : unit =
  match v with
  | Int i -> Printf.printf "Int %d" i
  | Triplet t -> Printf.printf "Triplet %d " t;
  | Nil -> Printf.printf "Nil"   

let rec list_tail (ptr:int) i =
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
  let i = !st in
  if i < alloc_limit then
    (* premier elemn de stack *)
    if i = -1 then 
      (ram.(i+1) <- rib;
       st := i+1) 
    else(
      ram.(i+1) <- rib;
      st := i+1) 
  else
    invalid_arg "stack overflow"
    (* gc *)

let create_sym (i:int)= 
  (* rib *list = alloc_rib(name, lst_length(name), STRING_TAG); *)
  let len = length ram.(i) in
  
  let x = i_accum !st !stbl in 

  push_symtbl_rib (make_rib (Triplet i) (Int len) (Int string_type));

  (* rib *sym = alloc_rib(FALSE, TAG_RIB(list), SYMBOL_TAG); *)
  push2_symtbl_word (Triplet 3) (Int symbol_type);

  (* rib *root = alloc_rib(TAG_RIB(sym), symbol_table, PAIR_TAG); *)
  push_word_stbl (Triplet (x+2)) 
      

let push_symtbl_word_accum (car: word) (cdr:word) =
  Printf.printf "\n%d\n" !stbl;
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
    invalid_arg "stack overflow"
    (* gc *)
    
let build_symtbl () : unit =

  (* Caraceres de fin de chaine *)
  push_symtbl nil_rib;

  let rec loop1 n :unit =
    if 0 < n then 
      ( push_symtbl nil_rib;
        create_sym(!st);
        loop1 (n-1)) 
    else 
      (* i = index dans la symtbl du premier caractere de la liste des symboles *)
      let rec loop3 (i:int) = 
        Printf.printf"in"; 
        (* récupère le byte *)
        let x = get_byte () in 
        Printf.printf "\n hello %c\n" (char_of_int x);
        (* on a ',' séparation des symboles *)
        if x = 44 then ( create_sym(i); loop3(!st)) else
        (* ';' Fin de la liste des symboles *)
        if x=59 then 
          ( create_sym(i)
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
  if i > alloc_limit then
      (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- (w, Int 0, tag);
       sp := i-1) 
    else(
      ram.(i-1) <- (w, Triplet (i), tag);
      sp := i-1) 
  else
    invalid_arg "stack overflow"
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
    invalid_arg "stack overflow"
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
    invalid_arg "stack overflow"
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
    invalid_arg "stack overflow"
    (* gc *)


let push_heap_r (rib : rib) : unit =
  let i = !pc in
  if i < size_ram then
    (* premier elemn de stack *)
    (ram.(i+1) <- rib;
     pc := i+1) 
  else
    invalid_arg "stack overflow"
    (* gc *)
    
let print_value (v : word) : unit =
  match v with
  | Int i -> Printf.printf "Int %d" i
  | Triplet t -> Printf.printf "Triplet %d " t;
  | Nil -> Printf.printf "Nil"     
let print_r (ri:rib) :unit= 
  match ri with 
    (car, cdr, tag) -> (
      Printf.printf "\n car : ";print_value car ; 
      Printf.printf " cdr : "; print_value cdr;
      Printf.printf " tag : "; print_value tag;
      Printf.printf " FINIIINININ \n")
let get_cdr_triplet_sym (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v2
  | _ -> invalid_arg "get_cdr_triplet_sym expected a triplet"


(*problem to be fixed*)
let push_heap_ribs (rib : word) : unit =
  let i = !pc in
  if i < size_ram then
    (let (car, cdr, tag) = ( ((ram.(get_int_triplet rib)))) in
     let len= int_val (get_cdr_triplet_sym (get_cdr_triplet_sym rib)) in 
     if is_rib_w (cdr) then 
       (
        (*nil rib fin de chaine*)
        (*ram.(i+1) <- nil_rib;*)
       (* list *)
         ram.(i+len+3) <-(Triplet 3, Triplet (i+len+2), Int 2); 
         let (car1, cdr1, tag1) = (ram.(get_int_triplet cdr)) in
        (* sym *)
      (* sym *)
         ram.(i+len+2) <- ( Triplet (len+i+1), cdr1, tag1);  
       
         let rec push_lst (lst : word) (i:int) :unit= 
         (* push la liste accum *)
           let p = !pc in 
           let r = ram.(get_int_triplet lst) in
          
           match r with 
             (Int 0, Int 0, Int 5) -> ram.(p+i+1) <- r
           | (a, Triplet t , Int 0) ->  ram.(p+i+1) <- (a, Triplet (p+i), Int 0) ; push_lst (get_cdr_triplet_sym lst) (i-1)
           | _ -> Printf.printf "ignore\n"
         in
       (* - 2 pour list et sym de createe_sym *)
         push_lst (get_car_triplet_s (get_cdr_triplet_sym rib)) (len));
     pc := i + len +3;
      
    )
  else
    invalid_arg "stack overflow"
   (* gc *)


let push_heap_r (rib : rib) : unit =
  let i = !pc in
  if i < size_ram then
    (* premier elemn de stack *)
    if i = -1 then 
      (ram.(i+1) <- rib;
       pc := i+1) 
    else(
      ram.(i+1) <- rib;
      pc := i+1) 
  else
    invalid_arg "stack overflow"
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
      let (rc, rcdr, rt) = rib in 
      ram.(i) <- (rc, rcdr, rt);
      ram.(i-1) <- (Triplet (i), cdr, tag);
      sp := i-1;

    )
      
  else
    invalid_arg "stack overflow"
    (* gc *) 

let decode = function () ->(

  (* Graphe d'instruction *)
    let rec decode_loop () : word = 
      let sym (n:int) = 

        let l = (list_tail (!stbl) (n))in
        
        let car = get_car_triplet_s l in 

        if is_rib_w car then
          (push_heap_ribs (car); 
           (Triplet !pc))
        else
          (push_heap_word car; 
           (Triplet !pc))
      in
      
      let add_instruction (op:int) (opnd :word) =
    (* TODO *)
    (* (_set-car! stack (_rib op opnd (_car stack))) *)

        let x = make_rib (Int op) opnd (tos()) in
        ignore(pop());

      
        push_stack_car x;

        decode_loop ()
      in
    (* calcul opnd *)
      let calcul_opnd (n:int) (d:int) (op:int) :word= 
        if (n< d) then 
          
          (
          
            if op <3 then 
              (sym n) 
            else 

              (Int n))
        else
        if n = d then (  Int (get_int 0)) else
          sym (get_int ((n-d)-1))

      
      in



      let x = get_code () in

      let rec loop (op:int) (n:word) = 
        
        let d = codes.(op) 
                  
        in
        
        if (d+2) < (int_val n) then
          (loop (op + 1) (Int ((int_val n)-(d+3))))

        else
        if 90 < x then (*if *)(

          let n= pop()in 
          add_instruction 4 n)
        else 
          (          
            (* jump ou call *)
            if op = 0 then (  

              push2_stack_word (Int 0) (Int 0) 
            )else (Printf.printf "\n op !=0 \n");
            let opnd = calcul_opnd (int_val n) d (op) in

            if 4 < op then
              (

                
                let p = pop() in 
                
                
                push_heap_r (make_rib opnd (Int 0) (p)) ;
                

        
                push_heap_r nil_rib;
                push_heap_r (make_rib (Triplet (!pc-1)) (Triplet !pc) (Int procedure_type));
                
                if ram.(!sp) = (Nil, Int 0, Int 0) then
                  (
                    Triplet !pc)
                else (

                  add_instruction (instr_const) (Triplet !pc))
              )
            else
            if (0<op) then
              (
              
                add_instruction (op-1) opnd)
            else
              (

                add_instruction (0) opnd)
          ) 
      
      in 

      loop (0) (Int x)
    in
    let main_proc = decode_loop() in 
    

    let d = (get_car_triplet main_proc) in  let f = get_tag_triplet d in 
    pc := get_int_triplet f

  )




let get_cont  = function () ->
  let rec loop (i:int) : word =
    match get_tag ram.(i) with
    | Int _ -> Triplet i
    | Triplet t -> 
        (match get_cdr ram.(i) with 
         | Int n -> Int n
         | Triplet t -> loop (get_int_triplet (get_cdr ram.(i)))
         | _ -> invalid_arg "get_cont 1")
    | _ -> invalid_arg "get_cont 2"
  in loop !sp

let get_opnd opnd = 
  match opnd with
  | Int n -> list_tail (!sp) n
  | Triplet t -> (get_car_triplet opnd)
  | _ -> invalid_arg "get_opnd"
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
  | Int i -> if i!= 0 then Printf.printf "stack[] empty\n" else Printf.printf "cheh\n"
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

let advance_pc = function () -> 
  let tag = get_tag ram.(!pc) in
  match tag with 
  | Int i -> pc := -1; Printf.printf "\neuh tag est un int \n"
  | Triplet t -> pc := get_int_triplet tag
  | _ -> invalid_arg "advance_pc"

let show_opnd opnd = 
  match opnd with 
  | Int i -> Printf.printf "\nopnd = Int %d" i
  | Triplet t -> let (car, cdr, tag) = ram.(t) in 
      if tag = Int 2 then (Printf.printf "\n sym : "; print_rib ram.(t); Printf.printf "\n") else
        Printf.printf "Triplet %d sus" t
  | _ -> invalid_arg "show_opnd"


(* Decodage de la RVM *)
let rec run = function () -> 
  Printf.printf "\ntest\n" ;
  let instr = get_car_triplet (Triplet !pc)
  and opnd = get_cdr_triplet (Triplet !pc)
  and next = get_tag_triplet (Triplet !pc)  
  in 
  Printf.printf "\ninstr\n";
  print_value instr;
  Printf.printf "\ninstr\n";
  print_value opnd;
  Printf.printf "\ninstr\n";
  print_value next;
  
  (* match instr with *)
  match instr with 
  | Int 3 -> 
      Printf.printf "--- const ";
      print_value opnd;
      Printf.printf "\ngenre la \n";
      show_stack();
      Printf.printf "ok bro\n";
      Printf.printf "Printing la stack before\n";
      print_rib ram.(!sp);
      Printf.printf "\n";
      push2_stack_word opnd (Int 0);
      Printf.printf "Printing la stack after\n";
      print_rib ram.(!sp);
      Printf.printf "\n";
      Printf.printf "pc1\n";
      print_rib ram.(!pc);
      Printf.printf "\n";
      advance_pc();
      Printf.printf "pc2\n";
      print_rib ram.(!pc);
      Printf.printf "\n";
      run()
  | Int 0 -> 
      if next = Int 0 then Printf.printf "--- jump\n" else
        (Printf.printf "--- call\n";
         let proc = get_opnd opnd in
         Printf.printf "proc : \n";
         show_opnd proc;
         print_r ram.(get_int_triplet proc);
         print_rib ram.(get_int_triplet proc);
         Printf.printf "\n";
        )
  | _ -> failwith "not yet implemented in run "

let set_global (value:word) = 
  let car = get_car_triplet_s (Triplet !stbl) in
  let (_, cdr, tag) = ram.(get_int_triplet car) in
  ram.(get_int_triplet car) <- (value, cdr, tag);

;;
(* cloture *)
push_symtbl nil_rib;

push_symtbl nil_rib;
push_symtbl nil_rib;
push_symtbl (Triplet 1, Triplet 2, Int singleton_type);

build_symtbl ();; 
ram;;
!st;;
!stbl;;


(* Printf.printf "\nhello\n";;
print_rib ram.(!stbl);;

Printf.printf "\n";; *)

push_heap_r (make_rib (Int 0) (Triplet !stbl) (Int 1));;
pc := !stbl+1;;


decode();;
(* Printf.printf "\nle pc  %d\n" !pc;;
print_rib ram.(!pc);;

Printf.printf "\n";; *)
