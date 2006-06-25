class
	EIFFEL_PARSER_ERRORS

feature -- Keywords

	an_indexing_value: STRING is "an indexing value"
	an_indexing_name: STRING is "an indexing name"
	create_expression: STRING is "create expression"
			-- create expression

	create_index_expression: STRING is "`create' indexing expression"
			-- Create indexing clause expression

feature -- Keywords

	agent_keyword: STRING is "`agent' keyword"
			-- agent keyword

	alias_keyword: STRING is "`alias' keyword"
			-- alias keyword

	all_keyword: STRING is "`all' keyword"
			-- all keyword

	and_keyword: STRING is "`and' keyword"
			-- and keyword

	as_keyword: STRING is "`as' keyword"
			-- as keyword

	assign_keyword: STRING is "`assign' keyword"
			-- assign keyword

	bit_keyword: STRING is "`bit' keyword"
			-- bit keyword

	check_keyword: STRING is "`check' keyword"
			-- check  keyword

	class_keyword: STRING is "`class' keyword"
			-- class keyword

	convert_keyword: STRING is "`convert' keyword"
			-- convert keyword

	create_keyword: STRING is "`create' keyword"
			-- create keyword

	current_keyword: STRING is "`Current' keyword"
			-- Current keyword

	debug_keyword: STRING is "`debug' keyword"
			-- debug keyword

	deferred_keyword: STRING is "`deferred' keyword"
			-- deferred keyword

	do_keyword: STRING is "`do' keyword"
			-- do keyword

	else_keyword: STRING is "`else' keyword"
			-- else keyword

	elseif_keyword: STRING is "`elseif' keyword"
			-- elseif keyword

	end_keyword: STRING is "`end' keyword"
			-- end keyword

	ensure_keyword: STRING is "`ensure' keyword"
			-- ensure keyword

	expanded_keyword: STRING is "`expanded' keyword"
			-- exexpanded keyword

	export_keyword: STRING is "`export' keyword"
			-- export keyword

	external_keyword: STRING is "`external' keyword"
			-- external  keyword

	false_keyword: STRING is "`False' keyword"
			-- False keyword

	feature_keyword: STRING is "`feature' keyword"
			-- feature keyword

	from_keyword: STRING is "`from' keyword"
			-- from keyword

	frozen_keyword: STRING is "`frozen' keyword"
			-- frozen keyword

	if_keyword: STRING is "`if' keyword"
			-- if keyword

	implies_keyword: STRING is "`implies' keyword"
			-- implies keyword

	indexing_keyword: STRING is "`indexing' keyword"
			-- indexing  keyword

	infix_keyword: STRING is "`infix' keyword"
			-- infix keyword

	inherit_keyword: STRING is "`inherit' keyword"
			-- inherit keyword

	inspect_keyword: STRING is "`inspect' keyword"
			-- inspect keyword

	invariant_keyword: STRING is "`invariant' keyword"
			-- invariant keyword

	is_keyword: STRING is "`is' keyword"
			-- is keyword

	like_keyword: STRING is "`like' keyword"
			-- like keyword

	local_keyword: STRING is "`local' keyword"
			-- local keyword

	loop_keyword: STRING is "`loop' keyword"
			-- loop keyword

	not_keyword: STRING is "`not' keyword"
			-- not keyword

	obsolete_keyword: STRING is "`obsolete' keyword"
			-- obsolete keyword

	old_keyword: STRING is "`old' keyword"
			-- old keyword

	once_keyword: STRING is "`once' keyword"
			-- once keyword

	or_keyword: STRING is "`or' keyword"
			-- or keyword

	prefix_keyword: STRING is "`prefix' keyword"
			-- prefix  keyword

	precursor_keyword: STRING is "`Precursor' keyword"
			-- Precursor keyword

	pure_keyword: STRING is "`pure' keyword"
			-- pure keyword

	redefine_keyword: STRING is "`redefine' keyword"
			-- redefine keyword

	reference_keyword: STRING is "`reference' keyword"
			-- reference keyword

	rename_keyword: STRING is "`rename' keyword"
			-- `rename keyword

	require_keyword: STRING is "`require' keyword"
			-- require keyword

	rescue_keyword: STRING is "`rescue' keyword"
			-- rescue  keyword

	result_keyword: STRING is "`Result' keyword"
			-- Result keyword

	retry_keyword: STRING is "`retry' keyword"
			-- retry keyword

	separate_keyword: STRING is "`separate' keyword"
			-- separate keyword

	strip_keyword: STRING is "`strip' keyword"
			-- strip keyword

	then_keyword: STRING is "`then' keyword"
			-- then keyword

	true_keyword: STRING is "`True' keyword"
			-- True keyword

	undefine_keyword: STRING is "`undefine' keyword"
			-- undefine keyword

	until_keyword: STRING is "`until' keyword"
			-- undefine keyword

	variant_keyword: STRING is "`variant' keyword"
			-- variant keyword

	when_keyword: STRING is "`when' keyword"
			-- when keyword

	xor_keyword: STRING is "`xor' keyword"


