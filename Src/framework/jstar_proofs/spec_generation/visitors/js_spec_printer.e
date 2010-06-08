indexing
	description: "Summary description for {JS_SPEC_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_SPEC_PRINTER

inherit
	JS_SPEC_VISITOR

create
	make

feature

	make
		do
			reset
		end

	reset
		do
			output := ""
		end

	output: STRING

feature -- Spec node processing

	process_binop (binop: JS_BINOP_NODE)
		do
			binop.left_argument.accept (Current)

			if equal (binop.operator, "/=") then
				append (" != ")
			else
				append (" " + binop.operator + " ")
			end

			binop.right_argument.accept (Current)
		end

	process_exports (exports: JS_EXPORTS_NODE)
		do
			check false end -- The exports is never printed as a whole. Print its individual components from the outside.
		end

	process_false (false_node: JS_FALSE_NODE)
		do
			append ("False")
		end

	process_field_sig (field_sig: JS_FIELD_SIG_NODE)
		do
			append ("<" + field_sig.class_name + ": " + field_sig.type + " " + field_sig.field + ">")
		end

	process_fld_eq_list_as_arg (fld_eq_list_as_arg: JS_FLD_EQ_LIST_AS_ARG_NODE)
		do
			append ("{")
			process_list (fld_eq_list_as_arg.fld_equality_list, ";")
			append ("}")
		end

	process_fld_equality (fld_equality: JS_FLD_EQUALITY_NODE)
		do
			append (fld_equality.fld)
			append ("=")
			fld_equality.value.accept (Current)
		end

	process_function_term_as_arg (function_term_as_arg: JS_FUNCTION_TERM_AS_ARG_NODE)
		do
			append (function_term_as_arg.function_name)
			append ("(")
			process_list (function_term_as_arg.argument_list, ", ")
			append (")")
		end

	process_integer_as_arg (integer_as_arg: JS_INTEGER_AS_ARG_NODE)
		do
			append ("numeric_const(" + integer_as_arg.value + ")")
		end

	process_mapsto (mapsto: JS_MAPSTO_NODE)
		do
			mapsto.object.accept (Current)
			append (".")
			mapsto.field_signature.accept (Current)
			append (" |-> ")
			mapsto.value.accept (Current)
		end

	process_named_iff (named_iff: JS_NAMED_IFF_NODE)
		do
			append (named_iff.name)
			append (": ")
			named_iff.left_assertion.accept (Current)
			append (" <=> ")
			named_iff.right_assertion.accept (Current)
			append (";")
		end

	process_named_implication (named_implication: JS_NAMED_IMPLICATION_NODE)
		do
			append (named_implication.name)
			append (": ")
			named_implication.antecedent.accept (Current)
			append (" => ")
			named_implication.consequent.accept (Current)
			append (";")
		end

	process_or (or_node: JS_OR_NODE)
		do
			or_node.left_assertion.accept (Current)
			append (" || ")
			or_node.right_assertion.accept (Current)
		end

	process_param (param: JS_PARAM_NODE)
		do
			append (param.name)
			append ("=")
			param.variable.accept (Current)
		end

	process_pred_def (pred_def: JS_PRED_DEF_NODE)
		do
			append (pred_def.predicate_name)
			append ("(")
			pred_def.target_param.accept (Current)
			if pred_def.param_list.count /= 0 then
				append (", {")
				process_list (pred_def.param_list, ";")
				append ("}")
			end
			append (") = ")
			pred_def.body.accept (Current)
		end

	process_pure_predicate (pure_predicate: JS_PURE_PREDICATE_NODE)
		do
				-- The exclamation here is very important!!!
			append ("! ")
			append (pure_predicate.predicate_name)
			append ("(")
			process_list (pure_predicate.argument_list, ", ")
			append (")")
		end

	process_spatial_predicate (spatial_predicate: JS_SPATIAL_PRED_NODE)
		do
			append (spatial_predicate.predicate_name)
			append ("(")
			process_list (spatial_predicate.argument_list, ", ")
			append (")")
		end

	process_star (star: JS_STAR_NODE)
		do
			star.left_assertion.accept (Current)
			append (" * ")
			star.right_assertion.accept (Current)
		end

	process_true (true_node: JS_TRUE_NODE)
		do
				-- Outputting a space here is crucial for detecting whether or not an assertion was supplied by the user.
			append (" ")
		end

	process_type_judgement (type_judgement: JS_TYPE_JUDGEMENT_NODE)
		do
			type_judgement.argument.accept (Current)
			append (" : ")
			type_judgement.type.accept (Current)
		end

	process_type (type: JS_TYPE_NODE)
		do
			append (type.name)
		end

	process_variable (variable: JS_VARIABLE_NODE)
		do
			append (variable.name)
		end

	process_variable_as_arg (variable_as_arg: JS_VARIABLE_AS_ARG_NODE)
		do
			variable_as_arg.variable.accept (Current)
		end

	process_where_pred_def (where_pred_def: JS_WHERE_PRED_DEF_NODE)
		do
			append (where_pred_def.pred_name)
			append ("(")
			process_list (where_pred_def.arguments, ",")
			append (") = ")
			where_pred_def.body.accept (Current)
			append (";")
		end

feature {NONE}

	process_list (a_list: LINKED_LIST [JS_SPEC_NODE]; separator: STRING)
		local
			is_first: BOOLEAN
		do
			from
				a_list.start
				is_first := True
			until
				a_list.off
			loop
				if not is_first then
					append (separator)
				else
					is_first := False
				end
				a_list.item.accept (Current)
				a_list.forth
			end
		end

	append (what: STRING)
		do
			output := output + what
		end

end
