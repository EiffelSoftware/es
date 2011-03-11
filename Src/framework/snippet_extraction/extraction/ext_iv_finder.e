note
	description: "Iterator to decide which variables will be used as interface variables for further snippet extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_IV_FINDER

inherit
	AST_ITERATOR
		redefine
			process_expr_call_as,
			process_if_as,
			process_inspect_as,
			process_loop_as
		end

	REFACTORING_HELPER

create
	make_from_candidates

feature {NONE} -- Initialization

	make_from_candidates (a_candidate_interface_variables: HASH_TABLE [TYPE_A, STRING])
		require
			a_candidate_iv_not_void: a_candidate_interface_variables /= Void
		do
			candidate_interface_variables := a_candidate_interface_variables
			create iv_pos_set.make
			create iv_neg_set.make
			recording := False
		ensure
			candidate_iv_not_void: candidate_interface_variables /= Void
			recording_is_false: recording = False
		end

feature -- Access

	iv_neg_set: LINKED_SET [STRING]

	iv_pos_set: like iv_neg_set

	last_interface_variables: HASH_TABLE [TYPE_A, STRING]
			-- Set of interface variables found according to AST iteration and that
			-- are mentioned in `candidate_interface_variables'.
		local
			l_iv_set: like iv_neg_set
			l_iv_type: TYPE_A
		do
				-- Calculating set difference: `iv_pos_set' minus `iv_neg_set'.
			create l_iv_set.make
			l_iv_set.merge (iv_pos_set)
			l_iv_set.subtract (iv_neg_set)

				-- Include all variables are mentioned in `candidate_interface_variables'.
			create Result.make (l_iv_set.count)
			across l_iv_set as l_iv
			loop
				l_iv_type := candidate_interface_variables.at (l_iv.item)
				if attached l_iv_type then Result.force (l_iv_type, l_iv.item) end
			end
		end

feature {NONE} -- Recording

	recording: BOOLEAN

	is_recording: BOOLEAN
		require
			recording /= Void
		do
			Result := recording
		end

	enable_recording
		require
			recording = False
		do
			recording := True
		end

	disable_recording
		require
			recording = True
		do
			recording := False
		end

feature {NONE} -- Implementation

	candidate_interface_variables: HASH_TABLE [TYPE_A, STRING]
			-- Set of variables that could potentially be interface variables. This set normally consists the local variables
			-- and formal arguments of a feature.

	process_expr_call_as (l_as: EXPR_CALL_AS)
			-- Book keeping if a variable is accessed a with and without a feature call. That information will be used
			-- to calcuate the `last_interface_variables'.
		do
			if is_recording then
					-- Record varible access without feature call in the positive set for interface variable determination.
				if attached {ACCESS_AS} l_as.call as l_iv_as then
					iv_pos_set.force (l_iv_as.access_name_8)
					fixme ("Debug code to remove")
--					io.put_string ("*[pos]* ")
--					io.put_string (l_iv_as.access_name_8)
--					io.put_new_line
				end

					-- Record variable access with feature call in the negative set for interface variable determination.
				if attached {NESTED_AS} l_as.call as l_nested_as and then attached l_nested_as.target as l_iv_as then
					iv_neg_set.force (l_iv_as.access_name_8)
					fixme ("Debug code to remove")
--					io.put_string ("*[neg]* ")
--					io.put_string (l_iv_as.access_name_8)
--					io.put_new_line
				end
			else
					-- Continue AST iteration otherwise.
				l_as.call.process (Current)
			end
		end

	process_if_as (l_as: IF_AS)
			-- Enable interface variable tracking for `l_as.condition' expression of if control flow statement.
			-- Beside that evaluations, the iteration conforms to the {AST_ITERATOR}.
		do
				-- Enable interface variable tracking.
			enable_recording
			l_as.condition.process (Current)
			disable_recording

			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_loop_as (l_as: LOOP_AS)
			-- Enable interface variable tracking for `l_as.stop' expression of loop control flow statement.
			-- Beside that evaluations, the iteration conforms to the {AST_ITERATOR}.
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.invariant_part)

				-- Enable interface variable tracking.
			enable_recording
			safe_process (l_as.stop)
			disable_recording

			safe_process (l_as.compound)
			safe_process (l_as.variant_part)
		end

	process_inspect_as (l_as: INSPECT_AS)
			-- Enable interface variable tracking for `l_as.switch' expression of inspect control flow statement.
			-- Beside that evaluations, the iteration conforms to the {AST_ITERATOR}.
		do
				-- Enable interface variable tracking.			
			enable_recording
			l_as.switch.process (Current)
			disable_recording

			safe_process (l_as.case_list)
			safe_process (l_as.else_part)
		end

end
