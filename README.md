# add-newline
A script for .c files to complete every printf with \n at the end.

Have you ever been lazy about adding \n at the end of every printf when you where programming in C? Well, I have because my keyboard is quite uncomfortable to do it every single time. So, I decided I wanted a bash script that does it for me, and here it is!

### How to use it
Lets supose that you have file1.c, file2.c, file3.c, and a directory called dir with example1.c, example2.c. You can use the script as it follows:
./add-newline -f file1.c file2.c file3.c -d dir -a
This will add \n at the end of every printf of those 3 files and every file inside dir. The -a argument is to tell the script to do it no matter if some printfs already have \n at the end. If you substitute -a for -o, the script will do the same to every printf that DOES NOT already have \n at the end.
If you add -r argument, the script will do everything described above recursively to every subdirectory of every directory passed to -d argument.
