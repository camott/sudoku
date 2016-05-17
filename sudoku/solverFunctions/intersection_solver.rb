#An intersecton solver determines if a possible value occurs 2/3 times in a box and all 2/3 cells happen to be in the same row or column,
#That value can be removed as a possibility from the rest of the cells in the row/column.  You can also do it the other way around.  If a
#value only occurs 2/3 times in a row/column and those 2/3 cell happen to be in the same box, then you can remove that value as a possibility
#from any other cells in that box.

#EX: if you have the following row [1, {6,7,8}, {6,8}, {7,9}, {6,8,9}, 2, 3, 4, 5] and 6 doesn't occur anywhere else in the box containing
#1, {6,7,8}, {6,8} then you know that 6 can be removed from the last unsolved cell since it must occur in the first box.

require_relative 'solver'

class IntersectionSolver < Solver

	def solve
		solve_all_ways do |cells|
			values = @board.find_values_in_cells cells
			is_square = cells.collect(&:box).uniq.size == 1
			cells = cells.reject(&:solved?)

			((1..9).to_a - values).to_a.each do |i|
				cells_with_possible_val = cells.select{|c| c.has_possible(i)}
				cells_to_check = []
				if is_square
					rows = cells_with_possible_val.collect(&:row).uniq
					cols = cells_with_possible_val.collect(&:column).uniq
					if rows.size == 1
						cells_to_check = @board.get_row(rows[0])
					elsif cols.size == 1
						cells_to_check = @board.get_column(cols[0])
					end
				else
					boxes = cells_with_possible_val.collect(&:box).uniq
					if boxes.size == 1
						cells_to_check = @board.get_square(boxes[0])
					end
				end
				if !cells_to_check.empty?
					cells_to_update = cells_to_check.select{|c| !cells_with_possible_val.include?(c) && c.has_possible(i) }
					cells_to_update.each do |c|
						@board.remove_possible_and_update_neighbors_if_solved c, i
					end
				end
			end
		end
	end

end