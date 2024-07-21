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

"inicioprog"      { return INICIOPROG;}
"fimprog"         { return FIMPROG;}
"inicioargs"      { return INICIOARGS;}
"fimargs"         { return FIMARGS;}
"iniciovars"      { return INICIOVARS;}
"fimvars"         { return FIMVARS;}
"escreva"         { return ESCREVA;}
"inteiro"         { return INTEIRO;}
"real"            { return REAL;}
"literal"         { return LITERAL;}
"se"              { return SE;}
"entao"           { return ENTAO;}
"fimse"           { return FIMSE;}
"enquanto"        { return ENQUANTO;}
"faca"            { return FACA;}
"fimenquanto"     { return FIMENQUANTO;}

{letter}({letter}|{digit}|_)*   {
    yylval.str = strdup(yytext);
 return IDENTIFICADOR; 
}
{digit}+(\.{digit}+)?(E|e+|-?{digit}+)? {
    yylval.str = strdup(yytext);
 return NUMERO; 
}
\"({letter}|{digit}|{symbol}|{whitespace})*\"  { 
    yylval.str = strdup(yytext);
 return LITERAL_CONST; 
}
"<"  { return OP_RELACIONAL; }
">"  { return OP_RELACIONAL; }
">=" { return OP_RELACIONAL; }
"<=" { return OP_RELACIONAL; }
"==" { return OP_RELACIONAL; }
"<>" { return OP_RELACIONAL; }
"+"  { return OP_ARITMETICO; }
"-"  { return OP_ARITMETICO; }
"*"  { return OP_ARITMETICO; }
"/"  { return OP_ARITMETICO; }
"="  { return ATRIBUICAO; }
"\(" { return ABRE_PAR; }
"\)" { return FECHA_PAR; }
","  { return VIRGULA; }
";"  { return PONTO_E_VIRG; }
{whitespace}+ { /* Ignora espaços em branco */ }
"{"({letter}|{digit}|{symbol}|{whitespace})*"}" { /* Ignora comentários */ }
<<EOF>> {return FIM_DE_ARQ;}
.  { printf("%s\n", yytext);return ERRO; }

%%
yywrap() {}