# cobol-fintech-ledger
A high-performance COBOL batch processing engine for banking transaction validation and cashback scoring.
# Enterprise COBOL Fintech Ledger Engine (MVP)

A high-performance batch processing program written in COBOL for validating financial transactions, executing business logic (dynamic cashback calculation), and generating structured compliance audit reports.

## Architecture & Features
- **Batch Processing Concept:** Mimics core-banking nightly batch jobs that process millions of records sequentially.
- **Business Logic Integration:** Applies conditional scoring (5% cashback for `FOOD` category, 1% baseline for other transactions).
- **Fixed-Width Data Processing:** Utilizes `FILE SECTION` definitions optimized for legacy financial data exchange standards.

## How to Run Locally

You can easily run and test this core banking module locally using **GnuCOBOL** (open-source compiler).

1. **Install GnuCOBOL:**
   - macOS: `brew install gnucobol`
   - Ubuntu/Linux: `sudo apt-get install gnucobol`

2. **Compile the program:**
   ```bash
   cobc -x -o ledger_engine ledger.cob
   ```

3. **Run the batch job:**
   ```bash
   ./ledger_engine
   ```

4. **Check the output:** 
   Open `audit_report.txt` to view the processed statement and calculated metrics.
