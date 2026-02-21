#DFA Example
dfa = {
    "states": ["q0", "q1"],
    "alphabet": ["a", "b"],
    "start_state": "q0",
    "accepting_states": ["q1"],
    "transitions": {
        "q0": {"a": "q1", "b": "q0"},
        "q1": {"a": "q0", "b": "q1"}
    }
}


def simulate_DFA(dfa, word):
    state = dfa["start_state"]
    for ch in word:
        state = dfa["transitions"][state][ch]
    return state in dfa["accepting_states"]

# TASK 1:computation_history

def computation_history(dfa, word):
    hist = []
    state = dfa["start_state"]
    consumed = ""
    rest = word

    hist.append(f"{consumed}-{state}-{rest}")

    for ch in word:
        nxt = dfa["transitions"][state][ch]
        consumed += ch
        rest = rest[1:]
        state = nxt
        hist.append(f"{consumed}-{state}-{rest}")

    return hist

# HELPER: generate strings of given length

def _all_strings(alpha, length):
    if length == 0:
        return [""]
    if length == 1:
        return alpha[:]

    prev = _all_strings(alpha, length - 1)
    out = []
    for base in prev:
        for ch in alpha:
            out.append(base + ch)
    return out

# TASK 2:language_exploration

def language_exploration(dfa, n):
    alpha = dfa["alphabet"]
    out = {}
    for L in range(n + 1):
        for w in _all_strings(alpha, L):
            out[w] = "ACCEPT" if simulate_DFA(dfa, w) else "REJECT"
    return out

# TASK 3:language_report

def language_report(dfa, n):
    alpha = dfa["alphabet"]
    states = dfa["states"]
    start = dfa["start_state"]
    acc = dfa["accepting_states"]
    trans = dfa["transitions"]

    rep = {}

    #1)Initialize state visit counts
    for s in states:
        rep[f"{s}_visit_count"] = 0
    #2)Initialize transition usage counts
    for s in trans:
        for sym in trans[s]:
            t = trans[s][sym]
            rep[f"{s}_{sym}_{t}_transition_count"] = 0
    #3)Initialize total accepted/rejected
    rep["total_accepted"] = 0
    rep["total_rejected"] = 0

    for L in range(n + 1):
        for w in _all_strings(alpha, L):
            st = start
            rep[f"{st}_visit_count"] += 1

            for ch in w:
                nxt = trans[st][ch]
                rep[f"{st}_{ch}_{nxt}_transition_count"] += 1
                st = nxt
                rep[f"{st}_visit_count"] += 1

            if st in acc:
                rep["total_accepted"] += 1
            else:
                rep["total_rejected"] += 1

    return rep


# optional tests
if __name__ == "__main__":
    print(computation_history(dfa, "ababa"))
    print(computation_history(dfa, "baab"))
    print(language_exploration(dfa, 2))
    print(language_exploration(dfa, 1))
    print(language_report(dfa, 2))
    print(language_report(dfa, 3))
    
