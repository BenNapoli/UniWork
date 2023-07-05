Algorithms Assignment

//////////////////////////////////////////////////////////////////
COMPILE WITH:
//////////////////////////////////////////////////////////////////

javac MazeGenerator.java
javac MazeSolverBFS.java

//////////////////////////////////////////////////////////////////
GENERATOR:
//////////////////////////////////////////////////////////////////

java MazeGenerator "N" "M" "FileName.Extension"

java MazeGenerator 10 10 maze.dat


Additional information: 
- Will generate maze at (0,0) as shown in specification. to change to random there is some
commented code with instructions in "maze.java". When starting at a random position small error 1 in 10 times you run it but
I left the error in as i had the functionailty specified working and didnt want to break it fiddling with the data structures. 

- Random walk Finish tends to favour fairly close to the Start, i think this is due to the nature of the random walk 
leaving blank spaces early on and popping back to them later.


//////////////////////////////////////////////////////////////////
SOLVER:
//////////////////////////////////////////////////////////////////

java MazeSolverBFS "FileName.Extension"

java MazeSolverBFS maze.dat


Additional information: 
- As above will solve any maze that starts at (0,0) IF NOT AT (0,0) will work 9 times out of 10.
Works 100% of the time with specified (0,0) start position.

- If millisecond output is 0 run again, it works but fluctuates between 0ms or 10ms-20ms depending on distance. I am not sure
if this is a bug or it runs too fast

- Number of steps in the soluion output does not include start vertex but string for path from start to finish does (will always differ by 1)


//////////////////////////////////////////////////////////////////
Aditional Info:
//////////////////////////////////////////////////////////////////

- If N OR M are larger then 10 will not display maze on console.
