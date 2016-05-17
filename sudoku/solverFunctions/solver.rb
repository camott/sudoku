class Solver

	def initialize board
		@board = board
	end

	def solve cells
		raise NotImplementedError, "Implement this method in an inheriting class"
	end

	private

	def solve_all_ways 
		anything_changed = false
		
		@board.iterate_through_all do |cells|
			anything_changed ||= yield(cells)
		end

		anything_changed
	end

end