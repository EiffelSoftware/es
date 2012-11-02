note
	description: "A writer that writes the analysis results of a dynamic program analysis to disk."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_WRITER

inherit
	EPA_EXPRESSION_VALUE_TYPE_CONSTANTS
		export
			{NONE} all
		end

feature -- Access

	class_: CLASS_C
			-- Context class of `feature_'.

	feature_: FEATURE_I
			-- Feature under analysis.

	transitions: LINKED_LIST [EPA_EXPRESSION_VALUE_TRANSITION]
			-- Unwritten transitions of the last processed state(s).

feature -- Element change

	extend (a_transitions: like transitions)
			-- Add `a_transitions' to `transitions'.
		require
			a_transitions_not_void: a_transitions /= Void
		do
			a_transitions.do_all (agent transitions.extend)
		ensure
			transitions_added: transitions.count = old transitions.count + a_transitions.count
		end

feature -- Basic operations

	try_write
			-- Try to write analysis results.
		deferred
		end

	write
			-- Write analysis results.
		deferred
		end

end
