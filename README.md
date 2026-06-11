# Samples isCOBOL

Coleção de programas educacionais escritos em isCOBOL (Veryant).

## Projetos

### calculadora-cobol
Calculadora de console com menu interativo.
Demonstra: variáveis, ACCEPT/DISPLAY, EVALUATE, COMPUTE e suporte a números negativos.

**Como executar:**
1. Importe o projeto na IDE Veryant (File → Import → Existing Projects)
2. Compile com Ctrl+B
3. Execute via Run → Run Configurations → isCOBOL Application

---

### estoque-produtos
Sistema de controle de estoque de console com menu interativo.
Demonstra: tabela interna com OCCURS e INDEXED BY, busca linear com SEARCH, SET para manipulação de index, nível 88 para flags semânticos, EVALUATE, PERFORM VARYING, ADD/SUBTRACT/COMPUTE, formatação monetária com PICTURE e validação de entradas.

**Funcionalidades:**
- Cadastro de produtos (código, nome, valor unitário, quantidade)
- Entrada e saída de estoque com validação de saldo
- Relatório completo com valor total por produto e total geral
- Consulta por código com classificação de status do estoque

**Como executar:**
1. Importe o projeto na IDE Veryant (File → Import → Existing Projects)
2. Compile com Ctrl+B
3. Execute via Run → Run Configurations → isCOBOL Application

---

### sistema-bancario

Sistema bancário simplificado de console com interface gráfica nativa isCOBOL.
Demonstra: tabelas internas com OCCURS aninhado (contas e histórico), PERFORM VARYING com índice auxiliar para busca segura, EVALUATE para menu, aritmética monetária com DECIMAL-POINT IS COMMA, DISPLAY WINDOW para janela gráfica flutuante no extrato, controle de buffer de entrada com campo PIC X(80), GO TO para saída antecipada de parágrafos e REGISTRAR-MOVIMENTO como parágrafo reutilizável.

**Funcionalidades:**
Criação de conta com número gerado automaticamente, nome, CPF e saldo inicial
Consulta de conta por número com exibição de dados completos
Depósito com validação de valor e atualização de saldo
Saque com validação de saldo suficiente
Transferência entre contas com validação de origem, destino e saldo
Extrato exibido em janela gráfica flutuante (DISPLAY WINDOW) com histórico de movimentações
Listagem de todas as contas cadastradas com saldo atual

**Como executar:**
Importe o projeto na IDE Veryant (File → Import → Existing Projects)
Compile com Ctrl+B
Execute via Run → Run Configurations → isCOBOL Application

---

### Autor 👤
Feito por **INTERON GROUP**
📧 Contato: github@interongroup.com

## Licença
Este repositório está licenciado sob a [MIT License](LICENSE).
Sinta-se livre para usar, modificar e distribuir.
