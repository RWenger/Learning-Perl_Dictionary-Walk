# Dictionary Walk Programming Challenge

Call two words “adjacent” if you can change one word into the other by adding, deleting, or changing a single letter.  A “word list” is an ordered list of unique words where successive words are adjacent. Write a program which takes two words as inputs, walks through the dictionary, and creates a list of words between them.

## Examples

hate -> love: hate, have, hove, love
dogs -> wolves: dogs, does, doles, soles, solves, wolves
man -> woman: man, ran, roan, roman, woman
flour -> flower: flour, lour, dour, doer, dower, lower, flower

## Files

-dictionary.txt - Dictionary of words
-createAdjacencyList.pl - Script to create an adjacency list from the dictionary.  Takes a few hours to run!
-adjacency.txt - Output of createAdjacencyList.pl.
-dwalk.pl - Script to walk the adjacency list. You will be prompted for pairs of words. Usage: perl dwalk.pl

## Notes

Since the solution uses BFS, the shortest list should always be found.

## Alternative Solution

Creating an adjacency list could be completed much faster than the brute-force method of checking each pair of dictionary words which is used in this solution.  Consider the word "cat".  These are possible adjacent words:

	*at
	c*t
	ca*
	*cat
	c*at
	ca*t
	cat*
	at
	ct
	ca

Use binary search to search for these possible adjacent words, replacing asterisks with a-z (*at -> aat, bat, cat, dat, ...).  If these new letter combinations are real words, they are adjacent.  For this method to be more efficient than the brute force method, binary search should be used.
