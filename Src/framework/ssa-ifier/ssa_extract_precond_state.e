note
	description: "Summary description for {SSA_EXTRACT_PRECOND_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXTRACT_PRECOND_STATE

inherit
	SHARED_SERVER

create
	make

feature
	class_: CLASS_C
	name: STRING
	replace: SSA_REPLACEMENT


	text: STRING
		do
			Result := context
		end

	make (a_class: CLASS_C; a_name: STRING; a_replace: SSA_REPLACEMENT)
		require
			attached a_replace
		do
			class_ := a_class
			name := a_name
			replace := a_replace
			context := ""
			
			construct_state_export
		end

	construct_state_export
		local
			vars: LIST [SSA_ARG_INSTANTIATE]
		do
			vars := collect_vars
			from
				vars.start
			until
				vars.after
			loop
				generate_state_var (vars.item)
				vars.forth
			end
		end

	generate_state_var (inst: SSA_ARG_INSTANTIATE)
		do
			if inst.type.is_integer then
				init_state_func (inst.formal_name, inst.actual_name)
			elseif inst.type.is_boolean then
				init_state_pred (inst.formal_name, inst.actual_name)
			else
				-- call to regular-class state printer (var.name)
			end

			-- generate formal/actual argument equalities
		end

	init_state_func (formal_arg, actual_arg: STRING)
		do
			add_string ("init_state.add_function_simple ")
			add_string ("(%"" + formal_arg)
			add_string ("%"," + actual_arg)
			add_string (")")
			add_string ("%N")
		end

	init_state_pred (formal_arg, actual_arg: STRING)
		do
			add_string ("init_state.add_predicate_simple ")
			add_string ("(%"" + formal_arg)
			add_string ("%"," + actual_arg)
			add_string (")")
			add_string ("%N")
		end

	context: STRING

	add_string (str: STRING)
		do
			context := context + str
		end

	collect_vars: ARRAYED_LIST [SSA_ARG_INSTANTIATE]
		local
			feat_i: FEATURE_I
			args: LIST [STRING]
			i: INTEGER
			inst: SSA_ARG_INSTANTIATE
		do
			create Result.make (10)
			feat_i := find_feature

			if attached feat_i then
				args := actual_args (replace.call)
				from
					i := 1
				until
					i > feat_i.argument_count
				loop
					create inst.make ( feat_i.arguments.item_name (i)
					                 , args [i]
					                 , feat_i.arguments [i]
					                 )
					i := i + 1
				end
			end
		end


	find_feature: FEATURE_I
		local
			feat_name: STRING
		do
			feat_name := call_name (replace.call)
			Result := replace.type.associated_class.feature_named_32 (feat_name)
		end


	actual_args (ast: AST_EIFFEL): ARRAYED_LIST [STRING]
		local
			i: INTEGER
		do
			if attached {ACCESS_FEAT_AS} ast as feat_as then
				create Result.make (10)
				from
					i := 1
				until
					i > feat_as.parameter_count
				loop
					Result.extend (feat_as.parameters [i].text_32 (match_list_server.item (class_.ast.class_id)))
					i := i + 1
				end
			end
		end

	call_name (ast: AST_EIFFEL): STRING
		do
			if attached {ACCESS_FEAT_AS} ast as feat_as then
				Result := feat_as.access_name_32
			elseif attached {ID_AS} ast as id then
				Result := id.name_32
			else
				check False end
			end
		end

end
