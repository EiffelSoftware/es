indexing
	description: "Summary description for {JS_SPEC_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	JS_SPEC_VISITOR

feature

	process_assertion (assertion: JS_ASSERTION_NODE)
		deferred
		end

	process_combine_oror (combine_oror: JS_COMBINE_OROR_NODE)
		deferred
		end

	process_combine_wand (combine_wand: JS_COMBINE_WAND_NODE)
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

	process_param (param: JS_PARAM_NODE)
		deferred
		end

	process_pred_def (pred_def: JS_PRED_DEF_NODE)
		deferred
		end

	process_pure_equality (pure_equality: JS_PURE_EQUALITY_NODE)
		deferred
		end

	process_pure_inequality (pure_inequality: JS_PURE_INEQUALITY_NODE)
		deferred
		end

	process_pure_predicate (pure_predicate: JS_PURE_PREDICATE_NODE)
		deferred
		end

	process_pure_type_judgement (pure_type_judgement: JS_PURE_TYPE_JUDGEMENT_NODE)
		deferred
		end

	process_spatial_combine (spatial_combine: JS_SPATIAL_COMBINE_NODE)
		deferred
		end

	process_spatial_mapsto (spatial_mapsto: JS_SPATIAL_MAPSTO_NODE)
		deferred
		end

	process_spatial_predicate (spatial_predicate: JS_SPATIAL_PRED_NODE)
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

end
