import subprocess
import os
import pty
import tkinter as tk
from tkinter import ttk, filedialog, Toplevel
from tkinter import messagebox
import markdown2
import webbrowser

tool_install_path = ""

# Helper functions
def set_window_size(window, percentage):
	'''
		Basic function to set the window size
		to some percentage to screen resolution size
	'''
	screen_width = window.winfo_screenwidth()
	screen_height = window.winfo_screenheight()
	window_width = int(screen_width * percentage)
	window_height = int(screen_height * percentage)

	# Calculate the position to center the window
	position_x = (screen_width - window_width) // 2
	position_y = (screen_height - window_height) // 2

	window.geometry(f"{window_width}x{window_height}+{position_x}+{position_y}")

def open_readme_in_browser(tool_name):
    readme_files = {
        "CBMC": "./C-Tools/CBMC/README.md",
        "KLEEMA": "./C-Tools/KLEEMA/README.md",
        "KLEE-TX": "./C-Tools/KLEE-TX/README.md",
        "MCDC-TX": "./C-Tools/MCDC-TX/README.md",
        "SC-MCC-CBMC": "./C-Tools/SC-MCC-CBMC/README.md",
        "Static-Analysis": "./C-Tools/StaticAnalysis/README.md",
        "ESBMC": "./Python-Tools/ESBMC/README.md",
        "DSE": "./Python-Tools/DSE/README.md",
        "AFL": "./Python-Tools/AFL/README.md"
    }

    file_path = readme_files.get(tool_name)
    
    if not file_path or not os.path.isfile(file_path):
        messagebox.showinfo("Coming Soon", f"{tool_name} documentation is coming soon!")
        return  
    
    if file_path:
        with open(file_path, "r", encoding="utf-8") as f:
            md_content = f.read()
            html_content = markdown2.markdown(md_content, extras=["fenced-code-blocks"])

        html_template = f"""
        <html>
        <head>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-dark.css">
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    max-width: 900px;
                    margin: auto;
                    padding: 20px;
                }}
            </style>
        </head>
        <body class="markdown-body">
            {html_content}
        </body>
        </html>
        """

        temp_html_path = os.path.join(tool_install_path, ".temp_readme.html")
        with open(temp_html_path, "w", encoding="utf-8") as f:
            f.write(html_template)

        webbrowser.open(temp_html_path)


def browse_file(text, type, file_entry):
    filename = filedialog.askopenfilename(filetypes=[(text, type)])
    file_entry.delete(0, tk.END)
    file_entry.insert(0, filename)

def browse_directory(entry_widget):
    dir_path = filedialog.askdirectory()
    if dir_path:
        entry_widget.delete(0, tk.END)
        entry_widget.insert(0, dir_path)
        
def execute_c(tool_name, file_path, output_text, bound):
    if not tool_name:
        output_text.insert(tk.END, "Error: No tool selected. Please select a tool before executing.\n")
        return
    if not file_path:
        output_text.insert(tk.END, "Error: No file selected. Please select a file before executing.\n")
        return

    output_text.insert(tk.END, f"Executing {tool_name} on {file_path}...\n")

    if tool_name == "CBMC":
        execute_cbmc(tool_name, file_path, bound, output_text)  # Pass tool_name
    elif tool_name == "KLEEMA":
        execute_kleema(file_path, output_text)
    elif tool_name == "KLEE-TX":
        execute_klee_tx(file_path, output_text)
    elif tool_name == "MCDC-TX":
        execute_mcdc_tx(file_path, output_text)
    elif tool_name == "SC-MCC-CBMC":
        execute_sc_mcc_cbmc(file_path, output_text)
    elif tool_name == "Static-Analysis":
        execute_static_analysis(file_path, output_text)
    else:
        output_text.insert(tk.END, f"Unknown tool: {tool_name}\n")



