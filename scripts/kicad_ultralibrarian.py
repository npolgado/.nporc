import os
import shutil
import tkinter as tk
from tkinter import filedialog
import zipfile

# os.path()

SYMBOL_PATH = r"C:\Users\Nick\Documents\KiCad\6.0\symbols"

FOOTPRINT_PATH = r"C:\Users\Nick\Documents\KiCad\6.0\footprints"

print(f"{os.path.isdir(SYMBOL_PATH)}\n{os.path.isdir(FOOTPRINT_PATH)}")

# Prompt user to select a zip file
root = tk.Tk()
root.withdraw()
zip_file_path = filedialog.askopenfilename(filetypes=[("Zip Files", "*.zip")])
print(zip_file_path)

project_name = input("Please enter a name for your project: ")

# Step 2: Unzip the zip file and find the .lib file and folder with .pretty in the name
with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
    # create temporary folder to extract zip contents
    tmp_folder = "tmp"
    zip_ref.extractall(tmp_folder)
    
for root, dirs, files in os.walk(tmp_folder):
    for file in files:
        if file.endswith(".lib"):
            lib_file_path = os.path.join(root, file)
            # Step 3: Rename .lib file and .pretty folder with project name
            new_lib_file_path = os.path.join(root, f"{project_name}.lib")
            os.rename(lib_file_path, new_lib_file_path)


    for dir in dirs:
        if ".pretty" in dir:
            pretty_folder_path = os.path.join(root, dir)

            new_pretty_folder_path = os.path.join(os.path.dirname(pretty_folder_path), f"{project_name}.pretty")
            os.rename(pretty_folder_path, new_pretty_folder_path)

# Step 4: Copy .lib file to SYMBOL_PATH and move .pretty folder to FOOTPRINT_PATH
shutil.copy(new_lib_file_path, SYMBOL_PATH)
shutil.move(new_pretty_folder_path, FOOTPRINT_PATH)

# Remove temporary folder
shutil.rmtree(tmp_folder)

print("Done!")