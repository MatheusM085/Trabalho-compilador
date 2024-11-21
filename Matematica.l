%{
#include "matematica.tab.h"
%}

%%

[0-9]+ {
    yylval.ival = atoi(yytext);  // Converte o texto para inteiro
    return NUMBER;               // Retorna o token NUMBER
}

[ \t]    { /* Ignora espaços em branco */ }
\n       { return '\n'; }
"+"      { return '+'; }
"-"      { return '-'; }
"*"      { return '*'; }
"/"      { return '/'; }

.        { printf("Caractere invalido: %s\n", yytext); }

%%

int yywrap() {
    return 1; // Obrigatório para o Flex
}
