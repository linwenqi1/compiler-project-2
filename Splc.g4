//lexer grammar Splc;
grammar Splc;

// Changes in Project 2: Splc.g4 contains both parser rules and lexer rules.
//  so there should be "grammar Splc;' instead of 'lexer grammer Splc;'

// IDEA Plugin Settings
// - Output Directory: src/main/java/
// - package name: generated.Splc

// =========================
// Parser Rules
// =========================

program: globalDef* EOF;

globalDef
    : specifier Identifier LPAREN funcArgs RPAREN LBRACE statement* RBRACE
    | specifier varDec SEMI
    | specifier SEMI
    ;

specifier
    : INT
    | CHAR
    | STRUCT Identifier
    | STRUCT Identifier LBRACE (specifier varDec SEMI)* RBRACE
    ;

varDec
    : Identifier
    | varDec LBRACK Number RBRACK
    | STAR varDec
    | LPAREN varDec RPAREN
    ;

funcArgs
    :  (specifier varDec (COMMA specifier varDec)*)
    ;

statement
    : LBRACE statement* RBRACE
    | specifier varDec (ASSIGN expression)? SEMI
    | IF LPAREN expression RPAREN statement (ELSE statement)?
    | WHILE LPAREN expression RPAREN statement
    | RETURN expression SEMI
    | expression SEMI
    ;

expression
    : Identifier
    | Number
    | Char
    | LPAREN expression RPAREN

    | expression INC
    | expression DEC
    | Identifier LPAREN (expression (COMMA expression)*)? RPAREN
    | expression LBRACK expression RBRACK
    | expression '.' Identifier
    | expression '->' Identifier

    | <assoc=right> INC expression
    | <assoc=right> DEC expression
    | <assoc=right> PLUS expression
    | <assoc=right> MINUS expression
    | <assoc=right> NOT expression
    | <assoc=right> AMP expression
    | <assoc=right> STAR expression

    | expression (STAR | DIV | MOD) expression
    | expression (PLUS | MINUS) expression
    | expression (LT | GT | LE | GE) expression
    | expression (EQ | NEQ) expression
    | expression AND expression
    | expression OR expression
    | <assoc=right> expression ASSIGN expression
    ;
// =========================
// Lexer Rules
// =========================

// ---------- Keywords ----------
INT     : 'int';
CHAR    : 'char';
STRUCT  : 'struct';
RETURN  : 'return';
IF      : 'if';
ELSE    : 'else';
WHILE   : 'while';
// ---------- Operators ----------
ASSIGN  : '=';
PLUS    : '+';
MINUS   : '-';
STAR    : '*';
DIV     : '/';
MOD     : '%';
LT      : '<';
LE      : '<=';
GT      : '>';
GE      : '>=';
EQ      : '==';
NEQ     : '!=';
AND     : '&&';
OR      : '||';
NOT     : '!';
INC     : '++';
DEC     : '--';
DOT     : '.';
ARROW   : '->';
AMP     : '&';
// ---------- Separators ----------
SEMI    : ';';
COMMA   : ',';
LPAREN  : '(';
RPAREN  : ')';
LBRACE  : '{';
RBRACE  : '}';
LBRACK  : '[';
RBRACK  : ']';
// ---------- Identifiers & Literals ----------
Identifier : [a-zA-Z_][a-zA-Z0-9_]*;
Number  : '0' | [1-9][0-9]*;
Char    : '\'' ( ~['\\] | EscapeSequence ) '\'' ;
fragment EscapeSequence : '\\' [0btnr"'\\] ;
// ---------- Whitespace & Comments ----------
WS      : [ \t\r\n]+ -> skip ;
LINE_COMMENT : '//' ~[\r\n]* -> skip;
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;