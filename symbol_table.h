#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct Symbol {
    char *name;
    char *type;
    char *value;
    struct Symbol *next;
} Symbol;

typedef struct SymbolTable {
    Symbol *head;
} SymbolTable;

SymbolTable* createSymbolTable();
void insertSymbol(SymbolTable *table, const char *name, const char *type);
int searchSymbol(SymbolTable *table, const char *name);
void updateSymbolType(SymbolTable *table, const char *name, const char *type);
void printSymbolTable(SymbolTable *table);
void freeSymbolTable(SymbolTable *table);
char* searchSymbolType(SymbolTable *table, const char *name);
void updateSymbolValue(SymbolTable *table, const char *name, const char *value);
char* searchSymbolValue(SymbolTable *table, const char *name);

#endif
