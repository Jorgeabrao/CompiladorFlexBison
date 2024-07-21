%{
#include "sin.tab.h"
#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>

int line_num = 1;
int col_num = 1;

void update_position(const char *text);


%}

digit       [0-9]
letter      [A-Za-z]
symbol      [~`!@#$%^&*()_\-+=\\/\[\]|'?><.,:]
whitespace  [ \t\r]

%%

"inicioprog"      { yylval.str = strdup(yytext);update_position(yytext);return INICIOPROG;}
"fimprog"         { yylval.str = strdup(yytext);update_position(yytext);return FIMPROG;}
"inicioargs"      { yylval.str = strdup(yytext);update_position(yytext);return INICIOARGS;}
"fimargs"         { yylval.str = strdup(yytext);update_position(yytext);return FIMARGS;}
"iniciovars"      { yylval.str = strdup(yytext);update_position(yytext);return INICIOVARS;}
"fimvars"         { yylval.str = strdup(yytext);update_position(yytext);return FIMVARS;}
"escreva"         { yylval.str = strdup(yytext);update_position(yytext);return ESCREVA;}
"inteiro"         { yylval.str = strdup(yytext);update_position(yytext);return INTEIRO;}
"real"            { yylval.str = strdup(yytext);update_position(yytext);return REAL;}
"literal"         { yylval.str = strdup(yytext);update_position(yytext);return LITERAL;}
"se"              { yylval.str = strdup(yytext);update_position(yytext);return SE;}
"entao"           { yylval.str = strdup(yytext);update_position(yytext);return ENTAO;}
"fimse"           { yylval.str = strdup(yytext);update_position(yytext);return FIMSE;}
"enquanto"        { yylval.str = strdup(yytext);update_position(yytext);return ENQUANTO;}
"faca"            { yylval.str = strdup(yytext);update_position(yytext);return FACA;}
"fimenquanto"     { yylval.str = strdup(yytext);update_position(yytext);return FIMENQUANTO;}

\n                { line_num++; col_num = 1; }

{letter}({letter}|{digit}|_)*   {
 yylval.str = strdup(yytext);
 update_position(yytext);
 return IDENTIFICADOR; 
}
{digit}+ {
 yylval.str = strdup(yytext);
 update_position(yytext);
 return NUMERO; 
}
{digit}+(\.{digit}+)?(E|e+|-?{digit}+)? {
 yylval.str = strdup(yytext);
 update_position(yytext);
 return REAL;
}
\"({letter}|{digit}|{symbol}|{whitespace}|;)*\"  { 
 yylval.str = strdup(yytext);
 update_position(yytext);
 return LITERAL_CONST; 
}
"<"  { yylval.str = strdup(yytext);update_position(yytext); return OP_RELACIONAL; }
">"  { yylval.str = strdup(yytext);update_position(yytext); return OP_RELACIONAL; }
">=" { yylval.str = strdup(yytext);update_position(yytext); return OP_RELACIONAL; }
"<=" { yylval.str = strdup(yytext);update_position(yytext); return OP_RELACIONAL; }
"==" { yylval.str = strdup(yytext);update_position(yytext); return OP_RELACIONAL; }
"<>" { yylval.str = strdup(yytext);update_position(yytext); return OP_RELACIONAL; }
"+"  { yylval.str = strdup(yytext);update_position(yytext); return OP_ARITMETICO; }
"-"  { yylval.str = strdup(yytext);update_position(yytext); return OP_ARITMETICO; }
"*"  { yylval.str = strdup(yytext);update_position(yytext); return OP_ARITMETICO; }
"/"  { yylval.str = strdup(yytext);update_position(yytext); return OP_ARITMETICO; }
"="  { yylval.str = strdup(yytext);update_position(yytext); return ATRIBUICAO; }
"\(" { yylval.str = strdup(yytext);update_position(yytext); return ABRE_PAR; }
"\)" { yylval.str = strdup(yytext);update_position(yytext); return FECHA_PAR; }
","  { yylval.str = strdup(yytext);update_position(yytext); return VIRGULA; }
";"  { yylval.str = strdup(yytext);update_position(yytext); return PONTO_E_VIRG; }
{whitespace}+ { /* Ignora espaços em branco */ }
"{"({letter}|{digit}|{symbol}|{whitespace}|;)*"}" { /* Ignora comentários */ }
<<EOF>> {return FIM_DE_ARQ;}
.  { printf("Invalid token:%s\n", yytext);return ERRO; }

%%

void update_position(const char *text) {
    int length = strlen(text);
    for (int i = 0; i < length; i++) {
        if (text[i] == '\n') {
            line_num++;
            col_num = 1;
        } else {
            col_num++;
        }
    }
}

int yywrap() {}