       IDENTIFICATION DIVISION.
        PROGRAM-ID. BANK-SYSTEM.
 
        ENVIRONMENT DIVISION.
        INPUT-OUTPUT SECTION.
        FILE-CONTROL.
            SELECT ACCOUNTS ASSIGN TO 'comptes.dat'
            ORGANIZATION IS LINE SEQUENTIAL.
            SELECT TRANSACTIONS ASSIGN TO 'transactions.dat'
            ORGANIZATION IS LINE SEQUENTIAL.
 
        DATA DIVISION.
        FILE SECTION.
        FD ACCOUNTS.
        01 ACCOUNT-RECORD.
           05 ACCOUNT-NUMBER     PIC X(6).
           05 ACCOUNT-NAME       PIC X(20).
           05 ACCOUNT-FIRSTNAME  PIC X(20).
           05 ACCOUNT-BALANCE    PIC 9(8)V99.
        FD TRANSACTIONS.
        01 TRANSACTION-RECORD.
           05 TRANS-ACCOUNT-NUMBER PIC X(6).
           05 TRANS-TYPE          PIC X(10).
           05 TRANS-AMOUNT        PIC 9(8)V99.
 
        WORKING-STORAGE SECTION.
        01 WS-OPTION            PIC 9.
        01 WS-AMOUNT            PIC 9(8)V99.
        01 WS-FOUND             PIC 9 VALUE 0.
        01 WS-INPUT-ACCOUNT     PIC X(6).
        01 WS-NEW-BALANCE       PIC 9(8)V99.
        01 WS-EOF               PIC 9 VALUE 0.
        01 WS-LOG-M             PIC X(50).
        01 WS-TRANS-TYPE        PIC X(10).
        01 WS-TRANS-ACCOUNT-NUMBER PIC X(6).
        01 WS-TRANS-AMOUNT      PIC 9(8)V99.
        01 WS-CREATE-ANOTHER    PIC X VALUE 'N'.
 
        PROCEDURE DIVISION.
        MAIN-PROCEDURE.
            PERFORM DISPLAY-MENU.
            STOP RUN.
 
        DISPLAY-MENU.
            DISPLAY '1. Creer un compte'.
            DISPLAY '2. Deposer de l''argent'.
            DISPLAY '3. Retirer de l''argent'.
            DISPLAY '4. Consulter le solde'.
            DISPLAY '5. Quitter'.
            ACCEPT WS-OPTION.
            EVALUATE WS-OPTION
                WHEN 1 PERFORM CREATE-ACCOUNT
                WHEN 2 PERFORM DEPOSIT
                WHEN 3 PERFORM WITHDRAW
                WHEN 4 PERFORM CHECK-BALANCE
                WHEN 5 STOP RUN
                WHEN OTHER DISPLAY 'Option invalide'.
            PERFORM DISPLAY-MENU.
 
        CREATE-ACCOUNT.
            OPEN EXTEND ACCOUNTS.
            PERFORM WITH TEST AFTER UNTIL WS-CREATE-ANOTHER = 'N'
                DISPLAY 'Numero de compte: '
                ACCEPT ACCOUNT-NUMBER
                DISPLAY 'Nom: '
                ACCEPT ACCOUNT-NAME
                DISPLAY 'Prenom: '
                ACCEPT ACCOUNT-FIRSTNAME
                MOVE 0 TO ACCOUNT-BALANCE
                WRITE ACCOUNT-RECORD
                DISPLAY 'Compte cree avec succes!'
                DISPLAY 'Voulez-vous creer un autre compte? (O/N): '
                ACCEPT WS-CREATE-ANOTHER
                IF WS-CREATE-ANOTHER = 'O' THEN
                    MOVE 'Y' TO WS-CREATE-ANOTHER
                ELSE
                    MOVE 'N' TO WS-CREATE-ANOTHER
                END-IF
            END-PERFORM.
            CLOSE ACCOUNTS.
            MOVE 'Creation de comptes terminee.' TO WS-LOG-M.
            PERFORM LOG-MESSAGE.
 
       DEPOSIT.
           OPEN I-O ACCOUNTS.
           OPEN OUTPUT TRANSACTIONS.
           DISPLAY 'Numero de compte: '.
           ACCEPT WS-INPUT-ACCOUNT.
           MOVE 0 TO WS-FOUND.
           MOVE 0 TO WS-EOF.
           READ ACCOUNTS AT END MOVE 1 TO WS-EOF.
           PERFORM UNTIL WS-FOUND = 1 OR WS-EOF = 1
               IF ACCOUNT-NUMBER = WS-INPUT-ACCOUNT THEN
                   DISPLAY 'Montant a deposer: '
                   ACCEPT WS-AMOUNT
                   IF WS-AMOUNT < 0 THEN
                       DISPLAY 'Montant invalide.'
                   ELSE
                       ADD WS-AMOUNT TO ACCOUNT-BALANCE
                       REWRITE ACCOUNT-RECORD
                       MOVE 1 TO WS-FOUND
                       MOVE 'Depot effectue avec succes!' TO WS-LOG-M
                       PERFORM LOG-MESSAGE
                       MOVE WS-INPUT-ACCOUNT TO TRANS-ACCOUNT-NUMBER
                       MOVE 'DEPOSIT' TO TRANS-TYPE
                       MOVE WS-AMOUNT TO TRANS-AMOUNT
                       WRITE TRANSACTION-RECORD
                   END-IF
               ELSE
                   READ ACCOUNTS AT END MOVE 1 TO WS-EOF
               END-IF
           END-PERFORM.
           IF WS-FOUND = 0 THEN DISPLAY 'Compte introuvable.'.
           CLOSE ACCOUNTS.
           CLOSE TRANSACTIONS.

       WITHDRAW.
           OPEN I-O ACCOUNTS.
           OPEN OUTPUT TRANSACTIONS.
           DISPLAY 'Numero de compte: '.
           ACCEPT WS-INPUT-ACCOUNT.
           MOVE 0 TO WS-FOUND.
           MOVE 0 TO WS-EOF.
           READ ACCOUNTS AT END MOVE 1 TO WS-EOF.
           PERFORM UNTIL WS-FOUND = 1 OR WS-EOF = 1
               IF ACCOUNT-NUMBER = WS-INPUT-ACCOUNT THEN
                   DISPLAY 'Montant a retirer: '
                   ACCEPT WS-AMOUNT
                   IF WS-AMOUNT < 0 THEN
                       DISPLAY 'Montant invalide.'
                   ELSE IF WS-AMOUNT > ACCOUNT-BALANCE THEN
                       DISPLAY 'Fonds insuffisants.'
                   ELSE
                       SUBTRACT WS-AMOUNT FROM ACCOUNT-BALANCE
                       REWRITE ACCOUNT-RECORD
                       MOVE 1 TO WS-FOUND
                       MOVE 'Retrait effectue avec succes!' TO WS-LOG-M
                       PERFORM LOG-MESSAGE
                       MOVE WS-INPUT-ACCOUNT TO TRANS-ACCOUNT-NUMBER
                       MOVE 'WITHDRAW' TO TRANS-TYPE
                       MOVE WS-AMOUNT TO TRANS-AMOUNT
                       WRITE TRANSACTION-RECORD
                   END-IF
               ELSE
                   READ ACCOUNTS AT END MOVE 1 TO WS-EOF
               END-IF
           END-PERFORM.
           IF WS-FOUND = 0 THEN DISPLAY 'Compte introuvable.'.
           CLOSE ACCOUNTS.
           CLOSE TRANSACTIONS.

       CHECK-BALANCE.
           OPEN INPUT ACCOUNTS.
           DISPLAY 'Numero de compte: '.
           ACCEPT WS-INPUT-ACCOUNT.
           MOVE 0 TO WS-FOUND.
           MOVE 0 TO WS-EOF.
           READ ACCOUNTS AT END MOVE 1 TO WS-EOF.
           PERFORM UNTIL WS-FOUND = 1 OR WS-EOF = 1
               IF ACCOUNT-NUMBER = WS-INPUT-ACCOUNT THEN
                   DISPLAY 'Solde actuel: ' ACCOUNT-BALANCE
                   MOVE 1 TO WS-FOUND
                   MOVE 'Consultation de solde reussie.' TO WS-LOG-M
                   PERFORM LOG-MESSAGE
               ELSE
                   READ ACCOUNTS AT END MOVE 1 TO WS-EOF
               END-IF
           END-PERFORM.
           IF WS-FOUND = 0 THEN DISPLAY 'Compte introuvable.'.
           CLOSE ACCOUNTS.

       LOG-MESSAGE.
           DISPLAY WS-LOG-M.
