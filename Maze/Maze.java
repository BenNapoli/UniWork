////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Author: Benjamin Napoli
// Student ID: c3303671
//
// Purpose Of This Class:
// This class holds the logic for both generating and solving the maze. the purpose of this class is to interact with 
// all of the various data structures. The stack that is made to implement the random walk and also a second stack is used
// to reverse the output sting, the queue is used for the BFS setting parents as it searches for the backtracking method,
// the graph is implemented as a 2D array as i never search through one by one and all vertexes are connected in order
// so all traversals are done North East South West instead of searching through the entirety of the graph to find connections.
// this dramatically reduces The Theta(). the largest part is Theta(NxN) which is for the output and generation which would
// be Theta(NxM) as any data structure as there are no blanks in a maze.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import java.util.Random;
import java.util.Date;
import java.time.ZonedDateTime;


public class Maze
{


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //private Variables
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
    private int N, M, totalVisited, S, F, totalNodes, bfsStepsTaken = 0, stepsSolution = 0;
	private Node[][] node;
	private Node start, finish;
	private boolean north = false, east = false, south = false, west = false;
	private String solutionPathBackwards;
	private long timeStart, timeEnd;


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Constructor
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    public Maze()
    {
        N = 0;
		M = 0;
		totalVisited = 0;
		start = null;
		finish = null;
    }
	

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Setter methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	private void setStatus() //Theta(NxM) all have to be set regardless so you cannot get lower
    {
		for (int nn = 0; nn<N; nn++) 
        {
			for (int mm = 0; mm<M; mm++)
			{
				node[nn][mm].setStatus();
			}
        }
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Getter method
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	private int getRandom(int max, int min) // gets random for walk method direction (also can be used to randomise start)
    {
		Random r = new Random();  
		int rand = r.nextInt((max - min) + 1) + min;  
		
		return rand;
	}
	
	
	public String getOutputForFile() //Theta(NxM) all have to be output regardless so you cannot get lower
	{
		String out = (N + "," + M + ":" + start.getID() + ":" + finish.getID() + ":"); // format first part of output
		
		for (int nn = 0; nn<N; nn++)
        {
			for (int mm = 0; mm<M; mm++)
			{
				out = out + node[nn][mm].getStatus(); //add all vertex data to output string
				
			}
        }
		return out;
	}


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//MazeGen Method
    public void generate(int nIn, int mIn) 
    {
		this.N = nIn;
		this.M = mIn;
		
		node = new Node[N][M];
		
		int id = 1;
		
		for (int nn = 0; nn<N; nn++) //Theta(NxM)
        {
			for (int mm = 0; mm<M; mm++)
			{
				node[nn][mm] = new Node(nn, mm, id); //generate maze of size nxm and pass constructor values in
				id++; // id ranges 1 to maze size
				
			}
        }
		
		walk(id-1); // walk around randomly and generate walls
		
		setStatus(); // all walls are up can now set whether each cell is 0, 1, 2, 3 depending on walls
		
    }
	
	
	//BFS Method
	public void generate(String mazeIn) // overloaded for BFS input
    {
		String[] splitInput = splitInput(mazeIn).split(""); //split method called which takes the raw vertex data from the start finish data stores it appropreately then sets split input the individual raq data characters
		
		node = new Node[N][M]; // M and N set in "splitInput() method"
		
		int id = 1;
		
		for (int nn = 0; nn<N; nn++) // Theta(NxM) would be the same for all data structures as same ammount of vertexes
        {
			for (int mm = 0; mm<M; mm++)
			{
				
				node[nn][mm] = new Node(nn, mm, id, Integer.parseInt(splitInput[id-1])); //overloaded constructor that adds the 0, 1, 2, 3 aswell so the maze is already generated
				
				if (id == S) // if start vertex
				{
					node[nn][mm].setStart(true);
					start = node[nn][mm];
				}
				else if (id == F) // if end vertex
				{
					node[nn][mm].setFinish(true);
					finish = node[nn][mm];
				}
				id++;
				
			}
        }
		totalNodes = id-1;
    }
	
	
	//BFS Method
	public void BFS() // Big O(NxM) as there is no search for adjacent. position of ajacent already known as it is a grid only need to find if wall
	{
		
		timeStart = ZonedDateTime.now().toInstant().toEpochMilli(); // solve maze starts AFTER maze is generated as time fo find result not time to generate maze

		boolean end = false;
		
		MazeQueue q = new MazeQueue(totalNodes+1); //create queue for BFS
		
		q.enqueue(start); //start goes in
		
		while (end == false) //while end not found
		{
			// This visual may help understanding the code below
			//
			//                    (n,m)
			//
			//                  n- = north
			//
			//               (0,0)(0,1)(0,2)
			//  m- = west    (1,0)(1,1)(1,2)    m+ = east
			//               (2,0)(2,1)(2,2)
			//
			//                 n+ = south
			//
			
			if (q.peek().getM()-1 != -1) // if west not out of bounds (-1)
			{
				if (node[q.peek().getN()][q.peek().getM()-1].getVisited() == false && node[q.peek().getN()][q.peek().getM()-1].getStatus() > 0 && node[q.peek().getN()][q.peek().getM()-1].getStatus() != 2) // if west vertex not visited AND there is no wall
				{
					node[q.peek().getN()][q.peek().getM()-1].setParent(node[q.peek().getN()][q.peek().getM()]); //set parent for backtrack solve without repition
					q.enqueue(node[q.peek().getN()][q.peek().getM()-1]); //add connecting vertex to queue
				}
			}
			
			if (q.peek().getN()+1 < N) // if south not out of bounds (maxN)
			{
				if (node[q.peek().getN()+1][q.peek().getM()].getVisited() == false && q.peek().getStatus() > 0 && q.peek().getStatus() != 1) // if South vertex not visited AND there is no wall
				{
					node[q.peek().getN()+1][q.peek().getM()].setParent(node[q.peek().getN()][q.peek().getM()]); //set parent for backtrack solve without repition
					q.enqueue(node[q.peek().getN()+1][q.peek().getM()]); //add connecting vertex to queue
				}
			}
			
			if (q.peek().getM()+1 < M) // if east not out of bounds (maxM)
			{
				if (node[q.peek().getN()][q.peek().getM()+1].getVisited() == false && q.peek().getStatus() > 0 && q.peek().getStatus() != 2) // if East vertex not visited AND there is no wall
				{
					node[q.peek().getN()][q.peek().getM()+1].setParent(node[q.peek().getN()][q.peek().getM()]); //set parent for backtrack solve without repition
					q.enqueue(node[q.peek().getN()][q.peek().getM()+1]); //add connecting vertex to queue
				}
			}
			
			if (q.peek().getN()-1 != -1) // if north not out of bounds (-1)
			{
				if (node[q.peek().getN()-1][q.peek().getM()].getVisited() == false && node[q.peek().getN()-1][q.peek().getM()].getStatus() > 0 && node[q.peek().getN()-1][q.peek().getM()].getStatus() != 1) // if North vertex not visited AND there is no wall
				{
					node[q.peek().getN()-1][q.peek().getM()].setParent(node[q.peek().getN()][q.peek().getM()]); //set parent for backtrack solve without repition
					q.enqueue(node[q.peek().getN()-1][q.peek().getM()]); //add connecting vertex to queue
				}
			}
			
			bfsStepsTaken++; //steps taken to solve maze
			
			q.dequeue().setVisited(true); //remove front at the same time as setting it to visited
			
			if (q.peek().getFinish() == true) // if next in queue is end of maze 
			{
				end = true; // finish looking
			}
			
		}
		
	}
	
	
	//BFS method
	public void backtrack() // backtracks from finish up the line of parents back to start
	{
		int i = 1;
		
		MazeStack stack = new MazeStack(totalNodes+1); // stack to reverse the output as it goes finish to start instead of start to finish
		
		Node temp = null; // temp reference to loop through
		
		stack.push(finish); // for reversal
		stack.push(finish.getParent());
		
		finish.getParent().setPartOfPath(true); // if vertex is part of path later then output adds x
		temp = finish.getParent();
		
		while (temp.getStart() == false) //goes through parents until at start
		{
			temp.getParent().setPartOfPath(true);
			
			stack.push(temp.getParent());
			
			temp = temp.getParent();
			
			i++;
		}
		
		stepsSolution = i; // iterations on path NOT INCLUDING START
		
		solutionPathBackwards = "(" + stack.top().getID(); //format output with stack
		stack.pop();
		
		for (int ii = 0; ii<i; ii++) // unloads stack into output
		{
			solutionPathBackwards = solutionPathBackwards + "," + stack.top().getID();
			stack.pop();
		}
		
		solutionPathBackwards = solutionPathBackwards + ")";

		timeEnd = ZonedDateTime.now().toInstant().toEpochMilli(); // at this time solution to maze has been found
		long timeTotal = timeEnd - timeStart;
		//timer.stop();
		
		System.out.println(solutionPathBackwards); //backwards is now forwards but still backwards, cunfusing named variable to remind myself to reverse it
		System.out.println("The number of steps in the solution: " + stepsSolution);
		System.out.println("The number of steps actually taken by the search: " + bfsStepsTaken);
		System.out.println("The time taken to solve the maze, in milliseconds: " + timeTotal);
		
		System.out.println("");
		
	}
	
	
	//BFS method
	private String splitInput(String mazeIn) // this method splits the input into 4 peices;N size, M size, start, finish, statusData
	{
		String[] in = mazeIn.split(",");
		N = Integer.parseInt(in[0]);
		
		String[] inN = in[1].split(":"); // splits the spaced ones by the :
		M = Integer.parseInt(inN[0]); // passes input into variable
		S = Integer.parseInt(inN[1]);
		F = Integer.parseInt(inN[2]);
		
		return inN[3]; // pass status data back to generate graph
	}
	
	
	//Generator Method
	private void walk(int total)
    {
		
		MazeStack walkStack = new MazeStack(total+1); //Stack to implement random walk as when you walk into a corner you must then pop back up to next area that can be visited
		
		////////////////////////////////////////
		//int randomN = getRandom(N-1, 0);
		//int randomM = getRandom(M-1, 0);
		////////////////////////////////////////
		// to implement with a random starting point just swap the 4 node[0][0] below with node[randomN][randomM] and and uncomment above.
		// implemented with 0,0 as starting point as all diagrams in assignment spec show it that way.
		//
		// there is a small error IF YOU CHANGE TO RANDOM NOT WITH START 0,0. it only occurs 10% of the time so i think it would be an 
		// easy fix but i did not fix the error as it is out of the relms of the specification. i think it has something to do with not setting S or finish to visited but im not sure
		///////////////////////////////////////
		
		start = node[0][0]; //setting start node
		node[0][0].setStart(true);
		node[0][0].setVisited(true);
		walkStack.push(node[0][0]);
		
		totalVisited++;
		while (totalVisited < total)
		{
			north = false; //reset ajacent available paths
			east = false;
			south = false;
			west = false;
			
			if (walkStack.top().hasTwoOpenings() == true) //too many openings (3 not 2)
			{
				walkStack.pop(); // pop back to try and find next vailable path
			}
			else // if not blocked in
			{
				if (checkAdjacent(walkStack.top()) == false) // if blocked in
				{
					walkStack.pop();
				}
				else // find direction available
				{
					boolean found = false;
					
					while (found == false) // loops through random generated 1-4 for direction as it is a random walk and direction much be random
					{
						switch(getRandom(4, 1))
						{
							case 1: //north walkable and chosen at random
								
								if (north == true)
								{
									walkStack.top().setPath(1); //sets wall = 0 in node for north
									node[walkStack.top().getN()][walkStack.top().getM()-1].setPath(3); //sets wall = 0 in northern node for south
									node[walkStack.top().getN()][walkStack.top().getM()-1].setVisited(true); // sets vissited
									walkStack.push(node[walkStack.top().getN()][walkStack.top().getM()-1]); // pushes new position onto stack
									totalVisited++;
									
									if (totalVisited == total) // if all vertexes visited walk over
									{
										finish = walkStack.top();
										walkStack.top().setFinish(true);
									}
									
								}
								found = true;
								break;
							
							case 2:
							
								if (east == true) //east walkable and chosen at random
								{
									walkStack.top().setPath(2);
									node[walkStack.top().getN()+1][walkStack.top().getM()].setPath(4);
									node[walkStack.top().getN()+1][walkStack.top().getM()].setVisited(true);
									walkStack.push(node[walkStack.top().getN()+1][walkStack.top().getM()]);
									totalVisited++;
									
									if (totalVisited == total)
									{
										finish = walkStack.top();
										walkStack.top().setFinish(true);
									}
								}
								found = true;
								break;
							
							case 3:
							
								if (south == true) //south walkable and chosen at random
								{
									walkStack.top().setPath(3);
									node[walkStack.top().getN()][walkStack.top().getM()+1].setPath(1);
									node[walkStack.top().getN()][walkStack.top().getM()+1].setVisited(true);
									walkStack.push(node[walkStack.top().getN()][walkStack.top().getM()+1]);
									totalVisited++;
									
									if (totalVisited == total)
									{
										finish = walkStack.top();
										walkStack.top().setFinish(true);
									}
								}
								found = true;
								break;
							
							case 4:
							
								if (west == true) //west walkable and chosen at random
								{
									walkStack.top().setPath(4);
									node[walkStack.top().getN()-1][walkStack.top().getM()].setPath(2);
									node[walkStack.top().getN()-1][walkStack.top().getM()].setVisited(true);
									walkStack.push(node[walkStack.top().getN()-1][walkStack.top().getM()]);
									totalVisited++;
									
									if (totalVisited == total)
									{
										finish = walkStack.top();
										walkStack.top().setFinish(true);
									}
								}
								found = true;
								break;
						}
					}
				}
			}
		}
	}
	
	
	//Generator Method
	private boolean checkAdjacent(Node current) // checks if current node/vertex has an adjacent vertex it can walk to for walk method to find the end of a path
    {
		
		boolean adjacent = false;
		
		if (current.getN() != 0) //not out of bounds
		{
			if (node[current.getN()-1][current.getM()].getVisited() == false) // if western vertex not visited
			{
				if (node[current.getN()-1][current.getM()].hasTwoOpenings() == false) //if western vertex is available to walk on
				{
					adjacent = true;
					west = true;
				}
			}
		}
		
		if (current.getN() != N-1) // east
		{
			if (node[current.getN()+1][current.getM()].getVisited() == false)
			{
				if (node[current.getN()+1][current.getM()].hasTwoOpenings() == false)
				{
					adjacent = true;
					east = true;
				}
			}
		}
		
		if (current.getM() != 0) // north
		{
			if (node[current.getN()][current.getM()-1].getVisited() == false)
			{
				if (node[current.getN()][current.getM()-1].hasTwoOpenings() == false)
				{
					adjacent = true;
					north = true;
				}
			}
		}
		
		if (current.getM() != M-1) // south
		{
			if (node[current.getN()][current.getM()+1].getVisited() == false)
			{
				if (node[current.getN()][current.getM()+1].hasTwoOpenings() == false)
				{
					adjacent = true;
					south = true;
				}
			}
		}
		
		return adjacent;
	}
	
	
	//Both BFS and Generator Method
	public void printToCommand() //loops through every vertex and displays
	{
		if (M < 11 && N < 11) // is maze smaller then 11x11
		{
			
			String temp = "";
			
			for (int mm = 0; mm<M; mm++) //top of maze printed
			{
				temp = temp + "|--";
			}
			
			temp = temp + "|";
			System.out.println(temp);
			
			//temp = "|";
			for (int nn = 0; nn<N; nn++) //theta(NxM)
			{
				temp = "|";
				for (int mm = 0; mm<M; mm++)
				{
					
					if (node[nn][mm].getStart() == true) //if start add S
					{
						if (node[nn][mm].getStatus() == 3)
						{
							temp = temp + "S  ";
						}
						else if (node[nn][mm].getStatus() == 2)
						{
							temp = temp + "S |";
						}
						else if (node[nn][mm].getStatus() == 1)
						{
							temp = temp + "S  ";
						}
						else if (node[nn][mm].getStatus() == 0)
						{
							temp = temp + "S |";
						}
					}
					else if (node[nn][mm].getFinish() == true) // if finish add F
					{
						if (node[nn][mm].getStatus() == 3)
						{
							temp = temp + "F  ";
						}
							else if (node[nn][mm].getStatus() == 2)
						{
							temp = temp + "F |";
						}
							else if (node[nn][mm].getStatus() == 1)
						{
							temp = temp + "F  ";
						}
						else if (node[nn][mm].getStatus() == 0)
						{
							temp = temp + "F |";
						}
					}
					else if (node[nn][mm].getPartOfPath() == true) // if part of solution path add *
					{
						if (node[nn][mm].getStatus() == 3)
						{
							temp = temp + "*  ";
						}
							else if (node[nn][mm].getStatus() == 2)
						{
							temp = temp + "* |";
						}
							else if (node[nn][mm].getStatus() == 1)
						{
							temp = temp + "*  ";
						}
						else if (node[nn][mm].getStatus() == 0)
						{
							temp = temp + "* |";
						}
					}
					else //generic vertex of maze
					{
						if (node[nn][mm].getStatus() == 3)
						{
							temp = temp + "   ";
						}
						else if (node[nn][mm].getStatus() == 2)
						{
							temp = temp + "  |";
						}
						else if (node[nn][mm].getStatus() == 1)
						{
							temp = temp + "   ";
						}
						else if (node[nn][mm].getStatus() == 0)
						{
							temp = temp + "  |";
						}
					}	
		
				}
				
				System.out.println(temp);
				temp = "|";
				
				for (int mm = 0; mm<M; mm++) // loops a second time because need to do bottom for each vertex
				{
					if (node[nn][mm].getStatus() == 3)
					{
						temp = temp + "  |";
					}
					else if (node[nn][mm].getStatus() == 2)
					{
						temp = temp + "  |";
					}
					else if (node[nn][mm].getStatus() == 1)
					{
							temp = temp + "--|";
					}
					else if (node[nn][mm].getStatus() == 0)
					{
							temp = temp + "--|";
					}
				}
				System.out.println(temp);
			}
		}
		else
		{
			System.out.println("Mazes with dimensions bigger then 10 will not be printed to console.");
		}
	}
}
