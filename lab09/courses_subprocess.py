#!/usr/bin/env python3
import sys, subprocess

code = sys.argv[1]
courses = ""
curl_command = f'curl --location --silent "http://www.timetable.unsw.edu.au/2024/{code}KENS.html"'
grep_command = f'grep -E "{code}"'
cut_command = "cut -d'>' -f2,3"
sed_command = f'sed -E "s/.*({code}[0-9]{{4}}).*>([a-zA-Z ]+.*)<.*/\\1 \\2/"'
grep_v_command = f'grep -vE "{code}[0-9]{{4}} {code}[0-9]{{4}}$"'
sort_command = "sort"
uni_command = "uniq"

full_command = f"{curl_command} | {grep_command} | {cut_command} | {sed_command} | {grep_v_command} | {sort_command} | {uni_command}"

courses = subprocess.run(full_command, capture_output=True, shell=True, text=True)
print(courses.stdout, end="")
