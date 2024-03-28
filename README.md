# bash_sqli_demo
A demonstration of SQL injection using bash and sqlite3

# requirements

You'll need a `bash` shell and an `sqlite3` binary. If you don't have `sqlite3`, run:

```
$ apt install sqlite3-tools
```

# how to look at the database with sqlite3

To open the database, run:

```
$ sqlite3 grades.db
```

You'll see something like this:
```
SQLite version 3.37.2 2022-01-06 13:25:41
Enter ".help" for usage hints.
sqlite>
```

To see the schema of the database, run:
```
sqlite> .schema
```

To see everything in the database, run:

```
sqlite3> SELECT * FROM grades;
```

You'll see the output:
```
1|peters01|zxcvbnm|Peter Peterson|3.7
2|mcloon01|qazwsx|Jumbo McLoony|2.1
3|tables01|qwerty|Bobby Drop Tables|4.7
4|roosev01|abc123|Teddy Roosevelt|3.9
6|klass01|qwerty|Ryan Z. Klassen|4.0
5|olear01|wasd1234|Mrs. O'Leary|3.3
```

You can try out other queries too, e.g.:

```
sqlite> SELECT realname FROM grades WHERE grade > 3.5;
sqlite> SELECT grade FROM grades WHERE realname LIKE "%bb%";
sqlite> SELECT grade FROM grades WHERE id = 1;
```

You can do conjunctions and disjunctions and combinations thereof:
```
sqlite> SELECT realname FROM grades WHERE id > 1 AND grade > 3;
sqlite> SELECT realname FROM grades WHERE id = 1 OR id = 2;
sqlite> SELECT realname FROM grades WHERE id = 1 OR realname LIKE "%o%" AND grade > 3;
```
Remember that strings in SQL must be quoted (e.g., like the `realname` field above), while numbers are not (like `grade` above).

SQL also has a comment sequence, which is `--` -- anything after a `--` that is in a query (not in a string) will comment out the rest of the query:
```
sqlite> SELECT realname FROM grades WHERE id = 1 -- OR realname LIKE "%o%" AND grade > 3;
```
The above query will only return records where `id = 1` because the rest of the query is commented out.

You can delete a table by running:
```
sqlite> DROP TABLE grades;
```

# restoring the database
If you just deleted the table, you can restore it by quitting sqlite3. First, press `control-D` at the `sqlite>` prompt. Then, at the `bash` prompt, run:

```
$ ./setup.sh
```
This will restore the database from the backup file.

# get_grades.sh

This program will report the grade for a user, once they "authenticate" themselves by providing some personal information. You can get the necessary information from sqlite.

Here's a sample run:
```
$ ./get_grades.sh 
Enter your username: peters01
Enter your password: zxcvbnm
Enter your id: 1
SELECT grade FROM grades WHERE user = 'peters01' AND pass = 'zxcvbnm' AND id = 1;
Your average grade is: 3.7
```

The program works by first getting the `username`, `password`, and `id` using the bash builtin `read`, which takes input from standard input (here the keyboard) and storing it in the variables.

Then, it constructs an SQL query in a variable by taking constant data (the string) and substituting in the variables just read from the keyboard. 

Then, it prints the value of `QUERY` just so you can see it, and then it executes the query using `sqlite3`, printing the results.

You can see the original QUERY string in the code:
```
QUERY="SELECT grade FROM grades WHERE user = '$USERNAME' AND pass = '$PASSWORD' AND id = $ID;"
```

So, if you ran `get_grades.sh` and typed in `peters01`, `zxcvbnm`, and `1` (as in the above example), `QUERY` would hold:
```
SELECT grade FROM grades WHERE user = 'peters01' AND pass = 'zxcvbnm' AND id = 1;
```

# SQL injection

SQL Injection is a class of attacks where a user inserts SQL code into variables that will be substituted into a query string (just as above) to make the program do something it wasn't supposed to do.

Classic tricks for doing this include:
 * closing strings by putting a `'` in the input
 * starting additional queries with `;` (where allowed)
 * commenting out portions of queries
 * using tautologies that are always true, like `foo = foo` or `1 = 1`
 * adding additional terms by inserting things like `1 OR INSERT_YOUR_CONDITION_HERE` where applicable
 * ... and more!

Many things you might try will simply result in syntax errors. However, look at the query that results, see if you can figure out why there was an error, and then improve your injection so that it does something interesting.

# Challenges

See if you can make these things happen:

 1. Make `get_grades.sh` print grades of other users without knowing information about them.
 2. Update grades in the database.
 3. Insert records into the database.
 4. Print the entire database.
 5. Delete the database.

Remember, if you delete the database, you can just run `./setup.sh` to restore it.

# Remediating SQL Injection

The classic -- but **deprecated** -- approach to remediating SQL injection is to first **validate** input, to make sure that each variable contains only the correct type and length of data. For example, `get_grades.sh` should make sure that data assigned to the variable `ID` contains only numbers. If all data is valid, the next step in the old-fashioned approach is to **sanitize** all input by *escaping* any variables that could contain SQL code (e.g., that have alphanumeric data including punctuation). This turns special characters, like `'`, `--`, `%`, `;` and more into simple characters to be read, rather than special SQL characters to be interpreted. However, simply escaping SQL queries is no longer the preferred approach because it can be done poorly and can fail in hard to predict ways. Don't do this unless you really know what you're doing.

Instead, the modern appraoch is to use [prepared statements / parameterized queries](https://cheatsheetseries.owasp.org/cheatsheets/Query_Parameterization_Cheat_Sheet.html). This is a much more foolproof method for securing your SQL-using application, and there are standard approaches for using prepared statements in all major languages.

# Questions / Comments

Email [pahp@d.umn.edu](mailto:pahp@d.umn.edu) with your questions and comments.

