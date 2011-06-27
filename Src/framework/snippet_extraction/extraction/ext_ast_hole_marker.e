note
	description: "Iterator to mark information relevant AST nodes for further snippet extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_HOLE_MARKER

inherit
	AST_ITERATOR
		redefine
			process_assign_as,
			process_creation_as,
			process_elseif_as,
			process_if_as,
			process_instr_call_as,
			process_loop_as,
			process_object_test_as,
			process_parameter_list_as
		end

	EPA_UTILITY

	EXT_ANN_UTILITY

	EXT_AST_UTILITY

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
			create annotation_factory.make
		end

feature -- Configuration

	variable_context: EXT_VARIABLE_CONTEXT
		assign set_variable_context
			-- Contextual information about relevant variables.

	set_variable_context (a_context: EXT_VARIABLE_CONTEXT)
			-- Sets `variable_context' to `a_context'	
		require
			attached a_context
		do
			variable_context := a_context
		end

	annotation_context: EXT_ANNOTATION_CONTEXT
		assign set_annotation_context
			-- Contextual information about relevant variables.

	set_annotation_context (a_context: EXT_ANNOTATION_CONTEXT)
			-- Sets `annotation_context' to `a_context'	
		require
			attached a_context
		do
			annotation_context := a_context
		end

	annotation_factory: EXT_ANNOTATION_FACTORY
			-- Annotation factory to create new typed annotation instances.

feature {NONE} -- Implementation

	process_assign_as (l_as: ASSIGN_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if variable_context.is_variable_of_interest (l_as.target.access_name_8) then
					-- Retain target, scan and annotate source expression.
				processing_expr (l_as.source)
			elseif is_ast_eiffel_using_variable_of_interest (l_as.source, variable_context) then
					-- make hole: only source expression uses variable of interest
				annotation_context.add_annotation (l_as.path, create_annotation_hole (l_as))
			end
		end

	process_creation_as (l_as: CREATION_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			processing_call (l_as, l_as.target, l_as.call)
		end

	process_elseif_as (l_as: ELSIF_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
				-- Annotate the expression, continue parsing with the body.
			processing_expr (l_as.expr)
			safe_process (l_as.compound)
		end

	process_if_as (l_as: IF_AS)
		do
			processing_expr (l_as.condition)
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			-- add NESTED_EXPR_AS
			-- add CREATION_EXPR_AS
			if attached {NESTED_AS} l_as.call as l_call_as then
				if is_not_chaining_nested_as (l_call_as) then
					processing_call (l_as, l_call_as.target, l_call_as.message)
				else
					annotation_context.add_annotation (l_as.path, create_annotation_hole (l_as))
				end
			elseif attached {ACCESS_AS} l_as.call as l_call_as then
				processing_call (l_as, l_call_as, Void)
			else
				Precursor (l_as)
			end
		end

	process_loop_as (l_as: LOOP_AS)
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.invariant_part)

			if attached l_as.stop then
				processing_expr (l_as.stop)
			end

			safe_process (l_as.compound)
			safe_process (l_as.variant_part)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
--			Precursor (l_as)
			fixme ("Simple naive implementation of object test pruning.")
			if attached l_as.expression then

				if not is_ast_eiffel_using_variable_of_interest (l_as.expression, variable_context) then
						-- make hole: object test not refering to target variable.
					annotation_context.add_annotation (l_as.path, create_annotation_hole (l_as))
				elseif not is_expr_as_clean (l_as.expression, variable_context) then
						-- make hole: expression to complex
					annotation_context.add_annotation (l_as.expression.path, create_annotation_hole (l_as.expression))
				end
			end
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
		do
			if attached {EIFFEL_LIST [EXPR_AS]} l_as.parameters then
				across l_as.parameters as l_list loop
					processing_expr (l_list.item)
				end
			end
		end

feature {NONE} -- Implementation (Helper)

	processing_call (l_as: AST_EIFFEL; l_target_as: ACCESS_AS; l_call_as: CALL_AS)
		require else
			l_as_path_not_void: attached l_as.path
			l_target_as_not_void: attached l_target_as
		do
				-- Check because PRECURSOR_AS does not have an access name.
			if attached l_target_as.access_name_8 and then variable_context.is_variable_of_interest (l_target_as.access_name_8) then
				if attached l_call_as then
					l_call_as.process (Current)
				end
			else
				if attached l_call_as then
						-- check call arguments
					if is_ast_eiffel_using_variable_of_interest (l_call_as, variable_context) then
							-- make hole: variables of interest used in call
						annotation_context.add_annotation (l_as.path, create_annotation_hole (l_as))
					end

					-- class feature call
				elseif attached {ACCESS_FEAT_AS} l_target_as as l_access_feat_as then
					if attached l_access_feat_as.internal_parameters as l_internal_parameter then
							-- make hole: variables of interest used in call
						annotation_context.add_annotation (l_as.path, create_annotation_hole (l_as))
					end
				end
			end
		end

	processing_class_feature_call (l_as: AST_EIFFEL; l_target_as: ACCESS_AS)
		require else
			l_as_path_not_void: attached l_as.path
			l_target_as_not_void: attached l_target_as
		do
			if variable_context.is_variable_of_interest (l_target_as.access_name_8) then
				l_target_as.process (Current)
			else
					-- make hole: variables of interest used in call
				fixme ("Processing argument list.")
				annotation_context.add_annotation (l_as.path, create_annotation_hole (l_as))
			end
		end

	processing_expr (l_as: EXPR_AS)
		require
			l_as_not_void: attached l_as
			l_as_path_not_void: attached l_as.path
		do
			if attached {OBJECT_TEST_AS} l_as as l_object_test_as then
				process_object_test_as (l_object_test_as)
			else
				if not is_expr_as_clean (l_as, variable_context) then
						-- make hole: expression to complex to keep unchanged.
					annotation_context.add_annotation (l_as.path, create_annotation_hole (l_as))
				end
			end
		end

feature {NONE} -- Annotation Handling

	create_annotation_hole (a_ast: AST_EIFFEL): EXT_ANNOTATION
			-- Create a new `{EXT_ANN_HOLE}' with metadata.
		do
			Result := annotation_factory.new_ann_hole (collect_mentions_set (a_ast, variable_context), Void)
		end

end
