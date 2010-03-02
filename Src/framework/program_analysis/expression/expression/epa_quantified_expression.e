note
	description: "Objects that represent quantified expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_QUANTIFIED_EXPRESSION

inherit
	EPA_EXPRESSION
		redefine
			is_quantified,
			text
		end

feature -- Access

	variables: HASH_TABLE [TYPE_A, STRING]
			-- Bounded variables and their types
			-- Key is the name of a bounded variable, value is the type of that variable
			-- Note: For the moment, only single bounded variable is supported.

	predicate: EPA_EXPRESSION
			-- Predicate of current quantification

	text: STRING
			-- Expression text of current item
			-- Note: The output may not in correct Eiffel syntax, so it cannot be directly used
			-- as an expression to evaluate (for example, in debugger).
			-- Current Eiffel syntax does not support some of the well-formed quantified expressions,
			-- for example, forall x. old has(x) implies has (x). 2.3.2010 Jasonw.

feature -- Status report

	is_quantified: BOOLEAN = True
			-- Is Current expression quantified, either universal or existential?

	is_variables_valid: BOOLEAN
			-- Is variables valid?
		local
			l_feature: detachable like feature_
		do
			fixme ("Only single bounded variable is supported for the moment. 2.3.2010 Jasonw")
			Result := variables.count = 1

			if Result then
					-- Check there is no feature with the same feature name as bounded variables.
				l_feature := feature_
				from
					variables.start
				until
					variables.after or not Result
				loop
					Result := attached context_class.feature_named (variables.key_for_iteration)
					if Result and then l_feature /= Void then
						to_implement ("Check if there is no local variable with the same name as the variable. 2.3.2010 Jasonw")
					end
					variables.forth
				end
			end
		end

feature{NONE} -- Implementation

	quantifier_name: STRING
			-- Name of the quantifier
		deferred
		end

	text_internal: STRING
			-- Text of current expression
		local
			l_cursor: CURSOR
			l_variables: like variables
			i, c: INTEGER
		do
			create Result.make (64)
			Result.append (quantifier_name)
			Result.append_character (' ')

			l_variables := variables
			l_cursor := l_variables.cursor
			from
				i := 1
				c := l_variables.count
				l_variables.start
			until
				l_variables.after
			loop
				Result.append (l_variables.key_for_iteration)
				Result.append (once ": ")
				Result.append (l_variables.item_for_iteration.name)
				if i < c then
					Result.append (once ", ")
				end
				i := i + 1
				l_variables.forth
			end
			l_variables.go_to (l_cursor)
			Result.append (once " :: ")
			Result.append (predicate.text)
		end

invariant
	predicate_is_valid: predicate.is_predicate and not predicate.is_quantified

end
