#!/usr/bin/perl


# Robert Wenger


use strict;
use warnings;

# These files must exist for the solution to work.
my $dictionaryPath = "dictionary.txt";
my $adjacencyListsPath = "adjacency.txt";

# These contain the data structures for the script.
#
# words - The list of words from the dictionary.
# adjacencyLists - One list per word of all adjacent words.
my @words;
my @adjacencyLists;

# Import the data structures above from the files above.
importDictionary();
importAdjacencyLists();

# Allow the user to simply type pairs of words.
while(1)
{
	print "\nType \"quit program\" to quit.\n";
	print "Input a word for the head of the list:\n";
	my $startWord = <STDIN>;
	chomp($startWord);
	
	if($startWord eq "quit program")
	{
		last;
	}
	
	print "\nInput a word for the tail of the list:\n";
	my $destinationWord = <STDIN>;
	chomp($destinationWord);
	
	if($destinationWord eq "quit program")
	{
		last;
	}
	
	# Get the indicies of the words from the dictionary.
	my $startWordIndex = getIndex($startWord);
	my $destinationWordIndex = getIndex($destinationWord);

	my @path = findPath($startWordIndex, $destinationWordIndex);
	
	# When no path is possible, the path is empty.
	if($path[0] eq '')
	{
		print ("\nNo path found\n");
		next;
	}

	print "\n";
	
	# Convert indicies back to words.
	my @wordArray;
	for(my $i = 0; $i < scalar(@path); $i++)
	{
		push @wordArray, ${words[$path[$i]]};
	}
	
	print join(", ", @wordArray) . "\n";
}

# Get the index of a given word from the dictionary.
sub getIndex
{
	my ($inputWord) = @_;
	
	for(my $i = 0; $i < scalar(@words); $i++)
	{	
		if($inputWord eq $words[$i])
		{
			return $i;
		}
	}
}

# Get words adjacent to the given word.
#
# The word is given by its position in the "words" array.
sub getAdjacentWords
{
	my ($word) = @_;

	return @{$adjacencyLists[$word]};
}

# Find a path from the first word to the last. Implements breadth-first search.
#
# 2 parameters: the indicies of the start and destination in the "words" array
sub findPath
{
	my ($start, $destination) = @_;
	
	my @visited;
	my @pathQueue;
	
	# Start with the first word.
	push @pathQueue, [$start];
	$visited[$start] = 1;
	

	# For breadth-first search, we use a queue.
	#
	# Paths are stored along with the word for 
	# the ability to print the path later.
	while(scalar(@pathQueue) > 0)
	{
		# Get the next word from the queue.
		my @currentPath = @{$pathQueue[0]};
		shift @pathQueue;
		my $currentWord = $currentPath[-1];
		
		
		# If the last element in the current path is the destination,
		# we're done.  Return the path.
		if($currentWord == $destination)
		{
			return @currentPath;
		}
		
		# If we're not at the destination, we need to enqueue adjacent words
		# to be checked.  First, find the adjacent words.
		my @adjacentWords = getAdjacentWords($currentWord);
		
		# For each word, add its path to the queue.
		for(my $i = 0; $i < scalar(@adjacentWords); $i++)
		{
			if(!$visited[$adjacentWords[$i]])
			{
				$visited[$adjacentWords[$i]] = 1;
				
				my @newPath = @currentPath;
				push @newPath, $adjacentWords[$i];
				push @pathQueue, [@newPath];
			}
		}
		
		
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

# Import the adjacency lists from the adjacency lists file.
sub importAdjacencyLists
{
	open(my $adjacencyListsFile, '<', $adjacencyListsPath)
	or die "Failed to open $adjacencyListsPath.  Exiting...\n";
	
	my $lineNumber = 0;
	while (my $line = <$adjacencyListsFile>)
	{
		# Referenced http://stackoverflow.com/questions/3574906/how-to-extract-a-number-from-a-string-in-perl
		# for this regex.  See FMc's answer.
		$adjacencyLists[$lineNumber] = [$line =~ /(\d+)/g];

		$lineNumber++;
	}
	close($adjacencyListsFile);
}
