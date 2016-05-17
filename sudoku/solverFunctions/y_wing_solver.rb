require_relative 'solver'

class YWingSolver < Solver

	def solve
		possible_starts = @board.select{|c| c.possible.size == 2 }
		while possible_starts.size > 0
			chain = [possible_starts.pop]
			#once any of the cells in the chain are solved, we are done processing this chain even if there are more possible links
			while((next_in_chain = @board.get_all_visible_from_cells(chain).select{|c| c.possible == chain.first.possible}.first) && chain.select(&:solved?).empty?)
				possible_starts.delete(next_in_chain)
				chain << next_in_chain
				find_y_wing_off_pivots chain if chain.size % 2 == 1
			end
		end
	end

	private 

	def find_y_wing_off_pivots pivot_cells
		anything_changed = false
		visible_cells = @board.get_all_visible_from_cells(pivot_cells)
		pivot_cells_possible = pivot_cells.first.possible
		#we eleminate any that have the same 2 possible because that would just be a naked pair with ones of the the pivot cells, not a y-wing
		possible_wings = visible_cells.select{|c| c.possible.size == 2 && c.possible != pivot_cells_possible && (c.has_possible(pivot_cells_possible.first) || c.has_possible(pivot_cells_possible.last)) }
		if possible_wings.size > 1
			#find all possible wings - we don't want both wings to have the same possible values
			#one must have one of the possibilities from the pivot cell and the other must have the other possibility
			possible_wings.combination(2).select{|pair| pair.first.possible - pivot_cells_possible == pair.last.possible - pivot_cells_possible && pair.first.possible != pair.last.possible }.each do |wings|
				#if all three have the same row, column or square, they are just a naked triplet, not a y-wing
				unless @board.in_same_container(wings + pivot_cells)
					value_to_remove = (wings.first.possible - pivot_cells_possible).first
					visible_from_both_wings = @board.get_all_visible_from_cell(wings.first) & @board.get_all_visible_from_cell(wings.last)
					cells_to_update = visible_from_both_wings.reject(&:solved?).select{|c| c.has_possible(value_to_remove) }
					anything_changed ||= !cells_to_update.empty?
					cells_to_update.each do |c|
						@board.remove_possible_and_update_neighbors_if_solved c, value_to_remove
					end
				end
			end
		end
		anything_changed
	end

end