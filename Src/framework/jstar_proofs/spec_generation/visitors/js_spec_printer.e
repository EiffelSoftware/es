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

	process_assertion (assertion: JS_ASSERTION_NODE)
		do
			process_list (assertion.pure_list, " * ")
			append (" | ")
			process_list (assertion.spatial_list, " * ")
		end

	process_combine_oror (combine_oror: JS_COMBINE_OROR_NODE)
		do
			combine_oror.left_assertion.accept (Current)
			append (" || ")
			combine_oror.right_assertion.accept (Current)
		end

	process_combine_wand (combine_wand: JS_COMBINE_WAND_NODE)
		do
			combine_wand.left_assertion.accept (Current)
			append (" -* ")
			combine_wand.right_assertion.accept (Current)
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

	process_pure_equality (pure_equality: JS_PURE_EQUALITY_NODE)
		do
			pure_equality.left_argument.accept (Current)
			append (" = ")
			pure_equality.right_argument.accept (Current)
		end

	process_pure_inequality (pure_inequality: JS_PURE_INEQUALITY_NODE)
		do
			pure_inequality.left_argument.accept (Current)
			append (" != ")
			pure_inequality.right_argument.accept (Current)
		end

	process_pure_predicate (pure_predicate: JS_PURE_PREDICATE_NODE)
		do
			append (pure_predicate.predicate_name)
			append ("(")
			process_list (pure_predicate.argument_list, ", ")
			append (")")
		end

	process_pure_type_judgement (pure_type_judgement: JS_PURE_TYPE_JUDGEMENT_NODE)
		do
			pure_type_judgement.argument.accept (Current)
			append (": ")
			pure_type_judgement.type.accept (Current)
		end

	process_spatial_combine (spatial_combine: JS_SPATIAL_COMBINE_NODE)
		do
			append ("(")
			spatial_combine.accept (Current)
			append (")")
		end

	process_spatial_mapsto (spatial_mapsto: JS_SPATIAL_MAPSTO_NODE)
		do
			append ("field(")
			spatial_mapsto.object.accept (Current)
			append (", ")
			spatial_mapsto.field_signature.accept (Current)
			append (", ")
			spatial_mapsto.value.accept (Current)
			append (")")
		end

	process_spatial_predicate (spatial_predicate: JS_SPATIAL_PRED_NODE)
		do
			append (spatial_predicate.predicate_name)
			append ("(")
			process_list (spatial_predicate.argument_list, ", ")
			append (")")
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
