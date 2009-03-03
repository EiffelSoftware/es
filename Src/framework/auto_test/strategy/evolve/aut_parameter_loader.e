indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PARAMETER_LOADER

create
	make

feature -- Creation
	make is
			--
		do
			is_loaded := false
		ensure
			is_loaded = false
		end

feature -- Load

	load_parameters is
		-- Load the files from the evolve directory
		require

		do


			create boolean_list.make_default
			create character_8_list.make_default
			create character_32_list.make_default
			create real_32_list.make_default
			create real_64_list.make_default
			create integer_8_list.make_default
			create integer_16_list.make_default
			create integer_32_list.make_default
			create integer_64_list.make_default
			create natural_8_list.make_default
			create natural_16_list.make_default
			create natural_32_list.make_default
			create natural_64_list.make_default
			create sed_list.make_default
			create creation_probability_list.make_default
			create diversity_probability_list.make_default
			create method_sequence_list.make_default

			load_primitive
			load_configuration

		end

feature -- Parameters
	is_sequential_method_invocation :BOOLEAN 
	is_evolving_primitive :BOOLEAN
	is_evolving_sed :BOOLEAN
	is_evolving_creation_probability :BOOLEAN
	is_evolving_diversification_probability :BOOLEAN is true

feature -- State

    is_loaded: BOOLEAN
    	-- True if the parameter files have been loaded

    folder_location :STRING
    	-- location where the files are stored


feature -- Set

	set_folder_location (str :STRING) is
    		-- Set the folder location
    	require
    		str /= void
    	do
    		folder_location := str + "/evolve/"
    	ensure
    		folder_location /= void
    	end

feature -- Get


	get_next_boolean :BOOLEAN is
			--
		do
			if boolean_list.count > 0 then
				if boolean_list.off then
			   		boolean_list.start
				end
				result := boolean_list.item_for_iteration
				boolean_list.forth
			else
				--Default value
				result := false
			end

		end

	get_next_character_8 :CHARACTER_8 is
			--
		do
			if character_8_list.count > 0 then
				if character_8_list.off then
			   		character_8_list.start
				end
				result := character_8_list.item_for_iteration
				character_8_list.forth
			else
				--Default value
				result := 'a'
			end

		end

	get_next_character_32:CHARACTER_32 is
			--
		do
			if character_32_list.count > 0 then
				if character_32_list.off then
			   		character_32_list.start
				end
				result := character_32_list.item_for_iteration
				character_32_list.forth
			else
				--Default value
				result := 'a'
			end
		end

	get_next_creation_probability: REAL_32 is
			--
		do
			if creation_probability_list.count > 0 then
				if creation_probability_list.off then
			   		creation_probability_list.start
				end
				result := creation_probability_list.item_for_iteration
				creation_probability_list.forth
			else
				--Default value
				result := 0
			end

		end

		get_next_diversity_probability: REAL_32 is
			--
		do
			if  diversity_probability_list.count > 0 then
				if diversity_probability_list.off then
			   		diversity_probability_list.start
				end
				result := diversity_probability_list.item_for_iteration
				diversity_probability_list.forth
			else
				--Default value
				result := 0
			end

		end


	get_next_real_32: REAL_32 is
			--
		do
			if real_32_list.count > 0 then
				if real_32_list.off then
			   		real_32_list.start
				end
				result := real_32_list.item_for_iteration
				real_32_list.forth
			else
				--Default value
				result := 0
			end

		end

	get_next_real_64 :REAL_64 is
			--
		do
			if real_64_list.count > 0 then
				if real_64_list.off then
			   		real_64_list.start
				end
				result := real_64_list.item_for_iteration
				real_64_list.forth
			else
				--Default value
				result := 0
			end
		end

	get_next_integer_8 :INTEGER_8 is
			--
		do
			if integer_8_list.count > 0 then
				if integer_8_list.off then
			   		integer_8_list.start
				end
				result := integer_8_list.item_for_iteration
				integer_8_list.forth
			else
				--Default value
				result := 1
			end
		end

		get_next_sed :INTEGER is
			--
		do
			if  sed_list.count > 0 then
				if sed_list.off then
			   		sed_list.start
				end
				result := sed_list.item_for_iteration
				sed_list.forth
			else
				--Default value
				result := 1
			end
		end


	get_next_integer_16:INTEGER_16 is
			--
		do
			if integer_16_list.count > 0 then
				if integer_16_list.off then
			   		integer_16_list.start
				end
				result := integer_16_list.item_for_iteration
				integer_16_list.forth
			else
				--Default value
				result := 1
			end
		end

	get_next_integer_32:INTEGER_32 is
			--
		do
			if integer_32_list.count > 0 then
				if integer_32_list.off then
			   		integer_32_list.start
				end
				result := integer_32_list.item_for_iteration
				integer_32_list.forth
			else
				--Default value
				result := 1
			end

		end

	get_next_integer_64 :INTEGER_64 is
			--
		do
			if integer_64_list.count > 0 then
				if integer_64_list.off then
			   		integer_64_list.start
				end
				result := integer_64_list.item_for_iteration
				integer_64_list.forth
			else
				--Default value
				result := 1
			end
		end

	get_next_natural_8 : NATURAL_8 is
			--
		do
			if  natural_8_list.count > 0 then
				if natural_8_list.off then
			   		natural_8_list.start
				end
				result := natural_8_list.item_for_iteration
				natural_8_list.forth
			else
				--Default value
				result := 1
			end
		end

	get_next_natural_16 : NATURAL_16 is
			--
		do
			if  natural_16_list.count > 0 then
				if natural_16_list.off then
			   		natural_16_list.start
				end
				result := natural_16_list.item_for_iteration
				natural_16_list.forth
			else
				--Default value
				result := 1
			end
		end

	get_next_natural_32 : NATURAL_32 is
			--
		do
			if  natural_32_list.count > 0 then
				if natural_32_list.off then
			   		natural_32_list.start
				end
				result := natural_32_list.item_for_iteration
				natural_32_list.forth
			else
				--Default value
				result := 1
			end

		end

	get_next_natural_64:NATURAL_64 is
			--
		do
			if  natural_64_list.count > 0 then
				if natural_64_list.off then
			   		natural_64_list.start
				end
				result := natural_64_list.item_for_iteration
				natural_64_list.forth
			else
				--Default value
				result := 1
			end
		end


