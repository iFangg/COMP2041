#!/usr/bin/env python3
import sys, requests, re
from bs4 import BeautifulSoup

code = sys.argv[1]
course_code = f"http://www.timetable.unsw.edu.au/2024/{code}KENS.html"
courses = {}

r = requests.get(course_code)
content = BeautifulSoup(r.content, 'html.parser')
for line in content.findAll():
    text = line.get('href')
    if not text or code not in text: continue
    desc = line.text
    if code in line.text: continue
    # print(repr(text))
    course = re.sub('\.html', '', text)
    if course in courses: continue
    courses[course] = desc
    # print(f"{course} {desc}")
    # print(repr(line.text))

for k, v in sorted(courses.items()):
    print(f"{k} {v}")
