indexing
	description: "Adapts the AST for a spec by substituting Current, Result, params and types."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_SPEC_ADAPTER

inherit
	JS_SPEC_VISITOR

	SHARED_WORKBENCH
	export {NONE} all end

	JS_HELPER_ROUTINES
	export {NONE} all end

create
	make

feature

	make
		do
			create variable_substitution.make (10)
			create type_substitution.make (10)

			-- Set up the type substitution - this can be done once and for all
			type_substitution.force ("int", "INTEGER")
			type_substitution.force ("int", "INTEGER_8")
			type_substitution.force ("int", "INTEGER_16")
			type_substitution.force ("int", "INTEGER_32")
			type_substitution.force ("int", "INTEGER_64")
			type_substitution.force ("int", "NATURAL")
			type_substitution.force ("int", "NATURAL_8")
			type_substitution.force ("int", "NATURAL_16")
			type_substitution.force ("int", "NATURAL_32")
			type_substitution.force ("int", "NATURAL_64")
		end

	with_class_context
		do
			with_feature_context (Void)
		end

	with_feature_context (f: FEATURE_I)
		local
			i: INTEGER
		do
			-- Set up the variable_substitution
			variable_substitution.wipe_out
			variable_substitution.force ("nil()", "Void")
				-- Although axioms have class scope, they still use Current as a free variable.
			variable_substitution.force ("@this:", "Current")
			if f /= Void then
				variable_substitution.force ("$ret_var", "Result")
				from
					i := 1
				until
					i > f.argument_count
				loop
					variable_substitution.force ("@parameter" + (i-1).out + ":", f.arguments.item_name (i))
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	variable_substitution: HASH_TABLE [STRING, STRING]

	type_substitution: HASH_TABLE [STRING, STRING]

feature -- Node processing

	process_binop (binop: JS_BINOP_NODE)
		do
			binop.left_argument.accept (Current)
			binop.right_argument.accept (Current)
		end

	process_exports (exports: JS_EXPORTS_NODE)
		do
			process_list (exports.named_formulas)
			process_list (exports.where_pred_defs)
		end

	process_false (false_node: JS_FALSE_NODE)
		do
		end

	process_field_sig (field_sig: JS_FIELD_SIG_NODE)
		local
			l_classes: LIST [CLASS_I]
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			-- It's not necessary to adapt field_sig.class_name

			-- Look up the type of the field
			l_classes := universe.classes_with_name (field_sig.class_name)
			if l_classes.count /= 1 then
				error ("Two or more classes in the system are found with name " + field_sig.class_name)
			end
			l_class := l_classes.i_th (1).compiled_representation
			if not l_class.has_feature_table then
				error ("Attribute " + field_sig.class_name + "." + field_sig.field + " does not exist")
			end
			l_feature := l_class.feature_named (field_sig.field)
			if l_feature = Void then
				error ("Attribute " + field_sig.class_name + "." + field_sig.field + " does not exist")
			end
			if not l_feature.is_attribute then
				error (field_sig.class_name + "." + field_sig.field + " is not an attribute")
			end
			field_sig.set_type (type_string (l_feature.type))
		end

	process_fld_eq_list_as_arg (fld_eq_list_as_arg: JS_FLD_EQ_LIST_AS_ARG_NODE)
		do
			process_list (fld_eq_list_as_arg.fld_equality_list)
		end

	process_fld_equality (fld_equality: JS_FLD_EQUALITY_NODE)
		do
			fld_equality.value.accept (Current)
		end

	process_function_term_as_arg (function_term_as_arg: JS_FUNCTION_TERM_AS_ARG_NODE)
		do
			process_list (function_term_as_arg.argument_list)
		end

	process_integer_as_arg (integer_as_arg: JS_INTEGER_AS_ARG_NODE)
		do
		end

	process_mapsto (mapsto: JS_MAPSTO_NODE)
		do
			mapsto.object.accept (Current)
			mapsto.field_signature.accept (Current)
			mapsto.value.accept (Current)
		end

	process_named_iff (named_iff: JS_NAMED_IFF_NODE)
		do
			named_iff.left_assertion.accept (Current)
			named_iff.right_assertion.accept (Current)
		end

	process_named_implication (named_implication: JS_NAMED_IMPLICATION_NODE)
		do
			named_implication.antecedent.accept (Current)
			named_implication.consequent.accept (Current)
		end

	process_or (or_node: JS_OR_NODE)
		do
			or_node.left_assertion.accept (Current)
			or_node.right_assertion.accept (Current)
		end

	process_param (param: JS_PARAM_NODE)
		do
		end

	process_pred_def (pred_def: JS_PRED_DEF_NODE)
		do
			pred_def.body.accept (Current)
		end

	process_pure_predicate (pure_predicate: JS_PURE_PREDICATE_NODE)
		do
			process_list (pure_predicate.argument_list)
		end

	process_spatial_predicate (spatial_predicate: JS_SPATIAL_PRED_NODE)
		do
			process_list (spatial_predicate.argument_list)
		end

	process_star (star: JS_STAR_NODE)
		do
			star.left_assertion.accept (Current)
			star.right_assertion.accept (Current)
		end

	process_true (true_node: JS_TRUE_NODE)
		do
		end

	process_type_judgement (type_judgement: JS_TYPE_JUDGEMENT_NODE)
		do
			type_judgement.argument.accept (Current)
			type_judgement.type.accept (Current)
		end

	process_type (type: JS_TYPE_NODE)
		local
			type_name: STRING
		do
			type_name := type.name
			if type_substitution.has_key (type_name) then
				type.set_name (type_substitution.item (type_name))
			end
		end

	process_variable (variable: JS_VARIABLE_NODE)
		local
			variable_name: STRING
		do
			variable_name := variable.name
			if variable_substitution.has_key (variable_name) then
				variable.set_name (variable_substitution.item (variable_name))
			end
		end

	process_variable_as_arg (variable_as_arg: JS_VARIABLE_AS_ARG_NODE)
		do
			variable_as_arg.variable.accept (Current)
		end

	process_where_pred_def (where_pred_def: JS_WHERE_PRED_DEF_NODE)
		do
			where_pred_def.body.accept (Current)
		end

feature {NONE} -- Helpers

	process_list (list: LINKED_LIST [JS_SPEC_NODE])
		do
			from
				list.start
			until
				list.off
			loop
				list.item.accept (Current)
				list.forth
			end
		end

end
