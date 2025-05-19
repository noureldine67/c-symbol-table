#ifndef __TABLE_DES_SYMBOLES_H__
#define __TABLE_DES_SYMBOLES_H__

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define IDENTIFIER 100
#define CONSTANTE_ENTIER 200
#define CONSTANTE_FLOAT 201
#define CONSTANTE_CAR 202
#define END_OF_FILE -1

typedef struct ts ts;

struct ts {
  char **table_symboles;
  int taille_table_symboles;
};

typedef enum { CIN = 1, CONST, COUT, ELSE, IF, TYPEDEF, WHILE } KEYWORD;

typedef enum {
  PLUS = 10,
  MINUS,
  MULT,
  DIV,
  MODULO,
  NOT,
  DOUBLE_OR,
  DOUBLE_AND,
  LT,
  LE,
  GT,
  GE,
  EQUAL,
  NOT_EQUAL,
  LEFT_DOUBLE_QUOTE,
  RIGHT_DOUBLE_QUOTE,
  AND,
  OR,
  SIMPLE_EQUAL,
  LEFT_PARENTHESIS,
  RIGHT_PARENTHESIS,
  LEFT_BRACKET,
  RIGHT_BRACKET,
  LEFT_BRACE,
  RIGHT_BRACE,
  COMMA,
  SINGLE_QUOTE,
  SEMI_COLON,
  DOUBLE_QUOTE
} SYMBOL;

#endif // !__TABLE_DES_SYMBOLES_H__
