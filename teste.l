%{
#include <stdio.h>
#include <stdlib.h>
#include "sin.tab.h"
#include "symbol_table.h"

SymbolTable *symTable;

%}

digit       [0-9]
letter      [a-zA-Z]
symbol      [!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]
whitespace  [ \t\n\r]

%%

"inicioprog"      { printf("inicio"); return  INICIOPROG; }
"fimprog"         { printf("fim"); return  FIMPROG; }
"inicioargs"      { printf("Iargs"); return  INICIOARGS; }
"fimargs"         { printf("Fargs"); return  FIMARGS; }
"iniciovars"      { printf("Ivars"); return  INICIOVARS; }
"fimvars"         { printf("Fvars"); return  FIMVARS; }
"escreva"         { printf("esc"); return  ESCREVA; }
"inteiro"         { printf("int"); return  INTEIRO; }
"real"            { printf("real"); return  REAL; }
"literal"         { printf("lit"); return  LITERAL; }
"se"              { printf("se"); return  SE; }
"entao"           { printf("ent"); return  ENTAO; }
"fimse"           { printf("Fse"); return  FIMSE; }
"enquanto"        { printf("enq"); return  ENQUANTO; }
"faca"            { printf("fac"); return  FACA; }
"fimenquanto"     { printf("Fenq"); return  FIMENQUANTO; }

{letter}({letter}|{digit}|_)*   { 
    printf("Id"); return  IDENTIFICADOR; 
}
{digit}+(\.{digit}+)?(E|e+|-?{digit}+)? { 
    printf("num"); return  NUMERO; 
}
\"({letter}|{digit}|{symbol}|{whitespace})*\"  { 
    printf("Clit"); return  LITERAL; 
}
"<"  { return  OP_RELACIONAL; }
">"  { return  OP_RELACIONAL; }
">=" { return  OP_RELACIONAL; }
"<=" { return  OP_RELACIONAL; }
"==" { return  OP_RELACIONAL; }
"<>" { return  OP_RELACIONAL; }
"+"  { return  OP_ARITMETICO; }
"-"  { return  OP_ARITMETICO; }
"*"  { return  OP_ARITMETICO; }
"/"  { return  OP_ARITMETICO; }
"="  { printf("="); return  ATRIBUICAO; }
"\(" { return  ABRE_PAR; }
"\)" { return  FECHA_PAR; }
","  { return  VIRGULA; }
";"  { printf(";"); return  PONTO_E_VIRG; }
{whitespace}+ { /* Ignora espaços em branco */ }
"{"({letter}|{digit}|{symbol}|{whitespace})*"}" { /* Ignora comentários */ }
<<EOF>> {printf("EOF"); return  FIM_DE_ARQ; }
.  {printf("forget"); return  ERRO; }

%%

int main(int argc, char **argv) {
    symTable = createSymbolTable();

    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }
    int token;
    do {
        token = yylex();
        printf("token exit code = %d, lexeme = \"%s\"\n", token, yytext);
    }   while (token !=  FIM_DE_ARQ);

    printSymbolTable(symTable);

    return 0;
}