class I18N_FORMATTING_UTILITY

feature -- Padd

	padd_with_space_left (a_integer, length: INTEGER): STRING_32 is
			--
		require
			valid_length: length > 0
			a_integer_not_to_large: a_integer < (10^(length+1)-1)
		local
			l_string: STRING_32
		do
			Result := padd_left (a_integer, length, ' ')
		end
	
	padd_with_space_right (a_integer, length: INTEGER): STRING_32 is
			--
		require
			valid_length: length > 0
			a_integer_not_to_large: a_integer < (10^(length+1)-1)
		local
			l_string: STRING_32
		do
			Result := padd_right (a_integer, length, ' ')
		end
		
	padd_with_0_left (a_integer, length: INTEGER): STRING_32 is
			--
		require
			valid_length: length > 0
			a_integer_not_to_large: a_integer < (10^(length+1)-1)
		local
			l_string: STRING_32
		do
			Result := padd_left (a_integer, length, '0')
		end
	
	padd_with_0_right (a_integer, length: INTEGER): STRING_32 is
			--
		require
			valid_length: length > 0
			a_integer_not_to_large: a_integer < (10^(length+1)-1)
		local
			l_string: STRING_32
		do
			Result := padd_right (a_integer, length, '0')
		end
		
feature {NONE} -- Implementation

	padd_left (a_integer, length: INTEGER; padder: CHARACTER): STRING_32 is
			--
		require
			valid_length: length > 0
			a_integer_not_to_large: a_integer < (10^(length+1)-1)
		local
			l_string: STRING_32
		do
			Result := a_integer.out
			if Result.count < length then
				create l_string.make_filled (padder, length - Result.count)
				Result.prepend (l_string)
			end
		end
		
	padd_right (a_integer, length: INTEGER; padder: CHARACTER): STRING_32 is
			--
		require
			valid_length: length > 0
			a_integer_not_to_large: a_integer < (10^(length+1)-1)
		local
			l_string: STRING_32
		do
			Result := a_integer.out
			if Result.count < length then
				create l_string.make_filled (padder, length - Result.count)
				Result.append (l_string)
			end
		end

end
