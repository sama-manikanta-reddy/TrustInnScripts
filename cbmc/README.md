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
    - [Step 2: Install CBCMC via Package Manager (APT)](#step-3-install-cbcmc-via-package-manager-apt)
  - [Verification](#verification)
  - [Troubleshooting](#troubleshooting)
  - [Additional Resources](#additional-resources)

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

## Troubleshooting

If you encounter any issues during the installation, refer to the official documentation or seek help from the community forums.

- For any issues regarding CBMC installation, check the [cbmc documentation](https://www.cprover.org/cbmc/).

---

## Additional Resources

- [CBMC Project Repository](https://github.com/diffblue/cbmc)
- [CBMC Documentation](https://diffblue.github.io/cbmc//index.html)