def execute_python(tool_name,file_path,output_text,input_path) :
    if not tool_name:
        output_text.insert(tk.END, "Error: No tool selected. Please select a tool before executing.\n")
        return
    if not file_path:
        output_text.insert(tk.END, "Error: No file selected. Please select a file before executing.\n")
        return

    output_text.insert(tk.END, f"Executing {tool_name} on {file_path}...\n")
    if tool_name == "ESBMC":
        execute_esbmc(file_path, output_text)
    elif tool_name == "DSE":
        execute_dse(file_path, output_text)
    elif tool_name == "AFL":
        execute_afl(file_path, output_text,input_path)
    else:
        output_text.insert(tk.END, f"Unknown tool: {tool_name}\n")
    
# Implement specific functions for each tool - C
def execute_cbmc(tool_name, file_path, bound_value, output_text):
    output_text.insert(tk.END, "Running CBMC...\n")
    output_text.insert(tk.END, f"Executing {tool_name} on {file_path} with level {bound_value}...\n")

    script_path = os.path.join(expanded_path, "C-Tools", "CBMC", "run.sh")
    try:
        result = subprocess.run([script_path, file_path, bound_value], capture_output=True, text=True)
        output_text.insert(tk.END, result.stdout)
        if result.stderr:
            output_text.insert(tk.END, "Errors/Warning:\n" + result.stderr)
    except Exception as e:
        output_text.insert(tk.END, f"Error executing CBMC: {str(e)}\n")

        
def execute_kleema(file_path, output_text):
    output_text.insert(tk.END, "Running KLEEMA...\n")
    # KLEEMA specific implementation
    # ...

def execute_klee_tx(file_path, output_text):
    output_text.insert(tk.END, "Running KLEE-TX...\n")
    # KLEE-TX specific implementation
    # ...

def execute_mcdc_tx(file_path, output_text):
    output_text.insert(tk.END, "Running MCDC-TX...\n")
    # MCDC-TX specific implementation
    # ...

def execute_sc_mcc_cbmc(file_path, output_text):
    output_text.insert(tk.END, "Running SC-MCC-CBMC...\n")
    # SC-MCC-CBMC specific implementation
    # ...

def execute_static_analysis(file_path, output_text):
    output_text.insert(tk.END, "Running Static Analysis...\n")
    clang_script_path = os.path.join(expanded_path, "C-Tools", "StaticAnalysis", "clang.sh")
    framac_script_path = os.path.join(expanded_path, "C-Tools", "StaticAnalysis", "run-Framma-C.sh")
    llvm_path = os.path.join(expanded_path, "C-Tools" , "StaticAnalysis", "LLVM-20.1.0-Linux-X64")
    try:
        output_text.insert(tk.END, "Running clang script...\n")
        result = subprocess.run([clang_script_path, llvm_path ,file_path], capture_output=True, text=True)
        output_text.insert(tk.END, result.stdout)
        if result.stderr:
            output_text.insert(tk.END, "Errors:\n" + result.stderr)
        output_text.insert(tk.END, "Running Framma-C script...\n")
        result = subprocess.run([framac_script_path, file_path], capture_output=True, text=True)
        output_text.insert(tk.END, result.stdout)
        if result.stderr:
            output_text.insert(tk.END, "Errors:\n" + result.stderr)
    except Exception as e:
        output_text.insert(tk.END, f"Error executing Static Analysis: {str(e)}\n")

# Implement specific functions for each tool - Python
def execute_esbmc(file_path, output_text):
    output_text.insert(tk.END, "Running ESBMC...\n")
    script_path = os.path.join(expanded_path, "Python-Tools", "ESBMC", "run.sh")
    # Example: Run ESBMC with subprocess
    try:
        result = subprocess.run([script_path, file_path], capture_output=True, text=True)
        output_text.insert(tk.END, result.stdout)
        #if result.stderr:
        #    output_text.insert(tk.END, "Errors:\n" + result.stderr)
    except Exception as e:
        output_text.insert(tk.END, f"Error executing ESBMC: {str(e)}\n")

