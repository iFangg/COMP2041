#!/usr/bin/env python3
import sys, fileinput, re, os
from collections import defaultdict

if len(sys.argv) <= 1:
    print("usage: eddy [-i] [-n] [-f <script-file> | <sed-command>] [<files>...]")
    sys.exit(1)

# different operations for different flags (-n, -f)
# seq 10 21 | 2041 eddy '3,/2/d' -> starting from line "3," -> 3 to the end apply this command

# ss2 shows that all characters can be interpreted in the regex (incl \, ; , ",", etc)
# whitespaces not part of commands, can appear before and after commands
#  comments "#" denote no commands until end of command
# use stack data strucutre to figure out which characters are commands and which are regex
#   push to stack per character in command
commands = ['q', 'p', 'd', 's']

def closed_stack(stack, regex_end, is_sub):
    open_stk = []
    #  figure out stack problem w substitute
    for s in stack:
        if s == regex_end and s not in open_stk:
            if is_sub:
                open_stk.append(s)
            open_stk.append(s)
        elif s == regex_end and s in open_stk:
            open_stk.remove(s)
    # print(open_stk)
    return len(open_stk) == 0

def get_commands(text, cmd_regex_pair):
    # FIX PASSING IN MULTIPLE OF THE SAME COMMAND
    regex_stack = []
    curr_cmd = ""
    seq = ""
    lines = []
    signifier = '/'
    comment = False
    stripped_text = text.replace(' ', '')

    for i in range(len(stripped_text)):
        char = stripped_text[i]
        if char == "s" and closed_stack(regex_stack, signifier, True):
            signifier = stripped_text[i + 1]

        if char == signifier:
            if seq:
                regex_stack.append(seq)
                seq = ""
            regex_stack.append(char)
            continue

        if char == "#" and closed_stack(regex_stack, signifier, curr_cmd == "s"):
            comment = True
            continue

        if (char in commands or char in ';\n') and closed_stack(regex_stack, signifier, curr_cmd == "s"): # double check if this checks if you're outside of regex search
            # print(f"char: {char}")
            regex_stack.append(seq) if seq else None
            curr_cmd = char if char in commands else curr_cmd

            if curr_cmd == 's':
                cmd_regex_pair[curr_cmd].append(regex_stack) if regex_stack else None
            else:
                cmd_regex_pair[curr_cmd] = regex_stack if regex_stack else cmd_regex_pair[curr_cmd]
            if char in ';\n':
                curr_cmd = ""
                # print(cmd_regex_pair)
                if comment:
                    comment = False
            regex_stack = []
            seq = ""
            continue
        seq += char if not comment else ""

    if seq or regex_stack:
        regex_stack.append(seq)

        if curr_cmd == 's':

            cmd_regex_pair[curr_cmd].append(regex_stack) if regex_stack else None
        else:
            cmd_regex_pair[curr_cmd] = regex_stack if not seq.startswith("#") else cmd_regex_pair[curr_cmd]

            

