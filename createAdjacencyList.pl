#!/usr/bin/perl

# Robert Wenger

# Note: This script takes a while to run! (~4 hours)

use strict;
use warnings;

# The dictionary file must exist for the script to create the adjacency list.
# Have not tested the case for an existing adjacency.txt file.
my $dictionaryPath = "dictionary.txt";
my $adjacencyListsPath = "adjacency.txt";

importDictionary();

# Loop through each word.  For each word, check every other for adjacency.
#
# Note: We only need to check half of the possibilities,
# since adjacent(x, y) = adjacent(y, x). However, we do need
# to keep track of adjacency from x to y and also y to x.
my @adjacencyLists;
for(my $x = 0; $x < scalar(@words); $x++)
{
	for(my $y = 0; $y < $x; $y++)
	{
		if(checkAdjacent($words[$x], $words[$y]))
		{
			push(@{$adjacencyLists[$x]}, $y);
			push(@{$adjacencyLists[$y]}, $x);
		}
	}
	# Update progress for sanity.
	if($x%1000 == 0){print $x." columns complete.\n";}
}

# Now, we simply write all of these generated lists to the adjacency file,
# one line per list. If the word is not adjacent to any other words,
# simply print a newline.
open(my $adjacencyListsFile, '>', $adjacencyListsPath)
	or die "Failed to open $adjacencyListsPath.  Exiting...\n";

for(my $x = 0; $x < scalar(@adjacencyLists); $x++)
{
	if(defined $adjacencyLists[$x])
	{
		print $adjacencyListsFile "@{$adjacencyLists[$x]}\n";
	}
	else
	{
		print $adjacencyListsFile "\n";
	}
}
	
close($adjacencyListsFile);

# Check for adjacent words.
#
# From the spec: Call two words “adjacent” if you can change one word into the 
# other by adding, deleting, or changing a single letter.
#
# 2 parameters - The words to check for adjacency.  Order does not matter.
sub checkAdjacent
{
	my ($word1, $word2) = @_;
	
	# If the words are more than one letter apart in length, they cannot
	# be adjacent.  This check should save some time.
	if(abs(length($word1) - length($word2)) > 1)
	{
		return 0;
	}
	# If words are equal, they are not adjacent.
	elsif($word1 eq $word2)
	{
		return 0;
	}
	# If the words are of equal length, we need to check if one letter has been changed.
	elsif(length($word1) == length($word2))
	{
		my $letterChanged = 0;
	
		# $i - current position to check
		for(my $i = 0; $i < length($word1); $i++)
		{
			# Characters at position $i of each word.
			my $char1 = substr($word1, $i, 1);
			my $char2 = substr($word2, $i, 1);
			
			# If the characters are not equal, we have one letter that is different.
			if($char1 ne $char2)
			{
				# If we already encountered a different letter,
				# this means the words are not adjacent.
				if($letterChanged)
				{
					return 0;
				}
				else
				{
					$letterChanged = 1;
				}
			}
		}
		
		# If we reach this point, only one letter was switched.
		# Thus, the words are adjacent.
		return 1;
	}
	# If the words are not equal length, we need to check if all letters
	# are identical except one added letter.
	else 
	{
		# Make sure the longest word is in word1.  This way, we won't need to
		# check for a removed letter as well.
		if(length($word2) > length($word1))
		{
			($word1, $word2) = ($word2, $word1);
		}
		
		my $characterAdded = 0;
		
		# Loop through each character position in the longer word.
		for(my $i = 0; $i + $characterAdded < length($word1);)
		{
			# Current letter for each word.
			# If there has already been a character added, 
			# the position of word1 has advanced by 1.
			my $char1 = substr($word1, $i + $characterAdded, 1);
			my $char2 = substr($word2, $i, 1);
			
			if($char1 ne $char2)
			{
				# If a character has already been added,
				# the words are not adjacent.
				if($characterAdded)
				{
					return 0;
				}
				else
				{
					$characterAdded = 1;
				}
			}
			# We must increment $i here.  Otherwise, we would skip
			# letters in word2 we haven't found in word1 yet.
			else
			{
				$i++;
			}
		}
		
		return 1;
		
	}
}

# Import the dictionary to the words list.
sub importDictionary
{
	open(my $dictionaryFile, '<', $dictionaryPath)
		or die "Failed to open $dictionaryPath.  Exiting...\n";

	my $lineNumber = 0;

	while (my $line = <$dictionaryFile>)
	{
		$words[$lineNumber] = $line;
		$lineNumber++;
	}
	close($dictionaryFile);
	chomp(@words);
}
