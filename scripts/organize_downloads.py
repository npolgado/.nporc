import os
import shutil
import time

def organize_downloads():
    downloads = os.path.expanduser("~/Downloads")  # Replace with your downloads folder path
    for filename in os.listdir(downloads):

        # Ignore directories and this script file
        if os.path.isdir(os.path.join(downloads, filename)) or filename == os.path.basename(__file__):
            continue

        # Get the file extension and create a directory with the same name
        file_ext = os.path.splitext(filename)[1]
        file_ext = file_ext[1:].lower()  # Remove the dot and convert to lower case

        if not file_ext:
            file_ext = "Other"
        
        dest_dir = os.path.join(downloads, file_ext)

        if not os.path.exists(dest_dir):
            os.mkdir(dest_dir)

        # Move the file to the destination directory
        src_file = os.path.join(downloads, filename)
        dest_file = os.path.join(dest_dir, filename)

        if os.path.exists(dest_file):
            dest_file = os.path.join(dest_dir, f"{time.time()}_{filename}")
        
        shutil.move(src_file, dest_file)

    print("Downloads folder has been organized.")

# IMPLEMENTATION
if __name__ == "__main__":
    downloads = os.path.expanduser("~/Downloads")  # Replace with your downloads folder path
    if not os.path.exists(os.path.join(downloads, "Other")):
        organize_downloads()

    organize_downloads()
