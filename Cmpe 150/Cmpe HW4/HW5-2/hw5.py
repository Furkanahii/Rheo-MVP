import sys
import pickle

# Constants ve global degiskenler

RESERVED_KEYWORDS = {
    "wa", "o", "no", "atai", "de", "aru", "print", "suru",
    "tasu", "seisu", "moji-retsu", "kakeru", "kaikakko", "tojikakko",
    "puroguramu", "hajimeyo", "oware"
}

symbol_table = {}
current_line_no = 0

# Hata fonksiyonlari

def raise_compile_error():
    raise Exception(f"Compile error line_no={current_line_no}")

def raise_runtime_error(line_no):
    raise Exception(f"Runtime error line_no={line_no}")
 
# Sayi siniflandirma 4'lü gruplara
def format_jpl_number(value: int) -> str:
    s = str(value)
    if len(s) <= 4: 
        return s
    groups = []
    while len(s) > 0:
        groups.append(s[-4:])
        s = s[:-4]
    return ",".join(reversed(groups))

# Sayi literal kontrolü ve parse

def parse_numeric_literal(token: str) -> int:
    if not token:
        raise_compile_error()

    for ch in token:
        if not (ch.isdigit() or ch == ','):
            raise_compile_error()

    if token.startswith(",") or token.endswith(",") or ",," in token:
        raise_compile_error()

    parts = token.split(",")
    if not (1 <= len(parts[0]) <= 4):
        raise_compile_error()
    for p in parts[1:]:
        if len(p) != 4:
            raise_compile_error()

    digits = "".join(parts)
    if len(digits) > 10:
        raise_compile_error()
    if len(digits) > 1 and digits.startswith("0"):
        raise_compile_error()

    return int(digits)

# Satir formatinin kontrolü 

def validate_line_format(line: str):
    in_string = False
    i = 0
    n = len(line)

    while i < n:
        ch = line[i]

        # '-' string siniri mi,keyword icindeki '-' mi?
        is_hyphen_delim = False
        if ch == '-':
            if in_string:
                is_hyphen_delim = True
                in_string = False
            else:
                if i == 0 or line[i-1] == ' ':
                    is_hyphen_delim = True
                    in_string = True

        # string disinda iken karakter kontrolleri
        if not in_string and not is_hyphen_delim:
            if not ch.isascii():
                raise_compile_error()

            if ch == ' ':
                if i + 1 < n and line[i+1] == ' ':
                    raise_compile_error()
            elif not (ch.isalnum() or ch == ',' or ch == '.' or ch == '-'):
                raise_compile_error()

        i += 1

# Tokenize(string literal destekli)

def tokenize_line(content: str):
    tokens = []
    i = 0
    n = len(content)

    while i < n:
        if content[i] == ' ':
            i += 1
            continue

        is_string_start = (content[i] == '-') and ((i == 0) or (content[i-1] == ' '))

        if is_string_start:
            j = content.find('-', i + 1)
            if j == -1:
                raise_compile_error()
            tokens.append(content[i:j+1])
            i = j + 1
        else:
            j = i
            while j < n and content[j] != ' ':
                j += 1
            tokens.append(content[i:j])
            i = j

    return tokens

# Değişken ismi kontrolü

def is_valid_variable_name(name):
    if not name.isascii():
        return False
    if not name.isalpha():
        return False
    if len(name) > 30:
        return False
    return True

# Expression parser(tasu / kakeru)

def parse_expr(tokens, i, depth):
    left_node, i, left_type = parse_term(tokens, i, depth)

    if i < len(tokens) and tokens[i] == "tasu":
        right_node, i, right_type = parse_expr(tokens, i + 1, depth)

        if left_type == "int" and right_type == "int":
            return ("ADD", left_node, right_node), i, "int"
        elif left_type == "str" and right_type == "str":
            return ("ADD", left_node, right_node), i, "str"
        else:
            raise_compile_error()

    return left_node, i, left_type

def parse_term(tokens, i, depth):
    left_node, i, left_type = parse_factor(tokens, i, depth)

    if i < len(tokens) and tokens[i] == "kakeru":
        right_node, i, right_type = parse_term(tokens, i + 1, depth)

        if left_type == "int" and right_type == "int":
            return ("MUL", left_node, right_node), i, "int"
        elif left_type == "int" and right_type == "str":
            return ("MUL", left_node, right_node), i, "str"
        else:
            raise_compile_error()

    return left_node, i, left_type

def parse_factor(tokens, i, depth):
    if i >= len(tokens):
        raise_compile_error()
    t = tokens[i]

    # Parantez
    if t == "kaikakko":
        if depth > 0:
            raise_compile_error()
        node, idx, expr_type = parse_expr(tokens, i + 1, depth + 1)
        if idx >= len(tokens) or tokens[idx] != "tojikakko":
            raise_compile_error()
        return node, idx + 1, expr_type

    # String literal: 
    if t.startswith("-") and t.endswith("-") and len(t) >= 2:
        val = t[1:-1]
        if "-" in val:
            raise_compile_error()
        if len(val) > 10000:
            raise_compile_error()
        return val, i + 1, "str"

    # Variable
    if t[0].isalpha():
        v = t.lower()
        if not is_valid_variable_name(t):
            raise_compile_error()
        if v not in symbol_table:
            raise_compile_error()
        return ("VAR", v), i + 1, symbol_table[v]

    # Number literal
    if t[0].isdigit():
        val = parse_numeric_literal(t)
        return val, i + 1, "int"

    raise_compile_error()
    
