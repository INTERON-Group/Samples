      *> CALCULADORA.cbl - Programa educacional em isCOBOL
      *> Demonstra: variáveis, entrada/saída, cálculos e condições
      *> ============================================================
       IDENTIFICATION DIVISION.
           PROGRAM-ID. CALCULADORA.
           AUTHOR. Exemplo Educacional.

       DATA DIVISION.
           WORKING-STORAGE SECTION.
           01 WS-NUMERO1        PIC S9(5)V99 VALUE ZEROS.
           01 WS-NUMERO2        PIC S9(5)V99 VALUE ZEROS.
           01 WS-RESULTADO      PIC S9(8)V99 VALUE ZEROS.
           01 WS-OPCAO          PIC 9(1)    VALUE ZEROS.
           01 WS-CONTINUAR      PIC X(1)    VALUE 'S'.
           01 WS-OPCAO-VALIDA   PIC X(1)     VALUE 'N'.

       PROCEDURE DIVISION.
       INICIO.
           DISPLAY WINDOW ERASE
           DISPLAY "========================================".
           DISPLAY "   BEM-VINDO À CALCULADORA COBOL".
           DISPLAY "========================================".

       MENU-PRINCIPAL.
           MOVE 'N' TO WS-OPCAO-VALIDA.
           
           DISPLAY " ".
           DISPLAY "Escolha a operação:".
           DISPLAY "1 - Adição".
           DISPLAY "2 - Subtração".
           DISPLAY "3 - Multiplicação".
           DISPLAY "4 - Divisão".
           DISPLAY "0 - Sair".
           DISPLAY " ".
           DISPLAY "Digite sua opção: " WITH NO ADVANCING.
           ACCEPT WS-OPCAO.

           EVALUATE WS-OPCAO
               WHEN 0
                   DISPLAY "Programa encerrado. Até logo!"
                   STOP RUN
               WHEN 1 THRU 4
                   MOVE 'S' TO WS-OPCAO-VALIDA
               WHEN OTHER
                   DISPLAY "Opção inválida! Digite um número de 0 a 4."
           END-EVALUATE.
 
           IF WS-OPCAO-VALIDA = 'N'
               GO TO MENU-PRINCIPAL
           END-IF.

           DISPLAY "Digite o primeiro número:  " WITH NO ADVANCING.
           ACCEPT WS-NUMERO1.
           DISPLAY "Digite o segundo número:   " WITH NO ADVANCING.
           ACCEPT WS-NUMERO2.

           EVALUATE WS-OPCAO
               WHEN 1
                   COMPUTE WS-RESULTADO = WS-NUMERO1 + WS-NUMERO2
                   DISPLAY "Resultado: " WS-NUMERO1 " + "
                            WS-NUMERO2 " = " WS-RESULTADO

               WHEN 2
                   COMPUTE WS-RESULTADO = WS-NUMERO1 - WS-NUMERO2
                   DISPLAY "Resultado: " WS-NUMERO1 " - "
                            WS-NUMERO2 " = " WS-RESULTADO

               WHEN 3
                   COMPUTE WS-RESULTADO = WS-NUMERO1 * WS-NUMERO2
                   DISPLAY "Resultado: " WS-NUMERO1 " x "
                            WS-NUMERO2 " = " WS-RESULTADO

               WHEN 4
                   IF WS-NUMERO2 = 0
                       DISPLAY "ERRO: Divisão por zero não é permitida!"
                   ELSE
                       COMPUTE WS-RESULTADO =
                               WS-NUMERO1 / WS-NUMERO2
                       DISPLAY "Resultado: " WS-NUMERO1 " ÷ "
                                WS-NUMERO2 " = " WS-RESULTADO
                   END-IF

               WHEN OTHER
                   DISPLAY "Opção inválida! Tente novamente."
           END-EVALUATE.

           DISPLAY " ".
           DISPLAY "Fazer outro cálculo? (S/N): " WITH NO ADVANCING.
           ACCEPT WS-CONTINUAR.

           IF WS-CONTINUAR = 'S' OR WS-CONTINUAR = 's'
               GO TO MENU-PRINCIPAL
           END-IF.

           DISPLAY "Obrigado por usar a calculadora!"
           STOP RUN.