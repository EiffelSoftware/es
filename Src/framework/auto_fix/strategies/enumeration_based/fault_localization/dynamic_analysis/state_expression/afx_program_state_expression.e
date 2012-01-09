note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_EXPRESSION

inherit

	SHARED_WORKBENCH
		undefine
			is_equal
		end

	EPA_AST_EXPRESSION
		rename
			make_with_text as old_make_with_text,
			make_with_feature as old_make_with_feature
		end

create
	make_with_text, make_with_feature

feature -- Initialization

	make_with_text (a_class: like class_; a_feature: like feature_; a_text: like text; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_text (a_class, a_feature, a_text, a_written_class)
			set_breakpoint_slot (a_bp_index)
		end

	make_with_feature (a_class: like class_; a_feature: like feature_; a_expression: like ast; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_feature (a_class, a_feature, a_expression, a_written_class)
			set_breakpoint_slot (a_bp_index)
		end

feature -- Access

	breakpoint_slot: INTEGER
			-- Index of the breakpoint slot, to which the state expression is associated.

	sub_expression_collector: AFX_SUB_EXPRESSION_COLLECTOR
			-- Shared sub-expression collector.
		once
			create Result
		end

	immediate_target_objects: EPA_HASH_SET [EPA_EXPRESSION]
			-- Immediate target objects of the current expression.
			-- Such immediate target objects could be used to change the value of the current expression.
		do
			if immediate_target_objects_cache = Void then
				target_object_detector.detect_target_objects_for_fixing (Current)
				immediate_target_objects_cache := target_object_detector.immediate_target_objects
			end
			Result := immediate_target_objects_cache
		ensure
			result_attached: Result /= Void
		end

	target_object_detector: AFX_TARGET_OBJECT_DETECTOR
			-- Shared target object detector.
		once
			create Result
		end

	related_boolean_expressions: DS_LINKED_LIST [AFX_PROGRAM_STATE_EXPRESSION]
			-- Boolean expressions that are related with the `Current' expression.
			-- The list is ready after a call to `compute_related_boolean_expressions'.
			-- Refer to `compute_related_boolean_expressions' for an explanation about what's in the set.
		do
			if related_boolean_expressions_cache = Void then
				create related_boolean_expressions_cache.make
			end
			Result := related_boolean_expressions_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_bp_spot_specific: BOOLEAN
			-- Is this state expression specific to a breakpoint slot?
			-- Yes, if `breakpoint_slot' is greater than 0;
			-- No, otherwise.
		do
			Result := (breakpoint_slot > 0)
		ensure
			definition: result = (breakpoint_slot > 0)
		end

feature -- Status set

	set_breakpoint_slot (a_slot: INTEGER)
			-- Set the breakpoint slot of `ast'.
		require
			valid_slot: a_slot >= 0
		do
			breakpoint_slot := a_slot
		end

	immediate_target_objects_cache: like immediate_target_objects
			-- Cache for `immediate_target_objects'.

feature{NONE} -- Cache

	related_boolean_expressions_cache: like related_boolean_expressions
			-- Cache for `related_boolean_expressions'.

end
