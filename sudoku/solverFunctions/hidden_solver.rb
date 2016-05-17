#A hidden solver determines whether there are only {num} cells in a row/column/box that contain a certain {num} values.  In that case, 
#you can remove the other possiblities from those cells

#EX: if you have the following row [1, 2, {3,6,7}, {3,5,6,7}, {3,4}, {3,4,5}, {3,4,5}, 8, 9]
#you know that 6/7 must be in the first two unsolved cells, then the rest of the possiblities can be removed from those two cells

require_relative 'solver'

class HiddenSolver < Solver

	def initialize board, num
		super(board)
		@num = num
	end

	def solve
		solve_all_ways do |cells|
			values = @board.find_values_in_cells cells
			cells = cells.reject(&:solved?)

			((1..9).to_a - values).combination(@num).each do |combination|
				contains_any = cells.select{|c| c.has_any_possible(combination) }
				if contains_any.size == @num
					cells_to_update = contains_any.select{|c| !(c.possible - combination).empty? }
					cells_to_update.each do |c|
						@board.remove_possible_and_update_neighbors_if_solved c, c.possible - combination
					end
				end
			end
		end
	end
end