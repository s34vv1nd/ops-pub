#!/bin/bash
# hung1 poller: pull repo, run hung/cmd.txt once per change, push result
cd "$(dirname "$0")/.." || exit 0
git pull -q 2>/dev/null
H=$(md5sum hung/cmd.txt 2>/dev/null | cut -d" " -f1)
[ -z "$H" ] && exit 0
[ -f hung/.h1 ] && [ "$(cat hung/.h1)" = "$H" ] && exit 0
echo "$H" > hung/.h1
bash hung/cmd.txt > hung/res-hung1.txt 2>&1
git add hung/res-hung1.txt hung/.h1 2>/dev/null
git -c user.email=h1@eaera -c user.name=h1 commit -qm "hung1 $H" 2>/dev/null
git push -q origin HEAD 2>/dev/null
