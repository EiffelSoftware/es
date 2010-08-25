note
	description: "[
					Roundtrip visitor to evaluate separateness of a class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SEPARATE_CLASS_VISITOR

	obsolete "This class should not be in use."

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as
		end

	SHARED_SCOOP_WORKBENCH

create
	make_with_separate_class_list

feature -- Initialisation

	make_with_separate_class_list(a_class_list: SCOOP_SEPARATE_CLASS_LIST)
			-- Initialise and reset flags
		require
			a_class_list_not_void: a_class_list /= Void
		do
			needed_classes := a_class_list
		end

feature -- Access

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			Precursor (l_as)

				-- case 2)
			if l_as.is_separate then
				add_class_to_list (l_as.class_name.name.as_upper)
			end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			Precursor (l_as)

				-- case 2)
			if l_as.is_separate then
				add_class_to_list (l_as.class_name.name.as_upper)
			end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			Precursor (l_as)

				-- case 2)
			if l_as.is_separate then
				add_class_to_list (l_as.class_name.name.as_upper)
			end
		end

feature {NONE} -- Implementation

	add_class_to_list (a_class_name: STRING) is
			-- adds a class to the neede_classes list if not already done.
		local
			a_class: CLASS_C
		do
			if not needed_classes.has (a_class_name) then
				a_class := get_class_by_name (a_class_name)
				if a_class /= Void then
					needed_classes.extend (a_class)
					io.put_string ("### C2 - Class " + a_class_name + " ###%N")
				end
			end
		end

	get_class_by_name (a_class_name: STRING): CLASS_C is
			-- gets class by class_name
		local
			i: INTEGER
			found_class: CLASS_C
		do
			found_class := void
			from i := 1 until i > system.classes.count loop
				if system.classes.item (i) /= Void and then
				   system.classes.item (i).name_in_upper.is_equal (a_class_name) then

					Result := system.classes.item (i)
				end
				i := i + 1
			end

			Result := found_class
		end

	needed_classes: SCOOP_SEPARATE_CLASS_LIST
		-- classes which needs client and proxy classes.

end -- class SCOOP_SEPARATE_CLASS_VISITOR
