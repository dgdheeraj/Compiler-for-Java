/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_NUM = 258,
    T_ID = 259,
    T_OParen = 260,
    T_CParen = 261,
    T_PUBLIC = 262,
    T_STATIC = 263,
    T_VOID = 264,
    T_STRING = 265,
    T_ARGS = 266,
    T_WHILE = 267,
    T_MAIN = 268,
    T_DO = 269,
    T_FOR = 270,
    T_IF = 271,
    T_ELSE = 272,
    T_INT = 273,
    T_CLASS = 274,
    T_IMPORT = 275,
    T_FLOAT = 276,
    T_CHAR = 277,
    T_CHARV = 278,
    T_U_INCR = 279,
    T_U_DECR = 280,
    T_S_PLUSEQ = 281,
    T_S_MINUSEQ = 282,
    T_S_MULTEQ = 283,
    T_S_DIVEQ = 284,
    TRUE = 285,
    FALSE = 286,
    T_S_DIV = 287,
    T_S_EQ = 288,
    T_GEQ = 289,
    T_LEQ = 290,
    T_LE = 291,
    T_GE = 292,
    T_ASSG = 293,
    T_NE = 294
  };
#endif
/* Tokens.  */
#define T_NUM 258
#define T_ID 259
#define T_OParen 260
#define T_CParen 261
#define T_PUBLIC 262
#define T_STATIC 263
#define T_VOID 264
#define T_STRING 265
#define T_ARGS 266
#define T_WHILE 267
#define T_MAIN 268
#define T_DO 269
#define T_FOR 270
#define T_IF 271
#define T_ELSE 272
#define T_INT 273
#define T_CLASS 274
#define T_IMPORT 275
#define T_FLOAT 276
#define T_CHAR 277
#define T_CHARV 278
#define T_U_INCR 279
#define T_U_DECR 280
#define T_S_PLUSEQ 281
#define T_S_MINUSEQ 282
#define T_S_MULTEQ 283
#define T_S_DIVEQ 284
#define TRUE 285
#define FALSE 286
#define T_S_DIV 287
#define T_S_EQ 288
#define T_GEQ 289
#define T_LEQ 290
#define T_LE 291
#define T_GE 292
#define T_ASSG 293
#define T_NE 294

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 63 "java-yacc.y" /* yacc.c:1909  */

    	float number;
        //float num;
    	char *string;
	struct node *tree;
//    	bool *boo;   	 

#line 140 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
