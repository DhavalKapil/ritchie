%{
/* need this for the call to atof() below */
#include <math.h>
#include "ritchie.tab.h" /* Generated by bison. */
#include "ritc.h"

//#define YY_DECL extern int yylex ( YYSTYPE * lvalp, YYLTYPE * llocp, yyscan_t scanner )
%}

%option bison-bridge bison-locations

alphabetic    [a-zA-Z]
numeral       [0-9]
alphanumeric  {alphabetic}|{numeral}
integer       {numeral}+
float         {numeral}+"."{numeral}*
identifier    {alphabetic}{alphanumeric}*

mathOp        "+"|"-"|"*"|"/"|"^^"
assignment    "="

%%

{integer}     { yylval->ival = atoi(yytext); return INT; }
{float}       { yylval->fval = atof(yytext); return FLOAT; }
{mathOp}      { yylval->sval = strdup(yytext);
                return MATH_OP; }
{identifier}  { yylval->sval = strdup(yytext);
                if (getFunctionType(yytext)!=0)
                  return VERB;
                if (getTypeParent(yytext)!=0)
                  return TYPE;
                /* Should this check if the variable is already defined? */
                return IDENT;
              }
{assignment}  { yylval->sval = strdup(yytext);
                return ASSIGNMENT; }
[\n]          return ENDOFLINE;
<<EOF>>       return ENDOFFILE;
[ \t]+        /* eat up whitespace */
"("           return LPAREN;
")"           return RPAREN;
.             /* do nothing? */
%%

