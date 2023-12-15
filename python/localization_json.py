import re
import json
import os
from typing import List, Dict

def extract_localization_keys_from_directory(directory_path: str) -> List[str]:
    """Extracts localization keys from all .dart files within a given directory."""
    keys = []
    key_pattern = re.compile(r"translate\('([^']+)'\)")

    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file.endswith(".dart"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r') as dart_file:
                    for line in dart_file:
                        matches = key_pattern.findall(line)
                        keys.extend(matches)

    return list(set(keys))  # Remove duplicates

def update_json_files(keys: List[str], json_file_paths: List[str]):
    """Updates JSON files with missing keys."""
    for json_path in json_file_paths:
        with open(json_path, 'r+', encoding='utf-8') as file:
            json_data = json.load(file)

            updated = False
            for key in keys:
                if key not in json_data:
                    json_data[key] = "missing_translation"  # Placeholder for missing translations
                    updated = True

            if updated:
                file.seek(0)  # Rewind file to the beginning
                json.dump(json_data, file, indent=4, ensure_ascii=False)
                file.truncate()  # Truncate file to new length

# Example usage
lib_directory_path = 'D:/Work/studybuddy/lib'  # Replace with the path to your 'lib' directory
json_file_paths = [
    'D:/Work/studybuddy/assets/lang/en.json',
    'D:/Work/studybuddy/assets/lang/de.json',
    'D:/Work/studybuddy/assets/lang/hr.json',
    'D:/Work/studybuddy/assets/lang/hu.json'
]  # Replace with the paths to your JSON localization files

# Extract keys from all .dart files in the 'lib' directory
localization_keys = extract_localization_keys_from_directory(lib_directory_path)

# Update JSON files
update_json_files(localization_keys, json_file_paths)
if __name__ == "__main__":
    localization_keys = extract_localization_keys_from_directory(lib_directory_path)
    update_json_files(localization_keys, json_file_paths)