''' Organize files '''

import os
import shutil
import tkinter as tk
from tkinter import filedialog

class OrganizerGUI:
    def __init__(self, master):
        self.master = master
        master.title('File Organizer')

        # Create the root directory selection button and label
        self.root_button = tk.Button(master, text='Select Root Directory', command=self.select_root_directory)
        self.root_button.pack(pady=5, padx=5)
        self.root_label = tk.Label(master, text='No directory selected')
        self.root_label.pack()

        # Create the new directory selection button and label
        self.root_new_dir_button = tk.Button(master, text='Select New Directory', command=self.select_new_directory)
        self.root_new_dir_button.pack(pady=5, padx=5)
        self.root_new_dir_label = tk.Label(master, text='No directory selected')
        self.root_new_dir_label.pack()

        # Create the file extension entry field
        self.extension_label = tk.Label(master, text='File Extension:')
        self.extension_label.pack(pady=5, padx=5)
        self.extension_entry = tk.Entry(master)
        self.extension_entry.insert(tk.END, '.mp3')
        self.extension_entry.pack()

        # Create the organize button
        self.organize_button = tk.Button(master, text='Organize', command=self.organize_mp3_files)
        self.organize_button.pack(pady=10)

        # Center all the elements
        master.pack_propagate(0)
        master.geometry("400x200")
        master.update_idletasks()
        width = master.winfo_width()
        height = master.winfo_height()
        x = (master.winfo_screenwidth() // 2) - (width // 2)
        y = (master.winfo_screenheight() // 2) - (height // 2)
        master.geometry('{}x{}+{}+{}'.format(width, height, x, y))

    def select_new_directory(self):
        # Open a file dialog box for the user to select the root directory
        new_directory = filedialog.askdirectory(title="Select the new directory")
        if new_directory:
            self.root_new_dir_label.config(text=new_directory)

    def select_root_directory(self):
        # Open a file dialog box for the user to select the root directory
        root_directory = filedialog.askdirectory(title="Select the root directory")
        if root_directory:
            self.root_label.config(text=root_directory)

    def organize_mp3_files(self):
        # Get the root directory and file extension from the GUI
        root_directory = self.root_label.cget('text')
        new_directory = self.root_new_dir_label.cget('text')
        extension = self.extension_entry.get()

        if root_directory:
            # Define the name of the new directory where mp3 files will be moved
            # new_directory_name = 'MP3_files'
            new_directory_path = new_directory

            # Create the new directory if it does not exist
            if not os.path.exists(new_directory_path):
                os.mkdir(new_directory_path)

            # Walk through all subdirectories in the root directory and move any mp3 files to the new directory
            for dirpath, dirnames, filenames in os.walk(root_directory):
                for filename in filenames:
                    if filename.endswith(extension):
                        file_path = os.path.join(dirpath, filename)
                        shutil.move(file_path, os.path.join(new_directory_path, filename))

            self.organize_button.config(text='MP3 files have been moved to the new directory.')
        else:
            self.organize_button.config(text='No directory was selected.')

if __name__ == '__main__':
    root = tk.Tk()
    gui = OrganizerGUI(root)
    root.mainloop()
