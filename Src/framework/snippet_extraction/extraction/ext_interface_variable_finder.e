note
	description: "Iterator to decide which variables will be used as interface variables for further snippet extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_INTERFACE_VARIABLE_FINDER

inherit
	EXT_SHARED_LOGGER

	EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE
		redefine
			process_elseif_as,
			process_if_as,
			process_inspect_as,
			process_loop_as
		end

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
		do
				-- Reset variable usage tracking state.
			reset

				-- Set up callbacks to track regular variable usage, except in control flow statement expressions.
			set_is_mode_disjoint (True)
			set_on_access_identifier (agent callback_use_pure)
			set_on_access_identifier_with_feature_call (agent callback_use_feat)

				-- Set up callback iterator to track variable usage in control flow statement expressions.
			create expr_variable_usage_finder
			expr_variable_usage_finder.set_is_mode_disjoint (True)
			expr_variable_usage_finder.set_on_access_identifier (agent callback_use_pure_in_cf_stmt)
			expr_variable_usage_finder.set_on_access_identifier_with_feature_call (agent callback_use_feat_in_cf_stmt)
		ensure
			attached nesting_stack
			attached partial_use_order
			attached expr_variable_usage_finder
		end

feature -- Access

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

	is_logging_active: BOOLEAN
		assign set_logging_active
			-- Should logging commands be executed?

	set_logging_active (a_active: BOOLEAN)
			-- Set `is_logging_active' to `a_active'.
		require
			a_active_attached: attached a_active
		do
			is_logging_active := a_active
		end

	is_mode_restricted_to_use_pure: BOOLEAN = False
			-- Record pure variable usage only and don't consider feature calls?

	is_mode_restricted_to_c_use_pure: BOOLEAN = True
			-- Record pure variable usage in control flow statement expressions only and don't consider feature calls?

	reset
			-- Reset variable usage tracking state from last run.
		do
				-- Create nesting stack and inital scope.
			create {LINKED_STACK [TUPLE [use_pure, use_feat: like last_use; c_use_pure, c_use_feat: like last_c_use]]} nesting_stack.make

				-- Create global book-keeping data structures.
			create partial_use_order.make (10)
			total_variable_usage := new_variable_usage_tuple
		ensure
			attached nesting_stack
			attached partial_use_order
			attached total_variable_usage
		end

	last_interface_variables: HASH_TABLE [TYPE_A, STRING]
			-- Set of interface variables found according to AST iteration and that
			-- are valid mentioned in `candidate_interface_variables'.
		local
			l_interface_variable_type: TYPE_A
		do
			check attached nesting_stack end
			check nesting_stack.is_empty end

			create Result.make (5)
			Result.compare_objects

				-- Selection criteria configured?
			if not variable_context.target_variables.is_empty and not variable_context.candidate_interface_variables.is_empty then

					-- Filter variables that are either not valid or not in the candidate list.
				across partial_use_order as l_order loop
					if last_c_use.has (l_order.key) and variable_context.candidate_interface_variables.has (l_order.key) then
						l_interface_variable_type := variable_context.candidate_interface_variables.at (l_order.key)

							-- Check if interface and target variable are in partial use relation.
						if across variable_context.target_variables as l_target some l_order.item.has (l_target.key) end then
							Result.force (l_interface_variable_type, l_order.key)
						end
					end
				end -- across
			end -- if

				-- Log partial use order.
			log_partial_use_order
		end

	last_use: LINKED_SET [STRING]
			-- List of all recorded 'use' information through last AST iteration.	
		do
			Result := calculate_effective_use (total_variable_usage.use_pure, total_variable_usage.use_feat)
		end

	last_c_use: LINKED_SET [STRING]
			-- List of all recorded 'c-use' information through AST last iteration.	
		do
			Result := calculate_effective_c_use (total_variable_usage.c_use_pure, total_variable_usage.c_use_feat)
		end

feature {NONE} -- Helpers

	new_variable_usage_tuple: TUPLE [use_pure, use_feat: like last_use; c_use_pure, c_use_feat: like last_c_use]
			-- Create a tuple initialized with empty lists for variable usage tracking.
		local
			l_use_pure, l_use_feat: like last_use
			l_c_use_pure, l_c_use_feat: like last_c_use
		do
			create l_use_pure.make
			l_use_pure.compare_objects

			create l_use_feat.make
			l_use_feat.compare_objects

			create l_c_use_pure.make
			l_c_use_pure.compare_objects

			create l_c_use_feat.make
			l_c_use_feat.compare_objects

			Result := [l_use_pure, l_use_feat, l_c_use_pure, l_c_use_feat]
		end

	calculate_effective_use (a_use_pure, a_use_feat: like last_use): like last_use
			-- Calculate effective use set depending on `is_mode_restricted_to_use_pure'.
		do
			create Result.make

			Result.compare_objects
			Result.merge (a_use_pure)

			if is_mode_restricted_to_use_pure then
				Result.subtract (a_use_feat)
			else
				Result.merge (a_use_feat)
			end
		end

	calculate_effective_c_use (a_c_use_pure, a_c_use_feat: like last_c_use): like last_c_use
			-- Calculate effective use set depending on `is_mode_restricted_to_c_use_pure'.
		do
			create Result.make

			Result.compare_objects
			Result.merge (a_c_use_pure)

			if is_mode_restricted_to_c_use_pure then
				Result.subtract (a_c_use_feat)
			else
				Result.merge (a_c_use_feat)
			end
		end

	open_scope
			-- Open new scope for local analysis due to nesting.
		do
			log_scope_opening

				-- Push new scope on top of stack.
			nesting_stack.force (new_variable_usage_tuple)
		end

	close_scope
			-- Close actual scope, evaluate and propagate results.	
		local
			l_closing_scope: like nesting_stack.item
			l_effective_use: like last_use
			l_effective_c_use: like last_c_use
		do
			log_scope_closing

				-- Pop scope from top of stack.
			l_closing_scope := nesting_stack.item
			nesting_stack.remove

				-- Calculate effective c-use set depending on `is_mode_restricted_to_c_use_pure'.
			l_effective_c_use := calculate_effective_c_use (l_closing_scope.c_use_pure, l_closing_scope.c_use_feat)

				-- Calculate effective use set depending on `is_mode_restricted_to_use_pure'.
			l_effective_use := calculate_effective_use (l_closing_scope.use_pure, l_closing_scope.use_feat)

				-- Update partial use order by relating `l_effective_c_use' to `l_effective_use':
				-- Each c-use in the actual scope might is followed at least once in a deeper nesting
				-- level by a use of the same variabe.
			across l_effective_c_use as l_c_use loop
				if partial_use_order.has (l_c_use.item) then
					partial_use_order.item (l_c_use.item).merge (l_effective_use)
				else
					partial_use_order.extend (l_effective_use, l_c_use.item)
				end
			end

				-- Progagating `use' information to upper level to resolve transitivity.
			if not nesting_stack.is_empty then
				nesting_stack.item.use_pure.merge (l_closing_scope.use_pure)
				nesting_stack.item.use_feat.merge (l_closing_scope.use_feat)
			end
		end

feature {NONE} -- Implementation

	nesting_stack: STACK [TUPLE [use_pure, use_feat: like last_use; c_use_pure, c_use_feat: like last_c_use]]
		-- Stack used for evaluation in different scopes that keeps track of variable usage.

	partial_use_order: HASH_TABLE [LINKED_SET [STRING], STRING]
		-- Partial order indicating that a variable is used it least once before another.

	total_variable_usage: like new_variable_usage_tuple
		-- List of all recorded usage information through AST iteration.
		-- This information is important to rule out false-positives at the end of processing.

feature {NONE} -- Callbacks

	callback_use_pure (a_as: ACCESS_AS)
			-- Callback triggered when an identifier is accessed outside control flow statement expressions.
		do
			if not nesting_stack.is_empty then
				nesting_stack.item.use_pure.force (a_as.access_name_8)
			end
			total_variable_usage.use_pure.force (a_as.access_name_8)

			log_on_access_identifier (a_as, "use-pure")
		end

	callback_use_feat (a_as: NESTED_AS)
			-- Callback triggered when an identifier with a feature call is accessed outside control flow statement expressions.		
		do
			if not nesting_stack.is_empty then
				nesting_stack.item.use_feat.force (a_as.target.access_name_8)
			end
			total_variable_usage.use_feat.force (a_as.target.access_name_8)

			log_on_access_identifier_with_feature_call (a_as, "use-feat")
		end

	callback_use_pure_in_cf_stmt (a_as: ACCESS_AS)
			-- Callback triggered when an identifier is accessed in control flow statement expressions.	
			-- See `expr_variable_usage_finder'.
		do
			if not nesting_stack.is_empty then
				nesting_stack.item.c_use_pure.force (a_as.access_name_8)
			end
			total_variable_usage.c_use_pure.force (a_as.access_name_8)

			log_on_access_identifier (a_as, "c-use-pure")
		end

	callback_use_feat_in_cf_stmt (a_as: NESTED_AS)
			-- Callback triggered when an identifier with a feature call is accessed in control flow statement expressions.
			-- See `expr_variable_usage_finder'.
		do
			if not nesting_stack.is_empty then
				nesting_stack.item.c_use_feat.force (a_as.target.access_name_8)
			end
			total_variable_usage.c_use_feat.force (a_as.target.access_name_8)

			log_on_access_identifier_with_feature_call (a_as, "c-use-feat")
		end

feature {NONE} -- Control Flow Structures

	expr_variable_usage_finder: EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE
		-- Callback iterator to track variable usage in control flow statement expressions.	

	process_if_as (l_as: IF_AS)
			-- Enable interface dedicated variable tracking for `l_as.condition' expression of if control flow statement.
			-- Beside that evaluations, the iteration conforms to the {AST_ITERATOR} but might open a new scope
			-- for tracking due to nesting level of statements.
		do
			open_scope

			l_as.condition.process (expr_variable_usage_finder)
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)

			close_scope
		end

	process_elseif_as (l_as: ELSIF_AS)
			-- Enable interface dedicated variable tracking for `l_as.expr' of elseif control flow statement.
			-- Beside that evaluations, the iteration conforms to the {AST_ITERATOR} but might open a new scope
			-- for tracking due to nesting level of statements.
		do
			open_scope

			l_as.expr.process (expr_variable_usage_finder)
			safe_process (l_as.compound)

			close_scope
		end

	process_loop_as (l_as: LOOP_AS)
			-- Enable interface dedicated variable tracking for `l_as.stop' expression of loop control flow statement.
			-- Beside that evaluations, the iteration conforms to the {AST_ITERATOR} but might open a new scope
			-- for tracking due to nesting level of statements.
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.invariant_part)

			open_scope
			if attached l_as.stop then
				l_as.stop.process (expr_variable_usage_finder)
			end
			safe_process (l_as.compound)
			close_scope

			safe_process (l_as.variant_part)
		end

	process_inspect_as (l_as: INSPECT_AS)
			-- Enable interface dedicated variable tracking for `l_as.switch' expression of inspect control flow statement.
			-- Beside that evaluations, the iteration conforms to the {AST_ITERATOR} but might open a new scope
			-- for tracking due to nesting level of statements.
		do
			open_scope

			l_as.switch.process (expr_variable_usage_finder)
			safe_process (l_as.case_list)
			safe_process (l_as.else_part)

			close_scope
		end

feature {NONE} -- Debug

	log_scope_opening
			-- Logging message for opening a scope.
		do
			if is_logging_active then
				log.put_string (once "[SCOPE OPENING]%N")
			end
		end

	log_scope_closing
			-- Logging message for closing a scope.
		do
			if is_logging_active then
				log.put_string (once "[SCOPE CLOSING]%N")
			end
		end

	log_on_access_identifier (a_as: ACCESS_AS; a_mode: STRING)
			-- Logging message for callback on access identifier.
		require
			a_mode_valid: a_mode ~ "use-pure" or a_mode ~ "c-use-pure"
		do
			if is_logging_active then
				log.put_string ("[")
				if a_mode ~ "use-pure" then
					log.put_string ("  ")
					log.put_string (a_mode)
				else
					log.put_string (a_mode)
				end
				log.put_string (" @ ")
				log.put_string (a_as.path.as_string)
				log.put_string ("]")

				log.put_string ("        ")
				log.put_string (a_as.access_name_8)
				log.put_string ("%N")
			end
		end

	log_on_access_identifier_with_feature_call (a_as: NESTED_AS; a_mode: STRING)
			-- Logging message for callback on feature invocation.
		require
			a_mode_valid: a_mode ~ "use-feat" or a_mode ~ "c-use-feat"
		do
			if is_logging_active then
				log.put_string ("[")
				if a_mode ~ "use-feat" then
					log.put_string ("  ")
					log.put_string (a_mode)
				else
					log.put_string (a_mode)
				end
				log.put_string (" @ ")
				log.put_string (a_as.path.as_string)
				log.put_string ("]")

				log.put_string ("        ")
				log.put_string (a_as.target.access_name_8)
				log.put_string ("%N")
			end
		end

	log_partial_use_order
			-- Logging string representation of partial use relation.
		do
			if is_logging_active then
				log.put_string ("%N")
				log.put_string ("Partial Use Order%N")
				log.put_string ("-----------------%N")

				across partial_use_order as l_order loop
					log.put_string ("> ")
					log.put_string (l_order.key)
					log.put_string (": ")

					across l_order.item as l_order_use loop
						log.put_string (l_order_use.item)
						log.put_string (", ")
					end

					log.put_string ("%N")
				end

				log.put_string ("%N")
			end
		end

end
