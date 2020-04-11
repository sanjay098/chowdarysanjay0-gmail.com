#!/bin/bash

# It will just print the help
print_usage(){
    echo -e "-------\nUSAGE:|\n-------"
    echo "script.sh file1_path file2_path"
    echo -e "-----------\nARGUMENTS:|\n-----------"
    echo "file1_path: path of the first file to be differentiated"
    echo "file2_path: path of the first file to be differentiated"
}

# $# gives argument counts
# if user has specified less than 2 arguments, just print the error message, help and exit.
if [ $# -lt 2 ]
then
    print_usage
    echo  $'\u274c' " ERROR: File paths not provided!"
    exit
fi

# Getting filenames from the arguments
FILE1="$1"
FILE2="$2"

# For differentiating the two files, comm utility is being used.
# Help of comm is here
# comm [-123] FILE1 FILE2

# Compare FILE1 with FILE2

#         -1      Suppress lines unique to FILE1
#         -2      Suppress lines unique to FILE2
#         -3      Suppress lines common to both files

# (some_command_here) this format is a process substitution, so command line will first execute it and get results 

#  we are using process substitution two times below: one for sorting the files and other for assigning the values to the variable file1_uniq_urls
#  Following command first sorts the both given files, get uniques and then pass it to the comm utility 
# -32 means it will not give those urls which are common to both and unique to file2 , hence we will get file1 unique urls
file1_uniq_urls=$(comm -32  <(sort -u $FILE1) <(sort -u $FILE2))

file2_uniq_urls=$(comm -31  <(sort -u $FILE1) <(sort -u $FILE2))

# Pass whatever the output of previous variable file1_uniq_urls to 'wc' utility which counts the word in the given input.
# Each url is supposed as word because a url does not have spaces in it.
# Hence, we will get count of the urls
file1_uniq_urls_count=$(echo "$file1_uniq_urls" | wc -w)

file2_uniq_urls_count=$(echo "$file2_uniq_urls" | wc -w)

# print the formatted output to the screen from the previous maintained variables
echo -e "$FILE1\n------\nCount of Missed Urls: $file2_uniq_urls_count \n\nURLS:\n$file2_uniq_urls\n$FILE2\n------\nCount of Missed Urls: $file1_uniq_urls_count \n\nURLS:\n$file1_uniq_urls\n"