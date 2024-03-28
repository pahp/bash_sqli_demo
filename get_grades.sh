#s!/usr/bin/env bash
# Simple SQL Injection Demo
# Dr. Peter A. H. Peterson <pahp@d.umn.edu>
# Released under the GPL: https://www.gnu.org/licenses/gpl-3.0.txt

echo -n "Enter your username: "
read USERNAME

echo -n "Enter your password: "
read PASSWORD

echo -n "Enter your id: "
read ID

QUERY="SELECT grade FROM grades WHERE user = '$USERNAME' AND pass = '$PASSWORD' AND id = $ID;"
echo $QUERY # uncomment for debugging

echo -n "Your average grade is: "

sqlite3 grades.db "$QUERY" # this will print the query result