def processed_output(cmd_regex_pair, flags, use_file, file_data):
    line_count = 1
    quit_line = float("inf")
    delete_line = [float("inf"), float("inf")]
    print_line = [float("inf"), float("inf")]

    select_line = [float("inf"), float("inf")]
    select_reg_match = 0
    select_regex = ""
    select_repl = ""
    g_repl = False
    if 's' in cmd_regex_pair and len(cmd_regex_pair['s']) > 1:
        g_repl = False if cmd_regex_pair['s'][1][-1] != 'g' else True
        select_regex = cmd_regex_pair['s'][1][1]
        select_repl = cmd_regex_pair['s'][1][3] if cmd_regex_pair['s'][1][2] != cmd_regex_pair['s'][1][3] else ""
    elif 's' in cmd_regex_pair and len(cmd_regex_pair['s']) > 0:
        g_repl = False if cmd_regex_pair['s'][0][-1] != 'g' else True
        select_regex = cmd_regex_pair['s'][0][1]
        select_repl = cmd_regex_pair['s'][0][3] if cmd_regex_pair['s'][0][2] != cmd_regex_pair['s'][0][3] else ""

    
    # quit
    if 'q' in cmd_regex_pair:
        if len(cmd_regex_pair['q']) == 1:
            quit_line = int(cmd_regex_pair['q'][0]) if cmd_regex_pair['q'][0] != "$" else float("inf")
    
    
    # sub
    if 's' in cmd_regex_pair:
        if len(cmd_regex_pair['s']) == 2:
            if len(cmd_regex_pair['s'][0]) == 1:
                if ',' in cmd_regex_pair['s'][0][0]:
                    interval = cmd_regex_pair['s'][0][0].split(',')
                    select_line = [int(interval[0]), int(interval[1])]
                else:
                    select_line = [int(cmd_regex_pair['s'][0][0]), int(cmd_regex_pair['s'][0][0])] if len(cmd_regex_pair['s'][0]) == 1 else [float("inf"), float("inf")]
            elif len(cmd_regex_pair['s'][0]) > 1:
                if ',' in cmd_regex_pair['s'][0][0]:
                    lower = cmd_regex_pair['s'][0][0].split(',')
                    select_line = [int(lower[0]), float("inf")]
                elif ',' in cmd_regex_pair['s'][0][-1]:
                    til_line = cmd_regex_pair['s'][0][-1].split(',')
                    select_line = [cmd_regex_pair['s'][0][1], int(til_line[1])]
                elif ',' in cmd_regex_pair['s'][0][len(cmd_regex_pair['s'][0]) // 2]:
                    select_line = [cmd_regex_pair['s'][0][1], cmd_regex_pair['s'][0][-2]] 
        
        if len(cmd_regex_pair['s'][0]) > 1:
            select_reg_match = 1


    # del
    if 'd' in cmd_regex_pair:
        if len(cmd_regex_pair['d']) == 1:
            if ',' in cmd_regex_pair['d'][0]:
                interval = cmd_regex_pair['d'][0].split(',')
                delete_line = [int(interval[0]), int(interval[1])]
            else:
                delete_line = [int(cmd_regex_pair['d'][0]), int(cmd_regex_pair['d'][0])] if cmd_regex_pair['d'][0] != "$" else [float("inf"), float("inf")]
        
        elif len(cmd_regex_pair['d']) > 1:
            if ',' in cmd_regex_pair['d'][0]:
                lower = cmd_regex_pair['d'][0].split(',')
                delete_line = [int(lower[0]), cmd_regex_pair['d'][-2]]
            elif ',' in cmd_regex_pair['d'][-1]:
                til_line = cmd_regex_pair['d'][-1].split(',')
                delete_line = [cmd_regex_pair['d'][1], int(til_line[1])]
            elif ',' in cmd_regex_pair['d'][len(cmd_regex_pair['d']) // 2]:
                delete_line = [cmd_regex_pair['d'][1], cmd_regex_pair['d'][-2]]

    # print
    if 'p' in cmd_regex_pair:
        if len(cmd_regex_pair['p']) == 1:
            if ',' in cmd_regex_pair['p'][0]:
                interval = cmd_regex_pair['p'][0].split(',')
                print_line = [int(interval[0]), int(interval[1])]
            else:
                print_line = [int(cmd_regex_pair['p'][0]), int(cmd_regex_pair['p'][0])] if len(cmd_regex_pair['p']) == 1 and cmd_regex_pair['p'][0] != "$" else [float("inf"), float("inf")]
        
        elif len(cmd_regex_pair['p']) > 1:
            if ',' in cmd_regex_pair['p'][0]:
                lower = cmd_regex_pair['p'][0].split(',')
                print_line = [int(lower[0]), float("inf")]
            elif ',' in cmd_regex_pair['p'][-1]:
                til_line = cmd_regex_pair['p'][-1].split(',')
                print_line = [cmd_regex_pair['p'][1], int(til_line[1])]
            elif ',' in cmd_regex_pair['p'][len(cmd_regex_pair['p']) // 2]:
                print_line = [cmd_regex_pair['p'][1], cmd_regex_pair['p'][-2]]
    
    
    # change to read files
    file_input = sys.stdin if not use_file else file_data
    line = sys.stdin.readline() if not use_file else file_data.pop(0)
    ending = "" if not use_file else "\n"
    for lines in file_input:
        curr = lines
        edited_line = line

        if 's' in cmd_regex_pair and len(cmd_regex_pair['s']) > 0:
            if len(cmd_regex_pair['s']) > 1:
                if isinstance(select_line[0], int) and isinstance(select_line[1], int) and select_line[0] <= line_count <= select_line[1]:
                    edited_line = re.sub(select_regex, select_repl, line, count = 1) if not g_repl else re.sub(select_regex, select_repl, line)
                # edited_line = re.sub(select_regex, select_repl, line, count = 1) if not g_repl else re.sub(select_regex, select_repl, line)
                
                elif re.search(cmd_regex_pair['s'][0][select_reg_match], line) and select_line == [float("inf"), float("inf")]:
                    edited_line = re.sub(select_regex, select_repl, line, count = 1) if not g_repl else re.sub(select_regex, select_repl, line)

            elif len(cmd_regex_pair['s']) == 1:
                edited_line = re.sub(select_regex, select_repl, line, count = 1) if not g_repl else re.sub(select_regex, select_repl, line)
        

        # sub
        if isinstance(select_line[0], int) and isinstance(select_line[1], int) and select_line[0] <= line_count <= select_line[1]:
            print(re.sub(select_regex, select_repl, line), end = ending)
            line = curr
            line_count += 1
            continue

        if isinstance(select_line[0], int) and not isinstance(select_line[1], int) and select_line[0] <= line_count:
            print(re.sub(select_regex, select_repl, line), end = ending)
            line = curr
            line_count += 1
            continue
        
        if isinstance(select_line[1], int) and not isinstance(select_line[0], int) and select_line[0] != float("inf") and re.search(select_line[0], line):
            while line_count < select_line[1]:
                print(re.sub(select_regex, select_repl, line), end = ending)
                line = sys.stdin.readline() if not use_file else file_data.pop(0)
                curr = line
                line_count += 1

            line = curr
            line_count += 1
            continue
        
        if not isinstance(select_line[0], int) and not isinstance(select_line[1], int) and select_line != [float("inf"), float("inf")]:
            if re.search(select_line[0], line):
                print(re.sub(select_regex, select_repl, line), end = ending)
                while line:
                    # print(f"hi {line}", end="")
                    print(re.sub(select_regex, select_repl, curr), end = ending)
                    line = sys.stdin.readline() if not use_file else file_data.pop(0)
                    curr = line
                    line_count += 1
                    if re.search(select_line[1], line):
                        print(re.sub(select_regex, select_repl, line), end = ending)
                        line = sys.stdin.readline() if not use_file else file_data.pop(0)
                        curr = line
                        line_count += 1
                        break
            else:
                # print("hello")
                print(line, end = ending)

            line = curr
            line_count += 1
            continue
  
        
        if 's' in cmd_regex_pair and len(cmd_regex_pair['s']) == 2 and len(cmd_regex_pair['s'][0]) > 1 and re.search(cmd_regex_pair['s'][0][1], line):
            print(edited_line, end = ending)
            line = curr
            line_count += 1
            continue


        # del
        if isinstance(delete_line[0], int) and isinstance(delete_line[1], int) and delete_line[0] <= line_count <= delete_line[1]:
            line = curr
            line_count += 1
            if line_count >= quit_line: 
                quit_line = float("inf")
            continue
        
        if isinstance(delete_line[0], int) and not isinstance(delete_line[1], int) and delete_line[1] != float("inf"):
            if delete_line[0] == line_count:
                while line:
                    if re.search(delete_line[1], line) and delete_line != line_count:
                        line = sys.stdin.readline() if not use_file else file_data.pop(0)
                        curr = line
                        line_count += 1
                        if line_count >= quit_line: 
                            quit_line = float("inf")
                        break
                    
                    line = sys.stdin.readline() if not use_file else file_data.pop(0)
                    curr = line
                    line_count += 1
                    if line_count >= quit_line: 
                        quit_line = float("inf")
            else:
                print(line, end = ending) if not flags['n'] else None
                line = curr
                curr = sys.stdin.readline() if not use_file else file_data.pop(0)
                line_count += 1
                if line_count >= quit_line: 
                    quit_line = float("inf")
            
            continue
        
        if isinstance(delete_line[1], int) and not isinstance(delete_line[0], int) and delete_line[0] != float("inf") and re.search(delete_line[0], line):
            while line_count < delete_line[1]:
                line = sys.stdin.readline() if not use_file else file_data.pop(0)
                curr = line
                line_count += 1
            if line_count >= quit_line:
                quit_line = float("inf")
            line = curr
            line_count += 1
            continue
        
        if not isinstance(delete_line[0], int) and not isinstance(delete_line[1], int) and delete_line != [float("inf"), float("inf")]:
            if re.search(delete_line[0], line):
                while line:
                    line = sys.stdin.readline() if not use_file else file_data.pop(0)
                    curr = line
                    line_count += 1
                    if re.search(delete_line[1], line):
                        line = sys.stdin.readline() if not use_file else file_data.pop(0)
                        curr = line
                        line_count += 1
                        break
            else:
                print(line, end = ending)

            if line_count >= quit_line:
                quit_line = float("inf")

            line = curr
            line_count += 1
            continue
 
        if 'd' in cmd_regex_pair and len(cmd_regex_pair['d']) > 1 and re.search(cmd_regex_pair['d'][1], line):
            line = curr
            line_count += 1
            if line_count >= quit_line:
                quit_line = float("inf")
            continue
        
        if 'd' in cmd_regex_pair and delete_line == [float("inf"), float("inf")]:
            if len(cmd_regex_pair['d']) == 0: 
                line = curr
                line_count += 1
                continue


        # print
        # if print_line[0] <= line_count <= print_line[1]:
        #     print(edited_line, end = "")
        if isinstance(print_line[0], int) and isinstance(print_line[1], int) and print_line[0] <= line_count <= print_line[1]:
            print(line, end = ending) if not flags["n"] else None
            print(edited_line, end = ending)
            line = curr
            line_count += 1
            continue
        
        if isinstance(print_line[0], int) and not isinstance(print_line[1], int) and print_line[0] <= line_count:
            print(line, end = ending) if not flags["n"] else None
            print(edited_line, end = ending)
            line = curr
            line_count += 1
            continue
        
        if isinstance(print_line[1], int) and not isinstance(print_line[0], int) and print_line[0] != float("inf") and re.search(print_line[0], line):
            print(line, end = ending) if not flags["n"] else None
            print(line, end = ending)
            while line_count < print_line[1]:
                print(curr, end = ending) if not flags["n"] else None
                print(curr, end = ending)
                line = sys.stdin.readline() if not use_file else file_data.pop(0)
                curr = line
                line_count += 1
            line = curr
            line_count += 1
            continue
        
        if not isinstance(print_line[0], int) and not isinstance(print_line[1], int) and print_line != [float("inf"), float("inf")]:
            if re.search(print_line[0], line):
                print(line, end = ending) if not flags["n"] else None
                print(line, end = ending)
                while line:
                    print(curr, end = ending) if not flags["n"] else None
                    print(curr, end = ending)
                    line = sys.stdin.readline() if not use_file else file_data.pop(0)
                    curr = line
                    line_count += 1
                    if re.search(print_line[1], line):
                        print(line, end = ending) if not flags["n"] else None
                        print(line, end = ending)
                        line = sys.stdin.readline() if not use_file else file_data.pop(0)
                        curr = line
                        line_count += 1
                        break
            else:
                print(line, end = ending)

            line = curr
            line_count += 1
            continue
        
        if 'p' in cmd_regex_pair and len(cmd_regex_pair['p']) > 1 and re.search(cmd_regex_pair['p'][1], line):
            print(line, end = ending)
        
        elif 'p' in cmd_regex_pair and print_line == [float("inf"), float("inf")]:
            print(line, end = ending) if len(cmd_regex_pair['p']) == 0 else None
        

        # quit
        if line_count == quit_line:
            print(edited_line, end = ending) if not flags['n'] else None
            return
        if 'q' in cmd_regex_pair:
            if not cmd_regex_pair['q']:
                print(f"{edited_line}", end = ending) if not flags['n'] else None
                return

            if len(cmd_regex_pair['q']) > 1 and re.search(cmd_regex_pair['q'][1], line):
                print(f"{edited_line}", end = ending) if not flags['n'] else None
                return

        # print("hi")
        print(f"{edited_line}", end = ending) if not flags['n'] else None
        line = curr
        line_count += 1



    if 'q' in cmd_regex_pair:
        if not cmd_regex_pair['q']:
            print(line, end = ending)
            return
        if cmd_regex_pair['q'][0] == "$":
            print(line, end = ending)
            return
        if line_count >= quit_line:
            return
        # if len(cmd_regex_pair['p']) > 1 and re.search(cmd_regex_pair['q'][1], line):
        #     print(line, end = "")
        #     return
    if 'd' in cmd_regex_pair:
        if not cmd_regex_pair['d']:
            return
        if cmd_regex_pair['d'][0] == "$":
            return
        if isinstance(delete_line[0], int) and isinstance(delete_line[1], int) and delete_line[0] <= line_count <= delete_line[1]:
            return
        if len(cmd_regex_pair['d']) > 1 and re.search(cmd_regex_pair['d'][1], line):
            return
    if 'p' in cmd_regex_pair:
        if not cmd_regex_pair['p'] or cmd_regex_pair['p'][0] == "$":
            print(line, end = ending)
        else:
            if len(cmd_regex_pair['p']) > 1 and re.search(cmd_regex_pair['p'][1], line):
                print(line, end = ending)
            else:
                print(line, end = ending) if isinstance(print_line[0], int) and isinstance(print_line[1], int) and print_line[0] <= line_count <= print_line[1] else None
    if 's' in cmd_regex_pair:
        if len(cmd_regex_pair['s']) == 2:
            if cmd_regex_pair['s'][0][0] == "$" or (isinstance(select_line[0], int) and isinstance(select_line[1], int) and select_line[0] <= line_count <= select_line[1]) or (len(cmd_regex_pair['s'][0]) > 1 and re.search(cmd_regex_pair['s'][0][1], line)):
                print(re.sub(select_regex, select_repl, line), end = ending) if g_repl else print(re.sub(select_regex, select_repl, line, count=1), end = ending)
                return
        else:
            print(re.sub(select_regex, select_repl, line), end = ending) if g_repl else print(re.sub(select_regex, select_repl, line, count=1), end = ending)
            return

    print(line, end = ending) if not flags['n'] else None
    return

try:
    cmd_regex_pair = defaultdict(list)
    flags = {"n": False, "f": False, "i": False}
    use_file = False
    file_data = []

    for i in range(1, len(sys.argv[1:]) + 1):
        cmd = sys.argv[i]
        if cmd == "-n": 
            flags["n"] = True
            continue
        if cmd == "-f":
            flags["f"] = True
            continue
        if cmd == "-i":
            flags["i"] = True
            continue

        if flags["f"]:
            with open(cmd, "r") as f:
                get_commands(f.read(), cmd_regex_pair)
            
            flags["f"] = False
        else:
            if os.path.exists(cmd) and os.path.isfile(cmd):
                use_file = True
                with open(cmd, "r") as f:
                    for line in f.read():
                        file_data.append(f"{line.strip()}") if line != "\n" else None
            else:
                get_commands(cmd, cmd_regex_pair)
        

    # print(f"cmds and regexes:")
    # for k, v in cmd_regex_pair.items():
    #     print(f"{k}: {v}")
    processed_output(cmd_regex_pair, flags, use_file, file_data)
except Exception as e:
    print("eddy: command line: invalid command")
    sys.exit(1)

