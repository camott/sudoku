require_relative 'solver'

class XyzWingSolver < Solver

	def solve
		possible_hinges = @board.select{|c| c.possible.size == 3 }
		possible_hinges.each do |hinge|
			possible_wings = @board.get_all_visible_from_cell(hinge).select{|c| c.possible.size == 2 && c.possible - hinge.possible == []}
			possible_wings.combination(2).select{|pair| pair.first.possible != pair.last.possible }.each do |wings|
				wings_and_hinge = possible_wings + [hinge]
				unless @board.in_same_container(wings_and_hinge)
					val_in_all = wings_and_hinge.collect(&:possible).reduce(&:&).first
					cells_to_update = @board.get_visible_from_all_cells(wings_and_hinge).select{|c| c.has_possible(val_in_all)}
					cells_to_update.each do |c|
						@board.remove_possible_and_update_neighbors_if_solved c, val_in_all
					end
				end
			end
		end
	end

end