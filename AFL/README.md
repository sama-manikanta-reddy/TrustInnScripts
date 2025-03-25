# [Internal Documentation] AFL (American Fuzzy Lop) Tool Installation Guide for Python Testing

<table width="100%">
  <tr>
    <td><strong>Author:</strong> Ch. Amarindhraa Sai </td>
    <td align="right"><strong>Last Updated:</strong> 06-03-2025</td>
  </tr>
</table>

This document provides step-by-step instructions to install and configure **AFL++ (American Fuzzy Lop)** for **Python fuzz testing** on an Ubuntu system.

---

## Table of Contents

- [\[Internal Documentation\] AFL (American Fuzzy Lop) Tool Installation Guide for Python Testing](#internal-documentation-afl-american-fuzzy-lop-tool-installation-guide-for-python-testing)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Tested Versions](#tested-versions)
  - [Prerequisites](#prerequisites)
  - [Step-by-Step Installation](#step-by-step-installation)
    - [Step 1: Install Dependencies](#step-1-install-dependencies)
    - [Step 2: Install AFL++ Manually](#step-2-install-afl-manually)
    - [Step 3: Set Up Core Dump Configuration](#step-3-set-up-core-dump-configuration)
    - [Step 4: Compile and Set Root Permissions](#step-4-compile-and-set-root-permissions)
    - [Step 5: Set Up Python AFL Environment](#step-5-set-up-python-afl-environment)
    - [Step 6: AFL Testing for Python Programs](#step-6-afl-testing-for-python-programs)
  - [Verification](#verification)
  - [Troubleshooting](#troubleshooting)
  - [Additional Resources](#additional-resources)

---

## Introduction

**AFL (American Fuzzy Lop)** is a powerful **fuzzing tool** designed to discover security vulnerabilities in applications by generating and mutating inputs. **AFL++** is an enhanced version of AFL with additional features, better performance, and improved fuzzing capabilities.

This guide covers **manual installation** of AFL++, setting up **python-afl**, configuring **core dump handling**, and automating testing for Python programs.

---

## Tested Versions

The following versions were used during testing:

- **OS:** Ubuntu 24.04.1 LTS
- **Tool Versions:**
  - **AFL++:** 4.09c
  - **Python:** 3.11.2
  - **GCC:** 13.3.0

---

## Prerequisites

Ensure the following requirements are met before proceeding:

✔ **Ubuntu 20.04 or later** (64-bit recommended)  
✔ **Administrator privileges** (sudo access required once)  
✔ **Python 3 and Virtual Environment support**  
✔ **Sufficient disk space** (At least 2GB for fuzzing results)  

---

## Step-by-Step Installation

### Step 1: Install Dependencies

Run the following commands to install all required dependencies:

```bash
sudo apt-get update
sudo apt-get install -y build-essential python3-dev automake cmake git \
    flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo \
    libgtk-3-dev lld llvm llvm-dev clang \
    ninja-build cpio libcapstone-dev wget curl python3-pip
```

---

### Step 2: Install AFL++ Manually

AFL++ must be installed manually to ensure the latest version is used.

```bash
git clone https://github.com/AFLplusplus/AFLplusplus
cd AFLplusplus
make distrib
sudo make install
```

Verify the installation:

```bash
afl-fuzz --version
```

Expected output:

```bash
American Fuzzy Lop ++ 4.09c
```

---

### Step 3: Set Up Core Dump Configuration

AFL++ requires core dumps to analyze crashes effectively. By default, Linux redirects core dumps to crash handlers like `apport`. We will modify this behavior.

1. **Create a C program to modify `/proc/sys/kernel/core_pattern`**  

   Save the following code as `set_core_pattern.c`:

   ```c
   #include <stdio.h>
   #include <fcntl.h>
   #include <unistd.h>

   int main() {
       if (geteuid() != 0) {
           fprintf(stderr, "Error: This program must be run as root.\n");
           return 1;
       }

       int fd = open("/proc/sys/kernel/core_pattern", O_WRONLY);
       if (fd < 0) {
           perror("Error opening /proc/sys/kernel/core_pattern");
           return 1;
       }

       if (write(fd, "core\n", 5) < 0) {
           perror("Error writing to /proc/sys/kernel/core_pattern");
           close(fd);
           return 1;
       }

       close(fd);
       printf("Successfully set core_pattern to 'core'\n");
       return 0;
   }
   ```

---

### Step 4: Compile and Set Root Permissions

To allow normal users to modify core dump settings **without sudo**, we set root permissions:

```bash
gcc -o set_core_pattern set_core_pattern.c
sudo chown root:root set_core_pattern
sudo chmod 4755 set_core_pattern
```

---

### Step 5: Set Up Python AFL Environment

1. **Create and activate a virtual environment:**
   ```bash
   python3 -m venv afl-env
   source afl-env/bin/activate
   ```
2. **Install `python-afl` inside the virtual environment:**
   ```bash
   pip install python-afl
   ```

---

### Step 6: AFL Testing for Python Programs

1. **Create a Python test script (`test_afl.py`)**
2. **Download the `pythonafl_script.sh` automation script**
3. **Download `set_core_pattern.c` programme which set to handle core dumps internally and avoid apport to handle them**
4. **Prepare test input corpus**  
   Create an `input_dir` with sample test cases:

   ```bash
   mkdir input_dir
   echo "sample test case" > input_dir/test1.txt
   ```
5. **Run `rootowner.sh` script file which compiles a C programme to handles core dumps internally**
   ```bash
   ./rootowner.sh
   ```
6. **Run the script (`pythonafl_script`):**
   ```bash
   chmod +x pythonafl_script.sh
   ./pythonafl_script.sh  <path-to-python-programme>
   ```

---

## Verification

To confirm the installation, verify the following:

✔ **Check AFL++ installation:**
   ```bash
   afl-fuzz --version
   ```
   Expected output:
   ```
   American Fuzzy Lop ++ 4.09c
   ```

✔ **Check virtual environment creation:**
   ```bash
   ls afl-env
   ```
   Expected output:
   ```
   bin  include  lib  lib64  pyvenv.cfg
   ```

✔ **Verify installed Python packages:**
   ```bash
   source afl-env/bin/activate
   pip list | grep python-afl
   ```
   Expected output:
   ```
   python-afl x.x.x
   ```

✔ **Check fuzzing output directory:**
   ```bash
   ls output_dir
   ```
   Expected output:
   ```
   queue  crashes  hangs
   ```

---


## Troubleshooting
If you encounter any issues:

✔ **Ensure AFL++ and its dependencies are installed correctly**.
✔ **Check that core dump configuration is set correctly by running:**
```bash
cat /proc/sys/kernel/core_pattern
```
✔ **If python-afl is not found, reinstall it:**
```bash
pip install --force-reinstall python-afl
```
✔ **Ensure you are running all commands inside the virtual environment:**
```bash 
source afl-env/bin/activate
```

## Additional Resources

- 📖 [AFL++ GitHub Repository](https://github.com/AFLplusplus/AFLplusplus)  
- 📝 [AFL++ Documentation](https://aflplus.plus/docs/)  
- 🔍 [Fuzzing Applications with AFL](https://medium.com/@ayushpriya10/fuzzing-applications-with-american-fuzzy-lop-afl-54facc65d102)  

---
