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

	make (a_type: CL_TYPE_A)
			-- Initialize translation unit for the invariant of `a_type'.
		do
			type := a_type
			id := "inv/" + type_id (a_type)
		end

	make_filtered (a_type: CL_TYPE_A; a_included, a_excluded: LIST [STRING]; a_ancestor: CLASS_C)
			-- Initialize translation unit for a partial invariant of `a_type'
			-- that only includes clauses `a_included', or excludes clauses `a_excluded',
			-- and only includes clauses inherited from `a_ancestor'.
		require
			type_exists: a_type /= Void
			not_both: a_included = Void or a_excluded = Void
		do
			type := a_type
			id := ""

			included := a_included
			if included /= Void then
				included.compare_objects
				across included as i loop id.append ("+" + i.item) end
			end
			excluded := a_excluded
			if excluded /= Void then
				excluded.compare_objects
				across excluded as i loop id.append ("-" + i.item) end
			end
			if a_ancestor /= Void then
				ancestor := a_ancestor
				id.append ("*" + ancestor.name_in_upper)
			else
				ancestor := type.base_class
			end
			id := "inv-filtered/" + id + "/" + type_id (a_type)
		end

feature -- Access

	type: CL_TYPE_A
			-- Type to which the invariant belongs.

	included, excluded: LIST [STRING]
			-- List of invariant tags to be filtered.

	ancestor: CLASS_C
			-- Class to which the invariant clauses will be restricted.

	id: STRING
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_TYPE_TRANSLATOR
		do
			create l_translator
			l_translator.translate_filtered_invariant_function (type, included, excluded, ancestor)
		end

invariant
	ancestor_exists: ancestor /= Void
	not_both: included = Void or excluded = Void

end
