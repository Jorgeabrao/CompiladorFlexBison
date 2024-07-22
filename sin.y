%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);
int checkType(const char *name, char *encounteredType);
int idsCheckType(const char *name, const char *name2);
char* mathCheck(char *ar1, char *ar2, char *op, char *ar2type);
char* idMathCheck(char *ar1, char *ar2, char *op, char *ar2type);
char* idsMathCheck(char *ar1, char *ar2, char *op);

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
    
    | restante IDENTIFICADOR ATRIBUICAO LITERAL_CONST PONTO_E_VIRG {if(checkType($2, "literal") == 0) updateSymbolValue(symTable, $2, $4);}
    | restante IDENTIFICADOR ATRIBUICAO NUMERO PONTO_E_VIRG {if(checkType($2, "inteiro") == 0) updateSymbolValue(symTable, $2, $4);}
    | restante IDENTIFICADOR ATRIBUICAO REAL PONTO_E_VIRG {if(checkType($2, "real") == 0) updateSymbolValue(symTable, $2, $4);}
    | restante IDENTIFICADOR ATRIBUICAO IDENTIFICADOR PONTO_E_VIRG {if(idsCheckType($2, $4) == 0) updateSymbolValue(symTable, $2, searchSymbolValue(symTable, $4));}
    | restante IDENTIFICADOR ATRIBUICAO IDENTIFICADOR OP_ARITMETICO IDENTIFICADOR PONTO_E_VIRG{if(checkType($2, idsMathCheck($4, $6, $5)) == 0) updateSymbolValue(symTable, $2, searchSymbolValue(symTable, $4));}
    | restante IDENTIFICADOR ATRIBUICAO IDENTIFICADOR OP_ARITMETICO NUMERO PONTO_E_VIRG {if(checkType($2, idMathCheck($4, $6, $5, "inteiro")) == 0) updateSymbolValue(symTable, $2, searchSymbolValue(symTable, $4));}
    | restante IDENTIFICADOR ATRIBUICAO IDENTIFICADOR OP_ARITMETICO REAL PONTO_E_VIRG {if(checkType($2, idMathCheck($4, $6, $5, "inteiro")) == 0) updateSymbolValue(symTable, $2, searchSymbolValue(symTable, $4));}
    | restante IDENTIFICADOR ATRIBUICAO IDENTIFICADOR OP_ARITMETICO LITERAL_CONST PONTO_E_VIRG {error++; printf("Error:%d:%d: %s não aceita operadores literais", line_num, col_num, $5);}
    | restante IDENTIFICADOR ATRIBUICAO NUMERO OP_ARITMETICO IDENTIFICADOR PONTO_E_VIRG {if(idMathCheck($6, $4, $5, "inteiro"))}
    | restante IDENTIFICADOR ATRIBUICAO REAL OP_ARITMETICO IDENTIFICADOR PONTO_E_VIRG {if(idMathCheck($6, $4, $5, "real"))}
    | restante IDENTIFICADOR ATRIBUICAO NUMERO OP_ARITMETICO NUMERO PONTO_E_VIRG
    | restante SE ABRE_PAR cond FECHA_PAR ENTAO restante FIMSE
    | restante ENQUANTO ABRE_PAR cond FECHA_PAR FACA restante FIMENQUANTO
    | restante ESCREVA LITERAL_CONST PONTO_E_VIRG 
    | restante ESCREVA IDENTIFICADOR PONTO_E_VIRG
    | FIMPROG eof
    ;

cond:
    IDENTIFICADOR OP_RELACIONAL IDENTIFICADOR {idsCheckType($1, $3);}
    | NUMERO OP_RELACIONAL NUMERO
    | LITERAL_CONST OP_RELACIONAL LITERAL_CONST
    | REAL OP_RELACIONAL REAL
    | NUMERO OP_RELACIONAL REAL {error++; printf("Erro:%d:%d: Tipo de '%s' esperado: 'inteiro', mas '%s' é: 'real'\n", line_num, col_num, $1, $3);}
    | NUMERO OP_RELACIONAL IDENTIFICADOR {checkType($3, "inteiro");}
    | REAL OP_RELACIONAL IDENTIFICADOR {checkType($3, "real");}
    | LITERAL OP_RELACIONAL IDENTIFICADOR {checkType($3, "literal");}
    | IDENTIFICADOR OP_RELACIONAL NUMERO {checkType($1, "inteiro");}
    | IDENTIFICADOR OP_RELACIONAL LITERAL_CONST {checkType($1, "literal");}
    | IDENTIFICADOR OP_RELACIONAL REAL {checkType($1, "real");}
    ;

