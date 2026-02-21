#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CMPE150 – HW3: Library Management Simulation
Run as:
    Just press "Run" in your IDE.

The input and output files are hardcoded for simplicity:
    input_*.txt  -> input file
    output.txt   -> output file

Do NOT import any modules except sys if needed.
"""

# ==================== Core Solver Function ====================

def library_system(lines):
    output_lines = []
    book_holder = dict()
    user_books = dict()
    user_order = []

    def register_user(name):
        if name not in user_books:
            user_books[name] = []
            user_order.append(name)

    def format_datetime(timestamp):
        date = timestamp[:10].replace("-", "/")
        time = timestamp[11:].replace("-", ":")
        return date, time

    for raw_line in lines:
        line = raw_line.strip()
        if not line:
            continue

        # kayip kitap listesi
        if line == "Currently missing books.":
            missing = sorted(book_holder.keys())
            text = "Missing books are:" if not missing else "Missing books are: " + ", ".join(missing)
            output_lines.append(text)
            continue

        # people/books 
        if line == "Books borrowed by people.":
            for person in user_order:
                books = user_books[person]
                if books:
                    # kitaplari alfabetik olarak siralama
                    sorted_books = sorted(books)
                    info = f"{person} borrowed {len(sorted_books)} books: " + ", ".join(sorted_books)
                    output_lines.append(info)
            continue

        # borrow/return islemleri
        parts = line.split()
        if len(parts) < 4:
            continue

        timestamp = parts[0]
        name = parts[-3]
        action = parts[-2]
        book = parts[-1]

        date, time = format_datetime(timestamp)
        register_user(name)

        if action == "Borrow":
            if book in book_holder:  # zaten alinmissa
                msg = f"{name} requested {book} on {date} at {time} - book not available"
            else:
                book_holder[book] = name
                user_books[name].append(book)
                msg = f"{name} borrowed {book} on {date} at {time}"
            output_lines.append(msg)

        elif action == "Return":
            if book in book_holder:  # kitap gercekten oduncteyse
                actual_holder = book_holder[book]
                if actual_holder in user_books and book in user_books[actual_holder]:
                    user_books[actual_holder].remove(book)
                del book_holder[book]
            msg = f"{name} returned {book} on {date} at {time}"
            output_lines.append(msg)

    return "\n".join(output_lines).rstrip("\n")


    # === END OF YOUR SOLUTION ===
    ########## DO NOT CHANGE THE CODE BELOW ##########

    output_lines.append("")  
    return "\n".join(output_lines).rstrip("\n")


def _read_input(path):
    """Reads all lines from the input file"""
    with open(path, "r", encoding="utf-8") as f:
        return [line.rstrip("\n") for line in f]


def _write_output(path, text):
    """Writes the result to the output file"""
    if text and not text.endswith("\n"):
        text = text + "\n"
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)


# ==================== Main Execution ====================
if __name__ == "__main__":
    # input and output file names
    INPUT_FILE = "/Users/furkanahi/Desktop/CMPE150HW3/testcase_inputs/input_1.txt" ##### -> YOU CAN CHANGE THE FILE NAME FOR TESTING
    OUTPUT_FILE = "output.txt"

    # Read input
    lines = _read_input(INPUT_FILE)

    # Process library events
    result = library_system(lines)

    # Write output
    _write_output(OUTPUT_FILE, result)

    # Optional: feedback to student
    print(f"Processing finished. Output written to '{OUTPUT_FILE}'")
