#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned int hash(char *str) {
    unsigned int hash = 0;
    while (*str) {
        hash = (hash << 5) + *str++;
    }
    return hash % TABLE_SIZE;
}

SymbolTable* createSymbolTable() {
    SymbolTable *symTable = (SymbolTable*)malloc(sizeof(SymbolTable));
    for (int i = 0; i < TABLE_SIZE; i++) {
        symTable->table[i] = NULL;
    }
    return symTable;
}

void insertSymbol(SymbolTable *symTable, char *name, char *type) {
    unsigned int index = hash(name);
    Symbol *newSymbol = (Symbol*)malloc(sizeof(Symbol));
    strcpy(newSymbol->name, name);
    strcpy(newSymbol->type, type);
    newSymbol->next = symTable->table[index];
    symTable->table[index] = newSymbol;
}

Symbol* lookupSymbol(SymbolTable *symTable, char *name) {
    unsigned int index = hash(name);
    Symbol *symbol = symTable->table[index];
    while (symbol) {
        if (strcmp(symbol->name, name) == 0) {
            return symbol;
        }
        symbol = symbol->next;
    }
    return NULL;
}

void printSymbolTable(SymbolTable *symTable) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        Symbol *symbol = symTable->table[i];
        if (symbol) {
            printf("Index %d:\n", i);
            while (symbol) {
                printf("  Name: %s, Type: %s\n", symbol->name, symbol->type);
                symbol = symbol->next;
            }
        }
    }
}
