indexing
	description: "Objects that ..."
	author: "Hong Zhang"
	date: "$Date: 2006-10-02 09:59:08  (Mon, 02 Oct 2006)$"
	revision: "$Revision$"

class
	I18N_BINARY_SEARCH_ARRAY_DICTIONAY
			--	the 'array' should be sorted
			--  the 'size' of 'array' should be given by its client
			--  the index of 'array' arranges from 1 to max_index, but which could also be resible
			--  max_index should be >=1
			--  I think there is something wrong with 'array.full' in class ARRAY


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

	make(a_plural_form:INTEGER) is
			-- create the datastructure
			do
				Precursor(a_plural_form)
				max_index:=default_number_of_entries
				create array.make (min_index, default_number_of_entries)
				current_index:=1
			end

feature --Insertion

	insert(a_entry: I18N_DICTIONARY_ENTRY) is
			-- add an entry to 'array' without sorting it
			-- auto resize when the capacity of 'array' is filled
			-- without duplicate check, let insertion_sort do it
		do
				array.put(a_entry, current_index)
				current_index:=current_index+1
				insertion_sort_1
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

feature	{NONE}--help functions

	insertion_sort_1 is
		-- 'array' is sorted except the last inserted element
		-- after every 'insert' is insertion_sort is called
		-- check whether the last element is duplicate first
		-- check the last inserted element, compare it with the one before it, whether it is greater, then the
		-- the loop is ended, or make a exchange with the former one if it is smaller,
		-- do it recursively

	local
		i:INTEGER
		entry: I18N_DICTIONARY_ENTRY
		sorted: BOOLEAN
	do
		if has (array.item (current_index-1).original_singular) then
			sorted:=True
		end
		if (current_index=2) then
			-- one element case
			sorted:=True
		end
		from
			i:=current_index-1
		until
			i<2 or sorted
		loop
			if array.item (i)>array.item (i-1) then
				sorted:=True
			else
				entry:=array.item (i)
				array.force (array.item (i-1), i)
				array.force (entry, i-1)
				i:= i-1
			end
		end
	end

	insertion_sort_2 is
			-- 'array' is sorted except the last  inserted element
			-- after every 'insert' is insertion_sort is called
			-- compare with its neighbour recursively until the right_index for it is found
			-- subcopy  'array' from the right_index to current_index-2  to position from right_index-1
			-- put the last_input in 'array' with right_index
	local
		i,right_index:INTEGER
		entry: I18N_DICTIONARY_ENTRY
		sorted,duplicate: BOOLEAN
	do
		if (current_index=2) then
			-- one element case
			sorted:=True
		end
		entry:= array.item (current_index-1)
		from
			i:=current_index-2
		until
			i<1 or sorted
		loop
			if entry > array.item (i) then
				sorted:=True
			elseif entry = array.item (i) then
				-- ignore duplicate entry
				-- set current-index as the one to filled next
				current_index:=current_index-1
				sorted:=True
				duplicate:=True
			else
				i:= i-1
			end
		end
		if (not duplicate) then
			right_index:=i+1
			array.subcopy (array, right_index, current_index-2, right_index+1)
			array.put (entry, right_index)
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

feature	-- Access

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
		-- the index which is to be filled next
	current_index: INTEGER
	default_number_of_entries: INTEGER is 50

invariant

	count_equal_current_index: count=current_index

end