def execute_dse(file_path, output_text):
    output_text.insert(tk.END, "Running DSE...\n")
    script_path = os.path.join(expanded_path, "Python-Tools", "DSE", "dse_run.sh")
    try:
        result = subprocess.run([script_path, file_path], capture_output=True, text=True)
        output_text.insert(tk.END, result.stdout)
        if result.stderr:
            output_text.insert(tk.END, "Errors:\n" + result.stderr)
    except Exception as e:
        output_text.insert(tk.END, f"Error executing DSE: {str(e)}\n")

def execute_afl2(file_path, output_text, input_path):
    output_text.insert(tk.END, "Running AFL...\n")
    script_path = os.path.join(expanded_path, "Python-Tools", "AFL", "run.sh")

    try:
        result = subprocess.run([script_path, file_path, input_path], capture_output=True, text=True)
        output_text.insert(tk.END, result.stdout)
        # Uncomment below lines if you want to display errors
        # if result.stderr:
        #     output_text.insert(tk.END, "Errors:\n" + result.stderr)
    except Exception as e:
        output_text.insert(tk.END, f"Error executing AFL: {str(e)}\n")



def execute_afl(file_path, output_text, input_path):
    output_text.insert(tk.END, f"Executing AFL on {file_path}...\n")
    output_text.insert(tk.END, "Running AFL...\n")

    script_path = os.path.join(expanded_path, "Python-Tools", "AFL", "run.sh")

    try:
        # Open a pseudo-terminal (PTY) to capture interactive output
        master, slave = pty.openpty()

        # Run AFL script in an interactive shell (PTY)
        process = subprocess.Popen(
            [script_path, file_path, input_path], 
            stdin=subprocess.PIPE, stdout=slave, stderr=slave, text=True
        )

        os.close(slave)  # Close the slave descriptor

        # Read output in real-time
        with os.fdopen(master) as output:
            for line in output:
                output_text.insert(tk.END, line)
                output_text.update_idletasks()  # Ensure real-time GUI updates

        process.wait()  # Wait for AFL to finish
    except Exception as e:
        output_text.insert(tk.END, f"Error executing AFL: {str(e)}\n")

# Tab Content Functions
def C_Tab_Content(tab):
    # File selection frame
    file_frame = ttk.Frame(tab)
    file_frame.pack(fill="x", padx=10, pady=5)

    file_entry = ttk.Entry(file_frame)
    file_entry.pack(side="left", expand=True, fill="x", padx=5)

    file_button = ttk.Button(file_frame, text="File", command=lambda: browse_file("C File", "*.c", file_entry))
    file_button.pack(side="right", padx=5)

    # Level selection frame (same layout as file selection)
    level_frame = ttk.Frame(tab)
    level_frame.pack(fill="x", padx=10, pady=5)

    level_entry = ttk.Entry(level_frame)
    level_entry.pack(side="left", expand=True, fill="x", padx=5)

    level_button = ttk.Label(level_frame, text="Level")
    level_button.pack(side="right", padx=5)  # Label to the right like "File" button

    # Execute button
    execute_button = ttk.Button(tab, text="Execute", 
                                command=lambda: execute_c(tool_var.get(), file_entry.get(), output_text, level_entry.get()))
    execute_button.pack(fill="x", padx=10, pady=5)

    # Tool selection frame
    tool_frame = ttk.LabelFrame(tab, text="Tool")
    tool_frame.pack(side="left", padx=10, pady=5, fill="y")

    tools = ["CBMC", "KLEEMA", "KLEE-TX", "MCDC-TX", "SC-MCC-CBMC", "Static-Analysis"]
    tool_var = tk.StringVar()

    for tool in tools:
        ttk.Radiobutton(tool_frame, text=tool, variable=tool_var, value=tool).pack(anchor="w", padx=5, pady=2)

    # Output display
    output_frame = ttk.Frame(tab)
    output_frame.pack(expand=True, fill="both", padx=10, pady=5)

    output_text = tk.Text(output_frame, bg="black", fg="white")
    output_text.pack(expand=True, fill="both")

