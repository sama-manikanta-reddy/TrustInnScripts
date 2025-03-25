#!/bin/bash

# Function to validate and create the installation folder
validate_install_path() {
    local install_path="$1"

    # Check if the path is empty
    if [[ -z "$install_path" ]]; then
        echo "Error: No installation path provided."
        echo "Usage: $0 <installation_folder_path>"
        exit 1
    fi

    # Expand tilde (~) if used in path
    install_path=$(eval echo "$install_path")

    # Check if the path exists
    if [[ -d "$install_path" ]]; then
        echo "Installation directory exists: $install_path"
    else
        echo "Installation directory does not exist. Creating it now..."
        mkdir -p "$install_path"
        if [[ $? -eq 0 ]]; then
            echo "Successfully created installation directory: $install_path"
        else
            echo "Error: Failed to create installation directory."
            exit 1
        fi
    fi

    # Check write permissions
    if [[ ! -w "$install_path" ]]; then
        echo "Error: No write permissions for $install_path."
        exit 1
    fi

    echo "Installation path is valid: $install_path"
}

setup_gui(){

    echo "Installing GUI..."
    sudo apt install python3-tk python3-markdown2 -y || { echo "Failed to install python3 dependencies"; exit 1; }
    echo "Downloading python script from GitHub..."
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/GUI.py" -O GUI.py || { echo "Failed to download GUI.py"; exit 1; }
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/logo.png" -O logo.png || { echo "Failed to download logo.png"; exit 1; }

    # Modify GUI.py to set install_path dynamically
    if grep -q '^tool_install_path =' GUI.py; then
        sed -i "s|^tool_install_path = .*|tool_install_path = \"$INSTALL_PATH\"|" GUI.py
    else
        echo "tool_install_path = \"$INSTALL_PATH\"" | cat - GUI.py > temp && mv temp GUI.py
    fi

    echo "✅ GUI setup complete!"
}

# Function to install cbmc
install_cbmc() {
    local cbmc_dir="./C-Tools/CBMC"

    echo "Installing CBMC in $cbmc_dir..."
    mkdir -p "$cbmc_dir"
    pushd "$cbmc_dir" > /dev/null || { echo "Failed to enter $cbmc_dir"; exit 1; }
    
    echo "Installing CBMC..."
    sudo apt install cbmc -y || { echo "CBMC installation failed"; exit 1; }

    echo "Downloading CBMC running script from GitHub..."
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/cbmc/README.md" -O README.md
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/cbmc/run.sh" -O run.sh
    chmod +x run.sh || { echo "Failed to set execute permissions"; exit 1; }

    popd > /dev/null || { echo "Failed to return to previous directory"; exit 1; }
    echo "✅ CBMC installation complete!"
}