feature -- Inspect Errors

	inspect_expression: STRING is "`inspect' expression"

	when_else_or_end_block: STRING is "`when' blocks, an `else' block or a matching `end' keyword"

feature -- Loop Errors

	from_block: STRING is "`from' block"

	invariant_block: STRING is "`invariant' block"

	variant_block: STRING is "`variant' block"

	until_expression: STRING is "`until' expression"

	loop_block: STRING is "`loop' block"

feature -- Symbols

	open_curley_symbol: STRING is "`{'"

	close_curley_symbol: STRING is "`}'"

	open_square_symbol: STRING is "`['"

	close_square_symbol: STRING is "`]'"

	open_paran_symbol: STRING is "`('"

	close_paran_symbol: STRING is "`)'"

	open_array_symbol: STRING is "`<<'"

	close_array_symbol: STRING is "`>>'"

	colon_symbol: STRING is "`:'"

	comma_symbol: STRING is "`,'"

	tilde_symbol: STRING is "`~'"

	bang_bang_symbol: STRING is "`!!'"

	bang_symbol: STRING is "`!'"

	free_operator_symbol: STRING is "free operator"

	plus_symbol: STRING is "`+'"

	minus_symbol: STRING is "`-'"

	star_symbol: STRING is "`*'"

	slash_symbol: STRING is "`/'"

	mod_symbol: STRING is "`\\'"

	div_symbol: STRING is "`//'"

	power_symbol: STRING is "`^'"

	dot_symbol: STRING is "`.'"

	dot_dot_symbol: STRING is "`..'"

	question_symbol: STRING is "`?'"

	ge_symbol: STRING is "`>='"

	gt_symbol: STRING is "`>'"

	le_symbol: STRING is "`<='"

	lt_symbol: STRING is "`<'"

	ne_symbol: STRING is "`/='"

	eq_symbol: STRING is "`='"

	assign_symbol: STRING is "`:='"

	reverse_assign_symbol: STRING is "`?='"

	address_symbol: STRING is "`$'"

feature -- Locations

	feature_declaration: STRING is "feature declaration"

	feature_name: STRING is "feature name"

	expression: STRING is "expression"

	convert_feature_declaration: STRING is "convert feature declaration"

	inherit_clause: STRING is "inheritance clause"

	formal_argument_declaration: STRING is "formal argument declaration"

	generic_contraint: STRING is "generic constraint"

	reverse_assignment: STRING is "`?=' reverse assignement"

	assignment: STRING is "`:=' assignment"

	typed_expression: STRING is "typed expression"

	identifier: STRING is "identifier"

	braced_class_name: STRING is "braced class name"