eof:
    FIM_DE_ARQ
    ;

%%

void yyerror(const char *s) {
    printf("Erro de sintaxe na linha %d, coluna %d: %s\n", line_num, col_num, s);
}

int checkType(const char *name, char *encounteredType) {
    char *c = searchSymbolType(symTable, name);
    if(strcmp(c,"error") == 0){
        error++;
        return 1;
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

char* idsMathCheck(char *ar1, char *ar2, char *op){
    char *c = searchSymbolType(symTable, ar1);
    char *t = searchSymbolType(symTable, ar2);
    char *c1 = searchSymbolValue(symTable, ar1);
    char *t1 = searchSymbolValue(symTable, ar2);
    if(strcmp(c,"Não encontrado") == 0 || strcmp(t,"Não encontrado") == 0){
        if(strcmp(c,"Não encontrado") == 0){
            error++;
            printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, ar1);
        }
        if(strcmp(t,"Não encontrado") == 0){
            error++;
            printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, ar2);
        }
        return "error";
    }
    if(strcmp(c, t) != 0){
        error++;
        printf("Erro:%d:%d: Tipo de '%s' esperado: '%s' para realizar a operação: '%s', mas '%s' possui tipo: '%s'\n", line_num, col_num, ar1, c, op, ar2, t);
        return "error";
    }else{
        if(strcmp(op,"/") == 0){
            if(strcmp(t1,"0") == 0 || strcmp(t1,"0.0") == 0 ){
                error++;
                printf("Erro:%d:%d: Divisão por 0 detectada em: %s/%s\n", line_num, col_num, ar1, ar2);
                return "error";
            }
            if(c1 == "NULL" || t1 == "NULL"){
                if(c1 == "NULL"){
                    error++;
                    printf("Erro:%d:%d: %s é NULL\n", line_num, col_num, c);
                    return "error";
                }
                if(t1 == "NULL"){
                    error++;
                    printf("Erro:%d:%d: %s é NULL\n", line_num, col_num, t);
                    return "error";
                }
            }
        }
        return c;
    }
}
char* idMathCheck(char *ar1, char *ar2, char *op, char *ar2type){
    char *c = searchSymbolType(symTable, ar1);
    char *c1 = searchSymbolValue(symTable, ar1);
    if(strcmp(c,"Não encontrado") == 0){
        if(strcmp(c,"Não encontrado") == 0){
            error++;
            printf("Erro:%d:%d: Identificador '%s' não declarado\n", line_num, col_num, ar1);
        }
        return "error";
    }
    if(strcmp(c, ar2type) != 0){
        error++;
        printf("Erro:%d:%d: Tipo de '%s' esperado: '%s' para realizar a operação: '%s', mas '%s' possui tipo: '%s'\n", line_num, col_num, ar1, c, op, ar2, ar2type);
        return "error";
    }else{
        if(strcmp(op,"/") == 0){
            if(strcmp(ar2,"0") == 0 || strcmp(ar2,"0.0") == 0 ){
                error++;
                printf("Erro:%d:%d: Divisão por 0 detectada em: %s/%s\n", line_num, col_num, ar1, ar2);
                return "error";
            }
            if(strcmp(ar2,"NULL") == 0){                
                error++;
                printf("Erro:%d:%d: %s é NULL\n", line_num, col_num, c);
                return "error";
            }
        }
        return c;
    }
char* mathCheck(char *ar1, char *ar2, char *op){
    if(strcmp(op,"/") == 0){
        if(strcmp(ar2,"0") == 0 || strcmp(ar2,"0.0") == 0 ){
            error++;
            printf("Erro:%d:%d: Divisão por 0 detectada em: %s/%s\n", line_num, col_num, ar1, ar2);
            return "error";
        }
        if(strcmp(ar2,"NULL") == 0){                
            error++;
            printf("Erro:%d:%d: %s é NULL\n", line_num, col_num, c);
            return "error";
        }
    }
    return c;
}

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
