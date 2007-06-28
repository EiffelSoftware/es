indexing
	description: "Objects that support cdd classes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CONSTANTS

feature -- Access

feature -- Project constants

	tests_cluster_name: STRING is "cdd_test_suite"
			-- Name of cdd cluster

feature -- Error constants

	error_none,				-- No error occured
	error_bad_root_cluster,	-- Root cluster is not a normal cluster
	error_need_recompile,
	error_unable_to_create_dir: INTEGER is unique
			-- Error codes


feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
