#!/bin/bash

# Définition du chemin vers le dossier de tests
TEST_DIR="tests"

# Création du dossier pour les traces s'il n'existe pas déjà
mkdir -p trace

# Parcours des fichiers de test dans le dossier TEST_DIR
for test_file in "$TEST_DIR"/*.scm; do
    # Récupération du nom de fichier sans extension
    file_name=$(basename "$test_file" .scm)

    # Vérifier si le nom de fichier commence par un chiffre
    if [[ $file_name =~ ^[0-9] ]]; then
        echo "Processing $file_name..."
        # Séparation du numéro de test et du nom du fichier
        file_number=$(echo "$file_name" | cut -d'-' -f1)
        file_name_only=$(echo "$file_name" | cut -d'-' -f2)

        # Exécution de la première commande
        ./rsc -t ml -l max "$test_file" 
        echo "Generated .ml file"
        # Renommage du fichier .ml généré en respectant le format "nom99.ml"
        mv "${test_file}.ml" "${TEST_DIR}/${file_name_only}${file_number}.ml"
        echo "File renamed"

        # Compilation du fichier .ml généré
        ocamlc -o "execs/${file_name}" "${TEST_DIR}/${file_name_only}${file_number}.ml"
        echo "Compiled"
        # Exécution du fichier compilé et redirection de la sortie vers le dossier trace
        "./execs/${file_name}" > "trace/${file_name}" &
        echo -e "Executed\n"

    else
        echo "Skipping $file_name (does not start with a number)"
    fi
done
