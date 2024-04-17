(* RVM code that prints HELLO! *)
(* @@(replace ");'u?>vD?>vRD?>vRA?>vRA?>vR:?>vR=!(:lkm!':lkv6y" (encode 92) @@ *)
let input = ");'u?>vD?>vRD?>vRA?>vRA?>vR:?>vR=!(:lkm!':lkv6y";;
(* )@@ *)

Printf.printf "input :\n%s\n" input;;



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

(* accumulateur de la string d'un symbole du bytecode*)
let st = ref (-1)
let stbl = ref (-1)
let pos = ref 0

(* derniere case de la zone memoire occupé par la pile *)
let spr  = ref !sp




let make_rib (a:word) (b:word) (c: word) : rib = (a, b, c)

let is_rib_w (r:word) : bool = match r with 
  | Triplet _ -> true 
  | _ -> false

let int_val (n : word) = 
  match n with 
  | Int i -> i
  | _ -> invalid_arg "expected an Integer"
 
let rib_eq (a:rib) (b:rib) : bool = 
  let (a1, a2, a3) = a in 
  let (b1, b2, b3) = b in 
  a1 = b1 && a2 = b2 && a3 = b3

let get_int_triplet (x : word) = 
  match x with 
    Triplet i -> i 
  |_ -> invalid_arg "expected a triplet get_int_triplet" 
let get_rib (r : word ) : rib =
  match r with 
  | Triplet i -> ram.(i)
  | _ -> invalid_arg "get_rib expected a triplet"
  
  
let word_eqv (a:word) (b:word) : bool = 
  match a, b with
  | Int i, Int j -> i = j
  | Triplet i, Triplet j -> rib_eq (get_rib (Triplet i)) (get_rib (Triplet j))
  | _, _ -> false
  
let get_car (rib : rib) : word= match rib with 
    (car, _,_ ) -> car

let set_car_triplet (rib : word) (newval:word) = 
  match rib with 
  | Triplet i -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag); newval
  | _ -> invalid_arg "set car triplet expected a triplet"
let get_car_triplet (rib : word) : word =
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v1
  | _ -> invalid_arg "get_car_triplet expected a triplet"


let get_cdr (rib : rib) : word= match rib with 
    (_, cdr,_ ) -> cdr

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


let to_bool = function true -> Triplet 2 | false -> Triplet 3
let getchar () =
  try
    input_char stdin |> int_of_char
  with End_of_file -> -1

let putchar c =
  (Printf.printf "putchar %d " c;
  char_of_int c |> print_char;
  flush stdout;
  c)

let tos  = function () -> get_car ram.(!sp)

let close () =
  let tos = tos() in
  let x = get_car_triplet tos in
  let y = get_cdr ram.(!sp) in
  let (car, cdr, tag) = ram.(!sp)
  in
   ram.(!sp) <- (x, y, Int 1);
   ram.(!sp-1) <- (Triplet !sp,cdr, tag);
    sp := !sp - 1
  

let false_rib : rib = make_rib (Int 0) (Int 0) (Int 5)
let true_rib : rib = make_rib (Int 0) (Int 0) (Int 5)
let nil_rib : rib = make_rib (Int 0) (Int 0) (Int 5)




let pop ()  =
  let x = get_car ram.(!sp) in 
  (if is_rib_w (get_cdr ram.(!sp)) then
    sp := get_int_triplet (get_cdr ram.(!sp))
  else
    (ram.(!spr-1) <- (Nil, get_cdr ram.(!sp),  get_tag ram.(!sp));
    sp := !spr-1;
    spr := !spr - 1
    )
  );
  x 

let push_rib(rib : rib) : unit =
  let i = !spr in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then 
      (ram.(i-1) <- rib;
       sp := i-1;
       spr := i-1) 
    else(
      ram.(i-1) <- rib;
      ram.(i-2) <- (Triplet (i-1), Triplet !sp, Int pair_type); 
      sp := i-2;
      spr := i-2) 
  else
    invalid_arg "stack overflow push_rib"
    (* gc *)


