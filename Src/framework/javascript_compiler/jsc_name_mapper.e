note
	description : "Provide relevant information about the context: current target, names of locals, arguments."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_NAME_MAPPER

inherit
	SHARED_JSC_CONTEXT
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object.
		do
			create {LINKED_LIST[attached STRING]}locals_names.make
			create {LINKED_STACK[attached TYPE_A]}target_types.make
			create {LINKED_STACK[attached JSC_BUFFER_DATA]}target_names.make
			is_inside_agent := false
		end

feature -- Target

	target_type : attached TYPE_A
			-- Current target type
		do
			Result := target_types.item
		end

	target_name : attached JSC_BUFFER_DATA
			-- Current target name
		do
			Result := target_names.item
		end

	current_class_target: attached STRING
			-- Reference to current class
		do
			if is_inside_agent then
				Result := "$this"
			else
				Result := "this"
			end
		end

	push_target_current
			-- Push target current
		local
			l_written_class: CLASS_C
			l_type: CL_TYPE_A
			l_data: JSC_BUFFER_DATA
		do
			create l_data.make_from_string (current_class_target)

			l_written_class := jsc_context.current_class
			check l_written_class /= Void end

			l_type := l_written_class.actual_type
			check l_type /= Void end

			push_target (l_type, l_data)
		end

	push_target (a_target_type: attached TYPE_A; a_target_name: attached JSC_BUFFER_DATA)
			-- Push target
		do
			target_types.put (a_target_type)
			target_names.put (a_target_name)
		end

	pop_target
			-- Pop target
		do
			target_types.remove
			target_names.remove
		end

	is_inside_agent: BOOLEAN assign set_is_inside_agent
			-- Is translating an agent definition inside a feature
	set_is_inside_agent (a_is_inside_agent: BOOLEAN)
		do
			is_inside_agent := a_is_inside_agent
		end

feature -- Names

	invariant_name (a_class_id: INTEGER): attached STRING
		do
			Result := "$invariant_" + a_class_id.out
		end

	local_name (a_index: INTEGER): attached STRING
			-- Name of local (in generated JavaScript code)
		do
			if a_index > locals_names.count then
				Result := "local" + a_index.out
			else
				Result := locals_names[a_index]
			end

			if jsc_context.is_reserved_javascript_word (Result) then
				jsc_context.add_error ("JavaScript reserved word", "What to do: Rename local " + Result + ".")
			end
		end

	set_locals_names (a_locals_names: attached LIST[attached STRING])
			-- Initialize names of locals
		do
			locals_names := a_locals_names
		end

	result_name: attached STRING
			-- How to call te Result
		do
			Result := "Result";
		end

	argument_name (a_node: attached ARGUMENT_B): attached STRING
			-- Name for an argument
		local
			l_arguments: FEAT_ARG
			l_arg_name: STRING
		do
			l_arguments := jsc_context.current_feature.arguments
			check l_arguments /= Void end

			l_arg_name := l_arguments.item_name (a_node.position)
			check l_arg_name /= Void end

			Result := l_arg_name
			if jsc_context.is_reserved_javascript_word (Result) then
				jsc_context.add_error ("JavaScript reserved word: " + Result, "What to do: Rename argument " + Result + ".")
			end
		end

	feature_name (a_feature: attached FEATURE_I; force_long_form: BOOLEAN): attached STRING
			-- Name for `a_feature'. Attributes have two forms.
		local
			l_feature_name: STRING
		do
			l_feature_name := a_feature.feature_name
			check l_feature_name /= Void end

			if a_feature.is_attribute then
				Result := l_feature_name
			else
				Result := l_feature_name + "_" + a_feature.written_in.out
			end
		end

feature {NONE} -- Implementation

	target_types : attached STACK[attached TYPE_A]

	target_names : attached STACK[attached JSC_BUFFER_DATA]

	locals_names: attached LIST[attached STRING]

end