def Python_Tab_Content(tab):
    # File Selection Frame
    file_frame = ttk.Frame(tab)
    file_frame.pack(fill="x", padx=10, pady=5)

    file_entry = ttk.Entry(file_frame)
    file_entry.pack(side="left", expand=True, fill="x", padx=5)

    file_button = ttk.Button(file_frame, text="File", command=lambda: browse_file("Python File", "*.py", file_entry))
    file_button.pack(side="right", padx=5)

    # Input Directory Selection Frame (Placed Below File Selection)
    input_dir_frame = ttk.Frame(tab)
    input_dir_frame.pack(fill="x", padx=10, pady=5)

    input_dir_entry = ttk.Entry(input_dir_frame)
    input_dir_entry.pack(side="left", expand=True, fill="x", padx=5)

    input_dir_button = ttk.Button(input_dir_frame, text="Input Dir", command=lambda: browse_directory(input_dir_entry))
    input_dir_button.pack(side="right", padx=5)

    # Execute Button
    execute_button = ttk.Button(tab, text="Execute", 
                                command=lambda: execute_python(tool_var.get(), file_entry.get(), output_text, input_dir_entry.get()))
    execute_button.pack(fill="x", padx=10, pady=5)

    # Tool Selection Frame
    tool_frame = ttk.LabelFrame(tab, text="Tool")
    tool_frame.pack(side="left", padx=10, pady=5, fill="y")
    
    tools = ["ESBMC", "DSE", "AFL"]
    tool_var = tk.StringVar()

    for tool in tools:
        ttk.Radiobutton(tool_frame, text=tool, variable=tool_var, value=tool).pack(anchor="w", padx=5, pady=2)
    
    # Output Frame
    output_frame = ttk.Frame(tab)
    output_frame.pack(expand=True, fill="both", padx=10, pady=5)
    output_text = tk.Text(output_frame, bg="black", fg="white")
    output_text.pack(expand=True, fill="both")


def Java_Tab_Content(tab):
    tk.Label(tab, text="Coming soon..", font=("Arial", 14)).pack(pady=20)

# Main Window setup
MainWindow = tk.Tk()
expanded_path = os.path.expanduser(tool_install_path)
icon_path = os.path.join(expanded_path, "logo.png")
MainWindow.title("TrustInn")
MainWindow.iconphoto(True, tk.PhotoImage(file=icon_path))
set_window_size(MainWindow, 0.75)
MainWindow.resizable(True, True)

# Menu bar
menu_bar = tk.Menu(MainWindow)
MainWindow.config(menu=menu_bar)

help_menu = tk.Menu(menu_bar, tearoff=0)

# C-Tools Submenu
c_tools_menu = tk.Menu(help_menu, tearoff=0)
c_tools = ["CBMC", "KLEEMA", "KLEE-TX", "MCDC-TX", "SC-MCC-CBMC", "Static-Analysis"]
for tool in c_tools:
    c_tools_menu.add_command(label=tool, command=lambda t=tool: open_readme_in_browser(t))

# Python-Tools Submenu
python_tools_menu = tk.Menu(help_menu, tearoff=0)
python_tools = ["ESBMC", "DSE", "AFL"]
for tool in python_tools:
    python_tools_menu.add_command(label=tool, command=lambda t=tool: open_readme_in_browser(t))

# Add Submenus to Help
help_menu.add_cascade(label="C-Tools", menu=c_tools_menu)
help_menu.add_cascade(label="Python-Tools", menu=python_tools_menu)

# Add Help Menu to Menu Bar
menu_bar.add_cascade(label="Help", menu=help_menu)

# Tab group
Notebook = ttk.Notebook(MainWindow)
Notebook.pack(expand=True, fill="both")

# Create Frames (Tabs)
C_Tab = ttk.Frame(Notebook)
Python_Tab = ttk.Frame(Notebook)
Java_Tab = ttk.Frame(Notebook)

# Add tabs to Notebook
Notebook.add(C_Tab, text="C")
Notebook.add(Python_Tab, text="Python")
Notebook.add(Java_Tab, text="Java")

# Add content to tabs
C_Tab_Content(C_Tab)
Python_Tab_Content(Python_Tab)
Java_Tab_Content(Java_Tab)

# Main Loop
MainWindow.mainloop()