let push_word (car : word) : unit =
  let i = !spr in
  if i > alloc_limit then
    (* premier elemn de stack *)
    if i = size_ram then 
      (* Int 0 car la stack = Int 0 au début *)
      (ram.(i-1) <- (car, Int 0, Int pair_type); 
      sp := !sp-1;
      spr := i-1) 
    else
      (ram.(i-1) <- (car, Triplet (!sp), Int pair_type); 
      sp := i-1;
      spr := i-1)
  else
    invalid_arg "stack overflow push_word"
    (* gc *)

(* Déclaration des primitives *)

let prim0 f = function () -> f () |> push_word

let prim1 f = function () -> 
  pop () |> f |> push_word


let prim2 f = function () ->
  let x = pop () in
  let y = pop () in
  f x y |> push_word


let prim3 f = function () ->
  let x = pop () in
  let y = pop () in
  let z = pop () in
  f x y z |> push_rib
  

let prim2_bool f = function () ->
  let x = pop () in
  let y = pop () in
  f x y |> to_bool |> push_word

let primitives = [|
(* @@(primitives (gen body) *)
  prim3 (fun z y x -> make_rib x y z);                                    (* @@(primitive (rib a b c))@@ *)
  prim1 (function x -> x);                                                (* @@(primitive (id x))@@ *)
  (function () -> pop () |> ignore);                                      (* @@(primitive (arg1 x y))@@ *)
  prim2 (fun y x -> y);                                                   (* @@(primitive (arg2 x y))@@ *)
  close;                                                                  (* @@(primitive (close rib))@@ *)
  prim1 (function Triplet _ -> Triplet 2 | _ -> Triplet 3);                    (* @@(primitive (rib? rib) (use bool2scm))@@ *)
  prim1 get_car_triplet ;                                                          (* @@(primitive (field0 rib))@@ *)
  prim1 get_cdr_triplet;                                                          (* @@(primitive (field1 rib))@@ *)
  prim1 get_tag_triplet;                                                          (* @@(primitive (field2 rib))@@ *)
  prim2 (fun y x -> set_car_triplet x y);                                      (* @@(primitive (field0-set! rib))@@ *)
  prim2 (fun y x -> set_cdr_triplet x y);                                      (* @@(primitive (field1-set! rib))@@ *)
  prim2 (fun y x -> set_tag_triplet x y);                                      (* @@(primitive (field2-set! rib))@@ *)
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
  prim1 (function Int ch -> Int (putchar ch) | _ -> invalid_arg "putchar argument must be Int");  (* @@(primitive (putchar x))@@ *)
  prim1 (function Int status -> exit status | _ -> invalid_arg "exit argument must be Int")           (* @@(primitive (exit x))@@ *)
(*  )@@ *)
|]



(* Cette fonction récursive retourne le pointeur vers la i-ème cellule de la liste chaînée, 
   à partir du pointeur initial ptr. *)
let rec list_tail (ptr:int) i =
  if 0 = i then 
    Triplet ptr
  else
    (if is_rib_w (get_cdr (ram.(ptr))) then
       let (car, cdr, tag) = ram.(ptr) in
       list_tail (get_int_triplet (cdr )) (i-1)
     else
        invalid_arg "list_tail")

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
  | ( _, _, Int 0) -> true
  | _ -> false

let not_nil_cdr (w : word)  =
  match w with 
    Nil -> false
  | _ -> true

let i_accum stbl st = if st > stbl then st else stbl     

let push_symtbl_rib (rib : rib) :unit =
  let i = i_accum !st !stbl in
  if i < size_ram then
    (ram.(i+1) <- rib)
  else
    invalid_arg "stack overflow push_symtbl_rib"
    (* gc *)

let push2_symtbl_word (car : word)(tag : word) : unit =
  let i = i_accum !st !stbl in
  if i < alloc_limit then
    (* premier elemn de stack *)
    if i = -1 then (ram.(i+2) <- (car, Int 0, tag)) else
      (ram.(i+2) <- (car, Triplet (i+1), tag))
  else
    invalid_arg "stack overflow push2_symtbl_word"
    (* gc *)