# Function to install Static Analysis
install_static_analysis() {
    local static_analysis_dir="./C-Tools/StaticAnalysis"

    echo "Installing Static Analysis in $static_analysis_dir..."
    mkdir -p "$static_analysis_dir"
    pushd "$static_analysis_dir" > /dev/null || { echo "Failed to enter $static_analysis_dir"; exit 1; }

    echo "Installing the latest LLVM release..."
    wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/LLVM-20.1.0-Linux-X64.tar.xz || { echo "Failed to download LLVM"; exit 1; }
    tar -xvf LLVM-20.1.0-Linux-X64.tar.xz || { echo "LLVM extraction failed"; exit 1; }
    rm -f LLVM-20.1.0-Linux-X64.tar.xz

    echo "Installing OPAM..."
    sudo apt install opam -y || { echo "OPAM installation failed"; exit 1; }
    opam init -y || { echo "OPAM initialization failed"; exit 1; }

    echo "Setting up OPAM switch..."
    # Check if the switch already exists
    if opam switch list --short | grep -q "^4.14.1$"; then
        echo "OPAM switch 4.14.1 already exists. Setting it..."
        opam switch set 4.14.1 || { echo "Failed to set OPAM switch"; exit 1; }
    else
        echo "Creating OPAM switch 4.14.1..."
        opam switch create 4.14.1 || { echo "OPAM switch creation failed"; exit 1; }
    fi
    eval "$(opam env --switch=4.14.1)" || { echo "OPAM environment setup failed"; exit 1; }

    echo "Installing Frama-C..." # asking for manual intervention
    opam install frama-c -y || { echo "Frama-C installation failed"; exit 1; }

    # Verify installation
    if ! command -v frama-c &> /dev/null; then
        echo "Error: Frama-C not found after installation!"
        exit 1
    fi

    echo "Downloading Static Analysis scripts from GitHub..."
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/static-analysis/README.md" -O README.md
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/static-analysis/clang.sh" -O clang.sh || { echo "Failed to download clang.sh"; exit 1; }
    chmod +x clang.sh
    sed -i "s|^export INSTALL_PATH=.*|export INSTALL_PATH=\"$INSTALL_PATH\"|" clang.sh

    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/static-analysis/run-Frama-C.sh" -O run-Frama-C.sh || { echo "Failed to download run-Framma-C.sh"; exit 1; }
    chmod +x run-Frama-C.sh
    sed -i "s|^export INSTALL_PATH=.*|export INSTALL_PATH=\"$INSTALL_PATH\"|" run-Frama-C.sh

    popd > /dev/null || { echo "Failed to return to previous directory"; exit 1; }
    echo "✅ Static Analysis installation complete!"
}

# Function to install ESBMC
install_esbmc() {
    local esbmc_dir="./Python-Tools/ESBMC"

    echo "Installing ESBMC in $esbmc_dir..."
    mkdir -p "$esbmc_dir"
    pushd "$esbmc_dir" > /dev/null || { echo "Failed to enter $esbmc_dir"; exit 1; }

    echo "Updating package lists..."
    sudo apt-get update -y || { echo "Failed to update package lists"; exit 1; }

    echo "Installing dependencies..."
    sudo apt-get install -y clang-14 llvm-14 clang-tidy-14 \
        python-is-python3 python3 python3-venv git ccache unzip wget curl \
        bison flex g++-multilib linux-libc-dev libboost-all-dev \
        libz3-dev libclang-14-dev libclang-cpp-dev cmake || { echo "Package installation failed"; exit 1; }

    # Clone ESBMC repository or update it if it already exists
    if [[ -d "esbmc" ]]; then
        echo "ESBMC directory already exists. Updating..."
        cd esbmc || { echo "Failed to enter esbmc directory"; exit 1; }
        git pull || { echo "Failed to update ESBMC repository"; exit 1; }
    else
        echo "Cloning ESBMC repository..."
        git clone https://github.com/esbmc/esbmc.git || { echo "Failed to clone ESBMC"; exit 1; }
        cd esbmc || { echo "Failed to enter esbmc directory"; exit 1; }
    fi

    echo "Building ESBMC..."
    mkdir -p build && cd build
    cmake .. -DENABLE_Z3=1 -DENABLE_PYTHON_FRONTEND=On || { echo "CMake configuration failed"; exit 1; }
    make -j4 || { echo "Build failed"; exit 1; }

    cd ../..
    echo "Downloading ESBMC running script from GitHub..."
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/esbmc/README.md" -O README.md
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/esbmc/run.sh" -O run.sh
    chmod +x run.sh || { echo "Failed to set execute permissions"; exit 1; }
    sed -i "s|^export INSTALL_PATH=.*|export INSTALL_PATH=\"$INSTALL_PATH\"|" run.sh

    echo "✅ ESBMC installation complete!"

    popd > /dev/null || { echo "Failed to return to previous directory"; exit 1; }
}

