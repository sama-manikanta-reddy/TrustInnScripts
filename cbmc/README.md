# [Internal Documentation] CBMC (Bounded Model Checker for C and C++) Tool Installation Guide

<table width="100%">
  <tr>
    <td><strong>Author:</strong> Ch. Amarindhraa Sai </td>
    <td align="right"><strong>Last Updated:</strong> 16-01-2025</td>
  </tr>
</table>

This document provides step-by-step instructions to install the **CBMC Tool** on any Ubuntu system.

---

## Table of Contents

- [\[Internal Documentation\] CBMC (Bounded Model Checker for C and C++) Tool Installation Guide](#internal-documentation-cbmc-bounded-model-checker-for-c-and-c-tool-installation-guide)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Tested Versions](#tested-versions)
  - [Prerequisites](#prerequisites)
  - [Step-by-Step Installation](#step-by-step-installation)
    - [Step 1: Update System](#step-1-update-system)
    - [Step 2: Install CBCMC via Package Manager (APT)](#step-2-install-cbcmc-via-package-manager-apt)
  - [Verification](#verification)
  - [Evaluating Different Types of C Programs with CBMC](#evaluating-different-types-of-c-programs-with-cbmc)
  - [Troubleshooting](#troubleshooting)
  - [Additional Resources](#additional-resources)
  - [NOTE: CBMC Limitations and Common Errors](#note-cbmc-limitations-and-common-errors)
    - [**Object Limit Error in CBMC**](#object-limit-error-in-cbmc)
      - [Cause:](#cause)
      - [Solution:](#solution)
    - [**Pointers Handling for Concurrency is Unsound**](#pointers-handling-for-concurrency-is-unsound)
      - [Cause:](#cause-1)

---

## Introduction

The **CBMC (C Bounded Model Checker) Tool** is a powerful static analysis tool used for verifying safety-critical software. It analyzes C and C++ programs to ensure their correctness by detecting potential errors such as buffer overflows, pointer dereferences, division by zero, and assertions violations. CBMC uses formal verification techniques like bounded model checking and symbolic execution to provide rigorous guarantees about program behavior.

---

## Tested Versions

The following versions were used during testing:

- **Ubuntu Version:** Ubuntu 24.04.1 LTS
- **Tool Versions:**
  - CBMC : CBMC-5.95.1-Linux-X64
  - gcc : gcc-13.3.0
  

---

## Prerequisites

Ensure the following are in place before beginning the installation:

- Ubuntu 20.04 or later (64 bit recommended)
- Internet connection
- Administrator privileges (sudo access)
- A C/C++ compiler (eg. GCC)

---

## Step-by-Step Installation

### Step 1: Update System

To ensure your system is up to date, run the following commands:

```bash
sudo apt update
sudo apt upgrade -y
```


### Step 2: Install CBCMC via Package Manager (APT)

CBMC may be available in Ubuntu’s package repositories, depending on your version.

1. **Install cbmc:**
   - It is recommended to install cbmc using the system's package manager.
   - For Ubuntu, you can install cbmc with the following command:

     ```bash
     sudo apt install cbmc
     ```

2. **Verify cbmc:**
   - After installing cbmc, verify it with the following command:

     ```bash
     cbmc --version
     ```


## Verification

To verify the installation, run the following command:

```bash
./cbmc_script.sh <c-file> <bound-value>

```

If the installation of all the tools was successful, you should see the result directory created for the c-file.

---

## Evaluating Different Types of C Programs with CBMC

While CBMC is a powerful verification tool, some types of C programs may encounter challenges during analysis. The table below summarizes various programs tested with CBMC, their verification status, and potential limitations:

<table>
  <tr>
    <th>Type of Programme</th>
    <th>Programme Name</th>
    <th>Testing Status</th>
    <th>Reasons for Failure (if any)</th>
  </tr>
  <tr>
    <td rowspan="3">Arrays</td>
    <td>Min-Max</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Reverse Array</td>
    <td>Pass</td>
    <td> N/A</td>
  </tr>
  <tr>
    <td>Spiral Matrix</td>
    <td>Fail</td>
    <td>--- begin invariant violation report ---<br>
Invariant check failed<br>
File: simplify_expr.cpp:3100 function: simplify_rec<br>
Condition: Postcondition<br>
Reason: (as_const(tmp).type().id() == ID_array && expr.type().id() == ID_array) || as_const(tmp).type() == expr.type() </td>
  </tr>
  <tr>
    <td rowspan="3">Control Flow</td>
    <td>Recursion (Fibonacci)</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Goto Statements</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>If Else</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td rowspan="3">Data Structures</td>
    <td>BST Operation</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Queue</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Stacked Array</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  
  <tr>
    <td rowspan="3">File Handling</td>
    <td>File Read Operations</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>File Write Operations</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Structure File Handling</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>


  <tr>
    <td rowspan="3">Functions</td>
    <td>Basic Function</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Function Pointer</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Tower of Hanoi</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>



<tr>
    <td rowspan="3">Multithreading</td>
    <td>Mutex Example</td>
    <td>Fail</td>
    <td>pointers handling for concurrency is unsound</td>
  </tr>
  <tr>
    <td>Producer Consumer</td>
    <td>Fail</td>
    <td>pointers handling for concurrency is unsound</td>
  </tr>
  <tr>
    <td>Thread Creation</td>
    <td>Fail</td>
    <td>pointers handling for concurrency is unsound</td>
  </tr>


<tr>
    <td rowspan="3">Pattern Matching</td>
    <td>KMP Algorithm</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Rabin-Karp Algorithm</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Substring Search</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>


<tr>
    <td rowspan="3">Pointers</td>
    <td>Function Pointers</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Pointer Arithmetic</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Linked List Operations</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  




  <tr>
    <td rowspan="3">Sorting</td>
    <td>Merge Sort</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Quick Sort</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Bubble Sort</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>


  
  <tr>
    <td rowspan="3">Strings</td>
    <td>Palindorme Check</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Reverse a String</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>String token</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
</table>



## Troubleshooting

If you encounter any issues during the installation, refer to the official documentation or seek help from the community forums.

- For any issues regarding CBMC installation, check the [cbmc documentation](https://www.cprover.org/cbmc/).

---

## Additional Resources

- [CBMC Project Repository](https://github.com/diffblue/cbmc)
- [CBMC Documentation](https://diffblue.github.io/cbmc//index.html)


## NOTE: CBMC Limitations and Common Errors

###  **Object Limit Error in CBMC**
When running complex programs (e.g., **BST operations**), you may encounter the following error:


####  Cause: 
CBMC uses **bounded memory modeling**, and by default, the maximum number of addressed objects is **2^8 (256)**.  
For complex data structures like **BSTs with dynamic memory allocation**, CBMC runs out of available object slots.

#### Solution:
Increase the object limit using the `--object-bits` option:
```bash
cbmc bst_program.c --object-bits 12
```

###  **Pointers Handling for Concurrency is Unsound**
When verifying **multi-threaded programs**, CBMC may display the following error:


#### Cause: 
CBMC is **not fully designed** for **multi-threaded verification**. It struggles with:
- **Pointer aliasing in concurrent execution**  
- **Race conditions** in shared memory  
- **Synchronization mechanisms (mutex, semaphores, atomic operations)**  
- **Thread interleaving complexities** that require explicit modeling  

CBMC's memory model does **not fully support dynamic thread synchronization**, leading to **unsound handling of pointers in multi-threaded programs**.


