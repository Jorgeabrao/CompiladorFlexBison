%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "symbol_table.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);
int numType(char *num);
int checkType(const char *name, const char *encounteredType);
int idsCheckType(const char *name, const char *name2);
void idsMathCheck(char *ar1, char *ar2, char *op);

char *aux[10];
int i = 0;
SymbolTable *symTable;
int error = 0;

extern int line_num;
extern int col_num;

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

%verbose
%start programa

%%

programa:
    INICIOPROG args {return 0;}
    ;

args:
    INICIOARGS listavars FIMARGS args
    | codigo
    ;

codigo:
    INICIOVARS listavars FIMVARS restante
    ;

listavars:
    LITERAL IDENTIFICADOR PONTO_E_VIRG listavars 
    {if((searchSymbol(symTable, $2))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $2);
        error++;
    }else{
        insertSymbol(symTable, $2, $1);
    };}
    | INTEIRO IDENTIFICADOR PONTO_E_VIRG listavars
    {if((searchSymbol(symTable, $2))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $2);
        error++;
    }else{
        insertSymbol(symTable, $2, $1);
    };}
    | REAL IDENTIFICADOR PONTO_E_VIRG listavars
    {if((searchSymbol(symTable, $2))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $2);
        error++;
    }else{
        insertSymbol(symTable, $2, $1);
    };}
    | LITERAL IDENTIFICADOR VIRGULA listavars
    {if((searchSymbol(symTable, $2))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $2);
        error++;
    }else{
        insertSymbol(symTable, $2, $1);
        while(i>=1){
            i--;
            updateSymbolType(symTable, aux[i], $1);
        }
    };}
    | INTEIRO IDENTIFICADOR VIRGULA listavars
    {if((searchSymbol(symTable, $2))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $2);
        error++;
    }else{
        insertSymbol(symTable, $2, $1);
        while(i>=1){
            i--;
            updateSymbolType(symTable, aux[i], $1);
        }
    };}
    | REAL IDENTIFICADOR VIRGULA listavars
    {if((searchSymbol(symTable, $2))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $2);
        error++;
    }else{
        insertSymbol(symTable, $2, $1);
        while(i>=1){
            i--;
            updateSymbolType(symTable, aux[i], $1);
        }
    };}
    | IDENTIFICADOR VIRGULA listavars
    {if((searchSymbol(symTable, $1))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $1);
        error++;
    }else{
        aux[i] = $1;
        i++;
        insertSymbol(symTable, $1, NULL);
    };}
    | IDENTIFICADOR PONTO_E_VIRG listavars
    {if((searchSymbol(symTable, $1))==1){ 
        printf("Error:%d:%d: Identificador \"%s\" já declarado anteriormente\n",line_num, col_num, $1);
        error++;
    }else{
        aux[i] = $1;
        i++;
        insertSymbol(symTable, $1, NULL);
    };}
    | args
    | 
    ;

restante:
    
    |IDENTIFICADOR ATRIBUICAO LITERAL_CONST PONTO_E_VIRG restante {if(checkType($1, "literal") == 0) updateSymbolValue(symTable, $1, $3);}
    | IDENTIFICADOR ATRIBUICAO NUMERO PONTO_E_VIRG restante {if(checkType($1, "inteiro") == 0 && numType($3) == 1){ 
        updateSymbolValue(symTable, $1, $3)
        ;}else{
            error++;
            printf("Erro:%d:%d: Tipo de '%s' esperado: 'inteiro', mas %s é: 'real'\n", line_num, col_num, $1, $3);
        }}
    | IDENTIFICADOR ATRIBUICAO REAL PONTO_E_VIRG restante {if(checkType($1, "real") == 0 && numType($3) == 0){ 
        updateSymbolValue(symTable, $1, $3)
        ;}else{
            error++;
            printf("Erro:%d:%d: Tipo de '%s' esperado: 'real', mas %s é: 'inteiro'\n", line_num, col_num, $1, $3);
        }}
    | IDENTIFICADOR ATRIBUICAO IDENTIFICADOR PONTO_E_VIRG restante {if(idsCheckType($1, $3) == 0) updateSymbolValue(symTable, $1, searchSymbolValue(symTable, $3));}
    | IDENTIFICADOR ATRIBUICAO IDENTIFICADOR OP_ARITMETICO IDENTIFICADOR PONTO_E_VIRG restante{idsMathCheck($3, $5, $4);}
    | IDENTIFICADOR ATRIBUICAO IDENTIFICADOR OP_ARITMETICO NUMERO PONTO_E_VIRG restante 
    | IDENTIFICADOR ATRIBUICAO NUMERO OP_ARITMETICO IDENTIFICADOR PONTO_E_VIRG restante 
    | IDENTIFICADOR ATRIBUICAO NUMERO OP_ARITMETICO NUMERO PONTO_E_VIRG restante
    | SE ABRE_PAR cond FECHA_PAR ENTAO restante FIMSE restante
    | ENQUANTO ABRE_PAR cond FECHA_PAR FACA restante FIMENQUANTO restante
    | ESCREVA LITERAL_CONST PONTO_E_VIRG restante
    | ESCREVA IDENTIFICADOR PONTO_E_VIRG restante
    | FIMPROG eof
    ;