feature {NONE } -- Implementation		


	boolean_list: DS_LINKED_LIST [BOOLEAN]
	character_8_list  : DS_LINKED_LIST [CHARACTER_8]
	character_32_list : DS_LINKED_LIST [CHARACTER_32]
	real_32_list: DS_LINKED_LIST [REAL_32]
	real_64_list: DS_LINKED_LIST [REAL_64]
	integer_8_list : DS_LINKED_LIST [INTEGER_8]
	integer_16_list: DS_LINKED_LIST [INTEGER_16]
	integer_32_list: DS_LINKED_LIST [INTEGER_32]
	integer_64_list: DS_LINKED_LIST [INTEGER_64]
	natural_8_list : DS_LINKED_LIST [NATURAL_8]
	natural_16_list: DS_LINKED_LIST [NATURAL_16]
	natural_32_list: DS_LINKED_LIST [NATURAL_32]
	natural_64_list: DS_LINKED_LIST [NATURAL_64]
	sed_list: DS_LINKED_LIST [INTEGER]
	creation_probability_list: DS_LINKED_LIST [DOUBLE]
	diversity_probability_list: DS_LINKED_LIST [DOUBLE]
	method_sequence_list: DS_LINKED_LIST [INTEGER]


	-- File names for the parameters
	boolean_file_name:      STRING is "boolean.txt"
	character_8_file_name : STRING is "character_8.txt"
	character_32_file_name: STRING is "character_32.txt"
	real_32_file_name:      STRING is "real_32.txt"
	real_64_file_name:      STRING is "real_64.txt"
	integer_8_file_name :   STRING is "integer_8.txt"
	integer_16_file_name:   STRING is "integer_16.txt"
	integer_32_file_name:   STRING is "integer_32.txt"
	integer_64_file_name:   STRING is "integer_64.txt"
	natural_8_file_name :   STRING is "natural_8.txt"
	natural_16_file_name:   STRING is "natural_16.txt"
	natural_32_file_name:   STRING is "natural_32.txt"
	natural_64_file_name:   STRING is "natural_64.txt"
	sed_file_name:          STRING is "sed.txt"
	creation_probability_file_name:  STRING is "creation_probability.txt"
	diversity_probability_file_name: STRING is "diversity_probability.txt"
	method_call_sequence_file_name:  STRING is "method_call_sequence.txt"


