indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENT_CLASS_CONFIG

inherit
	SAT_INSTRUMENT_CONFIG
		redefine
			set_class_name
		end

	SHARED_WORKBENCH

create
	make

feature{NONE} -- Initialization

	make (a_name: like class_name) is
			-- Initialize `class_name' with `a_name'.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			set_class_name (a_name)
		end

feature -- Status report

	is_ancestor_enabled: BOOLEAN
			-- Should ancestors of class named `class_name' also be instrumented?

feature -- Setting

	set_is_ancestor_enabled (b: BOOLEAN) is
			-- Set `is_ancestor_enabled' with `b'.
		do
			is_ancestor_enabled := b
		ensure
			is_ancestor_enabled_set: is_ancestor_enabled = b
		end

	set_class_name (a_name: like class_name) is
			-- Set `class_name' with `a_name'.
			-- Note: reference setting, don't copy object.
		do
			Precursor (a_name)
		ensure then
			instrumented_classes_internal_reset: instrumented_classes_internal = Void
		end

feature -- Status report

	is_instrument_enabled (a_context: BYTE_CONTEXT): BOOLEAN is
			-- Should instrument code be generated for the piece of code which is being process in `a_context'?
		do
			Result := instrumented_classes.has (a_context.associated_class.name_in_upper)
		ensure then
			good_result: Result = instrumented_classes.has (a_context.associated_class.name_in_upper)
		end

feature{NONE} -- Implementation

	instrumented_classes: DS_HASH_SET [STRING] is
			-- Name (in upper case) of classes to be instrumented
		local
			l_classes_i: LIST [CLASS_I]
			l_ancestors: DS_LINKED_LIST [CLASS_C]
			l_cursor: DS_LINKED_LIST_CURSOR [CLASS_C]
		do
			if instrumented_classes_internal = Void then
				create instrumented_classes_internal.make (20)
				instrumented_classes_internal.set_equality_tester (
					create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (
						agent (str1, str2: STRING): BOOLEAN do Result := str1.is_equal (str2) end))

				l_classes_i := universe.classes_with_name (class_name)
				if not l_classes_i.is_empty then
					instrumented_classes_internal.force_last (class_name)

						-- Calculate ancestors of `class_name'.
					create l_ancestors.make
					calculate_parents (l_classes_i.first, l_ancestors)

						-- Add ancestors of `class_name' into `instrument_classes'.
					l_cursor := l_ancestors.new_cursor
					from
						l_cursor.start
					until
						l_cursor.after
					loop
						instrumented_classes_internal.force_last (l_cursor.item.name_in_upper)
						l_cursor.forth
					end
				end
			end
			Result := instrumented_classes_internal
		ensure
			result_attached: Result /= Void
		end

	instrumented_classes_internal: like instrumented_classes
			-- Implementation of `instrumented_classes'

	calculate_parents (a_class: CLASS_I; a_list: DS_LIST [CLASS_C])
			-- Store parent classes of `a_class' into `a_list'.
		require
			a_class_attached: a_class /= Void
			a_list_attached: a_list /= Void
		local
			l_class_i: CLASS_I
			l_class_C: CLASS_C
			l_list: LIST [CLASS_C]
			l_cursor: CURSOR
		do
			if a_class.is_compiled then
				l_list := a_class.compiled_class.parents_classes
				if l_list /= Void and then not l_list.is_empty then
					l_cursor := l_list.cursor
					from l_list.start until l_list.after loop
						l_class_c ?=  l_list.item
						if not a_list.has (l_class_c) then
							a_list.force_last (l_class_c)
							l_class_i ?= l_class_c.lace_class
							calculate_parents (l_class_i, a_list)
						end
						l_list.forth
					end
					l_list.go_to (l_cursor)
				end
			end
		end

end
