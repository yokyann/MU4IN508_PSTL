let input = array_create 9000 ;; 

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
   Nil of unit
  | Int of int<32>
  | Triplet of int<32>  
;;

type rib = word * word * word ;;


let size_ram = 9000;;
let alloc_limit = size_ram / 2 -1;;

let ram = array_create size_ram ;; 
let sp = array_create 1;;
let pc = array_create 1;;
let stbl = array_create 1;;
let pos = array_create 1;;
let hp = array_create 1;;

(* program counter : indice dans la ram *)
pc.(0) <- -1;;
(* le sommet de pile qui indique l'indice dasn la ram *)
sp.(0) <- size_ram;;
stbl.(0) <- -1;;
pos.(0) <- 0;;
hp.(0) <- -1;;

let make_rib (a,b,c) : rib = (a, b, c);;

let is_rib_w (r:word) : bool = match r with 
  | Triplet _ -> true 
  | _ -> false
end
;;
let my_rib: rib = (Int(1), Nil(), Triplet(255));;


let int_val (n) = 
  match n with 
  | Int(i) -> i
  | _ -> fatal_error ("expected an Integer")
  end
;;



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

let print_rib rib =
  let (a, b, c) = rib in
  print_open_bracket ();
  print_value a; print_separator ();
  print_value b; print_separator ();
  print_value c;
  print_close_bracket ()
;;


let print_r (ri:rib) :unit= 
  let (car, cdr, tag) = ri in 
    print_string " car : "; print_value car ; 
    print_string " cdr : "; print_value cdr;
    print_string " tag : "; print_value tag;
    print_newline ();;

(* j'ai enleve la verification pour nil parce que je dois tout changer en unit *)
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

let rib_eq (a,b) : bool = 
  let (a1, a2, a3) = a in 
  let (b1, b2, b3) = b in 
  word_eqv(a1,b1) && word_eqv(a2,b2) && word_eqv(a3,b3)
;;



let get_car (rib:rib) : word= 
  let(a,b,c) = rib in 
  a;;

let set_car (rib,w) = 
  let(a,b,c) = rib in
  (w,b,c);; 

let set_car_triplet (rib,newval) = 
  match rib with 
  | Triplet (i) -> let (car, cdr, tag) = ram.(i) in ram.(i) <- (newval, cdr, tag); newval
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

let get_cdr (rib : rib) : word=
  let (_,cdr,_) = rib in
  cdr
;;

let set_cdr_triplet (rib,newval) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, newval, tag); newval
  | _ -> fatal_error "set cdr triplet expected a triplet"
end
;;

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

let set_tag_triplet (rib,newval) = 
  match rib with
  | Triplet i -> let (car,cdr,tag) = ram.(i) in ram.(i) <- (car, cdr, newval); newval
  | _ -> fatal_error "set cdr triplet expected a triplet"
end;;

let make_rib_of_ints (a,b,c) = (Int a, Int b, Int c);;
let false_rib : rib = make_rib_of_ints (0,0,5);;
let true_rib : rib = make_rib_of_ints (0,0,5);;
let nil_rib : rib = make_rib_of_ints (0,0,5);;

let tos = fun () -> get_car(ram.(sp.(0)));;

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


let push_heap rib = 
  let i = hp.(0) in 
  ram.(i-1) <- rib; 
  hp.(0) <- i-1 
;;

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

(* let getchar () =
  try
    input_char stdin |> int_of_char
  with End_of_file -> -1
;; *)

(* let putchar c =
  print_string "putchar ";
  let char_to_print = char_of_int c in
  print_string char_to_print;
  flush stdout;
  c;; *)

let get_next_stack = fun () ->
  if is_rib_w (get_cdr_triplet (Triplet (sp.(0)))) then
    sp.(0) <- get_int_triplet (get_cdr_triplet (Triplet (sp.(0))))
  else
    fatal_error "get_next_stack"
  ;;

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



(* primitives.(5) <- prim1_rib (fun x -> match x with
  | Triplet _ -> true_rib 
  | _ -> (Triplet 1, Triplet 2, Int 5)
end);; *)
let ignore (x) =
  ();;

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
  
  (* | 18 -> prim0 (function () -> Int (getchar ()));
  | 19 -> prim1 (function Int ch -> Int (putchar ch) | _ -> fatal_error "putchar argument must be Int");  
  | 20 -> prim1 (function Int status -> exit status | _ -> fatal_error "exit argument must be Int")            *)
  | _ -> fatal_error "Invalid primitive index"
end;; 


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

let get_byte = fun () ->
  let c = input.(pos.(0)) in
  pos.(0) <- pos.(0) + 1; c;;

let get_code () =
  let x = (get_byte ()) - 35 in if x < 0 then 57 else x
;;

let rec get_int n =
  let x = get_code () in
  let n = n * 46 in
  if x < 46 then n + x else get_int (n + x - 46)
;;

let is_pair (n) = 
  let (a, b, c) = n in
  let l = 0 in
  match c with   
  | Int(l) -> true
  | _ -> false
end 
;;

let not_nil_cdr (w : word)  =
  match w with 
    Nil () -> false
  | _ -> true
end;;

let i_accum (stbl,st) = if stbl > st then stbl else st;;

let push_symtbl_rib (rib : rib) :unit =
  let i = i_accum (hp.(0),stbl.(0)) in
  if i < size_ram then
    (ram.(i+1) <- rib)
  else
    fatal_error "stack overflow push_symtbl_rib"
    (* gc *)
;;

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

let push_symtbl (rib:rib) : unit =
  let i = i_accum (hp.(0),stbl.(0)) in
  if i < alloc_limit then
      (ram.(i+1) <- rib;
      hp.(0) <- i+1)
  else
    fatal_error "stack overflow push_symtbl"
    (* gc *)
;;


let create_sym (i)= 
  let len = length (ram.(i)) in
  push_symtbl_rib (make_rib ((Triplet i),(Int len),(Int string_type)));
  push2_symtbl_word ((Triplet 3),(Int symbol_type));
  let x = i_accum (hp.(0),stbl.(0)) in 
  push_word_stbl (Triplet (x+2)) 
;;

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

let set_global (value:rib) = 
  push_symtbl_rib value;
  set_car_triplet (get_car_triplet ((Triplet (stbl.(0)))),(Triplet (hp.(0))));;


let push_prog_r (rib : rib) : unit =
  let i = pc.(0) in
  ram.(i+1) <- rib;
  pc.(0) <- i+1;;

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


let codes_size = 6;;
let codes = array_create codes_size;;
codes.(0) <- 20;;
codes.(1) <- 30;;
codes.(2) <- 0;;
codes.(3) <- 10;;
codes.(4) <- 11;;
codes.(5) <- 4;;



let sym n =
  let l = list_tail ((stbl.(0)), n) in
  let car = get_car_triplet l in
  car
;;



let calcul_opnd (n, d, op) =
  if n < d then (
    if op < 3 then (sym n) else (Int n))
  else (if n = d then
    Int (get_int 0)
  else
    sym (get_int (n-d-1)))
;;

let add_instruction (op, opnd) =
  let x = make_rib (Int op, opnd, tos ()) in
  push_stack_r x
;;


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
                (* (Triplet (pc.(0)); *)
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
  
  let decode () =
    let main_proc = decode_loop() in
    let d = get_car_triplet main_proc in
    let f = get_tag_triplet d in
    pc.(0) <- get_int_triplet f
  ;;
  




 let get_var opnd = 
  match opnd with 
  | Triplet _ -> get_car_triplet opnd
  | Int i -> get_car_triplet (list_tail ((sp.(0)),i))
  | _ -> fatal_error "get_var"
 end;;
 
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

let advance_pc = fun () -> 
  let tag = get_tag_triplet (Triplet (pc.(0))) in
  match tag with 
  | Int i -> pc.(0) <- stbl.(0)
  | Triplet t -> pc.(0) <- get_int_triplet tag
  | _ -> fatal_error "advance_pc"
end;;


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




(* RUN *)
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
            (* push_heap (get_rib (get_cont()));
            pc := !hp; *)
            
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
          (* besoin d'un endroit où la stocker car elle va etre modifié *)
          push_heap (Int nparams, Int 0, Int 0);
          let np = hp.(0) in
          (* ram.(p+1) <- (Int nparams, Int 0, Int 0); *)
          (* @@(feature arity-check *)
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
              (* build_rest nil_rib; *)
              push_heap nil_rib;
              rest_loop (Triplet ((hp.(0))),(nargs-nparams))
            );
            
            let new_cont = make_rib ((Int 0),(proc),(Int 0)) in
            push_heap new_cont;
            (* on garde le pointeur vers new-cont *)
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
                  (* jump *)
                  let k = get_cont() in
                  let (car, cdr, tag) = ram.(nc) in
                  ram.(nc) <- ((get_car_triplet k), cdr, (get_tag_triplet k))
                );
                print_value (get_tag_triplet (code));
                print_string "printed tag dfe code\n";
                pc.(0) <- get_int_triplet (get_tag_triplet (code));
                sp.(0) <- get_int_triplet (new_stack);
                (* ram.(!sp-1) <- get_rib (new_stack);
                sp := !sp -1; *)
              
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




(* let set_global (value:word) = 
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
set_global (Triplet (2));; *)

(* let (car, cdr, tag) = ram.(0) in ram.(0) <- (car, (Triplet (stbl.(0))), tag);; *)

(* setup_stack();; *)

(* run();;  *)

let main() = 
print_string "Compilation reussi, pas de bug dans la syntaxe "; print_newline();;


