note
	description: "Summary description for {EPA_BASIC_BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_BASIC_BLOCK

inherit
	HASHABLE

feature -- Access

	id: INTEGER
			-- Basic block identifier

	class_: CLASS_C
			-- Class to which current basic block is associated

	written_class: CLASS_C
			-- Class in which current basic block is written

	feature_: FEATURE_I
			-- Feature to which current basic block belongs

	hash_code: INTEGER
			-- Hash code value
		do
			Result := hash_code_string.hash_code
		ensure then
			good_result: Result = hash_code_string.hash_code
		end

	asts: ARRAYED_LIST [AST_EIFFEL]
			-- List of ASTs inside current block
		deferred
		end

	predecessors: ARRAYED_LIST [EPA_BASIC_BLOCK]
			-- Predecessor blocks
		deferred
		end

	successors: ARRAYED_LIST [EPA_BASIC_BLOCK]
			-- Successor blocks
		deferred
		end

feature -- Setting

	set_id (a_id: INTEGER)
			-- Set `id' with `a_id'.
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

	set_class_ (a_class: like class_)
			-- Set `class_' with `a_class'.
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_written_class (a_class: like written_class)
			-- Set `written_class' with `a_class'.
		do
			written_class := a_class
		ensure
			written_classset: written_class = a_class
		end

	set_feature_ (a_feature: like feature_)
			-- Set `feature_' with `a_feature'.
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

feature -- Setting

	hash_code_string: STRING
			-- String representing the ID of current block
		do
			if attached {STRING} hash_code_string_internal as l_cache then
				Result := l_cache
			else
				hash_code_string_internal := id.out
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	hash_code_string_internal: detachable STRING
			-- Cache for `hash_code_string'

end
