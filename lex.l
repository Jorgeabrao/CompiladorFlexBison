%{
#include "sin.tab.h"
#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>

SymbolTable *symTable;

%}

digit       [0-9]
letter      [A-Za-z]
symbol      [~`!@#$%^&*()_\-+=\\/\[\]|'?><.,]
whitespace  [ \t\r\n]

%%

"inicioprog"      { printf("%s\n", yytext);return INICIOPROG;}
"fimprog"         { printf("%s\n", yytext);return FIMPROG;}
"inicioargs"      { printf("%s\n", yytext);return INICIOARGS;}
"fimargs"         { printf("%s\n", yytext);return FIMARGS;}
"iniciovars"      { printf("%s\n", yytext);return INICIOVARS;}
"fimvars"         { printf("%s\n", yytext);return FIMVARS;}
"escreva"         { printf("%s\n", yytext);return ESCREVA;}
"inteiro"         { printf("%s\n", yytext);return INTEIRO;}
"real"            { printf("%s\n", yytext);return REAL;}
"literal"         { printf("%s\n", yytext);return LITERAL;}
"se"              { printf("%s\n", yytext);return SE;}
"entao"           { printf("%s\n", yytext);return ENTAO;}
"fimse"           { printf("%s\n", yytext);return FIMSE;}
"enquanto"        { printf("%s\n", yytext);return ENQUANTO;}
"faca"            { printf("%s\n", yytext);return FACA;}
"fimenquanto"     { printf("%s\n", yytext);return FIMENQUANTO;}

{letter}({letter}|{digit}|_)*   {
    yylval.str = strdup(yytext);
    printf("%s\n", yytext);return IDENTIFICADOR; 
}
{digit}+(\.{digit}+)?(E|e+|-?{digit}+)? {
    yylval.str = strdup(yytext);
    printf("%s\n", yytext);return NUMERO; 
}
\"({letter}|{digit}|{symbol}|{whitespace})*\"  { 
    yylval.str = strdup(yytext);
    printf("%s\n", yytext);return LITERAL_CONST; 
}
"<"  { printf("%s\n", yytext);return OP_RELACIONAL; }
">"  { printf("%s\n", yytext);return OP_RELACIONAL; }
">=" { printf("%s\n", yytext);return OP_RELACIONAL; }
"<=" { printf("%s\n", yytext);return OP_RELACIONAL; }
"==" { printf("%s\n", yytext);return OP_RELACIONAL; }
"<>" { printf("%s\n", yytext);return OP_RELACIONAL; }
"+"  { printf("%s\n", yytext);return OP_ARITMETICO; }
"-"  { printf("%s\n", yytext);return OP_ARITMETICO; }
"*"  { printf("%s\n", yytext);return OP_ARITMETICO; }
"/"  { printf("%s\n", yytext);return OP_ARITMETICO; }
"="  { printf("%s\n", yytext);return ATRIBUICAO; }
"\(" { printf("%s\n", yytext);return ABRE_PAR; }
"\)" { printf("%s\n", yytext);return FECHA_PAR; }
","  { printf("%s\n", yytext);return VIRGULA; }
";"  { printf("%s\n", yytext);return PONTO_E_VIRG; }
{whitespace}+ { /* Ignora espaços em branco */ }
"{"({letter}|{digit}|{symbol}|{whitespace})*"}" { /* Ignora comentários */ }
<<EOF>> { printf("EOF\n"); return FIM_DE_ARQ;}
.  { printf("%s\n", yytext);return ERRO; }

%%
yywrap() {}