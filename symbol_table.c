#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

SymbolTable* createSymbolTable() {
    SymbolTable *table = (SymbolTable *)malloc(sizeof(SymbolTable));
    table->head = NULL;
    return table;
}

void insertSymbol(SymbolTable *table, const char *name, const char *type) {
    if (searchSymbol(table, name)) {
        //printf("Símbolo '%s' já existe na tabela.\n", name);
        return;
    }

    Symbol *newSymbol = (Symbol *)malloc(sizeof(Symbol));
    newSymbol->name = strdup(name);
    newSymbol->type = type ? strdup(type) : NULL;
    newSymbol->value = NULL;
    newSymbol->next = table->head;
    table->head = newSymbol;
}

int searchSymbol(SymbolTable *table, const char *name) {
    Symbol *current = table->head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return 1; // Símbolo encontrado
        }
        current = current->next;
    }
    return 0; // Símbolo não encontrado
}

void updateSymbolType(SymbolTable *table, const char *name, const char *type) {
    Symbol *current = table->head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            if (current->type != NULL) {
                free(current->type);
            }
            current->type = strdup(type);
            //printf("Tipo do símbolo '%s' atualizado para '%s'.\n", name, type);
            return;
        }
        current = current->next;
    }
    //printf("Símbolo '%s' não encontrado na tabela.\n", name);
}

void printSymbolTable(SymbolTable *table) {
    Symbol *current = table->head;
    while (current != NULL) {
        printf("Símbolo: %s, Tipo: %s, Valor: %s\n", current->name, current->type ? current->type : "N/A", current->value ? current->value : "N/A");
        current = current->next;
    }
}

void freeSymbolTable(SymbolTable *table) {
    Symbol *current = table->head;
    Symbol *next;
    while (current != NULL) {
        next = current->next;
        free(current->name);
        if (current->type != NULL) {
            free(current->type);
        }
        free(current);
        current = next;
    }
    free(table);
}

char* searchSymbolType(SymbolTable *table, const char *name) {
    Symbol *current = table->head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current->type; // Símbolo encontrado
        }
        current = current->next;
    }
    return "Não encontrado"; // Símbolo não encontrado
}

void updateSymbolValue(SymbolTable *table, const char *name, const char *value){
    Symbol *current = table->head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            if (current->value != NULL) {
                free(current->value);
            }
            current->value = strdup(value);
            //printf("Tipo do símbolo '%s' atualizado para '%s'.\n", name, value);
            return;
        }
        current = current->next;
    }
    //printf("Símbolo '%s' não encontrado na tabela.\n", name);
}

char *searchSymbolValue(SymbolTable *table, const char *name) {
    Symbol *current = table->head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            if(current->value == NULL){
                free(current->value);
                current->value = "NULL";
            }
            return current->value;
        }
        current = current->next;
    }
    return NULL; // Retorna NULL se o símbolo não for encontrado
}