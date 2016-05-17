class Cell

	attr_reader :row, :column, :val

	def initialize row, col, val, possible={}
		@column = col
		@row = row
		@val = val
		@possible = @val.nil? ? possible.empty? ? {
			1 => nil,
			2 => nil,
			3 => nil,
			4 => nil,
			5 => nil,
			6 => nil,
			7 => nil,
			8 => nil,
			9 => nil
		} : possible : {}
	end

	def remove_possible vals
		unless solved?
			if vals.is_a?(Array)
				vals.each do |v|
					@possible.delete v
				end
			else
				@possible.delete vals
			end
			if possible.length == 1
				set_val possible.first
			end
		end
	end

	def box
		(@row / 3) * 3 + (@column / 3)
	end

	def possible
		@possible.keys
	end

	def solved?
		!@val.nil?
	end

	def set_val val
		@val = val
		@possible = {}
	end

	def clone
		Cell.new(row, column, val, @possible.clone)
	end

	def ==(o)
	  o.class == self.class && o.state == self.state
	end

	def state
	  [@row, @column]
	end

	def hash
		state.hash
	end

	def to_s
		solved? ? "#{@val}" : "_"
	end

	def print_full i
		if solved?
			if i == 1
				print "   #{val}   "
			else
				print "       "
			end
		else
			print " "
			(i*3+1..i*3+3).to_a.each do |i| 
				if @possible.include?(i)
					print "#{i}"
				else
					print " "
				end
				print " "
			end
		end
	end
end