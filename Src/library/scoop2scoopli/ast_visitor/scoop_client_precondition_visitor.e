indexing
	description: "Summary description for {SCOOP_CLIENT_PRECONDITION_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_PRECONDITION_VISITOR

inherit
	SCOOP_CLIENT_ASSERTION_EXPR_VISITOR
		redefine
			make
		end

create
	make

feature -- Initialisation

	make (an_argument_object: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Initialisation with list of the separate internal argument.
		do
			Precursor (an_argument_object)

			assertions := create {SCOOP_CLIENT_PRECONDITIONS}.make
		end

feature -- Access

	process_precondition (l_as: REQUIRE_AS) is
		do
			if l_as /= Void then
				last_index := l_as.require_keyword_index
			end
			safe_process (l_as)
		end

feature {NONE} -- Parent implementation

	evaluate_assertion  is
			-- evaluates the processed tagged_as flags
		do
			if current_assertion.is_containing_separate_calls then
				-- assertion contains separate calls.
				current_preconditions.wait_conditions.extend (current_assertion)
			else
				-- assertion contains no separate call
				current_preconditions.non_separate_preconditions.extend (current_assertion)
			end
		end

	evaluate_expression is
			-- evaluates the processed expr flags
			-- needed when processing binary expression evaluation and lists.
		do
			-- evaluate is_separate_assertion flag
			if is_expr_separate_assertion then
				current_assertion.set_is_containing_separate_calls (is_expr_separate_assertion)
			end
		end

	evaluate_external_assertion_object (an_assertion_object: SCOOP_CLIENT_ASSERTIONS) is
			-- Evaluates the created assertion object after running through the internal parameters.
		local
			i: INTEGER
			l_precondition_object: SCOOP_CLIENT_PRECONDITIONS
			l_assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT
		do
			l_precondition_object ?= an_assertion_object
			if l_precondition_object /= Void then
				-- evaluate the result object of the visited calls of tuples, binary expressions
				-- and internal parameters

				if l_precondition_object.wait_conditions.count > 0 then
					-- analysed expression contains separate arguments
					current_assertion.set_is_containing_separate_calls (true)

				elseif l_precondition_object.non_separate_preconditions.count > 0 then
					-- analysed expression contains no separate arguments
					-- do nothing
				end

				debug ("SCOOP_CLIENT_ASSERTIONS_EXT")

					if l_precondition_object.wait_conditions.count > 0 then

						from
							i := 1
						until
							i > l_precondition_object.wait_conditions.count
						loop
								-- copy all calls
							l_assertion_object := l_precondition_object.wait_conditions.i_th (i)
							current_assertion.calls.append (l_assertion_object.calls)
							i := i + 1
						end
					end

					if l_precondition_object.non_separate_preconditions.count > 0 then

						from
							i := 1
						until
							i > l_precondition_object.non_separate_preconditions.count
						loop
								-- copy all calls
							l_assertion_object := l_precondition_object.non_separate_preconditions.i_th (i)
							current_assertion.calls.append (l_assertion_object.calls)
							i := i + 1
						end
					end

				end
			end
		end

	create_same_visitor: SCOOP_CLIENT_ASSERTION_EXPR_VISITOR is
			-- returns a new created visitor of the same type
		do
			Result := create {SCOOP_CLIENT_PRECONDITION_VISITOR}.make (arguments)
		end

feature {NONE} -- Implementation

	current_preconditions: SCOOP_CLIENT_PRECONDITIONS is
			-- container for new generated precondition lists.
		do
			Result ?= assertions
		end


end
