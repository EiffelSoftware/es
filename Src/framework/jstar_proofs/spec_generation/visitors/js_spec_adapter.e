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
			if f /= Void then
				variable_substitution.force ("@this:", "Current")
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

	process_assertion (assertion: JS_ASSERTION_NODE)
		do
			process_list (assertion.pure_list)
			process_list (assertion.spatial_list)
		end

	process_combine_oror (combine_oror: JS_COMBINE_OROR_NODE)
		do
			combine_oror.left_assertion.accept (Current)
			combine_oror.right_assertion.accept (Current)
		end

	process_combine_wand (combine_wand: JS_COMBINE_WAND_NODE)
		do
			combine_wand.left_assertion.accept (Current)
			combine_wand.right_assertion.accept (Current)
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

	process_param (param: JS_PARAM_NODE)
		do
		end

	process_pred_def (pred_def: JS_PRED_DEF_NODE)
		do
			pred_def.body.accept (Current)
		end

	process_pure_equality (pure_equality: JS_PURE_EQUALITY_NODE)
		do
			pure_equality.left_argument.accept (Current)
			pure_equality.right_argument.accept (Current)
		end

	process_pure_inequality (pure_inequality: JS_PURE_INEQUALITY_NODE)
		do
			pure_inequality.left_argument.accept (Current)
			pure_inequality.right_argument.accept (Current)
		end

	process_pure_predicate (pure_predicate: JS_PURE_PREDICATE_NODE)
		do
			process_list (pure_predicate.argument_list)
		end

	process_pure_type_judgement (pure_type_judgement: JS_PURE_TYPE_JUDGEMENT_NODE)
		do
			pure_type_judgement.argument.accept (Current)
			pure_type_judgement.type.accept (Current)
		end

	process_spatial_combine (spatial_combine: JS_SPATIAL_COMBINE_NODE)
		do
			spatial_combine.combine_content.accept (Current)
		end

	process_spatial_mapsto (spatial_mapsto: JS_SPATIAL_MAPSTO_NODE)
		do
			spatial_mapsto.object.accept (Current)
			spatial_mapsto.field_signature.accept (Current)
			spatial_mapsto.value.accept (Current)
		end

	process_spatial_predicate (spatial_predicate: JS_SPATIAL_PRED_NODE)
		do
			process_list (spatial_predicate.argument_list)
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
