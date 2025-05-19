%option noyywrap
%{
#include "../header/table_des_symboles.h"
%}


CONSTANTE_ENTIER [0-9]+[lL]?
CONSTANTE_FLOAT ([0-9]+(\.[0-9]*)?|\.[0-9]+)([eE][+-]?[0-9]+)?[fFlL]?
CONSTANTE_CAR \'\\?[a-zA-Z]\'
VARIABLE (_|[a-zA-Z])([_a-zA-Z_0-9])*
BLANC [ \t\b\n]
COMMENTAIRE \/\*((\*+[^/])|[^\*])*\*+\/


%%


cin { return CIN;}
const { return CONST;}
cout { return COUT; }
else { return ELSE;}
if { return IF;}
typedef { return TYPEDEF;}
while { return WHILE;}

\+ { return PLUS; }
\- { return MINUS; }
\* { return MULT; }
\/ { return DIV; }
\% { return MODULO; }
\! { return NOT; }
\|\| { return DOUBLE_OR; }
\&\& { return DOUBLE_AND; }
\< { return LT; }
\<\= { return LE; }
\> { return GT; }
\>\= { return GE; }
\=\= { return EQUAL; }
\!\= { return NOT_EQUAL; }
\& { return AND; }
\| { return OR; }
\= { return SIMPLE_EQUAL; }
\<\< { return LEFT_DOUBLE_QUOTE; }
\>\> { return RIGHT_DOUBLE_QUOTE; }
\( { return LEFT_PARENTHESIS; }
\) { return RIGHT_PARENTHESIS; }
\[ { return LEFT_BRACKET; }
\] { return RIGHT_BRACKET; }
\{ { return LEFT_BRACE; }
\} { return RIGHT_BRACE; }
\, { return COMMA; }
\' { return SINGLE_QUOTE; }
\; { return SEMI_COLON; }
\" { return DOUBLE_QUOTE; }

{VARIABLE} { return IDENTIFIER; }
{CONSTANTE_ENTIER} { return CONSTANTE_ENTIER; }
{CONSTANTE_FLOAT} { return CONSTANTE_FLOAT; }
{CONSTANTE_CAR} { return CONSTANTE_CAR; }
{BLANC} {;}
{COMMENTAIRE} {;}

<<EOF>> { return END_OF_FILE; }

%%


void print_symbtab(ts *t) {
  printf("\n");
  printf("\t\t SYMBOL TABLE (%d symbol(s))\t\n", (*t).taille_table_symboles);
  printf("\t-------------------------------------------------\n");
  printf("\t|     index\t|\tsymbol\t\t\t|\n");

  printf("\t-------------------------------------------------\n");
  for (int i = 0; i < (*t).taille_table_symboles; i++) {
    printf("\t|\t%d\t|\t%s\t\t", i, (*t).table_symboles[i]);
    if (strlen((*t).table_symboles[i]) < 8) {
      printf("\t");
    }
    printf("|\n");
  }
  printf("\t-------------------------------------------------\n");
}

int estDansLaTableDesSymboles(ts t, char *symbole) {
  // Parcourir la table des symboles pour chercher si l'identiant y est déjà
  for (size_t i = 0; i < t.taille_table_symboles; i++) {
    if (!strcmp(*(t.table_symboles + i), symbole)) {
      return i;
    }
  }

  // Non trouvé
  return -1;
}

int main(int argc, char *argv[]) {

  // Vérifier le nombre d'argument
  assert(argc == 2);

  // Ouverture du fichier
  yyin = fopen(argv[1], "r");
  if (yyin == NULL) {
    fprintf(stderr, "Error fopen().");
    return EXIT_FAILURE;
  }

  // Table des symboles
  ts t;
  t.taille_table_symboles = 5;
  t.table_symboles = NULL;
  char *predefinis[5] = {"char", "int", "float", "void", "main"};

  // Allocation
  t.table_symboles = (char **)calloc(t.taille_table_symboles, sizeof(char *));
  assert(t.table_symboles != NULL);

  // Symboles prédéfinis
  for (size_t i = 0; i < 5; i++) {
    *(t.table_symboles + i) = predefinis[i];
  }

  // Commencer à 5 car 0-4 déjà pris
  int indice_trouve = 0;
  int token = 0;
  while ((token = yylex()) != END_OF_FILE) {

    // Cas où le token est un identifiant
    if (token == IDENTIFIER) {

      // Chercher s'il n'est pas déjà dans la table des symboles
      indice_trouve = estDansLaTableDesSymboles(t, yytext);

      // S'il n'est pas dans la table alors on l'ajoute via une allocation
      // dynamique
      if (indice_trouve == -1) {

        // Reallouer la mémoire
        t.table_symboles = (char **)realloc(
            t.table_symboles, ++(t.taille_table_symboles) * sizeof(char *));
        assert(t.table_symboles != NULL);

        // Allouer une place pour accueillir le nouveau identiant
        t.table_symboles[t.taille_table_symboles - 1] =
            (char *)calloc(strlen(yytext) + 1, sizeof(char));
        assert(t.table_symboles[t.taille_table_symboles - 1] != NULL);

        // Écriture de la chaîne pointée par yytext à la bonne place
        int n = snprintf(t.table_symboles[t.taille_table_symboles - 1],
                 strlen(yytext) + 1, "%s", yytext);
        assert(n >= 0 && n < strlen(yytext) + 1);
      }

      printf("Token %d \t[identifier]\t\t\tindex : %d\t=>\t\"%s\"\n", token,
             indice_trouve == -1 ? t.taille_table_symboles - 1 : indice_trouve,
             yytext);
    } else if (token >= CIN && token <= WHILE) {
      // Cas où le token est un symbole clé
      printf("Token %d \t[keyword]\t\t\t\"%s\"\n", token, yytext);
    } else if (token >= PLUS && token <= DOUBLE_QUOTE) {
      // Cas où token est un symbole non-alphanumérique
      printf("Token %d \t[non-alphanumeric symbol]\t\"%s\"\n", token, yytext);
    } else if (token == CONSTANTE_CAR || token == CONSTANTE_ENTIER || token == CONSTANTE_FLOAT) {
      // Cas où token est une constante
      printf("Token %d \t[constant]\t\t\t%s\n", token, yytext);
    }
  }

  // Afficher la table des symboles
  print_symbtab(&t);

  // Libérer la mémoire
  if (t.taille_table_symboles > 5) {
    for (size_t i = 5 ; i < t.taille_table_symboles;
         i++) {
      free(t.table_symboles[i]);
      t.table_symboles[i] = NULL;
    }
  }

  free(t.table_symboles);
  t.table_symboles = NULL;

  // Fermer le yyin
  if (fclose(yyin) != 0) {
    fprintf(stderr, "Error fopen().");
    return EXIT_FAILURE;
  }

  // Destruction yylex
  yylex_destroy();
  // Succès
  return EXIT_SUCCESS;
}
