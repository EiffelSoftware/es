indexing
	description: "Objects that ..."
	author: "Hong Zhang"
	date: "$Date: 2006-10-02 09:59:08  (Mon, 02 Oct 2006)$"
	revision: "$Revision$"

class
	I18N_BINARY_SEARCH_ARRAY_DICTIONAY
			--	the 'array' should be sorted
			--  the 'size' of 'array' should be given by its client
			--  the index of 'array' arranges from 1 to max_index
			--  max_index should be >=1


	inherit
		I18N_DICTIONARY

	rename
		extend as insert
	redefine
		make
	end


create
	make

feature --Creation

	make(a_plural_form:INTEGER;a_number_of_entries:INTEGER) is
			-- create the datastructure
			do
				Precursor(a_plural_form,a_number_of_entries)
				max_index:=a_number_of_entries
				create array.make (min_index, max_index)
				current_index:=1
			end

feature --Insertion

	insert(a_entry: I18N_DICTIONARY_ENTRY) is
			-- add an entry to 'array' without sorting it
		do
			if (current_index>=max_index) then
				io.put_string ("ARRAY IS FULL!%N")
			else
				array.put (a_entry, current_index)
				current_index:=current_index+1
			end
		end

feature --Access

	has(original:STRING_GENERAL):BOOLEAN is
			-- does the dictionary have this entry?
			-- use binary search algorithm
			-- require 'array'is sorted
			-- use has_index has a help function
		local
			index:INTEGER
		do
			index:=has_index(original.as_string_32)
			if index /=-1 then
				Result:=True
			end
		end

	has_index(original:STRING_GENERAL):INTEGER is
			-- does the dictionary have this entry?
			-- use binary search algorithm
			-- require 'array'is sorted
			-- return the Index of the found item
			-- return -1 if not found
		local
			left,right,middle: INTEGER
			m_string: STRING_32
		do
			from
				left:=min_index
				right:=current_index

			invariant
				right < current_index
						implies array.item(right + 1)<= array.item(current_index)
				left <= current_index and left > min_index
						implies array.item(left - 1) <= array.item(current_index)
			variant
				right - left + 1
			until
				left>right or (result=middle)
			loop
				middle := ((left + right).as_natural_32 |>> 1).as_integer_32
				m_string := array.item(middle).original_singular.as_string_32

				if original.as_string_32 < m_string then
					right := middle - 1
				elseif original.as_string_32 > m_string then
					left := middle + 1
			---?? i do not know whether original could be used or not
				else
					--Found
					Result := middle
					left := left + 1 -- not nice but required to decrease variant
				end
			end
			Result:=-1
		end


	has_plural(original_singular, original_plural: STRING_GENERAL; plural_number:INTEGER):BOOLEAN is
			--
		local
			entry: I18N_DICTIONARY_ENTRY
			index: INTEGER
		do
			index:=has_index(original_singular.as_string_32)
			if index /= -1 then
				entry := array.item (index)
				if entry.plural_translations.item(reduce (plural_number)) /= Void then
						Result := True
				end
			end
		end

	get_singular(original:STRING_GENERAL): STRING_32 is
		--
		local
			entry: I18N_DICTIONARY_ENTRY
			index: INTEGER
		do
			index:=has_index(original.as_string_32)
			if index /= -1 then
				entry := array.item (index)
				Result := entry.singular_translation
			end
		end

	get_plural(original_singular, original_plural: STRING_GENERAL; plural_number: INTEGER): STRING_32 is
				--
		local
			entry: I18N_DICTIONARY_ENTRY
			index: INTEGER
		do
			index:=has_index(original_singular.as_string_32)
			if index /= -1 then
				entry := array.item (index)
				Result := entry.plural_translations.item (reduce (plural_number))
			end
		end



feature --Information

	count:INTEGER is
		do
			Result := current_index
		end


feature {NONE} --Implementation

	array: ARRAY[I18N_DICTIONARY_ENTRY]
	min_index: INTEGER is 1
	max_index: INTEGER
	current_index:INTEGER

invariant
		current_index_is_larger: array.full implies current_index=max_index

end

