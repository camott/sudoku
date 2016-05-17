class Board < Array

	def initialize input
		if input.is_a?(String)
			input.lines.each_with_index do |l, row|
				l.gsub(/\s/, '').split(',').each_with_index do |val, col|
					self << Cell.new(row, col, val == "-" ? nil : val.to_i)
				end
			end
			reject(&:solved?).each do |cell|
				remove_possible_and_update_neighbors_if_solved cell, get_all_visible_values_from_cell(cell)
			end
		elsif input.is_a?(Array)
			self.concat input
		end
	end

	def get_row i
		self[i*9..i*9+8]
	end

	def iterate_through_rows
		(0..8).each do |row_i|
			yield(get_row(row_i), row_i)
		end
	end

	def get_column i
		select{|c| c.column == i }
	end

	def iterate_through_columns
		(0..8).each do |col_i|
			yield(get_column(col_i), col_i)
		end
	end

	def get_square i
		select{|c| c.box == i }
	end

	def iterate_through_squares
		(0..8).each do |sq_i|
			yield(get_square(sq_i), sq_i)
		end
	end

	def get_all_visible_from_cell cell
		select{|other| (other.box == cell.box || other.row == cell.row || other.column == cell.column) && other != cell}
	end

	def get_all_visible_values_from_cell cell
		find_values_in_cells(get_all_visible_from_cell(cell))
	end

	def find_values_in_cells cells
		cells.select(&:solved?).collect(&:val)
	end

	def remove_possible_and_update_neighbors_if_solved c, val
		unless c.solved?
			c.remove_possible val
			update_neighbors c if c.solved?
		end
	end

	def update_neighbors c
		get_all_visible_from_cell(c).each { |neighbor| remove_possible_and_update_neighbors_if_solved neighbor, c.val }
	end

	def set_value_and_update_neighbors c, val
		c.set_val val
		update_neighbors c
	end

	def is_valid?
		valid = select{|c| !c.solved? && c.possible.empty? }.empty?

		iterate_through_rows do |row, i|
			vals = find_values_in_cells row
			valid_row = (vals == vals.uniq)
			valid &&= valid_row
		end

		iterate_through_columns do |col, i|
			vals = find_values_in_cells col
			valid_col = (vals == vals.uniq)
			valid &&= valid_col
		end

		iterate_through_squares do |square, i|
			vals = find_values_in_cells square
			valid_square = (vals == vals.uniq)
			valid &&= valid_square
		end

		valid
	end

	def solved?
		reject(&:solved?).empty?
	end

	def clone
		Board.new(map{ |c| c.clone })
	end

	def print_compact
		iterate_through_rows do |row, row_i|
			puts row.join(",")
		end
		puts
	end

	def print_full
		puts "       1       2       3        4       5       6        7       8       9     "
		puts "  ++-----------------------++-----------------------++-----------------------++"
		iterate_through_rows do |row, row_i|
			(0..2).each do |i|
				print i == 1 ? "#{(row_i + 65).chr} " : "  "
				print "|"
				row.each_with_index do |c, index| 
					print "|" if index % 3 == 0
					c.print_full(i)
					print "|"
				end
				puts "|"
			end
			if row_i % 3 == 2
				puts "  ++-----------------------++-----------------------++-----------------------++"
				puts "  ++-----------------------++-----------------------++-----------------------++"
			else
				puts "  ||-----------------------||-----------------------||-----------------------||"
			end
		end
	end

end