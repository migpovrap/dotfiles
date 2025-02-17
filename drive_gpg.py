#!/usr/bin/env python3

import os
import shutil
import tempfile
from pathlib import Path
import subprocess
from typing import List, Tuple

# Global variable for the directory
TARGET_DIRECTORY = os.path.expanduser("~/Documents")

def get_gpg_files(directory: str = TARGET_DIRECTORY) -> Tuple[List[Path], List[Path]]:
    """Find all .gpg and .gpgtar files in the specified directory"""
    gpg_files = list(Path(directory).rglob("*.gpg"))
    gpgtar_files = list(Path(directory).rglob("*.gpgtar"))
    return gpg_files, gpgtar_files

def decrypt_gpg(file_path: Path) -> None:
    """Decrypt a .gpg file"""
    original_file_name = file_path.stem  # removes .gpg extension
    if '_' in original_file_name:
        # Split on last underscore and join with dot
        name_parts = original_file_name.rsplit('_', 1)
        original_file_name = '.'.join(name_parts)
    output_path = file_path.with_name(original_file_name)
    
    subprocess.run(['gpg', '--output', output_path.name, '-d', file_path.name], cwd=TARGET_DIRECTORY, check=True)
    print(f"Decrypted {file_path} to {output_path}")

def decrypt_gpgtar(file_path: Path) -> None:
    """Decrypt and extract a .gpgtar file"""
    with tempfile.TemporaryDirectory() as temp_dir:
        # Decrypt to temp directory
        subprocess.run(['gpgtar', '--decrypt', file_path.name], cwd=temp_dir, check=True)
        
        # Find the extracted directory (usually ends with _1_)
        extracted_dir = next(Path(temp_dir).glob("*.gpgtar_1_"), None)
        if extracted_dir:
            # Move contents to the directory where the .gpgtar file is located
            output_dir = file_path.parent
            
            # Move contents to final location
            for item in extracted_dir.iterdir():
                shutil.move(str(item), str(output_dir / item.name))
            
            # Remove the temporary extracted directory
            shutil.rmtree(extracted_dir)
            print(f"Extracted {file_path} to {output_dir}")
        else:
            print(f"Error: No extracted content found for {file_path}")

def list_files_and_dirs(directory: str = TARGET_DIRECTORY) -> List[Path]:
    """List all files and directories in the specified directory"""
    return list(Path(directory).iterdir())

def encrypt_file(file_path: str, gpg_key: str) -> None:
    """Encrypt a file or directory"""
    path = Path(file_path)
    if not path.exists():
        print(f"Error: {file_path} does not exist")
        return

    if path.is_dir():
        output_path = path.with_suffix('.gpgtar')
        subprocess.run(['gpgtar', '-r', gpg_key, '-o', output_path.name, '-e', path.name], cwd=TARGET_DIRECTORY, check=True)
        print(f"Encrypted directory {path} to {output_path}")
    else:
        output_path = path.with_suffix('.gpg')
        subprocess.run(['gpg', '-r', gpg_key, '--output', output_path.name, '-e', path.name], cwd=TARGET_DIRECTORY, check=True)
        print(f"Encrypted file {path} to {output_path}")

def main():
    gpg_key = "migpovrap@hotmail.com"
    
    # Change to the target directory
    os.chdir(TARGET_DIRECTORY)
    
    while True:
        gpg_files, gpgtar_files = get_gpg_files()
        
        print("\nAvailable operations:")
        print("1. Decrypt files")
        print("2. Encrypt a file/directory")
        print("3. Exit")
        
        choice = input("\nSelect an option (1-3): ")
        
        if choice == "1":
            print("\nAvailable files to decrypt:")
            all_files = [(i, f) for i, f in enumerate(gpg_files + gpgtar_files, 1)]
            
            for idx, file in all_files:
                print(f"{idx}. {file.name}")
            
            if not all_files:
                print("No encrypted files found.")
                continue
                
            try:
                file_idx = int(input("\nSelect a file number to decrypt (or 0 to cancel): ")) - 1
                if file_idx == -1:
                    continue
                    
                selected_file = all_files[file_idx][1]
                if selected_file.suffix == '.gpg':
                    decrypt_gpg(selected_file)
                else:
                    decrypt_gpgtar(selected_file)
            except (ValueError, IndexError):
                print("Invalid selection")
                
        elif choice == "2":
            print("\nAvailable files and directories to encrypt:")
            files_and_dirs = list_files_and_dirs()
            
            for idx, item in enumerate(files_and_dirs, 1):
                print(f"{idx}. {item.name}")
            
            if not files_and_dirs:
                print("No files or directories found.")
                continue
                
            try:
                file_idx = int(input("\nSelect a file/directory number to encrypt (or 0 to cancel): ")) - 1
                if file_idx == -1:
                    continue
                    
                selected_file = files_and_dirs[file_idx]
                encrypt_file(str(selected_file), gpg_key)
            except (ValueError, IndexError):
                print("Invalid selection")
                
        elif choice == "3":
            break
            
        else:
            print("Invalid option")

if __name__ == "__main__":
    main()