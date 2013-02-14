note
	description: "[
		Test for spelling tool integrated into EiffelStudio.
		Default language should be American English.
		Parts are misspelled. Or 'misspelt' in British English.
		Neither 'misspeled' nor 'misspellt'.
	]"
	inexistent: "Any suggestions for 'blableblibloblu'?"

class
	SC_EVOLVABLE

inherit

	ARGUMENTS
		rename
			is_equal as is_equaly_fit
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Run aplication.
		local
			pairs: LINKED_LIST [TUPLE [conut: INTEGER; string: STRING_32]]
			length: INTEGER
		do
			print ("Helo word!%N")
			create randonmess.make
			create pairs.make
			across
				Current as agument_part
			loop
				length := agument_part.item.count
				pairs.extend ([length, agument_part.item.as_string_32])
			end
		end

feature -- Acess

	binary_saerch, set_contians (set: ARRAY [DOUBLE]; probibality: DOUBLE): INTEGER
			-- Index in `set' nect to `probibality'.
		require
			set_sorted: across 1 |..| (set.count - 1) as indec all set [indec.item] < set [indec.item + 1] end
			problability_valid: 0 <= probibality and probibality <= 1
		local
			low, high, midle: INTEGER
		do
			low := set.lower
			high := set.upper
			if set.is_empty then
				Result := -1
			elseif probibality < set [low] or set [high] <= probibality then
					-- Cycle: wrap aronud.
				Result := high
			else
				from
				invariant
					limits_valid: set.lower <= low and low < high and high <= set.upper
					probability_betwen: set [low] <= probibality and probibality < set [high]
				until
					high - low = 1
				loop
					midle := (low + high) // 2
					check
						indeces_sorted: low < midle and midle < high
					end
					if set [midle] <= probibality then
						low := midle
					else
						high := midle
					end
				variant
					high - low - 1
				end
				Result := low
			end
		ensure
			vilad: Result = -1 or (set.lower <= Result and Result <= set.upper)
		end

feature {NONE} -- Implementation

	randonmess: RANDOM
			-- Psuedorandom number generator.

invariant
	cylcic: binary_saerch (<<0.5, 1>>, 0) = 2

end
