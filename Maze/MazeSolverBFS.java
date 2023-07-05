////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Author: Benjamin Napoli
// Student ID: c3303671
//
// Purpose Of This Class:
// This class holds the high level logic for Solving the maze. this class interacts with the maze class and imports maze from file.
// import and passing handled, order of run handled
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import java.io.File;  // handle files
import java.io.FileNotFoundException;  // handle errors
import java.util.Scanner; // scanner class for reading text files


public class MazeSolverBFS
{
	
	private Maze maze = new Maze();
	
	private int N, M;
	private String mazeIn, fileName;


    public static void main(String[] args)
    {
		MazeSolverBFS mBFS = new MazeSolverBFS();
		
        mBFS.run(args);
    }


    public void run(String[] args)
    {
		System.out.println(""); // no space = no good
		
		errorCheckInput(args); //error check
		
		getFileInput(); // gets file input and stores in "mazeIn"
		
		maze.generate(mazeIn); //Overloaded generate with a string instead of 2 ints generates maze using file input
		
		maze.BFS(); // Does a bredth first search which sets last = parent while visiting
		
		maze.backtrack(); // backtracks from finish to start through parent links

		maze.printToCommand(); // prints maze if < 10

		System.out.println(""); // spaceeeeee
    }
		
		
	private void errorCheckInput(String[] args)
    {
		if (args.length == 1) // correct length
		{
			try 
			{
				fileName = args[0];
			} 
			catch (NumberFormatException e) 
			{
				System.err.println("Argument " + args[2] + " must be an String.");
				System.exit(1);
			}
		}
		else
		{
			System.err.println("Input must be formatted in the following: \"inputFileName.Extenstion\"");
			System.exit(1);
		}
    }
	
	
	private void getFileInput()
	{
		String in = "";
        try
        {
            File myObj = new File(fileName);
            Scanner myReader = new Scanner(myObj);
            while (myReader.hasNextLine())
            {
                in = in + myReader.nextLine();
            }
			mazeIn = in; // input can stay as 1 string for simplicity of this class
            myReader.close();
        }
        catch (FileNotFoundException e) // no errors pls
        {
            System.out.println("Error");
            e.printStackTrace();
        }
	}

}
