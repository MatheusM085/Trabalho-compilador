# 🧮 Desafios Matemáticos com Tempo

Este projeto é um **compilador interativo** que desafia os usuários a resolver cálculos matemáticos em até **10 segundos**. Criado com **Flex** e **Bison**, o sistema gera expressões matemáticas, analisa respostas do usuário e controla o tempo de resposta, proporcionando uma experiência interativa e desafiadora.

## 📜 Funcionalidades

- **Gerar Desafios Matemáticos**: Problemas de aritmética (adição, subtração, multiplicação, divisão) ou equações simples.
- **Limite de Tempo**: Respostas devem ser fornecidas em até **10 segundos**.
- **Resultados Interativos**:
  - Resposta correta e no tempo: `Sucesso!`
  - Resposta incorreta ou fora do tempo: `Sem Sucesso.`
- **Mensagens Dinâmicas**: O programa guia o usuário de forma clara e objetiva.
- **Compatível com Windows**: Compilação final com **MinGW** para geração de executáveis.

## 📂 Estrutura do Projeto

```plaintext
.
├── matematica.l         # Analisador léxico (Flex)
├── matematica.y         # Analisador sintático e semântico (Bison)
├── Makefile             # Automação da compilação
├── README.md            # Documentação do projeto
└── bin/                 # Executáveis gerados
