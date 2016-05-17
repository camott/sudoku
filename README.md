#Sudoku info

1. How does your algorithm work?

The algorithm starts by creating a board with the given values filled in.  It then goes through each unsolved cell and determines what possible values could be in that cell. At any point while going through the cells, a cell may be solved if the algorithm determines that there is only one possible value for that cell at which point all its neighbors are updated again to remove that possible value.  Once it's gone through all the cells, for any remaining unsolved cells it begins making guesses.  We determine which cell to make a guess in by finding the cell with the least number of possible values. Choosing the cell with the least number of possible values gives the guess the best chance of being right. If a guess leads to a valid board, it will continue making guesses in other cells. If a guess leads to an invalid board, we can assume that guess is not a possible value for the cell. That value is removed as a possibility and we either make another guess for the cell or if there was only one other possible value left, we can assume the value for that cell. If none of the possible values result in a valid board, that means a previous guess was incorrect, so we need to go up the stack and re-try different values for previously made guesses. The board is copied at every step in the algorithm so that we can easily step back to the previous board and make a different decision.

2. Give and explain the big-O notation of the best, worst, and expected run-time of your program.

Assume for the following m is the number of unsolved cells
In the best case scenario the puzzle is solvable without making any guesses.  That means that all that ran was creating the board, checking the validity and printing it. 
Creating the board – O(m) we will iterate through every unsolved cell, potentially up to 8 times each as we determine what values cannot be in a cell.  We know the number of times the unsolved cell will be changed is 8 since it stops checking once a cell is solved and a cell is solved once it only has a single possibility.
Checking the validity of the board – O(1), it is going through all the cells not just the unsolved ones.  Since the board is always the same size, this is constant time.
Printing it – O(1) since it just iterates through each of the 81 cells and prints the value.
Best case scenario – O(m) + O(1) + O(1) = O(m)

Average case – We perform the same actions as the best case scenario, but there are still some left unsolved.  In that case, we need to start making guesses. 
Check if the board is valid & solved – O(1) since it involves iterating through all 81 cells (though each cell is touched multiple times).
Determining the cell to guess – O(81 + m log m) Iterate through every cell to determine the unsolved ones, then sort the unsolved ones. Reduces to O(m log m)
Make guess – There are 9^m potential options to explore.  We attempt to improve our chances by reducing the number of potentials in each cell and choosing cells with fewer possibilities so we are more likely to be right.  However, it’s still possible that we go down every bad path.  I’m not entirely sure how to include the optimizations in the running time.
Average Case – O(1) + O(9^m(m log m))

Worst case scenario – We don’t know any of the values, which would leave 9^81 options.  The worst case would be that the last tested of the 9^81 options is the correct one. That’s technically constant time, but it would be awful in reality.

3. Why did you design your program the way you did?

A Sudoku board has two major parts, the individual cell and the overall board.  I split them up into two classes because the cell manages it’s own value/possible values whereas the board manages the interactions between cells and selection of specific cells.  The solve class is there for two purposes, to read/write to the command line and to actually call the algorithm that solves the puzzle. I debated putting the guess_solve function into another class, but ultimately decided that it made sense to just keep it in the solve file.  I thought about completely encapsulating the idea of cells within the board and never referencing an individual cell from the solve file, but that ultimately made the code more difficult to follow.

4. What are some other decisions you could have made. How might they have been better? How might they have been worse?

I've actually tried to code a Sudoku solver before in my own time since I really enjoy the game. One design decision I could have made and which I had tried before (examples included in the solverFunctions folder) would be to use Sudoku strategies to solve the puzzle legitimately instead of making guesses. This actually makes the algorithm faster with easier puzzles since it doesn't ever travel incorrect paths. It's also much better space wise since it doesn't need to create many duplicates of the board. The downside is that for hard boards, the "advanced" Sudoku strategies are required.  It's more difficult to code the advanced strategies and also, at some point having 10+ different solve functions starts to get a little confusing within the code.  Finally that solution is more difficult since it's hard to tell which of the different strategies to run at any given time. Ultimately, if I was going to actually use this project, I think it would be worth having some heuristic that determined whether to use the strategies or whether to just try guessing. I included some examples of the other strategies that I played around with, but I code every possible strategy for time reasons.

There were also some small changes I could have made to improve the runtime complexity.  For instance, when finding the columns/boxes, the board class iterates through all cells searching for the ones with a particular column/box values.  I was able to easily refactor the row finder to be more efficient, so that doesn’t search through every cell.  Every time it checks the validity of the table, it runs through each cell 19 times (9x for the columns, 9x for the boxes and 1x for the rows). I debated having the cells for each column/row/box stored in an inner array, but I thought that would make the clone function much more complicated, and the clone function is an integral piece since for each guess we need to clone the board.   There’s probably a way to calculate exactly which cells should be in a column/box just like I did with the rows, but I didn’t quite get that far ☺

Sample run:
ruby solve.rb "-,-,-,8,4,-,-,-,9
-,-,1,-,-,-,-,-,5
8,-,-,-,2,1,4,6,-
7,-,8,-,-,-,-,9,-
-,-,-,-,-,-,-,-,-
-,5,-,-,-,-,3,-,1
-,2,4,9,1,-,-,-,7
9,-,-,-,-,-,5,-,-
3,-,-,-,8,4,-,-,-"