cond:
    IDENTIFICADOR OP_RELACIONAL IDENTIFICADOR {idsCheckType($1, $3);}
    | NUMERO OP_RELACIONAL NUMERO
    | LITERAL_CONST OP_RELACIONAL LITERAL_CONST 
    | NUMERO OP_RELACIONAL IDENTIFICADOR
    | LITERAL OP_RELACIONAL IDENTIFICADOR
    | IDENTIFICADOR OP_RELACIONAL NUMERO 
    | IDENTIFICADOR OP_RELACIONAL LITERAL_CONST
    ;

eof:
    FIM_DE_ARQ
    ;

%%

void yyerror(const char *s) {
    printf("Erro de sintaxe na linha %d, coluna %d: %s\n", line_num, col_num, s);
}

int checkType(const char *name, const char *encounteredType) {
    char *c = searchSymbolType(symTable, name);
    if(strcmp(c,"real") == 0 && strcmp(encounteredType,"inteiro") == 0 ){
        return 0;
    }
    if(strcmp(c,"Não encontrado") == 0){
        error++;
        printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, name);
        return 1;
    }
    if(strcmp(c, encounteredType) == 0){
        return 0;
    }else{
        error++;
        printf("Erro:%d:%d: Tipo de '%s' esperado: '%s', mas encontrado: '%s'\n", line_num, col_num, name, c, encounteredType);
        return 2;
    }
}

int idsCheckType(const char *name, const char *name2) {
    char *c = searchSymbolType(symTable, name);
    char *t = searchSymbolType(symTable, name2);
    if(strcmp(c,"Não encontrado") == 0 || strcmp(t,"Não encontrado") == 0){
        if(strcmp(c,"Não encontrado") == 0){
            error++;
            printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, name);
        }
        if(strcmp(t,"Não encontrado") == 0){
            error++;
            printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, name2);
        }
        return 1;
    }
    if(strcmp(c, t) == 0){
        return 0;
    }else{
        error++;
        printf("Erro:%d:%d: Tipo de '%s' esperado: '%s', mas '%s' possui tipo: '%s'\n", line_num, col_num, name, c, name2, t);
        return 2;
    }
}

void idsMathCheck(char *ar1, char *ar2, char *op){
    char *c = searchSymbolType(symTable, ar1);
    char *t = searchSymbolType(symTable, ar2);
    if(strcmp(c,"Não encontrado") == 0 || strcmp(t,"Não encontrado") == 0){
        if(strcmp(c,"Não encontrado") == 0){
            error++;
            printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, ar1);
        }
        if(strcmp(t,"Não encontrado") == 0){
            error++;
            printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, ar2);
        }
        return;
    }
    if(strcmp(c, t) != 0){
        error++;
        printf("Erro:%d:%d: Tipo de '%s' esperado: '%s' para realizar a operação: '%s', mas '%s' possui tipo: '%s'\n", line_num, col_num, ar1, c, op, ar2, t);
        return;
    }else{
        if(strcmp(op,"/") == 0){
            if(strcmp(t,"0") == 0 || strcmp(t,"0.0") == 0 ){
                printf("Erro:%d:%d: Divisão por 0 detectada em:'%s'/'%s'\n", line_num, col_num, ar1, ar2);
            }
            return;
        }
    }
}

int numType(char *num){
    int i = 0;
    if (num[0] == '-' || num[0] == '+') {
        i = 1;
    }
    for (; num[i] != '\0'; i++) {
        if (!isdigit(num[i])) {
            return 0;
        }
    }
    return 1;
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
    }
    else { //yyparse()==1 - could not complete parsing
        printf("Syntax analyzer failed\n");
        fclose(yyin); // close input file
        printf("File closed succesfully\n");
    }

    printSymbolTable(symTable);
    freeSymbolTable(symTable);

    return 0;
}
