# Analyseur Lexical C- avec Table des Symboles

## Objectif

Ce projet implémente un analyseur lexical pour un sous-ensemble du langage C++ appelé C-. Il utilise Lex pour identifier les unités lexicales et construire une table des symboles.

## Fonctionnement

L’analyseur lexical lit un fichier source et extrait :

* Les mots-clés : `cin`, `const`, `cout`, `else`, `if`, `typedef`, `while`
* Les symboles non alphanumériques : `+`, `-`, `*`, `/`, `==`, `!=`, etc.
* Les identificateurs (noms de variables, fonctions, etc.)
* Les constantes : entières, flottantes, caractères
* Il ignore les espaces, sauts de ligne et commentaires (`/* ... */`)

## Table des symboles

Les identificateurs sont enregistrés dans une table des symboles. Une entrée est ajoutée uniquement si l’identifiant n’y est pas déjà. Les identificateurs prédéfinis (`char`, `int`, `float`, `void`, `main`) sont chargés au début.

## Sortie

Pour chaque token reconnu, le programme affiche son type et sa valeur. À la fin, il affiche la table des symboles.