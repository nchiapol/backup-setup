#!/bin/bash
echo "comparing 100 random files from backup with live data"
if [ $# -ne 1 ]
then
    echo "usage:"
    echo "    random_check.sh <repo-path>::<archive-id>"
    exit 1
fi

VERIFY_DIR=$(mktemp -d)
cd "$VERIFY_DIR" || exit
echo "extracting files from backup (this will take some time)"
borg list --format "{type} {path}{NL}" "$1" | grep -e "^-" | shuf -n 100 | grep -o "home/.*" | xargs -d '\n' borg extract "$1"
IDENTICAL=$(diff -rs "$VERIFY_DIR/home/nchiapol/" ~/ | grep -ce 'identical$')

if [ "$IDENTICAL" -eq 100 ]
then
    echo -e "\nSUCCESS: all files are identical\n"
    cd - >> /dev/null || exit
    echo "removing temporary directory"
    rm -rf "$VERIFY_DIR"
else
    echo -e "\nFAILURE: $IDENTICAL/100 files are identical\n"
    echo "temporary directory not removed: $VERIFY_DIR"
fi
