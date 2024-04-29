from collections import defaultdict

def read_dna(dna_file):
    """
    Read a DNA string from a file.
    the file contains data in the following format:
    A <-> T
    G <-> C
    G <-> C
    C <-> G
    G <-> C
    T <-> A
    Output a list of touples:
    [
        ('A', 'T'),
        ('G', 'C'),
        ('G', 'C'),
        ('C', 'G'),
        ('G', 'C'),
        ('T', 'A'),
    ]
    Where either (or both) elements in the string might be missing:
    <-> T
    G <->
    G <-> C
    <->
    <-> C
    T <-> A
    Output:
    [
        ('', 'T'),
        ('G', ''),
        ('G', 'C'),
        ('', ''),
        ('', 'C'),
        ('T', 'A'),
    ]
    """
    pairings = []
    with open(dna_file, "r") as f:
        for r_pair in f.read().split('\n'):
            pair = r_pair.split()
            # print(pair)
            if not pair: 
                # print(pair)
                continue
            if len(pair) < 3:
                missing_pair = ['', '']
                if len(pair) == 2:
                    missing_pair = [pair[0], ''] if pair[1] == "<->" else ['', pair[1]]
                pairings.append(missing_pair)
            else:
                # print(pair)
                pairings.append([pair[0], pair[2]])
            
    # print(pairings)
    return pairings

def is_rna(dna):
    """
    Given DNA in the aforementioned format,
    return the string "DNA" if the data is DNA,
    return the string "RNA" if the data is RNA,
    return the string "Invalid" if the data is neither DNA nor RNA.
    DNA consists of the following bases:
    Adenine  ('A'),
    Thymine  ('T'),
    Guanine  ('G'),
    Cytosine ('C'),
    RNA consists of the following bases:
    Adenine  ('A'),
    Uracil   ('U'),
    Guanine  ('G'),
    Cytosine ('C'),
    The data is DNA if at least 90% of the bases are one of the DNA bases.
    The data is RNA if at least 90% of the bases are one of the RNA bases.
    The data is invalid if more than 10% of the bases are not one of the DNA or RNA bases.
    Empty bases should be ignored.
    """

    dna_list = ['A', 'T', 'G', 'C']
    rna_list = ['A','U','G','C']
    dna_count = 0
    rna_count = 0
    invalid_count = 0
    total = 0
    # print(f"1: dna is {dna}")
    for pair in dna:
        if pair[0] in dna_list: dna_count += 1
        if pair[1] in dna_list: dna_count += 1
        if pair[0] in rna_list: rna_count += 1
        if pair[1] in rna_list: rna_count += 1
        if pair[0] not in dna_list and pair[0] not in rna_list: invalid_count += 1
        if pair[1] not in dna_list and pair[1] not in rna_list: invalid_count += 1
        total += 2

    # print(f"{dna_count}, {rna_count}, {invalid_count}, {total}")
    if dna_count / total >= 0.9: return "DNA"
    if rna_count / total >= 0.9: return "RNA"
    return "Invalid"



def clean_dna(dna):
    """
    Given DNA in the aforementioned format,
    If the pair is incomplete, ('A', '') or ('', 'G'), ect
    Fill in the missing base with the match base.
    In DNA 'A' matches with 'T', 'G' matches with 'C'
    In RNA 'A' matches with 'U', 'G' matches with 'C'
    If a pair contains an invalid base the pair should be removed.
    Pairs of empty bases should be ignored.
    """
    # print(f"2: dna is {[pair for pair in dna if '' in pair]}")
    dna_matching = {'A': 'T', 'T': 'A', 'G': 'C', 'C': 'G'}
    rna_matching = {'A': 'U', 'U': 'A', 'G': 'C', 'C': 'G'}
    data = is_rna(dna)
    new_dna = []
    for i in range(len(dna)):
        if not dna[i][0] and not dna[i][1]: continue
        if not dna[i][0]:
            if data == "RNA":
                dna[i][0] = rna_matching[dna[i][1]] if dna[i][1] in rna_matching else dna_matching[dna[i][1]]
            else:
                dna[i][0] = dna_matching[dna[i][1]] if dna[i][1] in dna_matching else rna_matching[dna[i][1]] 
        if not dna[i][1]:
            if data == "RNA":
                dna[i][1] = rna_matching[dna[i][0]] if dna[i][0] in rna_matching else dna_matching[dna[i][0]] 
            else:
                dna[i][1] = dna_matching[dna[i][0]] if dna[i][0] in dna_matching else rna_matching[dna[i][0]] 

        new_dna.append(dna[i])
        # print(f"2: updated dna = {dna[i]}")
    
    return new_dna

def mast_common_base(dna):
    """
    Given DNA in the aforementioned format,
    return the most common first base:
    eg. given:
    A <-> T
    G <-> C
    G <-> C
    C <-> G
    G <-> C
    T <-> A
    The most common first base is 'G'.
    Empty bases should be ignored.
    """
    # print(f"3: dna is {dna}")
    bases = defaultdict(int)
    for pair in dna:
        # print(pair) if pair[0] == 'U' else None
        bases[pair[0]] += 1
    # print(bases)
    max_base = []
    for k, v in sorted(bases.items(), key = lambda x: x[1], reverse = True):
        # print(f"{k}, {v}")
        max_base = [k, v]
        break
    # print(bases)
    # print(sorted(bases.items(), key = lambda x: x[1], reverse = True))
    # print(f"The most common first base is '{max_base[0]}'")
    return max_base[0]


def base_to_name(base):
    """
    Given a base, return the name of the base.
    The base names are:
    Adenine  ('A'),
    Thymine  ('T'),
    Guanine  ('G'),
    Cytosine ('C'),
    Uracil   ('U'),
    return the string "Unknown" if the base isn't one of the above.
    """
    # print(f"4: base is {base}")
    names = {'A': 'Adenine', 'T': 'Thymine', 'G': 'Guanine', 'C': 'Cytosine', 'U': 'Uracil'}
    name = names[base] if base in names else "Unkown"
    # print(name)
    return name
