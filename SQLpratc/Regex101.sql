--Note REGEX might run properly when the file format is not .sql. File naming only for organising purpose.

--Escapes sequences
Lorem ipsum --Lorem\sipsum, where \s escapes or ignores the whitespace in Lorem ipsum and still returns a found result.

--Character Ranges
3EF --[173][EDR], would not return true for anything other than what is inside the two [][].
2S --[0-3][M-t].
Y8 --[A-Za-z0-9][0-9].
y8 --[A-Za-z0-9][0-9], not true for 8y or 8Y.
Y --[^AEIO], ^ inside brackets acts as negator, not true for AEIO.
=9 --[=0-9][-0-9].
U8 --[0-a9][-0-9] Returns true, even thou a is not equal to U and would not return if A, thus it is best to be case minded when using Regex.

---Anchors
20 --[0-9]$ and for [0]$ or ^[0-9], ^[2].
40 Yo boys soap song --^[0-9].
Yo boys soap song --^[Y], ^[A-z].
song- --[0-9-]$.
1423 --[0-9][0-9]
14 --^[0-9][0-9]$
32 --^[0-9][0-9]$

--Quantifiers
DFA --[A-Z][A-Z][A-Z], such repetitions of regex can be avoided by using Quantifiers as the below regex example.
DFA --[A-Z]{3}, [a-Z]{x}, where {} signifies a quantifier.
212-567-8790 --[0-9]{3}-[0-9]{3}-[0-9]{4}, Using Quantifiers we can return a string which is already in phone no. format.
23456-6789 --This string will return false if querried with the above Regex.

--Min and Max repetitions
NYC --[A-Z]{2,3}
NY --[A-Z]{2,3}
N --[A-Z]{2,3} would return false, as the minimum repetitions is 2
YZ2 --[A-Z0-9]{2,}
YADSasdze2343adfDAS --[A-Za-z0-9]{2,}

--0 or 1 repetitions(a.k.a Optional) memonic = S or N
SD --[0-9]?[A-Z]{2}, where ? is shorthand for {0,1}
3FD--[0-9]?[A-Z]{2}, where ? is shorthand for {0,1}
2125678790 --[0-9]{3}-?[0-9]{3}-?[0-9]{4}, using the previous phone no. exmple we can make - optional

--1 or more repetitions
z --[xyz]+, where + is shorthand for {1,} i.e., 1 or more repetitions
xyzzyyxxxzzxxyz --[xyz]+
xyzzyyxxxzzxxyz1234324223344312 --[xyz]+[0-9]+

--0 or more repetitions
34 --[0-3]+[XYZ]*, where [XYZ] is optional, i.e., it is optional that if any letters do exist also if there are many repetitions.
3XYYZZ --[0-3]+[XYZ]* and * is shorthand for {0,}

--Wildcards and Everything function.
b/a?a23 -- .{7} where . acts as an wildcard for any character, newlines, punctuation, whitespace.
b,a -- ...
adhf;jhas;12-31234 -- .* where . combined with * is called the Everything function
Hello -- H.{3}O

--Grouping
--We can use paranthesis () to group regex which need to be repeated.
A360 --([A-Z][0-9]{3})+
A380B380 --([A-Z][0-9]{3})+
N95-PM24-T90 --([A-Z][0-9]{2,3}-?)+
--if we search for phone no. and an optional area code.
420-840-1263 --([0-9]{3}-)?([0-9]{3,4}-?)+

--Alternation or the OR operator
Alpha -- Alpha|beta|gamma
-- To find phone no. that either ends with 0 or 1
122-343-8970 --([0-9]{3,4}-?){3}(0|1)

--Prefixes and Suffixes
OMEGA66 --(?<=[A-Z])[0-9]+ where (?<=[A-Z]) is used for prefixes.
66OMEGA --[0-9]+(?=[A-Z]+) where (?=[A-Z]+) is used for suffixes, and is position sensitive.
