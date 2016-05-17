#A naked solver determines whether there are {num} cells in a row/column/box that must all be one of {num} values
#If those {num} cells must be one of the {num} values, no other cells in that grouping can contain any of those values and can
#have them removed as a possibility

#EX: if you have the following row [1, 2, {6,7}, {6,7}, {7,9}, {6,8,9}, 3, 4, 5]
#you know that the first two unsolved cells must be 6/7 then both those possiblities can be removed from the second two unsolved cells

require_relative 'solver'

class NakedSolver < Solver

	def solve
		solve_all_ways do |cells|
			unsolved_cells = cells.reject(&:solved?)

			possibilities_per_cell = unsolved_cells.map{ |c| c.possible }
			possibility_counts = possibilities_per_cell.inject(Hash.new(0)) do |counts, possibilities|
				counts[possibilities] += 1
				counts
			end
			naked_sets = possibility_counts.select{|possibilities, count| possibilities.size == count }

			naked_sets.each_key do |possibilities|
				cells_to_update = unsolved_cells.select{|c| c.has_any_possible(possibilities) && c.possible - possibilities != [] }
				cells_to_update.each do |c|
					@board.remove_possible_and_update_neighbors_if_solved c, possibilities
				end
			end
		end
	end
end