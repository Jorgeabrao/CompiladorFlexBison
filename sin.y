%{
#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

SymbolTable *symTable;
%}

%union {
    char *str;
    int num;
}

%token <str>  INICIOPROG FIMPROG INICIOARGS FIMARGS
%token <str>  INICIOVARS FIMVARS ESCREVA INTEIRO
%token <str>  REAL LITERAL SE ENTAO FIMSE
%token <str>  ENQUANTO FACA FIMENQUANTO IDENTIFICADOR
%token <str>  NUMERO OP_RELACIONAL OP_ARITMETICO
%token <str>  ATRIBUICAO ABRE_PAR FECHA_PAR LITERAL_CONST
%token <str>  VIRGULA PONTO_E_VIRG FIM_DE_ARQ ERRO

%start programa

%%

programa:
    INICIOPROG args{printf("oi\n"); }
    ;

args:
    INICIOARGS listavars FIMARGS args
    | codigo
    ;

codigo:
    INICIOVARS listavars FIMVARS restante
    | error
    ;

listavars:
    LITERAL IDENTIFICADOR PONTO_E_VIRG listavars
    | INTEIRO IDENTIFICADOR PONTO_E_VIRG listavars
    | 
    ;

restante:
    IDENTIFICADOR ATRIBUICAO LITERAL_CONST PONTO_E_VIRG restante
    | IDENTIFICADOR ATRIBUICAO NUMERO PONTO_E_VIRG restante
    | SE ABRE_PAR cond FECHA_PAR ENTAO restante FIMSE restante
    | ENQUANTO ABRE_PAR cond FECHA_PAR FACA restante FIMENQUANTO restante
    | ESCREVA LITERAL_CONST PONTO_E_VIRG restante
    | ESCREVA IDENTIFICADOR PONTO_E_VIRG restante
    | FIMPROG eof
    | 
    ;

cond:
    IDENTIFICADOR OP_RELACIONAL IDENTIFICADOR
    | NUMERO OP_RELACIONAL NUMERO
    | LITERAL_CONST OP_RELACIONAL LITERAL_CONST
    | NUMERO OP_RELACIONAL IDENTIFICADOR
    | LITERAL OP_RELACIONAL IDENTIFICADOR
    | IDENTIFICADOR OP_RELACIONAL NUMERO
    | IDENTIFICADOR OP_RELACIONAL LITERAL_CONST
    ;

eof:
    FIM_DE_ARQ {return 0;}
    | error eof {yyerrok;}
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "line %s\n", s);
}

int main(int argc, char **argv) {
    int out;
    symTable = createSymbolTable();

    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
        if (yyin == NULL) {
            printf("File not found!\n");
            exit(1);
        }
    }
    out=yyparse();

    if(!out) {// yyparse == 0 - parsing completed
    printf("Syntax analyzer finished succesfully.\n");
    fclose(yyin);
    printf("File closed succesfully\n");
    return(0);
    }
    else { //yyparse()==1 - could not complete parsing
        printf("Syntax analyzer failed\n");
        fclose(yyin); // close input file
        printf("File closed succesfully\n");
        return(1);
    }

    printSymbolTable(symTable);

    return 0;
}