feature -- Expected Values

	obsolete_string: STRING is "obsolete description string - e.g. %"Use `other_feature' instead.%""
	an_infix_string: STRING is "an infix string - e.g. %"<%""
	a_prefix_string: STRING is "a prefix string - e.g. %"<%""
	an_alias_string: STRING is "an alias string - e.g. %"[]%", %"not%" or infix %"<%""
	an_expression: STRING is "an expression"
	an_identifier: STRING is "an identifier"
	a_static_expr_or_constant: STRING is "static expression or a constant"
	a_renaming_pair: STRING is "a renaming pair"
	a_convert_feature: STRING is "a convert feature declaration"
	a_indentifier: STRING is "a identifier"
	a_formal_generic: STRING is "a formal generic parameter"
	a_non_empty_string: STRING is "a non-empty string"
	a_delayed_actual: STRING is "a delayed actual parameter"
	an_assertion: STRING is "an assertion"
	a_routine_body_or_constant: STRING is "a routine body or a constant value"
	a_routine_body: STRING is "a routine body"

	a_formal_argument: STRING is "a formal argument declaration"
	colon_or_lparan_symbols: STRING is "`:' or `('"

	a_renamed_feature: STRING is "a renamed feature"

	a_generic_parameter: STRING is "a generic parameter"
	a_c_cpp_external: STRING is "a C/C++ external"
	a_c_cpp_alias_name: STRING is "a C/C++ external alias name"
	a_right_hand_expression: STRING is "a right-hand expression"
	a_left_hand_target: STRING is "a left-hand target"
	a_qualified_feature_call: STRING is "an exported qualifing feature name"
	a_qualified_static_feature_call: STRING is "an exported qualifing static feature name"
	a_creation_routine: STRING is "a class creation routine"

	a_static_expr_or_constant_list: STRING is "a single static expression or a constant a comma delimted list of expressions"

	a_local_or_attribute: STRING is "a local, argument or class attribute"
	a_local_or_attribute_or_bracket_expression: STRING is "a local, argument, class attribute or a bracketted expression"

	a_braced_class_name: STRING is "a braced class name - e.g. {A}"
	a_braced_static_call: STRING is "a braced static call - e.g. {A}.f"

	an_assertion_identifier: STRING is "an assertion identifier"

	a_manifest_string: STRING is "a manifest string"

feature -- Expected Values

	a_string: STRING is "a string"
	an_integer_constant: STRING is "an integer constant"
	an_integer_contant_or_identifier: STRING is "an integer constant or a identifier"
	a_manifest_constant_or_unique: STRING is "a manifest constant or `unique' keyword"

feature -- Access

	frozen_deferred_declaration: STRING is "Classes cannot be marked `frozen' and `deferred', they are contradicting declarations."
			-- Error for classes marked frozen and deferred

	deferred_cannot_be_implemented: STRING is "Deferred routines cannot contain implementation."

	current_cannot_be_assigned_to: STRING is "`Current' cannot be assigned to."

	void_cannot_be_assigned_to: STRING is "`Void' cannot be assigned to."

	valid_eiffel_class_name: STRING is "a valid Eiffel class name"

	a_class_name: STRING is "a class name"

	a_feature_name: STRING is "a feature name"

	a_valid_feature_name: STRING is "a valid Eiffel feature name"

	an_agent_target: STRING is "a agent target"

	a_creation_target: STRING is "a creation target"



feature -- Full Error Strings

	unrecoverable_error: STRING is "Unrecoverable syntax error found in class text!"

	external_used_in_non_il_parser: STRING is "`external' can only be used with an Eiffel for .NET parser."

feature -- Warning Strings

	empty_parenthesis_warning: STRING is "Empty paranthesis `()' are not ECMA-Eiffel compliant, please remove them."

	assign_keyword_warning: STRING is  "`assign' is now an Eiffel keyword, please reevaluate the use of it."

	indexing_value_missing_warning: STRING is "An indexing clause term should have an associated value."

	missing_index_part_warning: STRING is "Missing `Index' part of `Index_clause'."

	empty_inherit_clause_warning: STRING is "Use `inherit ANY' or do not specify an empty inherit clause"

	declared_expanded_warning: STRING is "Make an expanded version of the base class associated with this type."

	creation_use_warning: STRING is "Use `create' keyword instead of `creation' keyword."

	tilda_use_warning: STRING is "Use `agent' keyword instead of tilde `~' symbol."

	bang_bang_use_warning: STRING is "Use `create' keyword instead of `!!'."

	bang_type_bang_use_warning: STRING is "Use `create {A}' instead of `!A!'."

	static_feature_use_warning: STRING is "Use of `feature' for static calls is redundant, please remove it."


end -- class
