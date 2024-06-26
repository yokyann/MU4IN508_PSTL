(* RVM code that prints HELLO! *)
(* @@(replace ");'u?>vD?>vRD?>vRA?>vRA?>vR:?>vR=!(:lkm!':lkv6y" (encode 92) @@ *)
let input = ");'u?>vD?>vRD?>vRA?>vRA?>vR:?>vR=!(:lkm!':lkv6y";;
(* )@@ *)


(* modifié à true pour afficher les etapes de l'interprétation *)
let debug = ref false

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

(* choix d'un nombre assez grand car nous n'avons pas implémenté de GC *)
let size_ram = 900000

(* la mémoire : tableau de rib*)
let ram : ram = Array.make size_ram (Nil, Nil, Nil)
(* indice vers le flux d'instruction *)
let pc = ref (-1)
(* indice vers le sommet de pile *)
let sp = ref size_ram
(* heap pointer*)
let hp = ref (-1)

(* indice vers la table des symboles *)
let stbl = ref (-1)
let pos = ref 0

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
  if c = 0 then Printf.printf "0"
    else
  char_of_int c |> print_char;
  flush stdout;
  c

let tos  = function () -> get_car ram.(!sp)

let push_heap rib = 
  let i = !hp in 
  ram.(i-1) <- rib; 
  hp := i-1 

let push_word (car : word) : unit =
  if word_eqv (Triplet (!hp-1)) (get_car ram.(1))  then
    invalid_arg "stack overflow push_word"
  else
    if !hp = size_ram then 
      (* Int 0 car la stack = Int 0 au début *)
      (ram.(!hp-1) <- (car, Int 0, Int pair_type); 
      hp := !hp-1;
      sp := !hp) 
    else
      (ram.(!hp-1) <- (car, Triplet (!sp), Int pair_type); 
      hp := !hp-1;
      sp := !hp)


let push_rib(rib : rib) : unit =
  (* gc *)
  if word_eqv (Triplet (!hp-1)) (get_car ram.(1))  then
    invalid_arg "stack overflow push_rib"
  else
    (* premier elemn de stack *)
    if !hp = size_ram then 
      (ram.(!hp-1) <- rib;
      hp := !hp -1;
      sp := !hp) 
    else(
      ram.(!hp-1) <- rib;
      hp := !hp -1;
      push_word (Triplet !hp);      
    ) 

let get_next_stack = function () ->
  if is_rib_w (get_cdr_triplet (Triplet !sp)) then
    sp := get_int_triplet (get_cdr_triplet (Triplet !sp))
  else
    failwith "get_next_stack"


let false_rib : rib = make_rib (Int 0) (Int 0) (Int 5)
let true_rib : rib = make_rib (Int 0) (Int 0) (Int 5)
let nil_rib : rib = make_rib (Int 0) (Int 0) (Int 5)

let print_value (v : word) : unit =
  match v with
  | Int i -> Printf.printf "Int %d" i
  | Triplet t -> Printf.printf "Triplet %d " t;
  | Nil -> Printf.printf "Nil" 


let rec show_rib (rib:word) prof i =
  if i > prof then 
    if is_rib_w (rib) then 
      Printf.printf("[Array]")
    else (
      Printf.printf"%d" (int_val rib)
    )
  else
    match rib with 
      Triplet t -> let (car, cdr, tag) = get_rib rib in (
        Printf.printf("[ ");
        show_rib car prof (i+1);
        Printf.printf(", ");
        show_rib cdr prof (i+1);
        Printf.printf(", ");
        show_rib tag prof (i+1);
        Printf.printf(" ]")
      )
    | Int i -> Printf.printf"%d" i
    | Nil -> Printf.printf "Nil"

let pop ()  =
  let x = get_car ram.(!sp) in 
  (if is_rib_w (get_cdr ram.(!sp)) then
     sp := get_int_triplet (get_cdr ram.(!sp))
   else
     (
       ram.(!hp-1) <- (Nil, get_cdr ram.(!sp),  get_tag ram.(!sp));
       hp := !hp-1;
       sp := !hp
     )
  );
  x 



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

let close () =
  let x = get_car_triplet (tos()) in
  let y= get_cdr_triplet (Triplet !sp) in 
  get_next_stack();
  push_rib (x, y, Int 1)

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

(* retourne l'indice de la dernière case occupé dans lespace dédié à la création de la table des symboles *)
let i_accum stbl st = 
  if stbl > st then stbl else st

let push_symtbl_rib (rib : rib) :unit =
  let i = i_accum !hp !stbl in
  if i < size_ram then
    (ram.(i+1) <- rib)
  else
    invalid_arg "stack overflow push_symtbl_rib"
(* gc *)

let push2_symtbl_word (car : word)(tag : word) : unit =
  let i = i_accum !hp !stbl in
    (* premier elemn de stack *)
    if i = -1 then (ram.(i+2) <- (car, Int 0, tag)) else
      (ram.(i+2) <- (car, Triplet (i+1), tag))


let push_word_stbl (car : word) : unit =
  let i = (get_int_triplet car) in
    (* premier elemn de stack *)
    if !stbl = 3 then ( (ram.(i+1) <- (car, Int 0, Int pair_type); stbl := i+1) )else
      (ram.(i+1) <- (car, Triplet (!stbl), Int pair_type); stbl := i+1)

(* récupère la taille d'une liste chainée *)
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
  let i = i_accum !hp !stbl in
    (* premier elemn de stack *)
    (ram.(i+1) <- rib;
     hp := i+1)


let create_sym (i:int)= 
  (* création d'un objet de type string associé à la chaine de caractère récupérée du bytecode*)
  let len = length ram.(i) in
  push_symtbl_rib (make_rib (Triplet i) (Int len) (Int string_type));

  (* création d'un objet de type symbole associé  *)
  push2_symtbl_word (Triplet 3) (Int symbol_type);
  let x = i_accum !hp !stbl in 

  (* Ajout de ce symbole à la table des symboles *)
  push_word_stbl (Triplet (x+2)) 


let push_symtbl_word_accum (car: word) (cdr:word) =
  let i = i_accum !hp !stbl in
      ram.(i+1) <- (car, cdr, Int pair_type);
      hp := i+1

(* construction de la table des symboles *)
let build_symtbl () : unit =

  (* Caractere de fin de chaine *)
  push_symtbl nil_rib;

  let rec loop1 n :unit =
    if 0 < n then ( 
        push_symtbl nil_rib;
        create_sym(!hp);
        loop1 (n-1)) 
    else 
      (* i = index dans la symtbl du premier caractere de la liste des symboles *)
      let rec loop3 (i:int) = 
        let x = get_byte () in 
        (* on a ',' séparation des symboles *)
        if x = 44 then ( 
          (* création du symbole *)
          create_sym(i); 
          (* début du prochain symbole *)
          push_symtbl nil_rib;
          loop3(!hp)) else
        (* ';' Fin de la liste des symboles *)
        if x=59 then 
          (
            (* dernier symbole *)
          create_sym(i);
          )
        else(
          push_symtbl_word_accum (Int x) (Triplet (i)); 
          loop3 (!hp))
      in
      loop3 (!hp)
  in
  let n = get_int 0 in (
    loop1 n)

let set_global (value:rib) = (
  push_symtbl_rib value;
  set_car_triplet (get_car_triplet (Triplet !stbl)) (Triplet !hp);)

let push_prog_r (rib : rib) : unit =
  let i = !pc in
  (ram.(i+1) <- rib;
  pc := i+1)





let push_stack_r rib =
  let i = !hp in 
  if word_eqv (Triplet (!hp-2)) (get_car ram.(1))  then 
    invalid_arg "stack overflow push_stack_r"
  else
    (
      let (car, cdr, tag) = ram.(!sp) in 
      ram.(i-1) <- rib;
      ram.(i-2) <- (Triplet(i-1), cdr, tag);
      hp := i-2;
      sp := !hp
    )
(* gc *)

let push_heap_copy (rib : rib) : unit =

  let i = !pc in
  let rec push_heap_stack (w : word) : word =
      match w with 
      | Int i -> w
      | Triplet t ->  
        if t < !stbl then 
          w
        else (
          let (w1, w2, w3) = get_rib w in 
          let x = (push_heap_stack w1, push_heap_stack w2, push_heap_stack w3) in 
          push_prog_r x;
          Triplet !pc
        )
      | _ -> invalid_arg "fail push heap copy Nil"
        
    in
    (* p : un rib dans la pile qui doit être copié dans le graphe d'instruction *)
      let (car, cdr, p) = rib in 
      match p with 
      | Int _ -> 
        (ram.(i+1) <- rib;
        pc := i+1)
      | Triplet t -> 
        let x = push_heap_stack (Triplet t) in
        ram.(!pc+1) <- (car, cdr, x);
        pc := !pc+1
      | _ -> invalid_arg "push_heap_copy"


(* construction du graphe d'instructions *)
let decode = function () ->(
  (* opcodes *)
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
        push_stack_r x;
        decode_loop ()
      in

      (* calcul opnd *)
      let calcul_opnd (n:int) (d:int) (op:int) :word= 
        if (n< d) then 
          (
            if op < 3 then (
              sym n) 
            else ( 
              (Int n)))
        else(
        if n = d then (
          Int (get_int 0)) 
        else
          (sym (get_int ((n-d)-1))))
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
                
                push_heap_copy (make_rib opnd (Int 0) (p));
                push_prog_r (make_rib (Triplet (!pc)) (Triplet 1) (Int procedure_type));

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
  (* False rib *)
  (* save index "limite" allocation *)
  ram.(1) <- (Int (!hp), Int 0, Int 5);
  (* set up stack [ 0, 0, [ 5, 0, 0 ] ] *)
  hp := size_ram;
  ram.(!hp-1) <- (Int 5, Int 0, Int 0);
  ram.(!hp-2) <- ( Int 0, Int 0, Triplet (!hp-1));
  hp := !hp - 2;
  sp := !hp



(* pointe pc vers la prochaine instruction *)
let advance_pc = function () -> 
  let tag = get_tag_triplet (Triplet !pc) in
  match tag with 
  | Triplet t -> pc := get_int_triplet tag
  | _ -> invalid_arg "advance_pc"

let get_cont  = function () ->
  let rec loop (s:word) : word =
    match get_tag_triplet s with
    | Int x -> 
      ( 
      loop (get_cdr_triplet s))
    | Triplet t -> 
      s
    | _ -> invalid_arg "get_cont 2"
  in loop (Triplet !sp)

(* Decodage de la RVM *)
let rec run () =  
  let instr = get_car_triplet (Triplet !pc)
  and opnd = get_cdr_triplet (Triplet !pc)
  and next = get_tag_triplet (Triplet !pc)  
  in 


  match instr with 
  | Int 3 -> 
    if !debug then(
      Printf.printf "--- const\n";
      Printf.printf "instr : \n";
      show_rib instr 3 0;
      Printf.printf "\nopnd : \n";
      show_rib opnd 3 0;
      Printf.printf "\nnext : \n";
      show_rib next 3 0;
      Printf.printf "\n";
      Printf.printf "pc :\n" ;
      show_rib (Triplet !pc) 4 0;
      Printf.printf "\nsp :\n" ;
      show_rib (Triplet !sp) 4 0;
      Printf.printf "\n";
    );
    push_word opnd ;

    advance_pc();
    run ()
  | Int 0 -> 
    if !debug then (
      if next = Int 0 then 
        (
          Printf.printf "--- jump\n" ;
          Printf.printf "instr : \n";
          show_rib instr 3 0;
          Printf.printf "\nopnd : \n";
          show_rib opnd 3 0;
          Printf.printf "\nnext : \n";
          show_rib next 3 0;
          Printf.printf "\n";

          Printf.printf "pc : \n" ;
          show_rib (Triplet !pc) 4 0;
          Printf.printf "\nsp : \n" ;
          show_rib (Triplet !sp) 5 0;
          Printf.printf "\n";
        )
      else(
        Printf.printf "--- call\n";
        Printf.printf "instr : \n";
        show_rib instr 3 0;
        Printf.printf "\nopnd : \n";
        show_rib opnd 3 0;
        Printf.printf "\nnext : \n";
        show_rib next 3 0;
        Printf.printf "\n";

        Printf.printf "pc : \n" ;
        show_rib (Triplet !pc) 5 0;
        Printf.printf "\nsp : \n" ;
        show_rib (Triplet !sp) 5 0;
        Printf.printf "\n";
      );
    );

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
          push_heap (car, get_car_triplet (Triplet !pc), tag);
          sp := !hp;
        )
        ;
        advance_pc();
        run())
     | Triplet t -> (
        (* calling a lambda *)
        let nparams = (int_val (get_car_triplet code)) lsr 1 in
        (* besoin d'un endroit où la stocker car elle va etre modifié *)
        push_heap (Int nparams, Int 0, Int 0);
        let np = !hp in
        (* ram.(p+1) <- (Int nparams, Int 0, Int 0); *)
        (* @@(feature arity-check *)
        let vari = int_val (get_car_triplet code) land 1 in  
        if (vari = 0  && nparams != (nargs)) || (vari != 0 && nparams > ( nargs)) then
          failwith "*** Unexpected number of arguments named ***"
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
                push_heap (car, rest, Int pair_type);
                rest_loop (Triplet (!hp)) (it-1) 
              )
              else(
                push_heap (rest, Triplet !sp, Int 0);
                sp := !hp;
                ram.(np) <- (Int (nparams+1), Int 0, Int 0);
              ); 
            in
            (* build_rest nil_rib; *)
            push_heap nil_rib;
            rest_loop (Triplet (!hp)) (nargs-nparams);
          );
        (* )@@ *)
        let new_cont = make_rib (Int 0) (proc) (Int 0) in
        push_heap new_cont;
        (* on garde le pointeur vers new-cont *)
        let nc = !hp in
        let rec loop nparams new_stack= 
          if 0 < nparams then 
            (
              let (car, cdr, tag) = ram.(!sp) in
              get_next_stack();
              push_heap (car, new_stack, Int 0);
              loop (nparams-1) (Triplet (!hp)))
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

            
              run();
            );
        in 
        let nparams = int_val (get_car_triplet (Triplet (np))) in
        loop nparams (Triplet (nc));   

      )

    | _ -> invalid_arg "run")


  | Int 1 -> 
    if !debug then 
      (
        Printf.printf "--- set\n";
        Printf.printf "instr : \n";
        show_rib instr 3 0;
        Printf.printf "\nopnd : \n";
        show_rib opnd 3 0;
        Printf.printf "\nnext : \n";
        show_rib next 3 0;
        Printf.printf "\n";

        Printf.printf "pc :\n" ;
        show_rib (Triplet !pc) 4 0;
        Printf.printf "\nsp :\n" ;
        show_rib (Triplet !sp) 4 0;
        Printf.printf "\n";
      );


    let x = tos() in 

    (match opnd with
      Int i -> 
        let lt = list_tail !sp i in
        let (car, cdr, tag) = ram.(get_int_triplet lt) in 
        ram.(get_int_triplet lt) <- (x, cdr, tag);
      | Triplet t -> let (car, cdr, tag) = ram.(t) in 
        ram.(t) <- (x, cdr, tag);
      | _ -> invalid_arg "set_var");

    get_next_stack();
    advance_pc();
    run()
  | Int 2 -> 
    if !debug then(
      Printf.printf "--- get\n";

      Printf.printf "instr : \n";
      show_rib instr 3 0;
      Printf.printf "\nopnd : \n";
      show_rib opnd 3 0;
      Printf.printf "\nnext : \n";
      show_rib next 3 0;
      Printf.printf "\n";

      Printf.printf "pc : \n" ;
      show_rib (Triplet !pc) 4 0;
      Printf.printf "\np : \n" ;
      show_rib (Triplet !sp) 4 0;
      Printf.printf "\n";
    );
    let x = get_var opnd in
    push_word x;

    advance_pc();
    run()
  | Int 4 -> 
    if !debug then (
      Printf.printf "--- if\n";
      Printf.printf "instr : \n";
      show_rib instr 3 0;
      Printf.printf "\nopnd : \n";
      show_rib opnd 3 0;
      Printf.printf "\nnext : \n";
      show_rib next 3 0;
      Printf.printf "\n";
  
      Printf.printf "pc : \n" ;
      show_rib (Triplet !pc) 4 0;
      Printf.printf "\nsp : \n" ;
      show_rib (Triplet !sp) 4 0;
      Printf.printf "\n";
    );
    let tos = tos() in
    if (word_eqv tos (Triplet 3)) then
      (
       advance_pc())
    else (
      
      pc := get_int_triplet (opnd));
    get_next_stack();
    run()

  | Int 5 -> 
    if !debug then 
      (Printf.printf "--- Halt\n")

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
hp := !stbl;

build_symtbl ();; 

ram.(0)<- (make_rib (Int 0) (Triplet !stbl) (Int 1));;


(* graphe d'instruction apres la table des symboles *)
pc := !stbl;;

hp := !sp;

decode();;

(* set global variables *)

set_global (Triplet 0);;
set_global (Triplet 3);;
set_global (Triplet 1);;
set_global (Triplet 2);;

(* le pointeur de !stbl a été changé apres l'appel a set_global *)
let (car, cdr, tag) = ram.(0) in ram.(0) <- (car, (Triplet !stbl), tag);;

setup_stack();;


run();; 
