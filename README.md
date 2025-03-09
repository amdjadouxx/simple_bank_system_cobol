# Banking System in COBOL

This COBOL program implements a simple banking system that allows managing customer accounts and transactions.

## 📂 Code Structure

The program is divided into several main sections:

- **IDENTIFICATION DIVISION**: Defines the program name.
- **ENVIRONMENT DIVISION**: Specifies the input/output files used.
- **DATA DIVISION**: Declares files and variables.
- **PROCEDURE DIVISION**: Contains the main program logic.

## 🚀 Features

The program provides the following features:

1. **Create an Account** 🏦: Allows creating a new account by entering the account number, first name, and last name.
2. **Deposit** 💰: Adds money to an existing account.
3. **Withdraw** 🏧: Withdraws money from an existing account, ensuring sufficient funds are available.
4. **Check Balance** 📊: Displays the current balance of a specified account.
5. **Exit** ❌: Terminates the program execution.

## 📦 Prerequisites and Dependencies

Before running the program, make sure you have a COBOL compiler installed. You can use **GnuCOBOL**:

### 🔧 Installing GnuCOBOL

**On Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install -y open-cobol
```

**On macOS (via Homebrew):**
```bash
brew install gnu-cobol
```

**On Windows:**  
Download and install [GnuCOBOL for Windows](https://sourceforge.net/projects/gnucobol/).

## 🔄 Usage

### 📌 Compilation

```bash
cobc -x main.cob
```

### ▶️ Execution

```bash
./main
```

## 📂 Required Files

The program uses two files to store accounts and transactions:

- **`comptes.dat`**: Contains account information.
- **`transactions.dat`**: Stores records of performed transactions.

Ensure these files exist and are accessible before running the program.

---
