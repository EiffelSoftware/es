indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENT_CLASS_CONFIG

create
	make

feature{NONE} -- Initialization

	make (a_name: like class_name) is
			-- Initialize.
		require
			a_name_attached: a_name /= Void
		do
			set_class_name (a_name)
		end

feature -- Access

	class_name: STRING
			-- Class name in upper case

feature -- Status report

	is_proper_ancestor_included: BOOLEAN
			-- Should proper ancestors of class named `class_name' be included?

	is_excluded: BOOLEAN
			-- Should this class be excluded?

feature -- Setting

	set_is_proper_ancestor_included (b: BOOLEAN) is
			-- Set `is_proper_ancestor_included' with `b'.
		do
			is_proper_ancestor_included := b
		ensure
			is_proper_ancestor_included_set: is_proper_ancestor_included = b
		end

	set_is_excluded (b: BOOLEAN) is
			-- Set `is_excluded' with `b'.
		do
			is_excluded := b
		ensure
			is_excluded_set: is_excluded = b
		end

	set_class_name (a_name: like class_name) is
			-- Set `class_name' with `a_name'.
		require
			a_name_attached: a_name /= Void
		do
			class_name := a_name.twin
		ensure
			class_name_set: class_name /= Void and then class_name.is_equal (a_name)
		end

end
