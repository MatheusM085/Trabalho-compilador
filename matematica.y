%{
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h> // Para implementar o timer no Windows
#include <conio.h>   // Para capturar a resposta antes do tempo esgotar

volatile int timeout = 0; // Variável global para verificar timeout

void yyerror(const char *s);
int yylex(void);
void gerar_expressao(int *resultado);
void avaliar_resposta(int resultado);
DWORD WINAPI timer_thread(LPVOID param);
%}

%union {
    int ival; // Para inteiros
}

%token <ival> NUMBER
%type <ival> expressao
%start programa

%%

programa:
    /* vazio */
    | programa expressao '\n' {
        printf("Resultado da expressao correta era: %d\n", $2);
    }
;

expressao:
    NUMBER { $$ = $1; }
    | expressao '+' NUMBER { $$ = $1 + $3; }
    | expressao '-' NUMBER { $$ = $1 - $3; }
    | expressao '*' NUMBER { $$ = $1 * $3; }
    | expressao '/' NUMBER {
        if ($3 == 0) {
            yyerror("Erro: Divisao por zero!");
            exit(1);
        }
        $$ = $1 / $3;
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

void gerar_expressao(int *resultado) {
    int num1 = rand() % 20 + 1; // Gera um número entre 1 e 20
    int num2 = rand() % 20 + 1; // Gera outro número entre 1 e 20
    int operador = rand() % 4;  // Escolhe aleatoriamente um operador: 0 (+), 1 (-), 2 (*), 3 (/)

    switch (operador) {
        case 0:
            *resultado = num1 + num2;
            printf("Quanto fica %d + %d?\n", num1, num2);
            break;
        case 1:
            *resultado = num1 - num2;
            printf("Quanto fica %d - %d?\n", num1, num2);
            break;
        case 2:
            *resultado = num1 * num2;
            printf("Quanto fica %d * %d?\n", num1, num2);
            break;
        case 3:
            while (num1 % num2 != 0) { // Garante divisões exatas
                num1 = rand() % 20 + 1;
                num2 = rand() % 20 + 1;
            }
            *resultado = num1 / num2;
            printf("Quanto fica %d / %d?\n", num1, num2);
            break;
    }
}

DWORD WINAPI timer_thread(LPVOID param) {
    Sleep(10000); // Espera 10 segundos
    timeout = 1;  // Marca o timeout
    return 0;
}

void avaliar_resposta(int resultado) {
    int resposta_usuario;
    char buffer[100];
    timeout = 0; // Reseta o timeout

    // Inicia o timer em uma nova thread
    HANDLE hThread = CreateThread(NULL, 0, timer_thread, NULL, 0, NULL);

    printf("Digite sua resposta (voce tem 10 segundos): ");

    // Verifica continuamente se o tempo esgotou ou se o usuário digitou algo
    while (!timeout) {
        if (_kbhit()) { // Verifica se uma tecla foi pressionada
            fgets(buffer, sizeof(buffer), stdin);
            TerminateThread(hThread, 0); // Finaliza o timer
            CloseHandle(hThread);        // Libera o handle do timer

            if (sscanf(buffer, "%d", &resposta_usuario) != 1) {
                printf("Entrada invalida. Digite apenas numeros.\n\n");
                return;
            }

            if (resposta_usuario == resultado) {
                printf("Parabens! Resposta correta.\n");
            } else {
                printf("Resposta errada. O correto era %d.\n", resultado);
            }
            printf("----------------------------------------\n");
            return;
        }
    }

    // Se o timeout ocorreu antes de o usuário pressionar enter
    printf("\nTempo esgotado! O correto era %d.\n", resultado);
    TerminateThread(hThread, 0); // Finaliza o timer
    CloseHandle(hThread);        // Libera o handle do timer
}

int main() {
    srand(time(NULL)); // Inicializa a semente do gerador de números aleatórios
    int resultado;

    printf("Bem-vindo ao Desafio de Matematica!\n");
    printf("Resolva as expressoes abaixo. Para sair, pressione CTRL+C.\n\n");

    while (1) {
        gerar_expressao(&resultado);  // Gera uma nova expressão
        avaliar_resposta(resultado); // Avalia a resposta do usuário
    }

    return 0;
}
