(* Allocation d'un tableau d'entrée de taille 9000 *)
let input = array_create 9000 ;; 

(* Constantes pour les types *)
let pair_type = 0;;         (* Type pour les paires *)
let procedure_type = 1;;    (* Type pour les procédures *)
let symbol_type = 2;;       (* Type pour les symboles *)
let string_type = 3;;       (* Type pour les chaînes *)
let vector_type = 4;;       (* Type pour les vecteurs *)
let singleton_type = 5;;    (* Type pour les singletons *)

(* Constantes pour les instructions de la VM *)
let instr_jc = 0;;          (* Instruction jump if condition *)
let instr_set = 1;;         (* Instruction set variable *)
let instr_get = 2;;         (* Instruction get variable *)
let instr_const = 3;;       (* Instruction pour une constante *)
let instr_if = 4;;          (* Instruction if condition *)
let instr_halt = 5;;        (* Instruction halt, arrête l'exécution *)

(* Définition d'un type de mot dans la VM *)
type word = 
   Nil of unit             (* Valeur nulle *)
  | Int of int<32>         (* Entier de 32 bits *)
  | Triplet of int<32>     (* Référence à une rib dans la RAM *)
;;

(* Définition d'un type rib comme une triplet de mots *)
type rib = word * word * word ;;

(* Taille de la RAM et limite d'allocation pour le GC *)
let size_ram = 9000;;
let alloc_limit = size_ram / 2 -1;;

(* Allocation de la RAM et initialisation des registres *)
let ram = array_create size_ram ;; 
let sp = array_create 1;;    (* Pile *)
let pc = array_create 1;;    (* Compteur de programme *)
let stbl = array_create 1;;  (* Table des symboles *)
let pos = array_create 1;;   (* Position dans l'entrée *)
let hp = array_create 1;;    (* Pointeur de tas *)

(* Initialisation des registres *)
pc.(0) <- 0;;              (* Compteur de programme commence à 0 *)
sp.(0) <- size_ram;;       (* Pile commence à la fin de la RAM *)
stbl.(0) <- 0;;            (* Table des symboles commence à 0 *)
pos.(0) <- 0;;             (* Position dans l'entrée commence à 0 *)
hp.(0) <- 0;;              (* Pointeur de tas commence à 0 *)

(* Fonction pour créer une rib *)
let make_rib (a,b,c) : rib = (a, b, c);;

(* Fonction pour vérifier si un mot est une rib *)
let is_rib_w (r:word) : bool = match r with 
  | Triplet _ -> true 
  | _ -> false
end
;;

(* Exemple de création d'une rib *)
let my_rib: rib = (Int(1), Nil(), Triplet(255));;

(* Fonction pour obtenir la valeur entière d'un mot *)
let int_val (n) = 
  match n with 
  | Int(i) -> i
  | _ -> fatal_error ("expected an Integer")
  end
;;

(* Fonction pour obtenir l'index d'une triplet *)
let get_int_triplet (x : word) = 
  match x with 
    Triplet i -> i 
  |_ -> fatal_error("expected a triplet 1")
end
;; 

(* Fonction pour obtenir une rib à partir d'un mot *)
let get_rib (r : word ) : rib =
  match r with 
  | Triplet i -> ram.(i)
  | _ -> fatal_error("get_rib expected a triplet")
end
;;

(* Fonctions d'affichage pour les ribs et les mots *)
let print_separator () = 
  print_string ",";;

let print_open_bracket () = 
  print_string "[";;

let print_close_bracket () = 
  print_string "]";;

let rec print_value v = 
  match v with
  | Int i -> print_int i
  | Nil ()-> print_string "Nil"
  | Triplet t -> 
      let (a, b, c) = get_rib (Triplet t) in
      print_open_bracket ();
      print_value a; print_separator ();
      print_value b; print_separator ();
      print_value c;
      print_close_bracket ()
  end
;;

(* Fonction pour afficher une rib *)
let print_rib rib =
  let (a, b, c) = rib in
  print_open_bracket ();
  print_value a; print_separator ();
  print_value b; print_separator ();
  print_value c;
  print_close_bracket ()
;;

(* Fonction pour vérifier l'équivalence de deux mots *)
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
  | Nil () -> match b with 
    | Nil () -> true
    | _ -> false
  end
end
;;

(* Fonction pour vérifier l'équivalence de deux ribs *)
let rib_eq (a,b) : bool = 
  let (a1, a2, a3) = a in 
  let (b1, b2, b3) = b in 
  word_eqv(a1,b1) && word_eqv(a2,b2) && word_eqv(a3,b3)
;;

(* Fonctions pour accéder aux éléments d'une rib *)
let get_car (rib:rib) : word= 
  let(a,b,c) = rib in 
  a;;

(* Fonction pour définir le car d'une triplet *)
let set_car_triplet (rib,newval) = 
  match rib with 
  | Triplet (i) -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag); newval
  | _ -> fatal_error ("set car triplet expected a triplet")
end
;;

(* Fonction pour obtenir le car d'une triplet *)
let get_car_triplet (rib : word) : word =
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v1
  | _ -> fatal_error("get_car_triplet expected a triplet")
end
;;

(* Fonctions pour accéder au cdr et tag d'une rib *)
let get_cdr (rib : rib) : word=
  let (_,cdr,_) = rib in
  cdr
;;

(* Fonction pour définir le cdr d'une triplet *)
let set_cdr_triplet (rib,newval) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, newval, tag); newval
  | _ -> fatal_error "set cdr triplet expected a triplet"
end
;;

(* Fonction pour obtenir le cdr d'une triplet *)
let get_cdr_triplet (rib:word) : word = 
  match rib with 
  | Triplet(t) -> let (v1, v2, v3) = ram.(t) in 
      v2
  | _ -> fatal_error "get_cdr_triplet expected a triplet"
end;;

(* Fonction pour obtenir le tag d'une rib *)
let get_tag (rib:rib) : word= 
  let(_,_,tag) = rib in 
  tag;;

(* Fonction pour obtenir le tag d'une triplet *)
let get_tag_triplet (rib : word) : word = 
  match rib with 
  | Triplet t -> let (v1, v2, v3) = ram.(t) in 
      v3
  | _ -> fatal_error("get_tag_triplet expected a triplet")
end;;

(* Fonction pour définir le tag d'une triplet *)
let set_tag_triplet (rib,newval) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, cdr, newval); newval
  | _ -> fatal_error "set cdr triplet expected a triplet"
end;;

(* Fonctions pour créer des ribs de base *)
let make_rib_of_ints (a,b,c) = (Int a, Int b, Int c);;
let false_rib : rib = make_rib_of_ints (0,0,5);;
let true_rib : rib = make_rib_of_ints (0,0,5);;
let nil_rib : rib = make_rib_of_ints (0,0,5);;

(* Fonction pour obtenir le sommet de la pile *)
let tos = fun () -> get_car(ram.(sp.(0)));;

(* Fonction pour dépiler un élément *)
let pop () =
  let current_sp = sp.(0) in
  let x = get_car (ram.(current_sp)) in
  if is_rib_w (get_cdr(ram.(current_sp))) then
    sp.(0) <- get_int_triplet (get_cdr (ram.(current_sp)))
  else
    ram.(hp.(0)-1) <- (Nil(), get_cdr(ram.(current_sp)), get_tag(ram.(current_sp)));
    hp.(0) <- hp.(0)-1;
    sp.(0) <- hp.(0);
  x
;;

(* Fonction pour empiler un rib dans le tas *)
let push_heap rib = 
  let i = hp.(0) in 
  ram.(i-1) <- rib; 
  hp.(0) <- i-1 
;;

(* Fonction pour empiler un mot *)
let push_word (car : word) : unit =
  if word_eqv ((Triplet (hp.(0)-1)) ,(get_car (ram.(1))))  then
    fatal_error "stack overflow push_word"
  else
    if hp.(0) = size_ram then 
      (* Int 0 car la stack = Int 0 au début *)
      (ram.(hp.(0)-1) <- (car, Int 0, Int pair_type); 
      hp.(0) <- hp.(0)-1;
      sp.(0) <- hp.(0)) 
    else
      (ram.(hp.(0)-1) <- (car, Triplet (sp.(0)), Int pair_type); 
      hp.(0) <- hp.(0)-1;
      sp.(0) <- hp.(0));;

(* Fonction pour empiler un rib *)
let push_rib(rib : rib) : unit =
  if word_eqv ((Triplet (hp.(0)-1)) ,(get_car (ram.(1))))  then
    fatal_error "stack overflow push_rib"
  else
    (* premier elemn de stack *)
    if hp.(0) = size_ram then 
      (ram.(hp.(0)-1) <- rib;
      hp.(0) <- hp.(0) -1;
      sp.(0) <- hp.(0)) 
    else(
      ram.(hp.(0)-1) <- rib;
      hp.(0) <- (hp.(0)) -1;
      push_word (Triplet (hp.(0)))
    );;

(* Fonction pour afficher une rib avec une profondeur maximale *)
let rec show_rib (rib,prof,i) =
  if i > prof then 
    if is_rib_w (rib) then 
      print_string("[Array]")
    else (
      print_int(int_val rib)
    )
  else
    match rib with 
      Triplet t -> let (car, cdr, tag) = get_rib rib in (
        print_string("[ ");
        show_rib (car,prof,(i+1));
        print_string(", ");
        show_rib (cdr,prof,(i+1));
        print_string(", ");
        show_rib (tag,prof,(i+1));
        print_string(" ]")
      )
    | Int i -> print_int(i) 
    | Nil () -> print_string "Nil"
  end
;;  

(* Fonctions primitives pour la manipulation des mots et ribs *)
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
  push_word result2_after_f
;;

let prim3 f =
  let x = pop () in
  let y = pop () in
  let z = pop () in
  let result2_after_f = f(x,y,z) in
  push_rib result2_after_f;;

(* Fonction pour convertir une valeur booléenne en rib *)
let to_bool = fun x -> 
  if x then true_rib else false_rib 
;;

let prim2_bool f =
  let x = pop () in
  let y = pop () in
  let result2 = f(x,y) in
  let bool_result2 = to_bool result2 in
  push_rib bool_result2
;;

(* Fonction pour obtenir la prochaine adresse de pile *)
let get_next_stack = fun () ->
  if is_rib_w (get_cdr_triplet (Triplet (sp.(0)))) then
    sp.(0) <- get_int_triplet (get_cdr_triplet (Triplet (sp.(0))))
  else
    fatal_error "get_next_stack"
  ;;

(* Fonction pour fermer une procédure *)
let close () =
  let tos = tos() in
  let x = get_car_triplet (tos) in
  print_string "close x\n";
  show_rib (x ,5 ,0);
  print_string "\n";
  let y= get_cdr_triplet (Triplet (sp.(0))) in 
  print_string "close y\n";
  show_rib (y ,5, 0);
  print_string "\n";
  get_next_stack();
  push_rib (x, y, Int 1);;

(* Fonction pour appliquer une primitive *)
let apply_prim2 (index) =
  match index with
  | 0 -> prim3 (fun (z, y, x) -> make_rib (x, y, z))
  | 1 -> prim3 (fun x -> x)
  | 3 -> prim2 (fun (y, x) -> y)
  | 4 -> close ()
  | 5 -> prim1_rib (fun x -> 
    match x with
    | Triplet _ -> true_rib 
    | _ -> (Triplet 1, Triplet 2, Int 5)
    end)
  | 6 -> prim1 get_car_triplet
  | 7 -> prim1 get_cdr_triplet 
  | 8 -> prim1 get_tag_triplet
  | 9 -> prim2 (fun (y, x) -> set_car_triplet (x, y))
  | 10 -> prim2 (fun (y, x) -> set_cdr_triplet (x, y))
  | 11 -> prim2 (fun (y, x) -> set_tag_triplet (x, y))
  | 12 -> prim2_bool (fun (y, x) -> word_eqv (x, y))
  | 13 -> prim2_bool (fun (y, x) -> match x with
                                  | Int a -> match y with
                                    | Int b -> a < b
                                    | _ -> fatal_error "< arguments must be Ints"
                                  end
                                  | _ -> fatal_error "< arguments must be Ints"
                                end)

  | 14 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a + b)
                                | _ -> fatal_error "+ arguments must be Ints"
                              end
                              | _ -> fatal_error "+ arguments must be Ints" end)
  | 15 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a - b)
                                | _ -> fatal_error "- arguments must be Ints"
                              end
                              | _ -> fatal_error "- arguments must be Ints" end) 
  | 16 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a * b)
                                | _ -> fatal_error "* arguments must be Ints"
                              end
                              | _ -> fatal_error "* arguments must be Ints" end) 
  | 17 -> prim2 (fun (y, x) -> match x with
                              | Int a -> match y with
                                | Int b -> Int (a / b)
                                | _ -> fatal_error "quotient arguments must be Ints"
                              end
                              | _ -> fatal_error "quotient arguments must be Ints" end) 
  | _ -> fatal_error "Invalid primitive index"
end;; 

(* Fonction pour obtenir le dernier élément d'une liste *)
let rec list_tail (ptr,i) =
  if 0 = i then 
    Triplet (ptr)
  else
    (if is_rib_w (get_cdr (ram.(ptr))) then
       let (car, cdr, tag) = ram.(ptr) in
       list_tail ((get_int_triplet (cdr)),(i-1))
     else
      fatal_error "list_tail")
;;

(* Fonction pour obtenir un octet de l'entrée *)
let get_byte = fun () ->
  let c = input.(pos.(0)) in
  pos.(0) <- pos.(0) + 1; c;;

(* Fonction pour obtenir un code à partir d'un octet *)
let get_code () =
  let x = (get_byte ()) - 35 in if x < 0 then 57 else x
;;

(* Fonction pour obtenir un entier à partir d'un code *)
let rec get_int n =
  let x = get_code () in
  let n = n * 46 in
  if x < 46 then n + x else get_int (n + x - 46)
;;

(* Fonction pour vérifier si un mot est une paire *)
let is_pair (n) = 
  let (a, b, c) = n in
  let l = 0 in
  match c with   
  | Int(l) -> true
  | _ -> false
end 
;;

(* Fonction pour obtenir l'accumulateur *)
let i_accum (stbl,st) = if stbl > st then stbl else st;;

(* Fonction pour empiler une rib dans la table des symboles *)
let push_symtbl_rib (rib : rib) :unit =
  let i = i_accum (hp.(0),stbl.(0)) in
  if i < size_ram then
    (ram.(i+1) <- rib)
  else
    fatal_error "stack overflow push_symtbl_rib"
    (* gc *)
;;

(* Fonction pour empiler un mot et son tag dans la table des symboles *)
let push2_symtbl_word (car,tag) : unit =
  let i = i_accum (hp.(0),stbl.(0)) in
  if i < alloc_limit then
    (* premier elemn de stack *)
    if i = -1 then (ram.(i+2) <- (car, Int 0, tag)) else
      (ram.(i+2) <- (car, Triplet (i+1), tag))
  else
    fatal_error "stack overflow push2_symtbl_word"
    (* gc *)
;;

(* Fonction pour empiler un mot dans la table des symboles *)
let push_word_stbl (car : word) : unit =
  let i = (get_int_triplet car) in
  if i < alloc_limit then
    
    (* premier elemn de stack *)
    if stbl.(0) = 3 then ( (ram.(i+1) <- (car, Int 0, Int pair_type); stbl.(0) <- i+1) )else
      (ram.(i+1) <- (car, Triplet (stbl.(0)), Int pair_type); stbl.(0) <- i+1)
  else
    fatal_error "stack overflow push_word_stbl "
    (* gc *)
  ;;

(* Fonction pour obtenir la longueur d'une liste *)
let length lst =
  let rec aux (l,acc) =
    if is_pair l then
      match (get_cdr l) with
      | Int _ -> acc +1
      | Triplet i -> aux ((get_rib (Triplet i)),(acc + 1))
      | _ -> fatal_error "length"
    end
    else
      acc
  in
  aux (lst,0)
;;

(* Fonction pour empiler une rib dans la table des symboles *)
let push_symtbl (rib:rib) : unit =
  let i = i_accum (hp.(0),stbl.(0)) in
  if i < alloc_limit then
      (ram.(i+1) <- rib;
      hp.(0) <- i+1)
  else
    fatal_error "stack overflow push_symtbl"
    (* gc *)
;;

(* Fonction pour créer un symbole *)
let create_sym (i)= 
  let len = length (ram.(i)) in
  push_symtbl_rib (make_rib ((Triplet i),(Int len),(Int string_type)));
  push2_symtbl_word ((Triplet 3),(Int symbol_type));
  let x = i_accum (hp.(0),stbl.(0)) in 
  push_word_stbl (Triplet (x+2)) 
;;

(* Fonction pour empiler un mot accumulé dans la table des symboles *)
let push_symtbl_word_accum (car,cdr) =
  let i = i_accum (hp.(0),stbl.(0)) in
  if i < alloc_limit then
    (
      ram.(i+1) <- (car, cdr, Int pair_type);
      hp.(0) <- i+1)
  else
    fatal_error "stack overflow push_symtbl_word_accum"
    (* gc *)
  ;;

(* Fonction pour construire la table des symboles *)
let build_symtbl () : unit =
push_symtbl nil_rib;

let rec loop1 n :unit =
  if 0 < n then 
    ( 
      push_symtbl nil_rib;
      create_sym(hp.(0));
      loop1 (n-1)) 
  else 
    let rec loop3 (i:int<32>) = 
      let x = get_byte () in 
      if x = 44 then ( 
        create_sym(i);
        push_symtbl nil_rib;
        loop3(hp.(0))) else
      if x=59 then 
        create_sym(i)
      else(
        push_symtbl_word_accum ((Int x),(Triplet (i))); 
        loop3 (hp.(0)))
    in
    loop3 (hp.(0))
in
let n = get_int 0 in (
  loop1 n)
;;

(* Fonction pour définir une variable globale *)
let set_global (value:rib) = 
  push_symtbl_rib value;
  set_car_triplet (get_car_triplet ((Triplet (stbl.(0)))),(Triplet (hp.(0))));;

(* Fonction pour empiler une rib dans le programme *)
let push_prog_r (rib : rib) : unit =
  let i = pc.(0) in
  ram.(i+1) <- rib;
  pc.(0) <- i+1;;

(* Fonction pour empiler une rib dans la pile *)
let push_stack_r rib =
  let i = hp.(0) in 
  if word_eqv ((Triplet (hp.(0)-2)), (get_car (ram.(1))))  then 
    fatal_error "stack overflow push_stack_r"
  else
    (
      let (car, cdr, tag) = ram.(sp.(0)) in 
      ram.(i-1) <- rib;
      ram.(i-2) <- (Triplet(i-1), cdr, tag);
      hp.(0) <- i-2;
      sp.(0) <- hp.(0)
    );;

(* Fonction pour empiler une copie de heap *)
let   push_heap_copy (rib : rib) : unit =
let i = pc.(0) in
let rec push_heap_stack (w : word) : word =
    match w with 
    | Int i -> w
    | Triplet t ->  
      if t < stbl.(0) then 
        w
      else (
        let (w1, w2, w3) = get_rib w in 
        let x = (push_heap_stack w1, push_heap_stack w2, push_heap_stack w3) in 
        push_prog_r x;
        Triplet (pc.(0))
      )
    | _ -> fatal_error "fail push heap copy Nil"
    end
  in
    let (car, cdr, p) = rib in 
    match p with 
    | Int _ -> 
      (ram.(i+1) <- rib;
      pc.(0) <- i+1)
    
    | Triplet t -> 
    let x = push_heap_stack (Triplet t) in
      ram.(pc.(0)+1) <- (car, cdr, x);
      pc.(0) <- pc.(0)+1

    | _ -> fatal_error "push_heap_copy"
    end;;

(* Taille et initialisation du tableau de codes *)
let codes_size = 6;;
let codes = array_create codes_size;;
codes.(0) <- 20;;
codes.(1) <- 30;;
codes.(2) <- 0;;
codes.(3) <- 10;;
codes.(4) <- 11;;
codes.(5) <- 4;;

(* Fonction pour obtenir un symbole *)
let sym n =
  let l = list_tail ((stbl.(0)), n) in
  let car = get_car_triplet l in
  car
;;

(* Fonction pour calculer l'opérande *)
let calcul_opnd (n, d, op) =
  if n < d then (
    if op < 3 then (sym n) else (Int n))
  else (if n = d then
    Int (get_int 0)
  else
    sym (get_int (n-d-1)))
;;

(* Fonction pour ajouter une instruction *)
let add_instruction (op, opnd) =
  let x = make_rib (Int op, opnd, tos ()) in
  push_stack_r x
;;

(* Boucle de décodage des instructions *)
let decode_loop () =
  let x = get_code () in
  let rec loop (op,n) = 
    let d = codes.(op) 
    in
    if (d+2) < (int_val n) then
      ( 
        loop ((op + 1),(Int ((int_val n)-(d+3))))
    )
    else
    if 90 < get_code () then (
      let tos = tos() in
      get_next_stack();
      add_instruction (4,tos);
      loop (0 ,(Int (get_code ()))))
    else 
      (  
        if op = 0 then (  
          (
          push_word (Int 0) 
          )
        )else (
          print_newline ()
          );
        let opnd = calcul_opnd ((int_val n),d,op) in
        if 4 < op then
          (
            let p = pop() in 
            push_heap_copy (make_rib (opnd,(Int 0),(p))) ;
            push_prog_r (make_rib ((Triplet (pc.(0))), (Triplet 1) ,(Int procedure_type)));
            if rib_eq (make_rib (Nil (), Int 0, Int 0), ram.(sp.(0))) then
              (add_instruction (instr_const,(Triplet (pc.(0))));
                loop (0 ,(Int (get_code ()))))
            else
              (add_instruction (instr_const,(Triplet (pc.(0))));
                loop (0 ,(Int (get_code ()))))
            )
        else(
          if (0<op) then
            (
              add_instruction ((op-1),opnd);
              loop (0 ,(Int (get_code ()))))
          else
            (
              add_instruction (0,opnd);
              loop (0 ,(Int (get_code ()))))
      ) )
    in
    loop (0 ,(Int (get_code ())));;

(* Fonction pour décoder le programme *)
let decode () =
  let main_proc = decode_loop() in
  let d = get_car_triplet main_proc in
  let f = get_tag_triplet d in
  pc.(0) <- get_int_triplet f
;;

(* Fonction pour obtenir une variable *)
let get_var opnd = 
match opnd with 
| Triplet _ -> get_car_triplet opnd
| Int i -> get_car_triplet (list_tail ((sp.(0)),i))
| _ -> fatal_error "get_var"
end;;

(* Fonction pour initialiser la pile *)
let setup_stack = fun () ->
  let f = hp.(0) in
  (* False rib *)
  ram.(f+1) <- (Triplet (f+2), Triplet (f+3), Int 5);
  ram.(f+2) <- (Int 0, Int 0, Int 5);
  ram.(f+3) <- (Int 0, Int 0, Int 5);
  (* save index "limite" allocation *)
  ram.(1) <- (Int (f+3), Int 0, Int 5);
  (* set up stack [ 0, 0, [ 5, 0, 0 ] ] *)
  hp.(0) <- size_ram;
  ram.(hp.(0)-1) <- (Int 5, Int 0, Int 0);
  ram.(hp.(0)-2) <- ( Int 0, Int 0, Triplet (hp.(0)-1));
  hp.(0) <- hp.(0) - 2;
  sp.(0) <- hp.(0);;

(* Fonction pour avancer le compteur de programme *)
let advance_pc = fun () -> 
  let tag = get_tag_triplet (Triplet (pc.(0))) in
  match tag with 
  | Int i -> pc.(0) <- stbl.(0)
  | Triplet t -> pc.(0) <- get_int_triplet tag
  | _ -> fatal_error "advance_pc"
end;;

(* Fonction pour obtenir la continuation *)
let get_cont  = fun () ->
  let rec loop (s) =
    let tag = get_tag_triplet s in 
    match tag with
    | Int x ->       
      show_rib (s, 5, 0);  
      loop (get_cdr_triplet s)
    | Triplet t -> 
      show_rib (s, 5, 0);  
      s
    | _ -> fatal_error "get_cont 2"
  end
  in loop (Triplet (sp.(0)))
;;

(* Fonction principale de la VM *)
let rec run () =  
  let instr = get_car_triplet (Triplet (pc.(0))) in
  let opnd = get_cdr_triplet (Triplet (pc.(0))) in
  let next = get_tag_triplet (Triplet (pc.(0)))  
  in 
  print_string "\n";

  match instr with 
  | Int i -> 
    match i with 
    | 3 ->
    print_string "--- const ";
    print_string "printing  instr : \n";
    show_rib (instr,3,0);
    print_string "\nprinting  opnd : \n";
    show_rib (opnd,3,0);
    print_string "\nprinting  next : \n";
    show_rib (next, 3 ,0);
    print_string "\n";

    print_string "printing  pc : " ;print_int (pc.(0));
    show_rib ((Triplet (pc.(0))) ,4 ,0);
    print_string "\nprinting  sp :"; print_int (pc.(0));
    show_rib ((Triplet (sp.(0))) ,4 ,0);
    print_string "\n";
    push_word opnd ;
    advance_pc();
    run ()
    
    |0 -> 
      if word_eqv(next,(Int 0)) then (
        print_string "--- jump\n";
        print_string "printing  instr : \n";
        show_rib (instr, 3, 0);
        print_string "\nprinting  opnd : \n";
        show_rib (opnd, 3, 0);
        print_string "\nprinting  next : \n";
        show_rib (next, 3, 0);
        print_string "\n";

        print_string "printing  pc : ";
        print_int (pc.(0));
        show_rib (Triplet (pc.(0)), 4, 0);
        print_string "\n printing  sp : ";
        print_int (sp.(0));
        show_rib (Triplet( sp.(0)), 4, 0);
        print_string "\n"
      
      )else(
      print_string "--- call\n";
      print_string "printing  instr : \n";
      show_rib (instr, 3, 0);
      print_string "\nprinting  opnd : \n";
      show_rib (opnd, 3, 0);
      print_string "\nprinting  next : \n";
      show_rib (next, 3, 0);
      print_string "\n";

      print_string "printing  pc : ";
      print_int (pc.(0));
      show_rib (Triplet (pc.(0)), 4, 0);
      print_string "\nprinting  sp : ";
      print_int (sp.(0));
      show_rib (Triplet (sp.(0)), 4, 0);
      print_string "\n"
      );

      let proc = get_var opnd in
      print_string "proc : \n";
      show_rib (proc, 3, 0);
      print_string "\n";
      let code = get_car_triplet proc in 
      print_string "code : \n";
      show_rib (code, 3, 0);
      print_string "\n";
      let (car, cdr, tag) = ram.(sp.(0)) in
      let nargs = (int_val car) in
      print_string "nargs : " ; print_int(nargs); print_string "\n";
      get_next_stack();
      
      match code with
        | Int i -> (
          print_string "\n printing  sp apres primitives : \n"; print_int (sp.(0));
          show_rib ((Triplet (sp.(0))), 3, 0);
          print_string "\n";
          
          apply_prim2(i);
          
          print_string "\nprinting  sp apres primitives : ";  print_int (sp.(0)); print_string"\n";
          show_rib ((Triplet (sp.(0))) ,5, 0);
          print_string "\n";

          if word_eqv(next,(Int 0)) then (
            (* jump *)
            pc.(0) <- get_int_triplet (get_cont());
            print_string "\n";
            let (car, cdr, tag) = ram.(sp.(0)) in 
            push_heap (car, get_car_triplet (Triplet (pc.(0))), tag);
            sp.(0) <- hp.(0)
          )else(print_newline());
        
          advance_pc();
          print_string "printing get_cont pc : "; print_int(pc.(0));
          show_rib ((Triplet (pc.(0))) ,5, 0);
          print_string "\nprinting  sp fin call ou jump : "; print_int(sp.(0)) ; print_string "\n";
          show_rib ((Triplet (sp.(0))), 5, 0);
          print_string "\n";

          run()
          )
        | Triplet t -> (
          print_string "not a number\n";
          print_string "print tag code aka pc de get";
          show_rib (code,3,0);
          print_string "\n";
          (* calling a lambda *)
          let nparams = (int_val (get_car_triplet code)) / 2 in
          push_heap (Int nparams, Int 0, Int 0);
          let np = hp.(0) in
          let vari = (int_val (get_car_triplet code)) mod 2 in
          print_string "vari :" ; print_int(vari); print_string("\n");
          print_string "nparams :" ;print_int nparams; print_string("\n");
          if (vari = 0) then(
            if (nparams != nargs) then
              fatal_error "*** Unexpected number of arguments named ***"
            else
              (print_string "")
          )else(
            if (nparams > nargs) then
              fatal_error "*** Unexpected number of arguments named ***"
            else
              (print_string ""));
          
          if vari = 1 then
            (
              let rec rest_loop (rest,it)= 
                if 0<it then ( 
                  let (car, cdr, tag) = ram.(sp.(0)) in
                  get_next_stack();
                  push_heap (car, rest, Int pair_type);
                  rest_loop ((Triplet (hp.(0))),(it-1)) 
                )
                else(
                  push_heap (rest, Triplet (sp.(0)), Int 0);
                  sp.(0) <- hp.(0);
                  ram.(np) <- (Int (nparams+1), Int 0, Int 0)
                )
              in
              push_heap nil_rib;
              rest_loop (Triplet ((hp.(0))),(nargs-nparams))
            );
            
            let new_cont = make_rib ((Int 0),(proc),(Int 0)) in
            push_heap new_cont;
            let nc = hp.(0) in
            let rec loop (nparams ,new_stack) =  
              if 0 < nparams then 
                (
                let (car, cdr, tag) = ram.(sp.(0)) in
                get_next_stack();
                push_heap (car, new_stack, Int 0);
                loop ((nparams-1),(Triplet (hp.(0))))
              )else(
                if is_rib_w next then (
                  let (car, cdr, tag) = ram.(nc) in 
                  ram.(nc) <- ((Triplet (sp.(0))), cdr, next)
                )else(
                  let k = get_cont() in
                  let (car, cdr, tag) = ram.(nc) in
                  ram.(nc) <- ((get_car_triplet k), cdr, (get_tag_triplet k))
                );
                print_value (get_tag_triplet (code));
                print_string "printed tag dfe code\n";
                pc.(0) <- get_int_triplet (get_tag_triplet (code));
                sp.(0) <- get_int_triplet (new_stack);
                show_rib ((Triplet (sp.(0))),3,0)
              )
          in 
          let nparams = int_val (get_car_triplet (Triplet (np))) in
          loop (nparams ,(Triplet (nc)));
          run()
        ) 
      | _ -> fatal_error "run" 
      end

    | 1 -> 
      print_string "--- set\n";
      print_string "printing  instr : \n";
      show_rib (instr,3,0);
      print_string "\nprinting  opnd : \n";
      show_rib (opnd ,3,0);
      print_string "\nprinting  next : \n";
      show_rib (next ,3 ,0);
      print_string "\n";
  
      print_string "printing  pc : "; print_int (pc.(0));
      show_rib ((Triplet (pc.(0))) ,4 ,0);
      print_string "\nprinting  sp : "; print_int (sp.(0));
      show_rib ((Triplet (sp.(0))), 4 ,0);
      print_string "\n";
      let x = tos() in 
     
      (match opnd with
      | Int i -> 
          let lt = list_tail (sp.(0) ,i) in
          let (car, cdr, tag) = ram.(get_int_triplet lt) in 
          print_string("printing le rib qui se fait modifier dans la stack\n");
          show_rib ((Triplet (get_int_triplet lt)) ,3 ,0);
          ram.(get_int_triplet lt) <- (x, cdr, tag);
          print_string "\napres modif\n";
          show_rib ((Triplet (get_int_triplet lt)) ,3 ,0);
          print_string "\n"

      | Triplet t -> let (car, cdr, tag) = ram.(t) in 
        print_string "printinf avant modif\n";
        show_rib ((Triplet t),3,0);
        ram.(t) <- (x, cdr, tag);
        print_string "\napres modif\n";
        show_rib ((Triplet t),3,0);
        print_string "\n"
      | _ -> fatal_error "set_var" end);

      get_next_stack();
      advance_pc();
      run()


    | 2 -> 
      print_string "--- get\n";
      print_string "printing  instr : \n";
      show_rib (instr,3,0);
      print_string "\nprinting  opnd : \n";
      show_rib (opnd ,3 ,0);
      print_string "\nprinting  next : \n";
      show_rib (next, 3 ,0);
      print_string "\n";
      print_string "printing  pc :"; print_int (pc.(0));
      show_rib ((Triplet (pc.(0))),4,0);
      print_string "\nprinting  sp :"; print_int (sp.(0));
      show_rib( (Triplet (sp.(0))) ,4, 0);
      print_string "\n";
      let x = get_var opnd in
      push_word x;
      advance_pc();
      print_string "printing  pc fin de get (next instruction) :"; print_int(pc.(0)); print_string "\n";
      show_rib ((Triplet (pc.(0))) ,4, 0);
      show_rib ((Triplet( sp.(0))) ,4, 0);
      print_string "\n";
      run()
      
    | 4 -> 
      print_string "--- if\n";
      print_string "printing  instr : \n";
      show_rib (instr, 3, 0);
      print_string "\nprinting  opnd : \n";
      show_rib (opnd, 3, 0);
      print_string "\nprinting  next : \n";
      show_rib( next, 3 ,0);
      print_string "\n";
      show_rib ((Triplet (pc.(0))) ,4, 0);
      show_rib ((Triplet( sp.(0))) ,4, 0);
      print_string "\n";
      let tos = tos() in
      if (word_eqv (tos,(Triplet 3))) then
        (print_string "false\n";
          advance_pc())
      else (
        print_string "true\n";
        pc.(0) <- get_int_triplet (opnd));
      get_next_stack();
      run()     
    
    | 5 -> 
    print_string "--- HALT\n"

    | _ -> print_newline()
  end
  | _ -> fatal_error "not yet implemented in run "
  end;;

(* Fonction pour définir une variable globale *)
let set_global (value:word) = 
  let car = get_car_triplet (Triplet (stbl.(0))) in
  let (_, cdr, tag) = ram.(get_int_triplet car) in
  ram.(get_int_triplet car) <- (value, cdr, tag);
  stbl.(0) <- get_int_triplet (get_cdr_triplet (Triplet (stbl.(0))))
;;

ram.(0) <- nil_rib;;
ram.(1) <- nil_rib;;
ram.(2) <- nil_rib;;
ram.(3) <- (Triplet 1, Triplet 2, Int singleton_type);;
stbl.(0) <- 3;;
hp.(0) <- stbl.(0);;
(* build_symtbl ();;  *)

ram.(0)<- (make_rib ((Int 0) ,(Triplet (stbl.(0))) ,(Int 1)));;

pc.(0) <- stbl.(0);;
hp.(0) <- sp.(0);;
(* decode();; *)

set_global (Triplet (0));;
set_global (Triplet (3));;
set_global (Triplet (1));;
set_global (Triplet (2));;

(* let (car, cdr, tag) = ram.(0) in ram.(0) <- (car, (Triplet (stbl.(0))), tag);; *)

(* setup_stack();; *)

(* run();;  *)

(* Fonction principale *)
let main() = 
  print_string "Compilation reussi, pas de bug dans la syntaxe "; 
  print_newline();;
