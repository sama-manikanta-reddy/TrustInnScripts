# [Internal Documentation] Python ESBMC Tool Installation Guide

<table width="100%">
  <tr>
    <td><strong>Author:</strong> Sama Manikanta Reddy</td>
    <td align="right"><strong>Last Updated:</strong> 07-01-2025</td>
  </tr>
</table>

This document provides step-by-step instructions to install the Python-based BMC (Bounded Model Checking) tool on any Ubuntu system.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Tested Versions](#tested-versions)
3. [Dependency overview](#dependency-overview)
4. [Prerequisites](#prerequisites)
5. [Step-by-Step Installation](#step-by-step-installation)
6. [Usage](#usage)
7. [Troubleshooting and Resources](#troubleshooting-and-resources)
8. [License](#license)

---

## Introduction

The ESBMC (the Efficient SMT-based Context-Bounded Model Checker) tool is a context-bounded model checker that automatically detects or proves the absence of runtime errors in single- and multi-threaded C, C++, CUDA, CHERI, Kotlin, Python, and Solidity programs. It can automatically verify predefined safety properties (e.g., bounds check, pointer safety, overflow) and user-defined program assertions.

---

## Tested Versions

The following versions were used during testing:

- **Ubuntu Version:** Ubuntu 24.04.1 LTS
- **Tool Versions:**
  - esbmc : v7.8.0
  - clang : v14.0.0
  - boost : v1.83
  - cmake : v3.28.3
  - python : v3.12.3
  - ast2json: v0.3
  - z3 : v4.13.3

---

## Dependency overview

| package   | required | minimum version |
|-----------|----------|-----------------|
| clang     | yes      | 11.0.0          |
| boost     | yes      | 1.77            |
| CMake     | yes      | 3.18.0          |
| Boolector | no       | 3.2.2           |
| CVC4      | no       | 1.8             |
| CVC5      | no       | 1.1.2           |
| MathSAT   | no       | 5.5.4           |
| Yices     | no       | 2.6.4           |
| Z3        | no       | 4.13.3          |
| Bitwuzla  | no       | 0.7.0           |

 ---

## Prerequisites

Ensure the following are in place before beginning the installation:

- Ubuntu 20.04 or later
- Internet connection
- Administrator privileges (sudo access)

---

## Step-by-Step Installation

1. **Update System:**

   It is important to keep your system packages up-to-date to ensure compatibility and security.

   ```bash
   sudo apt-get update
   ```

2. **Install Dependencies:**

   Here we install the following dependencies:

   - clang-14, llvm-14, clang-tidy-14: These are tools from the LLVM project, including the Clang compiler, LLVM core libraries, and Clang-Tidy for static code analysis.
   - python-is-python3, python3: Ensures that the `python` command refers to Python 3, and installs Python 3.
   - git: A version control system for tracking changes in source code.
   - ccache: A compiler cache to speed up recompilation.
   - unzip, wget, curl: Utilities for file extraction and downloading files from the internet.
   - bison, flex: Tools for generating parsers.
   - g++-multilib: A GNU C++ compiler with support for building 32-bit and 64-bit applications.
   - linux-libc-dev: Development files for the Linux kernel headers.
   - libboost-all-dev: Boost C++ libraries development files.
   - libz3-dev: Development files for the Z3 theorem prover.
   - libclang-14-dev, libclang-cpp-dev: Development files for Clang libraries.
   - cmake: A cross-platform build system generator.

   ```bash
   sudo apt-get install -y clang-14 llvm-14 clang-tidy-14 python-is-python3 python3 git ccache unzip wget curl bison flex g++-multilib linux-libc-dev libboost-all-dev libz3-dev libclang-14-dev libclang-cpp-dev cmake
   ```

3. **Clone ESBMC Repository:**

   Clone the ESBMC repository from GitHub to get the latest source code.

   ```bash
   git clone https://github.com/esbmc/esbmc.git
   ```

4. **Building ESBMC with Z3 Solver and Python Frontend**

   ESBMC (Efficient SMT-Based Model Checker) relies on SMT solvers for reasoning about formulas in its back-end. While solvers are optional, enabling at least one solver is essential for verifying most programs. This guide outlines the steps to build ESBMC with the Z3 solver and enable the Python frontend for analyzing Python code.

   - 4.1. **Download and Enable Z3 Solver**
        - The Z3 solver is already installed during the dependencies installation step.
        - Include it during the build process with the `-DENABLE_Z3` option.

   - 4.2. **Enabling the Python Frontend**
        - The Python frontend facilitates the analysis of Python code by leveraging the Abstract Syntax Tree (AST) generated using the `ast2json` Python package.
        - To enable this feature, use the `-DENABLE_PYTHON_FRONTEND=On` option during the build process.

   - 4.3. **Build Process**
        - Follow these steps to build ESBMC with the Z3 solver and Python frontend:

            ```bash
            cd esbmc
            mkdir build && cd build
            cmake .. -DENABLE_Z3=1 -DENABLE_PYTHON_FRONTEND=On -DBUILD_TESTING=On
            make -j4
            ```

   - 4.4. **Install `ast2json`**
        - To use the Python frontend, install the `ast2json` Python package. While installing it in a virtual environment (venv) is recommended to avoid conflicts, it is not mandatory.

            ```bash
            # Create a virtual environment (optional but recommended)
            python -m venv .venv
            source ./.venv/bin/activate
            pip install ast2json
            # Exit the virtual environment
            exit
            ```

## Usage

To use ESBMC with the Python frontend:

1. Activate the Virtual Environment (if applicable):

   ```bash
   source ./.venv/bin/activate
   ```

2. Navigate to the Build Directory:Run a Basic Execution Test:

   ```bash
   cd build/src/esbmc
   ```

3. Run a Basic Execution Test :

   Use the following command to check if ESBMC is working correctly

   ```bash
   ./esbmc <path_to_python_file> --python <path>
   ```

   Example

   ```bash
   ./esbmc main.py --python python3
   ```

## Troubleshooting and Resources

If you encounter any issues during the installation, refer to the official documentation or seek help from the community forums.

- [Official ESBMC Repository](https://github.com/esbmc/esbmc)
- [Official ESBMC Documentation](https://ssvlab.github.io/esbmc/documentation.html#how-to-install)
- [Official Build Documentation of ESBMC](https://github.com/esbmc/esbmc/blob/master/BUILDING.md)

## License

This documentation is intended solely for guiding users on installing and using the tool. We are not affiliated with the official ESBMC repository or its maintainers in any manner. For the official repository and license information, please visit the [ESBMC GitHub](https://github.com/esbmc/esbmc?tab=License-1-ov-file#readme)
