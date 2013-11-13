note
	description: "[
		Translation unit for the invariant function of an Eiffel class.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_INVARIANT_FUNCTION

inherit

	E2B_TRANSLATION_UNIT

create
	make,
	make_filtered

feature {NONE} -- Implementation

	make (a_type: TYPE_A)
			-- Initialize translation unit for type `a_type'.
		do
			type := a_type
			id := "inv/" + type_id (a_type)
		end

	make_filtered (a_type: TYPE_A; a_included, a_excluded: LIST [STRING])
			-- Initialize translation unit for type `a_type' with filtered tags.
		local
			l_inc_string, l_exc_string: STRING
		do
			type := a_type
			included := a_included
			excluded := a_excluded
			l_inc_string := ""
			if a_included /= Void then
				across a_included as i loop l_inc_string.append ("+" + i.item) end
			end
			l_exc_string := ""
			if a_excluded /= Void then
				across a_excluded as i loop l_exc_string.append ("-" + i.item) end
			end
			id := "inv-filtered/" + l_inc_string + l_exc_string + "/" + type_id (a_type)
		end

feature -- Access

	type: TYPE_A
			-- Type to be translated.

	included, excluded: LIST [STRING]
			-- List of invariant tags to be filtered.

	id: STRING
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_TYPE_TRANSLATOR
		do
			create l_translator
			if included = Void and excluded = Void then
				l_translator.translate_invariant_function (type)
			elseif included = Void then
				l_translator.translate_filtered_invariant_function (type, create {LINKED_LIST [STRING]}.make, excluded)
			elseif excluded = Void then
				l_translator.translate_filtered_invariant_function (type, included, create {LINKED_LIST [STRING]}.make)
			else
				l_translator.translate_filtered_invariant_function (type, included, excluded)
			end
		end

end
