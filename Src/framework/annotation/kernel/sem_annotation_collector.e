note
	description: "Class to collect annotations from AST nodes"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_ANNOTATION_COLLECTOR

feature -- Access

	last_annotations: HASH_TABLE [ANN_ANNOTATION, INTEGER]
			-- Annotations collected from last `collect'
			-- Keys are breakpoint slots, values are annotations
			-- associated with those breakpoint slots.

	context_class: CLASS_C
			-- Context class from which the collection is performed

	written_class: CLASS_C
			-- The written class of the ast for which the collection is performed

	feature_: FEATURE_I
			-- The feature where the ast is from

feature -- Basic operations

	collect (a_ast: AST_EIFFEL)
			-- Collect annotations from `a_ast',
			-- make results available in `last_annotations'.
		deferred
		end

feature -- Setting

	set_context_class (a_class: like context_class)
			-- Set `context_class' with `a_class'.
		do
			context_class := a_class
		ensure
			context_class_set: context_class = a_class
		end

	set_written_class (a_class: like written_class)
			-- Set `written_class' with `a_class'.
		do
			written_class := a_class
		ensure
			written_class_set: written_class = a_class
		end

	set_feature (a_feat: like feature_)
			-- Set `feature_' with `a_feat'.
		do
			feature_ := a_feat
		ensure
			feature_set: feature_ = a_feat
		end

feature{NONE} -- Implementation

	initialize_breakpoints (a_ast: AST_EIFFEL; a_context_class: detachable CLASS_C)
			-- Initialize breakpoints to `a_ast' in the context of `a_context_class'.
			-- `a_context_class' (if attached) is used to handle inherited breakpoints.
			-- If `a_context_class' is detached, the breakpoint will start from 1.
		local
			l_bp_initializer: ETR_BP_SLOT_INITIALIZER
		do
			create l_bp_initializer
			if a_context_class = Void then
				l_bp_initializer.init_from (a_ast)
			else
				l_bp_initializer.init_with_context (a_ast, a_context_class)
			end
		end

end
