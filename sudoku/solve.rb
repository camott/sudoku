require_relative 'cell'
require_relative 'board'

def guess_solve board
	board_valid = board.is_valid?
	return board if board_valid && board.solved?
	return nil unless board_valid

	solved_board = nil

	cell_to_guess = board.reject(&:solved?).sort_by{ |c| c.possible.length }.first
	while !cell_to_guess.possible.empty? && solved_board.nil?
		copied_board = board.clone
		guess = cell_to_guess.possible.first
		copied_cell_to_guess = copied_board.select{|c| c == cell_to_guess}.first
		copied_board.set_value_and_update_neighbors copied_cell_to_guess, guess
		solved_board = guess_solve copied_board
		if solved_board.nil?
			board.remove_possible_and_update_neighbors_if_solved cell_to_guess, guess
			if cell_to_guess.solved?
				solved_board = guess_solve board
			end
		end
	end

	solved_board
end


time_started = Time.now
if ARGV[0]
	@board = Board.new ARGV[0]
	raise "invalid board entered" unless @board.is_valid?
else
	raise "no input"
end

unless @board.solved?
	@board = guess_solve @board
	raise "invalid board solution" unless @board.is_valid?
end

if ARGV[1] == 'full'
	@board.print_full
else
	@board.print_compact
end

puts "took #{Time.now - time_started} seconds" if ARGV[1] == 'full'