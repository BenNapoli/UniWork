////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Author: Benjamin Napoli
// Student ID: c3303671
//
// Purpose Of This Class:
// This class holds the high level logic for generating the maze. this class interacts with the maze class and files.
// input/output is handled here as well as order of methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import java.io.File;  // handle files
import java.io.FileNotFoundException;  // handle errors
import java.io.FileWriter; // for exporting information
import java.util.Scanner; // scanner class for reading text files


public class MazeGenerator
{
	
	private Maze maze = new Maze();
	
	private int N, M;
	private String fileOutName;


    public static void main(String[] args)
    {
		MazeGenerator gen = new MazeGenerator();
		
        gen.run(args);
    }
	

    public void run(String[] args)
    {
		System.out.println(""); // no space = no good
		
		errorCheckInput(args); // error check to make sure N M are both numbers
		
		maze.generate(N, M); //pass in size and generate maze (generate contains walk)
		
		maze.printToCommand(); //display to commandline

		display(maze.getOutputForFile()); //write to file
		
		System.out.println(""); // no space = no good

    }
		
		
	private void errorCheckInput(String[] args)
    {
		if (args.length == 3) // if correct ammount of inputs
		{
			try // must be int
			{
				N = Integer.parseInt(args[0]);
			} 
			catch (NumberFormatException e) 
			{
				System.err.println("Argument " + args[0] + " must be an integer.");
				System.exit(1);
			}
			
			try // must be int
			{
				M = Integer.parseInt(args[1]);
			} 
			catch (NumberFormatException e) 
			{
				System.err.println("Argument " + args[1] + " must be an integer.");
				System.exit(1);
			}
			
			try 
			{
				fileOutName = args[2];
			} 
			catch (NumberFormatException e) 
			{
				System.err.println("Argument " + args[2] + " must be an String.");
				System.exit(1);
			}
			
		}
		else
		{
			System.err.println("Input must be formatted in the following: \"N M outputFileName.Extenstion\"");
			System.exit(1);
		}
    }


	private void display(String fileContents)
	{
		File file = null; //creating a file variable with filewriter
		FileWriter filewriter = null; // creating a filewriter
		try 
		{
			file = new File(fileOutName); // setting the name and path of the output file
			filewriter = new FileWriter(file); //linking the filewriter to the file
			
			filewriter.write(fileContents); //file writer does not have a next line command therefore every new line makes use of the system line separator
			filewriter.close(); // close the writer
		}
		catch (Exception e) // error checking
		{
			e.printStackTrace();
		} 
		finally 
		{
			try 
			{
				if (filewriter != null) 
				{
					filewriter.close();
				}
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
		}
		System.out.println("Maze created and stored in the file: " + fileOutName); //displays a message so that the user knows the proccess is complete
	}

}
