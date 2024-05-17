# MU4IN508_PSTL
Ribbit sur FPGA avec Eclat

## Encadrants : Emmanuel Chailloux et Loïc Sylvestre

Etudiant 1 :  28705948   XU Marc  
Etudiant 2 :  28707630   Huynh Yok Yann  
Etudiant 3 :  21311739   Kessal Yacine  

La vm en OCaml se trouve dans ribbit-main/src/host/ml/rvm.ml  
La vm en Eclat se trouve dans ribbit-main/src/host/RibbitEclat  
Pour tester l'implémentaiton en OCaml écrite pour la version en Eclat (on supose être dans le dossier ribbit-main/src)

    $ ./rsc -t ml -o repl.ml repl.scm
    $ ocamlc -o repl repl.ml
    $ ./repl

Pour debug et avoir une trace de l'exécution du programme, il suffit de modifer la variable 
    let debug = ref true
    
Pour lancer tous les programmes du dossier 'tests': 
    $ ./tracing.sh
Les programmes tel que tests/50-repl.scm et tests/16-getchar.scm ne passent pas car ils ont besoin d'un input

