note
	description: "Find expressions that are similar to a given expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SIMILAR_EXPRESSION_FINDER

inherit
	EPA_EXPRESSION_FINDER

	REFACTORING_HELPER

	AST_ITERATOR

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

create
	make

feature{NONE} -- Initialization

	make (a_expression: like expression; a_context_class: like context_class)
			-- Initialze Current.
		do
			expression := a_expression
			context_class := a_context_class
		end

feature -- Access

	expression: EPA_EXPRESSION
			-- Expression whose similar expressions are to be found

	context_class: CLASS_C
			-- Class in which expressions similar to `expression' are to be found

feature --  Basic operations

	search (a_expression_repository: EPA_HASH_SET [EPA_EXPRESSION])
			-- <Precursor>
		local
			l_features: LIST [FEATURE_I]
		do
				-- Create empty `last_found_expressions'.
			create last_found_expressions.make (100)
			last_found_expressions.set_equality_tester (expression_equality_tester)

				-- Go through the ASTs of all features in `context_class',
				-- searching for similar expressions.
			from
				l_features := features_in_class (context_class, Void)
				l_features.start
			until
				l_features.after
			loop
				l_features.item_for_iteration.e_feature.ast.process (Current)
				l_features.forth
			end
		end

end
