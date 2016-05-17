require_relative 'solver'

class BoxedSolver < Solver

	def initialize board, num
		super(board)
		@num = num
	end

	def solve
		#This is going to grab groups of rows/columns
		(0..8).to_a.combination(@num).to_a.each do |combination|
			#an x-wing can be through a row or a column
			{:row => :column, :column => :row}.each do |grouping|
				groupings_all = []
				combination.each do |i|
					groupings_all << @board.send("get_#{grouping.first}".to_sym, i)
				end
				groupings_unsolved = groupings_all.map{|g| g.reject(&:solved?)}
				
				possible_vals = (1..9).to_a - groupings_all.map{|g| @board.find_values_in_cells(g)}.reduce(&:|)
				possible_vals.each do |i|
					groupings_with_possible_val = groupings_unsolved.map{|g| g.select{|c| c.has_possible(i)}}

					#the value has to occur <= num in each grouping for it to be an x-wing or sword-fish
					if groupings_with_possible_val.inject(true){|all_right_size, g| all_right_size && g.size <= @num && g.size != 0}

						#checking the opposite value to make sure that the cells are parallel
						opposite_vals = groupings_with_possible_val.map{|g| g.collect(&grouping.last)}.flatten.uniq
						#if values are parallel
						if opposite_vals.size == num
							cells_to_update = opposite_vals.map{|v| @board.send(
								"get_#{grouping.last}".to_sym, v).reject(&:solved?).select{|c| c.has_possible(i)} }.flatten
							#ignore the cells that are part of the x-wing / sword-fish
							cells_to_update = cells_to_update - groupings_with_possible_val.flatten
							cells_to_update.each do |c|
								@board.remove_possible_and_update_neighbors_if_solved c, i
							end
						end
					end
				end
			end
		end
	end

end