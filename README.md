# MasterMindGame
Fully working Mastermind game on a Raspberry Pi 3 using C and ARM Assembly. 

To play or excute the game on the pi you would need to follow these steps of compiling and running 

gcc -c mm-matches.s -o mm-matches.o
gcc -c -o master-mind.o master-mind.c
gcc -o master-mind master-mind.o mm-matches.o
Run: sudo ./master-mind

This implementation used inline assembly code so lcdbinary isnt needed 
