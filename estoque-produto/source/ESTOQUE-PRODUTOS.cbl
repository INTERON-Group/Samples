      *> ============================================================
      *> ESTOQUE-PRODUTOS.cbl
      *> Sample educativo em isCOBOL Evolve 2026R1 - Veryant IDE
      *>
      *> Funcionalidades:
      *>   1 - Cadastrar produto (codigo, nome, valor, quantidade)
      *>   2 - Entrada de estoque
      *>   3 - Saida de estoque
      *>   4 - Relatorio completo de estoque
      *>   5 - Consultar produto por codigo
      *>   0 - Encerrar
      *>
      *> Conceitos isCOBOL demonstrados:
      *>   - OCCURS com INDEXED BY (tabela interna indexada)
      *>   - SEARCH com AT END e WHEN (busca linear em tabela)
      *>   - SET para manipular INDEX
      *>   - Nivel 88 para condicoes nomeadas (flags semanticos)
      *>   - EVALUATE (WHEN / WHEN OTHER)
      *>   - PERFORM UNTIL e PERFORM VARYING
      *>   - ADD / SUBTRACT / COMPUTE
      *>   - PICTURE com edicao monetaria (ZZZ,ZZ9.99)
      *>   - Validacao de entrada com flag WS-ERRO
      *>   - Sub-rotinas internas reutilizaveis
      *>   - ON SIZE ERROR em operacao aritmetica
      *>
      *> Autoria: INTERON
      *> ============================================================

       IDENTIFICATION DIVISION.
       PROGRAM-ID. ESTOQUE-PRODUTOS.
       AUTHOR. INTERON.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ANY-COMPUTER.
       OBJECT-COMPUTER. ANY-COMPUTER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> -----------------------------------------------------------
      *> TABELA INTERNA DE PRODUTOS
      *> Capacidade: ate 20 produtos distintos
      *> INDEXED BY: obrigatorio para uso com SEARCH
      *> -----------------------------------------------------------
       01 WT-CATALOGO.
           05 WT-PRODUTO OCCURS 20 TIMES
                         INDEXED BY IDX-PROD.
               10 WT-CODIGO      PIC 9(4)       VALUE ZEROS.
               10 WT-NOME        PIC X(30)      VALUE SPACES.
               10 WT-VALOR-UNIT  PIC 9(8)V99    VALUE ZEROS.
               10 WT-QUANTIDADE  PIC S9(6)      VALUE ZEROS.

      *> -----------------------------------------------------------
      *> CONTROLE DE QUANTIDADE DE REGISTROS NA TABELA
      *> -----------------------------------------------------------
       01 WS-TOTAL-PRODS   PIC 9(2)   VALUE ZEROS.

      *> -----------------------------------------------------------
      *> VARIAVEIS DE ENTRADA DO USUARIO
      *> -----------------------------------------------------------
       01 WS-COD-ENTRADA    PIC 9(4)   VALUE ZEROS.
       01 WS-NOME-ENTRADA   PIC X(30)  VALUE SPACES.
       01 WS-VALOR-ENTRADA  PIC 9(8)V99 VALUE ZEROS.
       01 WS-QTDE-ENTRADA   PIC 9(6)   VALUE ZEROS.
       01 WS-QTDE-MOV       PIC 9(6)   VALUE ZEROS.
       01 WS-OPCAO          PIC 9      VALUE ZEROS.
       01 WS-CONTINUAR      PIC X      VALUE 'S'.

      *> -----------------------------------------------------------
      *> FLAGS E CONTROLE DE FLUXO
      *> -----------------------------------------------------------
       01 WS-ERRO           PIC X      VALUE 'N'.
       01 WS-ENCONTRADO     PIC X      VALUE 'N'.
           88 PRODUTO-ENCONTRADO      VALUE 'S'.
           88 PRODUTO-NAO-ENCONTRADO  VALUE 'N'.

       01 WS-OPCAO-VALIDA   PIC X      VALUE 'N'.
           88 OPCAO-OK                VALUE 'S'.

      *> -----------------------------------------------------------
      *> VARIAVEIS DE CALCULO E FORMATACAO
      *> -----------------------------------------------------------
       01 WS-VALOR-TOTAL-ITEM  PIC 9(12)V99  VALUE ZEROS.
       01 WS-VALOR-TOTAL-EST   PIC 9(14)V99  VALUE ZEROS.
       01 WS-POSICAO           PIC 9(2)      VALUE ZEROS.

      *> Variaveis formatadas para exibicao no console
       01 WS-FMT-VALOR         PIC ZZZ,ZZZ,ZZ9.99.
       01 WS-FMT-TOTAL         PIC Z,ZZZ,ZZZ,ZZ9.99.
       01 WS-FMT-QTDE          PIC ZZZ,ZZ9.

      *> -----------------------------------------------------------
      *> CONTADOR AUXILIAR
      *> -----------------------------------------------------------
       01 WS-X                 PIC 9(2)   VALUE ZEROS.

       PROCEDURE DIVISION.

      *> ============================================================
      *> PONTO DE ENTRADA DO PROGRAMA
      *> ============================================================
       INICIO-PARA.
           PERFORM EXIBIR-CABECALHO-PARA
           PERFORM MENU-PRINCIPAL-PARA
           STOP RUN.

      *> ============================================================
      *> CABECALHO DO SISTEMA
      *> ============================================================
       EXIBIR-CABECALHO-PARA.
           DISPLAY " "
           DISPLAY "  ================================================"
           DISPLAY "        SISTEMA DE CONTROLE DE ESTOQUE"
           DISPLAY "        Autoria: INTERON"
           DISPLAY "        Plataforma: isCOBOL Evolve 2026R1"
           DISPLAY "  ================================================"
           DISPLAY " ".

      *> ============================================================
      *> MENU PRINCIPAL - LOOP PRINCIPAL DO SISTEMA
      *> ============================================================
       MENU-PRINCIPAL-PARA.
           MOVE 'S' TO WS-CONTINUAR

           PERFORM UNTIL WS-CONTINUAR = 'N'
                      OR WS-CONTINUAR = 'n'

               MOVE 'N' TO WS-OPCAO-VALIDA
               DISPLAY " "
               DISPLAY "  +------------------------------------------+"
               DISPLAY "  |         MENU PRINCIPAL                   |"
               DISPLAY "  +------------------------------------------+"
               DISPLAY "  |  1 - Cadastrar novo produto              |"
               DISPLAY "  |  2 - Entrada de estoque                  |"
               DISPLAY "  |  3 - Saida de estoque                    |"
               DISPLAY "  |  4 - Relatorio completo de estoque       |"
               DISPLAY "  |  5 - Consultar produto por codigo        |"
               DISPLAY "  |  0 - Encerrar o sistema                  |"
               DISPLAY "  +------------------------------------------+"
               DISPLAY " "
               DISPLAY "  Opcao: " WITH NO ADVANCING
               ACCEPT WS-OPCAO

               EVALUATE WS-OPCAO
                   WHEN 0
                       PERFORM ENCERRAR-PARA
                   WHEN 1
                       MOVE 'S' TO WS-OPCAO-VALIDA
                       PERFORM CADASTRAR-PRODUTO-PARA
                   WHEN 2
                       MOVE 'S' TO WS-OPCAO-VALIDA
                       PERFORM ENTRADA-ESTOQUE-PARA
                   WHEN 3
                       MOVE 'S' TO WS-OPCAO-VALIDA
                       PERFORM SAIDA-ESTOQUE-PARA
                   WHEN 4
                       MOVE 'S' TO WS-OPCAO-VALIDA
                       PERFORM RELATORIO-ESTOQUE-PARA
                   WHEN 5
                       MOVE 'S' TO WS-OPCAO-VALIDA
                       PERFORM CONSULTAR-PRODUTO-PARA
                   WHEN OTHER
                       DISPLAY "  [!] Opcao invalida."
                           " Digite um numero de 0 a 5."
               END-EVALUATE

               IF OPCAO-OK
                   DISPLAY " "
                   DISPLAY "  Voltar ao menu principal? (S/N): "
                       WITH NO ADVANCING
                   ACCEPT WS-CONTINUAR
               END-IF

           END-PERFORM.

      *> ============================================================
      *> OPCAO 1 - CADASTRAR PRODUTO
      *> Conceitos: validacao de duplicidade via SEARCH,
      *>            preenchimento de tabela OCCURS com SET
      *> ============================================================
       CADASTRAR-PRODUTO-PARA.
           MOVE 'N' TO WS-ERRO
           DISPLAY " "
           DISPLAY "  ---- CADASTRO DE PRODUTO ----"

      *>   Verifica se ha espaco na tabela
           IF WS-TOTAL-PRODS >= 20
               DISPLAY "  [ERRO] Capacidade maxima atingida"
                   " (20 produtos)."
               MOVE 'S' TO WS-ERRO
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Codigo do produto (4 digitos): "
                   WITH NO ADVANCING
               ACCEPT WS-COD-ENTRADA

      *>       Valida codigo informado
               IF WS-COD-ENTRADA = 0
                   DISPLAY "  [ERRO] Codigo invalido."
                       " Deve ser maior que zero."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

      *>   Verifica duplicidade usando SEARCH
           IF WS-ERRO = 'N'
               PERFORM BUSCAR-POR-CODIGO-PARA
               IF PRODUTO-ENCONTRADO
                   DISPLAY "  [ERRO] Codigo "
                       WS-COD-ENTRADA
                       " ja esta cadastrado."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Nome do produto (max 30): "
                   WITH NO ADVANCING
               ACCEPT WS-NOME-ENTRADA

               IF WS-NOME-ENTRADA = SPACES
                   DISPLAY "  [ERRO] Nome nao pode ser em branco."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Valor unitario (ex: 1999.99): "
                   WITH NO ADVANCING
               ACCEPT WS-VALOR-ENTRADA

               IF WS-VALOR-ENTRADA <= 0
                   DISPLAY "  [ERRO] Valor deve ser maior que zero."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Quantidade inicial em estoque: "
                   WITH NO ADVANCING
               ACCEPT WS-QTDE-ENTRADA

      *>       Insere o novo produto na proxima posicao da tabela
      *>       SET avanca o index para a posicao correta
               ADD 1 TO WS-TOTAL-PRODS
               MOVE WS-TOTAL-PRODS TO WS-X
               SET IDX-PROD TO WS-X

               MOVE WS-COD-ENTRADA   TO WT-CODIGO(IDX-PROD)
               MOVE WS-NOME-ENTRADA  TO WT-NOME(IDX-PROD)
               MOVE WS-VALOR-ENTRADA TO WT-VALOR-UNIT(IDX-PROD)
               MOVE WS-QTDE-ENTRADA  TO WT-QUANTIDADE(IDX-PROD)

               DISPLAY " "
               DISPLAY "  [OK] Produto cadastrado com sucesso!"
               DISPLAY "       Codigo  : " WT-CODIGO(IDX-PROD)
               DISPLAY "       Nome    : " WT-NOME(IDX-PROD)
               MOVE WT-VALOR-UNIT(IDX-PROD) TO WS-FMT-VALOR
               DISPLAY "       Valor   : R$ " WS-FMT-VALOR
               MOVE WT-QUANTIDADE(IDX-PROD) TO WS-FMT-QTDE
               DISPLAY "       Qtde    : " WS-FMT-QTDE " unidades"
           END-IF.

      *> ============================================================
      *> OPCAO 2 - ENTRADA DE ESTOQUE
      *> Conceitos: SEARCH para localizar produto, ADD para somar
      *> ============================================================
       ENTRADA-ESTOQUE-PARA.
           MOVE 'N' TO WS-ERRO
           DISPLAY " "
           DISPLAY "  ---- ENTRADA DE ESTOQUE ----"

           IF WS-TOTAL-PRODS = 0
               DISPLAY "  [!] Nenhum produto cadastrado ainda."
               MOVE 'S' TO WS-ERRO
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Codigo do produto: " WITH NO ADVANCING
               ACCEPT WS-COD-ENTRADA
               PERFORM BUSCAR-POR-CODIGO-PARA

               IF PRODUTO-NAO-ENCONTRADO
                   DISPLAY "  [ERRO] Produto com codigo "
                       WS-COD-ENTRADA " nao encontrado."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Quantidade a entrar: " WITH NO ADVANCING
               ACCEPT WS-QTDE-MOV

               IF WS-QTDE-MOV = 0
                   DISPLAY "  [ERRO] Quantidade deve ser"
                       " maior que zero."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

           IF WS-ERRO = 'N'
               ADD WS-QTDE-MOV TO WT-QUANTIDADE(IDX-PROD)
                   ON SIZE ERROR
                       DISPLAY "  [ERRO] Overflow: quantidade"
                           " excede o limite do campo."
                       MOVE 'S' TO WS-ERRO
               END-ADD

               IF WS-ERRO = 'N'
                   MOVE WT-QUANTIDADE(IDX-PROD) TO WS-FMT-QTDE
                   DISPLAY " "
                   DISPLAY "  [OK] Entrada registrada!"
                   DISPLAY "       Produto : " WT-NOME(IDX-PROD)
                   DISPLAY "       Entrada : " WS-QTDE-MOV " unidades"
                   DISPLAY "       Saldo   : " WS-FMT-QTDE " unidades"
               END-IF
           END-IF.

      *> ============================================================
      *> OPCAO 3 - SAIDA DE ESTOQUE
      *> Conceitos: SEARCH + SUBTRACT + validacao de saldo
      *> ============================================================
       SAIDA-ESTOQUE-PARA.
           MOVE 'N' TO WS-ERRO
           DISPLAY " "
           DISPLAY "  ---- SAIDA DE ESTOQUE ----"

           IF WS-TOTAL-PRODS = 0
               DISPLAY "  [!] Nenhum produto cadastrado ainda."
               MOVE 'S' TO WS-ERRO
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Codigo do produto: " WITH NO ADVANCING
               ACCEPT WS-COD-ENTRADA
               PERFORM BUSCAR-POR-CODIGO-PARA

               IF PRODUTO-NAO-ENCONTRADO
                   DISPLAY "  [ERRO] Produto com codigo "
                       WS-COD-ENTRADA " nao encontrado."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

           IF WS-ERRO = 'N'
               DISPLAY "  Quantidade a retirar: " WITH NO ADVANCING
               ACCEPT WS-QTDE-MOV

               IF WS-QTDE-MOV = 0
                   DISPLAY "  [ERRO] Quantidade deve ser"
                       " maior que zero."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

      *>   Valida saldo disponivel antes de deduzir
           IF WS-ERRO = 'N'
               IF WS-QTDE-MOV > WT-QUANTIDADE(IDX-PROD)
                   MOVE WT-QUANTIDADE(IDX-PROD) TO WS-FMT-QTDE
                   DISPLAY "  [ERRO] Saldo insuficiente."
                   DISPLAY "         Saldo atual: " WS-FMT-QTDE
                       " unidades."
                   MOVE 'S' TO WS-ERRO
               END-IF
           END-IF

           IF WS-ERRO = 'N'
               SUBTRACT WS-QTDE-MOV FROM WT-QUANTIDADE(IDX-PROD)

               MOVE WT-QUANTIDADE(IDX-PROD) TO WS-FMT-QTDE
               DISPLAY " "
               DISPLAY "  [OK] Saida registrada!"
               DISPLAY "       Produto : " WT-NOME(IDX-PROD)
               DISPLAY "       Saida   : " WS-QTDE-MOV " unidades"
               DISPLAY "       Saldo   : " WS-FMT-QTDE " unidades"

      *>       Alerta de estoque baixo (nivel 88 implicito via IF)
               IF WT-QUANTIDADE(IDX-PROD) <= 5
                   DISPLAY "  [!] ATENCAO: saldo baixo"
                       " (igual ou abaixo de 5 unidades)!"
               END-IF
           END-IF.

      *> ============================================================
      *> OPCAO 4 - RELATORIO COMPLETO DE ESTOQUE
      *> Conceitos: PERFORM VARYING sobre tabela OCCURS,
      *>            COMPUTE para valor total, acumulador
      *> ============================================================
       RELATORIO-ESTOQUE-PARA.
           DISPLAY " "
           DISPLAY "  =============================================="
           DISPLAY "          RELATORIO COMPLETO DE ESTOQUE"
           DISPLAY "  =============================================="

           IF WS-TOTAL-PRODS = 0
               DISPLAY "  Nenhum produto cadastrado."
           ELSE
               MOVE ZEROS TO WS-VALOR-TOTAL-EST
               DISPLAY " "
               DISPLAY "  COD  | NOME                          "
                   "| QTDE    | VL. UNIT.    | VL. TOTAL"
               DISPLAY "  -----+-------------------------------"
                   "+----------+--------------+-------------"

      *>           PERFORM VARYING: percorre todos os produtos
      *>           cadastrados usando subscrito WS-X
               PERFORM VARYING WS-X FROM 1 BY 1
                   UNTIL WS-X > WS-TOTAL-PRODS

                   SET IDX-PROD TO WS-X

      *>               COMPUTE: calcula valor total do item
                   COMPUTE WS-VALOR-TOTAL-ITEM =
                       WT-QUANTIDADE(IDX-PROD) *
                       WT-VALOR-UNIT(IDX-PROD)

      *>               Acumula valor geral do estoque
                   ADD WS-VALOR-TOTAL-ITEM TO WS-VALOR-TOTAL-EST

                   MOVE WT-VALOR-UNIT(IDX-PROD)  TO WS-FMT-VALOR
                   MOVE WT-QUANTIDADE(IDX-PROD)  TO WS-FMT-QTDE
                   MOVE WS-VALOR-TOTAL-ITEM      TO WS-FMT-TOTAL

                   DISPLAY "  "
                       WT-CODIGO(IDX-PROD)  " | "
                       WT-NOME(IDX-PROD)    " | "
                       WS-FMT-QTDE          " | "
                       "R$ " WS-FMT-VALOR   " | "
                       "R$ " WS-FMT-TOTAL

               END-PERFORM

               DISPLAY "  -----+-------------------------------"
                   "+----------+--------------+-------------"
               DISPLAY "  Total de produtos cadastrados: "
                   WS-TOTAL-PRODS
               MOVE WS-VALOR-TOTAL-EST TO WS-FMT-TOTAL
               DISPLAY "  Valor total do estoque: R$ " WS-FMT-TOTAL
               DISPLAY "  ============================================="
           END-IF.

      *> ============================================================
      *> OPCAO 5 - CONSULTAR PRODUTO POR CODIGO
      *> Conceitos: SEARCH com AT END e WHEN, SET, nivel 88
      *> ============================================================
       CONSULTAR-PRODUTO-PARA.
           DISPLAY " "
           DISPLAY "  ---- CONSULTA DE PRODUTO ----"

           IF WS-TOTAL-PRODS = 0
               DISPLAY "  [!] Nenhum produto cadastrado ainda."
           ELSE
               DISPLAY "  Codigo do produto: " WITH NO ADVANCING
               ACCEPT WS-COD-ENTRADA
               PERFORM BUSCAR-POR-CODIGO-PARA

               IF PRODUTO-NAO-ENCONTRADO
                   DISPLAY "  [!] Produto com codigo "
                       WS-COD-ENTRADA " nao encontrado."
               ELSE
                   COMPUTE WS-VALOR-TOTAL-ITEM =
                       WT-QUANTIDADE(IDX-PROD) *
                       WT-VALOR-UNIT(IDX-PROD)

                   MOVE WT-VALOR-UNIT(IDX-PROD) TO WS-FMT-VALOR
                   MOVE WT-QUANTIDADE(IDX-PROD) TO WS-FMT-QTDE
                   MOVE WS-VALOR-TOTAL-ITEM     TO WS-FMT-TOTAL

                   DISPLAY " "
                   DISPLAY "  +--------------------------------------+"
                   DISPLAY "  | DADOS DO PRODUTO                    |"
                   DISPLAY "  +--------------------------------------+"
                   DISPLAY "  | Codigo    : " WT-CODIGO(IDX-PROD)
                   DISPLAY "  | Nome      : " WT-NOME(IDX-PROD)
                   DISPLAY "  | Qtde      : " WS-FMT-QTDE " unidades"
                   DISPLAY "  | Vl. Unit. : R$ " WS-FMT-VALOR
                   DISPLAY "  | Vl. Total : R$ " WS-FMT-TOTAL

      *>               EVALUATE TRUE: classifica nivel do estoque
                   EVALUATE TRUE
                       WHEN WT-QUANTIDADE(IDX-PROD) = 0
                           DISPLAY "  | Status    : SEM ESTOQUE"
                       WHEN WT-QUANTIDADE(IDX-PROD) <= 5
                           DISPLAY "  | Status    : CRITICO"
                               " (abaixo de 5)"
                       WHEN WT-QUANTIDADE(IDX-PROD) <= 20
                           DISPLAY "  | Status    : BAIXO"
                               " (abaixo de 20)"
                       WHEN OTHER
                           DISPLAY "  | Status    : NORMAL"
                   END-EVALUATE

                   DISPLAY "  +--------------------------------------+"
               END-IF
           END-IF.

      *> ============================================================
      *> SUB-ROTINA: BUSCAR PRODUTO POR CODIGO NA TABELA
      *>
      *> Entrada : WS-COD-ENTRADA
      *> Saida   : WS-ENCONTRADO ('S' ou 'N')
      *>           IDX-PROD posicionado no item (se encontrado)
      *>
      *> Conceitos: SEARCH com INDEXED BY, AT END, WHEN, SET
      *> ============================================================
       BUSCAR-POR-CODIGO-PARA.
           MOVE 'N' TO WS-ENCONTRADO

           IF WS-TOTAL-PRODS > 0
      *>       SET inicializa o index no primeiro elemento
      *>       obrigatorio antes de qualquer SEARCH
               SET IDX-PROD TO 1

      *>       SEARCH: percorre a tabela WT-PRODUTO linearmente
      *>       AT END: executado se chegar ao fim sem encontrar
      *>       WHEN:   condicao de parada com sucesso
               SEARCH WT-PRODUTO
                   AT END
                       MOVE 'N' TO WS-ENCONTRADO
                   WHEN WT-CODIGO(IDX-PROD) = WS-COD-ENTRADA
                       MOVE 'S' TO WS-ENCONTRADO
               END-SEARCH
           END-IF.

      *> ============================================================
      *> ENCERRAMENTO DO SISTEMA
      *> ============================================================
       ENCERRAR-PARA.
           DISPLAY " "
           DISPLAY "  ================================================"
           DISPLAY "  Sistema encerrado. Obrigado por usar o INTERON!"
           DISPLAY "  isCOBOL Evolve 2026R1 - Veryant"
           DISPLAY "  ================================================"
           STOP RUN.

       END PROGRAM ESTOQUE-PRODUTOS.
