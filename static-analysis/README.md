# [Internal Documentation] Static Analysis Tool Installation Guide

<table width="100%">
  <tr>
    <td><strong>Author:</strong> Sama Manikanta Reddy</td>
    <td align="right"><strong>Last Updated:</strong> 07-01-2025</td>
  </tr>
</table>

This document provides step-by-step instructions to install the **Static Analysis Tool** on any Ubuntu system.

---

## Table of Contents

- [\[Internal Documentation\] Static Analysis Tool Installation Guide](#internal-documentation-static-analysis-tool-installation-guide)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Tested Versions](#tested-versions)
  - [Prerequisites](#prerequisites)
  - [Step-by-Step Installation](#step-by-step-installation)
    - [Step 1: Update System](#step-1-update-system)
    - [Step 2: Install LLVM and Clang](#step-2-install-llvm-and-clang)
    - [Step 3: Installing Frama-C via opam](#step-3-installing-frama-c-via-opam)
    - [Step 4: Install Static Analysis Tool](#step-4-install-static-analysis-tool)
  - [Verification](#verification)
  - [Evaluating Different Types of C Programs with Static Analysis](#evaluating-different-types-of-c-programs-with-static-analysis)
  - [Troubleshooting](#troubleshooting)
  - [Additional Resources](#additional-resources)

---

## Introduction

The **Static Analysis Tool** helps developers analyze their codebase for potential issues and improve overall quality. This guide outlines how to install and configure the tool on an Ubuntu system. (need to verify)

---

## Tested Versions

The following versions were used during testing:

- **Ubuntu Version:** Ubuntu 24.04.1 LTS
- **Tool Versions:**
  - LLVM : LLVM-19.1.6-Linux-X64
  - Opam base compiler : v4.14.1
  - frama-c : v4.5.6
  - Static Analysis Tool: v1.0.0

---

## Prerequisites

Ensure the following are in place before beginning the installation:

- Ubuntu 20.04 or later
- Internet connection
- Administrator privileges (sudo access)

---

## Step-by-Step Installation

### Step 1: Update System

To ensure your system is up to date, run the following commands:

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 2: Install LLVM and Clang

1. **Download Pre-built Binaries:**
   - Download the pre-built binaries of LLVM from the official GitHub repository [here](https://github.com/llvm/llvm-project/releases).
   - Ensure that you download the binary that matches your operating system and CPU architecture (for Ubuntu, check the binaries labeled with Linux).

2. **Avoid Building from Source:**
   - Building LLVM from source can be time-consuming and error-prone.
   - Using the pre-built packages is a more efficient and reliable option.

3. **Clang Inclusion:**
   - Note that Clang is included in the LLVM package.
   - You do not need to download Clang separately.
   - For some operating systems, it may be explicitly mentioned whether Clang is included or not. Choose the appropriate binary accordingly.

4. **Isolation from System Files:**
   - We are avoiding the use of the `apt` package manager for installation.
   - This is to prevent disturbing or affecting any other libraries that are already installed.
   - This approach helps to isolate this installation from the system files.

### Step 3: Installing Frama-C via opam

opam is the OCaml package manager. Every Frama-C release is made available via an opam package.

1. **Install opam:**
   - It is recommended to install opam using the system's package manager.
   - For Ubuntu, you can install opam with the following command:

     ```bash
     sudo apt install opam
     ```

2. **Initialize opam:**
   - After installing opam, initialize it with the following command:

     ```bash
     opam init
     ```

   - Follow the prompts to set up your environment.

3. **Install a Switch:**
   - A switch is an isolated installation of the OCaml compiler and a set of libraries.
   - You can list the available compiler versions with the following command:

     ```bash
     opam switch list-available base
     ```

   - Create a switch with the latest OCaml version (e.g., 4.14.1) with the following command:

     ```bash
     opam switch create 4.14.1
     ```

   - Set the switch as the current environment:

     ```bash
     eval $(opam env --switch <switch>)
     ```

4. **Install Frama-C using opam:**
   - Once the switch is set up, you can install Frama-C with the following command:

     ```bash
     opam install frama-c
     ```

### Step 4: Install Static Analysis Tool

To install and use our Static Analysis Tool, follow these steps:

1. **Download the Tool:**
   - Download the source code of the Static Analysis Tool from the official website.

2. **Extract the Tool:**
   - Extract the downloaded archive to a directory of your choice.
   - This archive contains two script files.

3. **Configure Script Files:**
   - Edit the paths in the script files to point to your downloaded LLVM directory.

4. **Run the Scripts:**
   - Navigate to the extracted directory and run the script files to use the tool.

---

## Verification

To verify the installation, run the following command:

```bash
./clang.sh <llvm_path> <c-file>
./run-Framma.sh <c-file>
```

If the installation of all the tools was successful, you should see the result directory created for the c-file.

---







## Evaluating Different Types of C Programs with Static Analysis


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
    <td>[Frama-C] For multi-dimensional arrays, variable length is only supported on the first dimension.</td>
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
    <td>Queue using Linked Lists</td>
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
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Producer Consumer</td>
    <td>Pass</td>
    <td>N/A</td>
  </tr>
  <tr>
    <td>Thread Creation</td>
    <td>Pass</td>
    <td>N/A</td>
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
    <td>Fail</td>
    <td>[eva] User Error: Deferred error message was emitted during the execution. <br>
        [kernal] Plug-in eva aborted: invalid user input</td>
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

- For any issues regarding LLVM installation, check the [official documentation](http://llvm.org/docs).
- For any issues regarding opam, check the [official documentation](https://opam.ocaml.org/doc/Install.html).
- For any issues regarding Frama-C, check the [official documentation](https://frama-c.com/html/documentation.html).
- For any issues regarding the Static Analysis Tool, check the shell scripts included in the Static Analysis directory.

---

## Additional Resources

- [Official LLVM Project Repository](https://github.com/llvm/llvm-project)
- [Official LLVM Documentation](http://llvm.org/docs)
- [Official Frama-C Documentation](https://frama-c.com/html/documentation.html)
- [Official Frama-C Installation Guide](https://git.frama-c.com/pub/frama-c/blob/master/INSTALL.md#installing-frama-c-via-opam)
- [Official Opam Installation Guide](https://opam.ocaml.org/doc/Install.html)
