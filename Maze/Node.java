////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Author: Benjamin Napoli
// Student ID: c3303671
//
// Purpose Of This Class:
// This is a simple Node class that holds the data for each vertex on the NxM grid.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public class Node
{

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //private Variables
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    private boolean visited = false, open = false, north = false, east = false, south = false, west = false, start = false, finish = false, partOfPath = false;
	private int status = 0, N, M, ID, openPathCount = 0; 
	private Node parent;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public Node(int nIn, int mIn, int idIn) // For MazeGenerator
    {
		this.N = nIn;
		this.M = mIn;
		this.ID = idIn;
    }
	
	public Node(int nIn, int mIn, int idIn, int statusIn) // overloaded for MazeSolver
    {
		this.N = nIn;
		this.M = mIn;
		this.ID = idIn;
		this.status = statusIn;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Setter method
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	public void setParent(Node in)
    {
        this.parent = in;
    }
	
	
	public void setVisited(boolean visitedIn)
    {
        this.visited = visitedIn;
    }
	
	
	public void setStart(boolean startIn)
    {
        this.start = startIn;
    }
	
	
	public void setFinish(boolean finishIn)
    {
        this.finish = finishIn;
    }
	
	
	public void setPartOfPath(boolean partIn)
    {
        this.partOfPath = partIn;
    }
	
	
	public void setStatus() //used in generator to generate status for output and display depending on wall directions
    {
		
        if (east == true && south == true)
		{
			this.status = 3;
		}
		else if (east == true)
		{
			this.status = 2;
		}
		else if (south == true)
		{
			this.status = 1;
		}
		else
		{
			this.status = 0;
		}
    }
	
	
	public void setPath(int i) // every vertex starts with 4 walls, this method breaks a wall in an inputted direction, used when generating
    {
		switch(i)
		{
			case 1:
			
				this.north = true;
				break;
				
			case 2:
			
				this.east = true;
				openPathCount++;
				break;
				
			case 3:
			
				this.south = true;
				openPathCount++;
				break;
				
			case 4:
				
				this.west = true;
				break;
		}
		
		if (openPathCount == 2) // cant open all walls
		{
			open = true;
		}
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Getter Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public Node getParent()
	{
		return parent;
	}

    public int getStatus()
    {
        return status;
    }
	
	public boolean getVisited()
    {
        return visited;
    }
	
	public boolean getPartOfPath()
    {
        return partOfPath;
    }

	
	public boolean getStart()
    {
        return start;
    }
	
	public boolean getFinish()
    {
        return finish;
    }
	
	public int getN()
    {
        return N;
    }
	
	public int getM()
    {
        return M;
    }
	
	public int getID()
    {
        return ID;
    }
	
	public boolean hasTwoOpenings() //3 but not renaming, stops all sides being open
    {
        return open;
    }


}
