#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TABLE_SIZE 100

typedef struct Symbol {
    char name[50];
    char type[20];
    struct Symbol *next;
} Symbol;

typedef struct SymbolTable {
    Symbol *table[TABLE_SIZE];
} SymbolTable;

unsigned int hash(char *str);
SymbolTable* createSymbolTable();
void insertSymbol(SymbolTable *symTable, char *name, char *type);
Symbol* lookupSymbol(SymbolTable *symTable, char *name);
void printSymbolTable(SymbolTable *symTable);

#endif