let push_word_stbl (car : word) : unit =
  let i = (get_int_triplet car) in
  if i < alloc_limit then
    
    (* premier elemn de stack *)
    if !stbl = -1 then ( (ram.(i+1) <- (car, Int 0, Int pair_type); stbl := i+1) )else
      (ram.(i+1) <- (car, Triplet (!stbl), Int pair_type); stbl := i+1)
  else
    invalid_arg "stack overflow push_word_stbl "
    (* gc *)


(* debug, affiche la string d'un symbole *)
let rec chars2str(lst : rib) : unit =
  if is_pair lst && not_nil_cdr (get_cdr lst) then
    if is_rib_w (get_cdr lst) then
      (let next = get_cdr lst in
       chars2str (get_rib next))
    else
      (let c = get_car lst in
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
      | Triplet i -> aux (get_rib (Triplet i)) (acc + 1)
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
    invalid_arg "stack overflow push_symtbl"
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
    (
      ram.(i+1) <- (car, cdr, Int pair_type);
      st := i+1)
  else
    invalid_arg "stack overflow push_symtbl_word_accum"
    (* gc *)
    

(* debug *)

let print_value (v : word) : unit =
  match v with
  | Int i -> Printf.printf "Int %d" i
  | Triplet t -> Printf.printf "Triplet %d " t;
  | Nil -> Printf.printf "Nil"  

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
                  
let print_value (v : word) : unit =
  match v with
  | Int i -> Printf.printf "Int %d" i
  | Triplet t -> Printf.printf "Triplet %d " t;
  | Nil -> Printf.printf "Nil"   
  
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
  
(* debug *)
let build_symtbl () : unit =

  (* Caractere de fin de chaine *)
  push_symtbl nil_rib;

  let rec loop1 n :unit =
    if 0 < n then 
      ( 
        push_symtbl nil_rib;
        create_sym(!st);
        loop1 (n-1)) 
    else 
      (* i = index dans la symtbl du premier caractere de la liste des symboles *)
      let rec loop3 (i:int) = 
        let x = get_byte () in 
        (* on a ',' séparation des symboles *)
        if x = 44 then ( 
          create_sym(i); 
          loop3(!st)) else
        (* ';' Fin de la liste des symboles *)
        if x=59 then 
          create_sym(i)
        else(
          push_symtbl_word_accum (Int x) (Triplet (i)); 
          loop3 (!st))
      in
      loop3 (!st)
  in
  let n = get_int 0 in (
    loop1 n)
  
let set_global (value:rib) = (
  push_symtbl_rib value;
  set_car_triplet (get_car_triplet (Triplet !stbl)) (Triplet !st);)
    

let push_heap_r (rib : rib) : unit =
  let i = !pc in
  if i < size_ram then
    (* premier elemn de stack *)
    (ram.(i+1) <- rib;
     pc := i+1) 
  else
    invalid_arg "stack overflow push_heap_r"
    (* gc *)

let get_next_stack = function () ->
  if is_rib_w (get_cdr_triplet (Triplet !sp)) then
    sp := get_int_triplet (get_cdr_triplet (Triplet !sp))
  else
    (let (car, cdr, tag) = ram.(!sp) in 
    ram.(!spr-1) <- (Nil, cdr, tag);
    sp := !spr-1;
    spr := !spr-1)
    
(* si tag(rib) est un triplet, il faut aller le chercher et le copier depuis la stack *)
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
      invalid_arg "stack overflow push_heap_copy"
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
    invalid_arg "stack overflow push_heap_copy"
    (* gc *)

(* -- *)
let decode = function () ->(
  let codes = [| 20; 30; 0; 10; 11; 4 |]
  in
    let rec decode_loop () : word = 
      (* récupere le n-ième symbole *)
      let sym (n:int) = 
        let l = (list_tail (!stbl) (n))in
        let car = get_car_triplet l in 
        car
      in
      
      
      let add_instruction (op:int) (opnd :word) =
        let x = make_rib (Int op) opnd (tos()) in
        let (car, cdr, tag) = ram.(!sp) in 
        let i = !spr in 
        ram.(i-1) <- x;
        ram.(!sp) <- (Triplet(i-1), cdr, tag);
        spr := i-1;
        decode_loop ()
      in

    (* calcul opnd *)
      let calcul_opnd (n:int) (d:int) (op:int) :word= 
        if (n< d) then 
          (
            if op <3 then (
              sym n) 
            else (
              (Int n)))
        else
        if n = d then (
          Int (get_int 0)) 
        else
          (sym (get_int ((n-d)-1)))
      in

      let x = get_code () in

      let rec loop (op:int) (n:word) = 
        let d = codes.(op) 
        in
        if (d+2) < (int_val n) then
          ( 
            loop (op + 1) (Int ((int_val n)-(d+3))))
        else
        if 90 < x then (*if *)(
          let tos = tos() in
          get_next_stack();
          add_instruction (4) (tos))
        else 
          (  
            if op = 0 then (  
              (
              push_word (Int 0) ;
              )
              
            )else (
              );
            let opnd = calcul_opnd (int_val n) d (op) in

            if 4 < op then
              (
                let p = pop() in 
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
              if (0<op) then
                (
                  add_instruction (op-1) opnd)
              else
                (
                  add_instruction (0) opnd)
          ) )
      
      in 

      loop (0) (Int x)
    in
    let main_proc = decode_loop() in 
    

    let d = (get_car_triplet main_proc) in  let f = get_tag_triplet d in 
    pc := get_int_triplet f;

  )

let get_var opnd = 
  match opnd with 
  | Triplet _ -> get_car_triplet opnd
  | Int i -> get_car_triplet (list_tail !sp i)
  | _ -> invalid_arg "get_var"

let setup_stack = function () ->
  ram.(!sp) <- (Int 5, Int 0, Int 0);
  ram.(!sp-1) <- (Int 0, Int 0, Triplet !sp);
  sp := !sp - 1;
  spr := !sp


let advance_pc = function () -> 
  let tag = get_tag_triplet (Triplet !pc) in
  match tag with 
  | Int i -> pc := !stbl; Printf.printf "\ntag est un int \n"
  | Triplet t -> pc := get_int_triplet tag
  | _ -> invalid_arg "advance_pc"

let get_cont  = function () ->
  let rec loop (s:word) : word =
    match get_tag_triplet s with
    | Int x -> loop (get_cdr_triplet s)
    | Triplet t -> s
    | _ -> invalid_arg "get_cont 2"
  in loop (Triplet !sp)
  

(* Decodage de la RVM *)
let rec run (p : int) =  
  let build_rest rib = 
    let i = !spr in 
    ram.(i-1) <- rib; 
    spr := i-1 
  in 
  let instr = get_car_triplet (Triplet !pc)
  and opnd = get_cdr_triplet (Triplet !pc)
  and next = get_tag_triplet (Triplet !pc)  
  in 
  match instr with 
  | Int 3 -> 
      Printf.printf "--- const ";
      push_word opnd ;
      advance_pc();
      run p 
  | Int 0 -> 
      if next = Int 0 then 
        (Printf.printf "--- jump\n") 
      else(
        Printf.printf "--- call\n");

        let proc = get_var opnd in
        let code = get_car_triplet proc in 
        let (car, cdr, tag) = ram.(!sp) in
         (* @@(feature arity-check (use rest-param) *)
        let nargs = (int_val car) in
        get_next_stack();
        (* )@@ *)

        (match code with 
        | Int i -> (
          (* Calling a primitive *)
          primitives.(i) () ;
          
          if next = Int 0 then (
            (* jump *)
            pc := get_int_triplet (get_cont());
            let (car, cdr, tag) = ram.(!sp) in 
            ram.(!sp) <- (car, get_car_triplet (Triplet !pc), tag))
          ;
        
          advance_pc();
          run(p))
        | Triplet t -> (
          (* calling a lambda *)
          let nparams = (int_val (get_car_triplet code)) lsr 1 in
          (* besoin d'un endroit où la stocker car elle va etre modifié *)
          ram.(p+1) <- (Int nparams, Int 0, Int 0);
          
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
                  if 0<it then ( 
                      let (car, cdr, tag) = ram.(!sp) in
                      get_next_stack();
                      build_rest (car, rest, Int pair_type);
                      rest_loop (Triplet (!spr)) (it-1) 
                    )
                  else(
                      build_rest (rest, Triplet !sp, Int 0);
                      sp := !spr;
                      ram.(p+1) <- (Int (nparams+1), Int 0, Int 0);
                    ); 
                in
                build_rest nil_rib;
                rest_loop (Triplet (!spr)) (nargs-nparams);
              );
           (* )@@ *)

              let build_new_cont rib =
                let i = !spr in
                ram.(i-1) <- rib;
                spr := i-1 in 

              (* +1 pour la case reserver pour nparams *)
              let np = (p+1) in

              let new_cont = make_rib (Int 0) (proc) (Int 0) in
              build_new_cont new_cont;
              (* on garde le pointeur vers new-cont *)
              let nc = !spr in

              let rec loop nparams new_stack= 
                if 0 < nparams then 
                  (
                    let (car, cdr, tag) = ram.(!sp) in
                    get_next_stack();
                    build_new_cont (car, new_stack, Int 0);
                    loop (nparams-1) (Triplet (!spr)))
                else
                  (
                    (* non-tail call ? *)
                    if is_rib_w next then (
                        (* call *)
                        let (car, cdr, tag) = ram.(nc) in 
                        ram.(nc) <- ((Triplet !sp), cdr, next);
                      ) 
                    else (
                      (* jump *)
                      let k = get_cont() in
                      let (car, cdr, tag) = ram.(nc) in
                      ram.(nc) <- ((get_car_triplet k), cdr, (get_tag_triplet k));
                    );
                    pc := get_int_triplet (get_tag_triplet (code));
                    sp := get_int_triplet (new_stack);
                    run(np);
                  );
                in
                let nparams = int_val (get_car_triplet (Triplet (p+1))) in
                loop nparams (Triplet (nc));          
          )
        
        | _ -> invalid_arg "run")
        

  | Int 1 -> 
    Printf.printf "\n--- set \n";

    let x = tos() in 

    (match opnd with
      Int i -> 
        let lt = list_tail !sp i in
        let (car, cdr, tag) = ram.(get_int_triplet lt) in 
          ram.(get_int_triplet lt) <- (x, cdr, tag)
    | Triplet t -> let (car, cdr, tag) = ram.(t) in 
        ram.(t) <- (x, cdr, tag);  
    | _ -> invalid_arg "set_var");

    get_next_stack();
    advance_pc();
    run(p)
  | Int 2 -> 
    Printf.printf "--- get\n";
    let x = get_var opnd in
    push_word x;
    advance_pc();
    run(p)
  | Int 4 -> 
    Printf.printf "--- if\n";
    let tos = tos() in
    if (word_eqv tos (Triplet 3)) then
        advance_pc()
      else (
        pc := get_int_triplet (opnd));
    get_next_stack();
    run(p)

  | Int 5 -> 
    Printf.printf "--- HALT\n";

  | _ -> failwith "not yet implemented in run "

let set_global (value:word) = 
  let car = get_car_triplet (Triplet !stbl) in
  let (_, cdr, tag) = ram.(get_int_triplet car) in
  ram.(get_int_triplet car) <- (value, cdr, tag);
  stbl := get_int_triplet (get_cdr_triplet (Triplet !stbl))

;;

(* set predefined globals (always 4 first in the symbol table) *)

ram.(0) <- nil_rib; (*rib  = primitive 0*)

ram.(1) <- nil_rib; (* nil = () *)
ram.(2) <- nil_rib; (* true = #t *)
ram.(3) <- (Triplet 1, Triplet 2, Int singleton_type); (* false = #f *)

stbl := 3;;

build_symtbl ();; 

ram.(0)<- (make_rib (Int 0) (Triplet !stbl) (Int 1));;

(* graphe d'instruction apres la table des symboles *)
pc := !stbl;;

decode();;

set_global (Triplet 0);;
set_global (Triplet 3);;
set_global (Triplet 1);;
set_global (Triplet 2);;

(* le pointeur de !stbl a été changé apres l'appel a set_global *)
let (car, cdr, tag) = ram.(0) in ram.(0) <- (car, (Triplet !stbl), tag);;

setup_stack();;

run(!pc);;