# Function to install AFL
install_afl() {
    local afl_dir="./Python-Tools/AFL"

    echo "Installing AFL in $afl_dir..."
    mkdir -p "$afl_dir"
    pushd "$afl_dir" > /dev/null || { echo "Failed to enter $afl_dir"; exit 1; }

    echo "Updating package lists..."
    sudo apt-get update -y || { echo "Failed to update package lists"; exit 1; }

    echo "Installing dependencies..."
    sudo apt-get install -y build-essential python3-dev automake cmake git \
        flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo \
        libgtk-3-dev lld llvm llvm-dev clang \
        ninja-build cpio libcapstone-dev wget curl python3-pip || { echo "Package installation failed"; exit 1; }

    # Clone AFL++ repository or update if it exists
    if [[ -d "AFLplusplus" ]]; then
        echo "AFLplusplus directory already exists. Updating..."
        cd AFLplusplus || { echo "Failed to enter AFLplusplus directory"; exit 1; }
        git reset --hard HEAD || { echo "Failed to reset AFLplusplus repository"; exit 1; }
        git pull origin main || { echo "Failed to update AFLplusplus repository"; exit 1; }
    else
        echo "Cloning AFLplusplus repository..."
        git clone https://github.com/AFLplusplus/AFLplusplus || { echo "Failed to clone AFLplusplus"; exit 1; }
        cd AFLplusplus || { echo "Failed to enter AFLplusplus directory"; exit 1; }
    fi

    echo "Building AFLplusplus..."
    make distrib || { echo "AFLplusplus build failed"; exit 1; }
    sudo make install || { echo "AFLplusplus installation failed"; exit 1; }

    # Verify installation
    if ! command -v afl-fuzz &> /dev/null; then
        echo "Error: afl-fuzz not found after installation!"
        exit 1
    fi

    rm -rf ../AFLplusplus

    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/AFL/README.md" -O README.md
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/AFL/set_core_pattern.c" -O set_core_pattern.c
    wget -q "https://raw.githubusercontent.com/sama-manikanta-reddy/TrustInnScripts/refs/heads/main/AFL/run.sh" -O run.sh
    chmod +x run.sh || { echo "Failed to set execute permissions"; exit 1; }
    gcc -o set_core_pattern set_core_pattern.c
    sudo chown root:root set_core_pattern
    sudo chmod 4755 set_core_pattern

    # Ensure AFL++ binaries are available in PATH
    export PATH="/usr/local/bin:$PATH"
    echo "✅ AFLplusplus installation complete!"

    popd > /dev/null || { echo "Failed to return to previous directory"; exit 1; }
}

# Function to install DSE
install_dse() {
    local dse_dir="./Python-Tools/DSE"

    echo "Installing DSE in $dse_dir..."
    mkdir -p "$dse_dir"
    pushd "$dse_dir" > /dev/null || { echo "Failed to enter $dse_dir"; exit 1; }

    # To be added
    git clone https://github.com/555shivv/tool.git || { echo "Error: Failed to clone repository!"; exit 1; }
    mv tool/PyExZ3-clone .
    rm -rf tool
    mv PyExZ3-clone/dse_run.sh .
    chmod +x dse_run.sh || { echo "Failed to set execute permissions"; exit 1; }
    sed -i "s|^export INSTALL_PATH=.*|export INSTALL_PATH=\"$INSTALL_PATH\"|" dse_run.sh
    
    echo "✅ DSE installation complete!"

    popd > /dev/null || { echo "Failed to return to previous directory"; exit 1; }
}

# Main script execution
sudo -v

INSTALL_PATH="$1"
validate_install_path "$INSTALL_PATH"

# Proceed with installation steps...
echo "Proceeding with installation in: $INSTALL_PATH"
INSTALL_PATH="${INSTALL_PATH}TrustInn"
mkdir -p "$INSTALL_PATH"
cd "$INSTALL_PATH"

# To refresh sudo password cache
while true; do sudo -n true; sleep 60; done &
SUDO_KEEPALIVE_PID=$!
trap "kill $SUDO_KEEPALIVE_PID" EXIT

echo "Updating package lists..."
sudo apt update -y || { echo "Failed to update package lists"; exit 1; }
sudo apt upgrade -y || { echo "Failed to upgrade packages"; exit 1; }

setup_gui
install_cbmc
install_static_analysis
install_esbmc
install_afl
install_dse
