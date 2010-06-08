indexing
	description: "Summary description for {JS_SPEC_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	JS_SPEC_VISITOR

feature

	process_binop (binop: JS_BINOP_NODE)
		deferred
		end

	process_exports (exports: JS_EXPORTS_NODE)
		deferred
		end

	process_false (false_node: JS_FALSE_NODE)
		deferred
		end

	process_field_sig (field_sig: JS_FIELD_SIG_NODE)
		deferred
		end

	process_fld_eq_list_as_arg (fld_eq_list_as_arg: JS_FLD_EQ_LIST_AS_ARG_NODE)
		deferred
		end

	process_fld_equality (fld_equality: JS_FLD_EQUALITY_NODE)
		deferred
		end

	process_function_term_as_arg (function_term_as_arg: JS_FUNCTION_TERM_AS_ARG_NODE)
		deferred
		end

	process_integer_as_arg (integer_as_arg: JS_INTEGER_AS_ARG_NODE)
		deferred
		end

	process_mapsto (mapsto: JS_MAPSTO_NODE)
		deferred
		end

	process_named_iff (named_iff: JS_NAMED_IFF_NODE)
		deferred
		end

	process_named_implication (named_implication: JS_NAMED_IMPLICATION_NODE)
		deferred
		end

	process_or (or_node: JS_OR_NODE)
		deferred
		end

	process_param (param: JS_PARAM_NODE)
		deferred
		end

	process_pred_def (pred_def: JS_PRED_DEF_NODE)
		deferred
		end

	process_pure_predicate (pure_predicate: JS_PURE_PREDICATE_NODE)
		deferred
		end

	process_spatial_predicate (spatial_predicate: JS_SPATIAL_PRED_NODE)
		deferred
		end

	process_star (star: JS_STAR_NODE)
		deferred
		end

	process_true (true_node: JS_TRUE_NODE)
		deferred
		end

	process_type_judgement (type_judgement: JS_TYPE_JUDGEMENT_NODE)
		deferred
		end

	process_type (type: JS_TYPE_NODE)
		deferred
		end

	process_variable (variable: JS_VARIABLE_NODE)
		deferred
		end

	process_variable_as_arg (variable_as_arg: JS_VARIABLE_AS_ARG_NODE)
		deferred
		end

	process_where_pred_def (where_pred_def: JS_WHERE_PRED_DEF_NODE)
		deferred
		end

end