load_configuration is
			-- open the primitive file and load the list
		local
			file: PLAIN_TEXT_FILE
			str:STRING
		do

			create file.make_open_read  (folder_location + "../../../../../evolve.conf")

			from
				file.start
			until
				file.after
			loop
				 file.read_line
				 str := file.last_string
				 str.to_lower


				if str.has_substring ("//") then
					--skip it is a comment

				elseif str.has_substring ("is_evolving_primitive")  then
					io.putstring ("Found evolving primitive")
					if str.has_substring ("true") then
						io.putstring ("Evolving primitive")
						io.put_new_line
						is_evolving_primitive := true
					elseif  str.has_substring ("false")  then
						is_evolving_primitive := false
					end
				elseif str.has_substring ("is_evolving_sed")  then
					if str.has_substring ("true") then
						io.putstring ("Evolving sed")
						io.put_new_line
						is_evolving_sed := true
					elseif  str.has_substring ("false")  then
						is_evolving_sed := false
					end

				elseif str.has_substring ("is_evolving_creation_probability")  then
					if str.has_substring ("true") then
						io.putstring ("Evolving creation probability")
						io.put_new_line
						is_evolving_creation_probability := true
					elseif  str.has_substring ("false")  then
						is_evolving_creation_probability := false
					end

				elseif str.has_substring ("is_sequential_method_invocation")  then
					if str.has_substring ("true") then
						is_sequential_method_invocation := true
					elseif  str.has_substring ("false")  then
						is_sequential_method_invocation := false
					end
				end

			end

		end


	load_primitive is
			-- open the primitive file and load the list
		local
			file: PLAIN_TEXT_FILE
		do
			io.put_new_line
			create file.make_open_read  (folder_location + boolean_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_integer
				if (file.last_integer > 0 ) then
					boolean_list.put_last (TRUE)
				else
					boolean_list.put_last (FALSE)
				end
			end
			file.close
			io.putstring ("Boolean list created with " + boolean_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + character_8_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_integer
				character_8_list.put_last ((file.last_integer // 255).to_character_8)
			end
			file.close
			io.putstring ("Character_8 list created with " + character_8_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + character_32_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_integer
				character_32_list.put_last ((file.last_integer // 600).to_character_32)
			end
			file.close
			io.putstring ("Character_32 list created with " + character_32_list.count.out)
			io.put_new_line



			create file.make_open_read (folder_location + real_32_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_real
				 real_32_list.put_last (file.last_real.ceiling_real_32)
			end
			file.close
			io.putstring ("Real_32 list created with " + real_32_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + real_64_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_real
			    real_64_list.put_last (file.last_real)
			end
			file.close
			io.putstring ("Real_64 list created with " + real_64_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + integer_8_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_integer_8
			    integer_8_list.put_last (file.last_integer_8)
			end
			file.close
			io.putstring ("Integer_8 list created with " + integer_8_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + integer_16_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_integer_16
			    integer_16_list.put_last (file.last_integer_16)
			end
			file.close
			io.putstring ("Integer_16 list created with " + integer_16_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + integer_32_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_integer_32
			    integer_32_list.put_last (file.last_integer_32)
			end
			file.close
			io.putstring ("Integer_32 list created with " + integer_32_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + integer_64_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_integer_16
			    integer_64_list.put_last (file.last_integer_64)
			end
			file.close
			io.putstring ("Integer_64 list created with " + integer_64_list.count.out)
			io.put_new_line


			create file.make_open_read (folder_location + natural_8_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_natural_8
			    natural_8_list.put_last (file.last_natural_8)
			end
			file.close
			io.putstring ("Neutral_8 list created with " + natural_8_list.count.out )
			io.put_new_line


			create file.make_open_read (folder_location + natural_16_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_natural_16
			    natural_16_list.put_last (file.last_natural_16)
			end
			file.close
			io.putstring ("Neutral_16 list created with " + natural_16_list.count.out )
			io.put_new_line


			create file.make_open_read (folder_location + natural_32_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_natural_32
			    natural_32_list.put_last (file.last_natural_32)
			end
			file.close
			io.putstring ("Neutral_32 list created with " + natural_32_list.count.out )
			io.put_new_line


			create file.make_open_read (folder_location + natural_64_file_name)
			from
				file.start
			until
				file.after
			loop
				file.read_natural_64
			    natural_64_list.put_last (file.last_natural_64)
			end
			file.close
			io.putstring ("Neutral_64 list created with " + natural_64_list.count.out )
			io.put_new_line


			create file.make_open_read (folder_location + sed_file_name)
			load_integer_from_file(file, sed_list)
			file.close
			io.putstring ("sed_list list created with " + sed_list.count.out )
			io.put_new_line



			create file.make_open_read (folder_location + creation_probability_file_name)
			load_double_from_file(file, creation_probability_list)
			file.close
			io.putstring ("creation_probability_list list created with " + creation_probability_list.count.out )
			io.put_new_line


			create file.make_open_read (folder_location + diversity_probability_file_name)
			load_double_from_file(file, diversity_probability_list)
			file.close
			io.putstring ("diversity_probability list created with " + diversity_probability_list.count.out )
			io.put_new_line

			create file.make_open_read (folder_location + method_call_sequence_file_name)
			load_integer_from_file(file, method_sequence_list)
			file.close
			io.putstring ("method_sequence_list list created with " + method_sequence_list.count.out )
			io.put_new_line

		end


	load_double_from_file (file : PLAIN_TEXT_FILE ; list : DS_LINKED_LIST[DOUBLE] ) is
		--
		do
			from
				file.start
			until
				file.after
			loop
				file.read_double
			    list.put_last (file.last_double)
			end

		end

	load_integer_from_file (file : PLAIN_TEXT_FILE ; list : DS_LINKED_LIST[INTEGER] ) is
		--
		do
			from
				file.start
			until
				file.after
			loop
				file.read_integer
			    list.put_last (file.last_integer)
			end

		end

invariant
	invariant_clause: True -- Your invariant here

end