# Compile (source/pickle instructions)

def compile_jpl(input_file, obj_file):
    global current_line_no, symbol_table
    symbol_table = {}

    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.read().splitlines()

    if not lines:
        current_line_no = 1
        raise_compile_error()

    current_line_no = 1
    if lines[0] != "Puroguramu o hajimeyo .":
        raise_compile_error()

    current_line_no = len(lines)
    if lines[-1] != "Puroguramu o oware .":
        raise_compile_error()

    instructions = []

    for idx in range(1, len(lines) - 1):
        current_line_no = idx + 1
        line = lines[idx]

        if not line:
            raise_compile_error()
        if line.startswith(" ") or line.endswith(" "):
            raise_compile_error()
        if not line.endswith(" ."):
            raise_compile_error()

        content = line[:-2]
        validate_line_format(content)
        tokens = tokenize_line(content)
        if not tokens:
            raise_compile_error()

        # Declaration
        if len(tokens) >= 2 and tokens[1] == "wa":
            if not (len(tokens) == 5 and tokens[3] == "de" and tokens[4] == "aru"):
                raise_compile_error()
            var_name = tokens[0]
            var_lower = var_name.lower()
            if not is_valid_variable_name(var_name):
                raise_compile_error()
            if var_lower in RESERVED_KEYWORDS:
                raise_compile_error()
            if var_lower in symbol_table:
                raise_compile_error()
            ttype = tokens[2]
            if ttype not in ("seisu", "moji-retsu"):
                raise_compile_error()
            vtype = "int" if ttype == "seisu" else "str"
            symbol_table[var_lower] = vtype
            instructions.append(("DEC", var_lower, vtype, current_line_no))

        # Assignment
        elif len(tokens) >= 4 and tokens[1] == "no" and tokens[2] == "atai":
            if not (tokens[3] == "wa" and tokens[-2] == "de" and tokens[-1] == "aru"):
                raise_compile_error()
            var_lower = tokens[0].lower()
            if var_lower not in symbol_table:
                raise_compile_error()
            expr_tokens = tokens[4:-2]
            if not expr_tokens:
                raise_compile_error()
            node, pidx, expr_type = parse_expr(expr_tokens, 0, 0)
            if pidx != len(expr_tokens):
                raise_compile_error()
            target_type = symbol_table[var_lower]
            if target_type != expr_type:
                raise_compile_error()
            instructions.append(("SET", var_lower, node, current_line_no))

        # Print
        elif len(tokens) >= 4 and tokens[-3] == "o" and tokens[-2] == "print" and tokens[-1] == "suru":
            expr_tokens = tokens[:-3]
            if not expr_tokens:
                raise_compile_error()
            node, pidx, expr_type = parse_expr(expr_tokens, 0, 0)
            if pidx != len(expr_tokens):
                raise_compile_error()
            instructions.append(("PRT", node, current_line_no))

        else:
            raise_compile_error()

    with open(obj_file, 'wb') as f:
        pickle.dump(instructions, f)

# Execute (pickle instructions/output)

runtime_mem = {}

def eval_node(node, line_no):
    if isinstance(node, tuple):
        op = node[0]
        if op == "VAR":
            return runtime_mem[node[1]]

        left = eval_node(node[1], line_no)
        right = eval_node(node[2], line_no)

        if op == "ADD":
            if isinstance(left, int) and isinstance(right, int):
                res = left + right
                if res > 9999999999:
                    raise_runtime_error(line_no)
                return res
            if isinstance(left, str) and isinstance(right, str):
                res = left + right
                if len(res) > 10000:
                    raise_runtime_error(line_no)
                return res
            raise_runtime_error(line_no)

        if op == "MUL":
            if isinstance(left, int) and isinstance(right, int):
                res = left * right
                if res > 9999999999:
                    raise_runtime_error(line_no)
                return res
            if isinstance(left, int) and isinstance(right, str):
                res = right * left
                if len(res) > 10000:
                    raise_runtime_error(line_no)
                return res
            raise_runtime_error(line_no)

    return node

def execute_jpl(obj_file, out_file):
    global runtime_mem
    with open(obj_file, 'rb') as f:
        instructions = pickle.load(f)

    runtime_mem = {}

    with open(out_file, 'w', encoding='utf-8') as f:
        for instr in instructions:
            opcode = instr[0]
            line_no = instr[-1]

            if opcode == "DEC":
                runtime_mem[instr[1]] = 0 if instr[2] == "int" else ""
            elif opcode == "SET":
                runtime_mem[instr[1]] = eval_node(instr[2], line_no)
            elif opcode == "PRT":
                val = eval_node(instr[1], line_no)
                if isinstance(val, int):
                    f.write(format_jpl_number(val) + "\n")
                else:
                    f.write(f"-{val}-\n")
                f.flush()

if __name__ == "__main__":
    if len(sys.argv) == 4:
        if sys.argv[1] == "-compile":
            compile_jpl(sys.argv[2], sys.argv[3])
        elif sys.argv[1] == "-execute":
            execute_jpl(sys.argv[2], sys.argv[3])
