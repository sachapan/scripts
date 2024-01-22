#!env python3
import sys
import re

def process_lines(lines):
    result_lines = []
    current_line = ""

    for line in lines:
        line = line.strip()

        # Skip blank lines
        if not line:
            continue

        # Skip lines that begin with a number
        if re.match(r'^\d', line):
            continue

        # Skip lines that contain only numbers and symbols
        if re.match(r'^[0-9\W]+$', line):
            continue

        # Replace underscores with a single quote before 's' or 't'
        line = re.sub(r'_(s|t)\b', r"'\1", line)

        # Remove html-like code
        line = re.sub("<[^<]+?>", "", line)

        # Concatenate lines until the length is 100 characters
        if len(current_line) + len(line) <= 100:
            current_line += line + " "
        else:
            result_lines.append(current_line.strip())
            current_line = line + " "

    # Add the last line
    if current_line:
        result_lines.append(current_line.strip())

    return result_lines

def main():
    if len(sys.argv) == 1:
        # Read input from stdin
        lines = sys.stdin.readlines()
    elif len(sys.argv) == 2:
        # Read input from file
        input_file = sys.argv[1]
        with open(input_file, 'r', encoding='utf-8') as file:
            lines = file.readlines()
    else:
        print("Usage: python script.py [input_file]")
        sys.exit(1)

    processed_lines = process_lines(lines)
    print('\n'.join(processed_lines))

if __name__ == "__main__":
    main()

