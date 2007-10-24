indexing
	description: "Base class of all mathematical objects"
	version: "$Id$"
	author: "Tobias Widmer and Bernd Schoeller"
	copyright: "see License.txt"

deferred class
	MML_ANY

inherit
	MML_COMPARISON

feature{MML_COMPARISON} -- Comparison

	 equals, infix "|=|" (other: MML_ANY): BOOLEAN is
			-- Is `other' mathematically equivalent ?
		require
			other_not_void : other /= Void
		deferred
		ensure
			equal_models_have_same_value: Result = equal_value (Current, other)
		end

end -- class MML_ANY
