#DFA Example

dfa = {
    "states": ["q0", "q1"],
    "alphabet": ["a", "b"],
    "start_state": "q0",
    "accepting_states": ["q1"],
    "transitions": {
        "q0": {
            "a": "q1",
            "b": "q0"
        },
        "q1": {
            "a": "q0",
            "b": "q1"
        }
    }
}


# ==================== Given Function ====================

def simulate_DFA(dfa, word):
    """
    Simulate the given DFA on the input word.
    Returns True if the word is accepted, False otherwise.
    """
    current_state = dfa["start_state"]
    for char in word:
        current_state = dfa["transitions"][current_state][char]
    return current_state in dfa["accepting_states"]


# ==================== TASK 1: computation_history ====================

def computation_history(dfa, word):
    """
    Return the list of configurations during the run of the DFA on 'word'.

    Configuration format:
        <consumed_part>-<current_state>-<unconsumed_part>

    Example:
        word = "ab"
        ["-q0-ab", "a-q1-b", "ab-q1-"]
    """
    history = []

    current_state = dfa["start_state"]
    consumed = ""
    unconsumed = word

    # Initial configuration (before reading any symbol)
    history.append(f"{consumed}-{current_state}-{unconsumed}")

    # Process each character
    for ch in word:
        next_state = dfa["transitions"][current_state][ch]

        # Move character from unconsumed to consumed
        consumed += ch
        unconsumed = unconsumed[1:]

        current_state = next_state

        # Record configuration after this step
        history.append(f"{consumed}-{current_state}-{unconsumed}")

    return history


# ==================== Helper: generate strings of given length ====================

def _generate_strings_of_length(alphabet, length):
    """
    Generate all strings over 'alphabet' of exact given 'length'.
    Returned in a consistent order: lexicographic w.r.t. alphabet.
    """
    if length == 0:
        return [""]  # epsilon
    if length == 1:
        return alphabet[:]  # copy

    shorter = _generate_strings_of_length(alphabet, length - 1)
    result = []
    for s in shorter:
        for ch in alphabet:
            result.append(s + ch)
    return result


# ==================== TASK 2: language_exploration ====================

def language_exploration(dfa, n):
    """
    Explore the language of the DFA up to length n.

    Returns a dictionary:
        key   = string (length 0..n)
        value = "ACCEPT" or "REJECT"
    """
    alphabet = dfa["alphabet"]
    result = {}

    # Generate all strings of length 0..n
    for length in range(0, n + 1):
        words = _generate_strings_of_length(alphabet, length)
        for w in words:
            if simulate_DFA(dfa, w):
                result[w] = "ACCEPT"
            else:
                result[w] = "REJECT"

    return result


# ==================== TASK 3: language_report ====================

def language_report(dfa, n):
    """
    Produce statistics over all strings of length 0..n:

    - "<state>_visit_count"
    - "<from>_<symbol>_<to>_transition_count"
    - "total_accepted"
    - "total_rejected"
    """
    alphabet = dfa["alphabet"]
    states = dfa["states"]
    start_state = dfa["start_state"]
    accepting_states = dfa["accepting_states"]
    transitions = dfa["transitions"]

    report = {}

    # 1) Initialize state visit counts
    for state in states:
        report[f"{state}_visit_count"] = 0

    # 2) Initialize transition usage counts
    for from_state, trans_dict in transitions.items():
        for symbol, to_state in trans_dict.items():
            key = f"{from_state}_{symbol}_{to_state}_transition_count"
            report[key] = 0

    # 3) Initialize total accepted / rejected
    report["total_accepted"] = 0
    report["total_rejected"] = 0

    # Consider all strings of length 0..n
    for length in range(0, n + 1):
        words = _generate_strings_of_length(alphabet, length)

        for w in words:
            current_state = start_state

            # Start state is visited once at the beginning of each run
            report[f"{current_state}_visit_count"] += 1

            # Process each character and track transitions/visits
            for ch in w:
                next_state = transitions[current_state][ch]

                # Transition usage count
                t_key = f"{current_state}_{ch}_{next_state}_transition_count"
                report[t_key] += 1

                # Move to next state and count visit
                current_state = next_state
                report[f"{current_state}_visit_count"] += 1

            # Check if this word is accepted or rejected
            if current_state in accepting_states:
                report["total_accepted"] += 1
            else:
                report["total_rejected"] += 1

    return report


# ==================== Optional simple tests ====================
# Bunlar sadece kendi bilgisayarında denemek için.
# İstersen teslim etmeden önce silebilirsin.

if __name__ == "__main__":
    print("=== Task 1: computation_history ===")
    print('computation_history(dfa, ""):')
    print(computation_history(dfa, ""))
    print()

    print('computation_history(dfa, "a"):')
    print(computation_history(dfa, "a"))
    print()

    print('computation_history(dfa, "ab"):')
    print(computation_history(dfa, "ab"))
    print()

    print('computation_history(dfa, "ababa"):')
    print(computation_history(dfa, "ababa"))
    print()

    print("=== Task 2: language_exploration (n=2) ===")
    print(language_exploration(dfa, 2))
    print()

    print("=== Task 3: language_report (n=2) ===")
    print(language_report(dfa, 2))



