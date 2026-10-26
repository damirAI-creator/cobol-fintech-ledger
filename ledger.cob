       IDENTIFICATION DIVISION.
       PROGRAM-ID. FintechLedger.
       AUTHOR. COBOL-Talent-MVP.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FILE-IN ASSIGN TO "transactions.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT FILE-OUT ASSIGN TO "audit_report.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  FILE-IN.
       01  TX-RECORD.
           05  TX-ID          PIC X(5).
           05  TX-ACC-NUM     PIC X(8).
           05  TX-AMOUNT      PIC 9(5)V92.
           05  TX-CATEGORY    PIC X(10).

       FD  FILE-OUT.
       01  REPORT-RECORD     PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-EOF            PIC X(1) VALUE "N".
       01  WS-CASHBACK       PIC 9(3)V92 VALUE 0.
       01  WS-TOTAL-TX       PIC 9(4) VALUE 0.
       01  WS-TOTAL-CASHBACK PIC 9(6)V92 VALUE 0.

       01  TXT-REPORT-LINE.
           05  FILLER         PIC X(2)  VALUE "ID:".
           05  R-ID           PIC X(5).
           05  FILLER         PIC X(3)  VALUE " | ACC:".
           05  R-ACC          PIC X(8).
           05  FILLER         PIC X(3)  VALUE " | AMT:".
           05  R-AMT          PIC ZZZ99.99.
           05  FILLER         PIC X(3)  VALUE " | CB:".
           05  R-CB           PIC ZZZ99.99.
           05  FILLER         PIC X(2)  VALUE " | CAT:".
           05  R-CAT          PIC X(10).

       01  TXT-SUMMARY-LINE.
           05  FILLER         PIC X(15) VALUE "TOTAL TX PROCESSED:".
           05  R-SUM-TX       PIC ZZZ9.
           05  FILLER         PIC X(15) VALUE " | TOTAL CB PAID:".
           05  R-SUM-CB       PIC ZZZZZ9.99.

       PROCEDURE DIVISION.
       0001-MAIN-LOGIC.
           OPEN INPUT FILE-IN
           OPEN OUTPUT FILE-OUT

           WRITE REPORT-RECORD FROM "=== BANKING LEDGER BATCH PROCESSING REPORT ==="

           READ FILE-IN
               AT END MOVE "Y" TO WS-EOF
           END-READ

           PERFORM UNTIL WS-EOF = "Y"
               PERFORM 0002-PROCESS-TRANSACTION
               READ FILE-IN
                   AT END MOVE "Y" TO WS-EOF
               END-READ
           END-PERFORM

           PERFORM 0003-WRITE-SUMMARY

           CLOSE FILE-IN
           CLOSE FILE-OUT
           STOP RUN.

       0002-PROCESS-TRANSACTION.
           ADD 1 TO WS-TOTAL-TX
           
           *> Логика бизнес-правила: 5% кэшбэк на ресторанный бизнес (FOOD), 1% на остальное
           IF TX-CATEGORY = "FOOD" THEN
               COMPUTE WS-CASHBACK = TX-AMOUNT * 0.05
           ELSE
               COMPUTE WS-CASHBACK = TX-AMOUNT * 0.01
           END-IF

           ADD WS-CASHBACK TO WS-TOTAL-CASHBACK

           *> Форматирование строки для отчета
           MOVE TX-ID TO R-ID
           MOVE TX-ACC-NUM TO R-ACC
           MOVE TX-AMOUNT TO R-AMT
           MOVE WS-CASHBACK TO R-CB
           MOVE TX-CATEGORY TO R-CAT

           WRITE REPORT-RECORD FROM TX-REPORT-LINE.

       0003-WRITE-SUMMARY.
           WRITE REPORT-RECORD FROM "========================================================="
           MOVE WS-TOTAL-TX TO R-SUM-TX
           MOVE WS-TOTAL-CASHBACK TO R-SUM-CB
           WRITE REPORT-RECORD FROM TX-SUMMARY-LINE.
