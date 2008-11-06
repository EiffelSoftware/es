indexing
	description: "The usage analyser goes through the AST of the compiled classes and generates a list of defined feature."
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_FEATURE_LIST_GENERATOR

inherit
	BPL_BN_ITERATOR
		redefine
			make,
			process_attribute_b,
			process_feature_i,
			process_feature_b,
			process_byte_code,
			process_routine_creation_b,
			process_creation_expr_b
		end

create
	make

feature{NONE} -- Initialization

	make (a_class: EIFFEL_CLASS_C) is
			-- Default creation
		do
			Precursor (a_class)
			create {ARRAYED_LIST [FEATURE_I]}command_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}query_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}deferred_command_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}deferred_query_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}attribute_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}function_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}constant_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}procedure_list.make (1)
			create {ARRAYED_LIST [FEATURE_I]}used_query_list.make (1)
			used_query_list.compare_objects
			create {ARRAYED_LIST [FEATURE_I]}used_command_list.make (1)
			used_command_list.compare_objects
			create {ARRAYED_LIST [FEATURE_I]}used_feature_list.make (1)
			used_feature_list.compare_objects
			create {ARRAYED_LIST [FEATURE_I]}all_query_list.make (1)

		end

feature -- Analyse

	analyse is
			-- Do the analysis of the class.
		do
			visit_all_features
		end

feature -- Access

	command_list: LIST [FEATURE_I]
		-- List of all commands defined in the class

	query_list: LIST [FEATURE_I]
		-- List of all queries defined in the class

	deferred_query_list: LIST [FEATURE_I]
		-- List of deferred queries

	deferred_command_list: LIST [FEATURE_I]
		-- List of deferred commands

	attribute_list: LIST [FEATURE_I]
		-- List of all attributes defined in the class (queries as attributes)

	function_list: LIST [FEATURE_I]
		-- List of all functions defined in the class (queries with implementation)

	constant_list: LIST [FEATURE_I]
		-- List of all constants defined in the class

	procedure_list: LIST [FEATURE_I]
		-- List of all procedures defined in the class (command with implementation)


	used_command_list: LIST [FEATURE_I]
		-- List of all supplier commands which are used in the class

	used_query_list: LIST [FEATURE_I]
		-- List of all supplier queries which are used in the class and recursivly by there contracts

	used_feature_list: LIST [FEATURE_I]
		-- List of all supplier commands and queries which are used in the class and recursivly by there contracts


	all_query_list: LIST [FEATURE_I]
		-- List of all queries defined or used in the class

feature -- Processing

	process_feature_i (a_feature: FEATURE_I) is
			-- Process a feature to record it in the lists.
		do
			if Mapping_table.item (a_feature.written_class.name) = Void then
				current_feature := a_feature
				Precursor (a_feature)

				if a_feature.is_attribute or a_feature.is_function or a_feature.is_constant then
					query_list.extend (a_feature)
					all_query_list.extend (a_feature)
				else
					command_list.extend (a_feature)
				end
				if a_feature.is_attribute then
					attribute_list.extend (a_feature)
				elseif a_feature.is_deferred then
					if a_feature.is_function then
						deferred_query_list.extend (a_feature)
					else
						deferred_command_list.extend (a_feature)
					end
				elseif a_feature.is_constant then
					constant_list.extend (a_feature)
				else
					if a_feature.is_function then
						function_list.extend (a_feature)
					else
						procedure_list.extend (a_feature)
					end
				end
			end
		end

	process_byte_code (a_node: BYTE_CODE) is
		do
			safe_process (a_node.use_frame)
			safe_process (a_node.modify_frame)
			safe_process (a_node.precondition)
			-- only process the implementation for current_class
			if current_feature.written_in = current_class.class_id then
				safe_process (a_node.compound)
				safe_process (a_node.rescue_clause)
			end
			safe_process (a_node.postcondition)
		end

	process_feature_b (a_node: FEATURE_B) is
		local
			used_feature, inherited_feature: FEATURE_I
			idx: INTEGER
			parents: FIXED_LIST[CLASS_C]
			byte_code: BYTE_CODE
		do
				-- TODO: Check why this doesn't work
			-- used_feature := system.class_of_id (a_node.written_in).feature_of_rout_id (a_node.routine_id)
			used_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
			if Mapping_table.item (used_feature.written_class.name) = Void and then not used_feature_list.has (used_feature) then
				if used_feature.is_attribute or used_feature.is_function or used_feature.is_constant then
					used_query_list.extend (used_feature)
					all_query_list.extend (used_feature)
				else
					used_command_list.extend (used_feature)
				end
				used_feature_list.extend (used_feature)
				if inv_byte_server.has(used_feature.written_in) then
					safe_process (inv_byte_server.item (used_feature.written_in).byte_list)
				end
				-- add precursors of feature_b
				parents := current_feature.written_class.parents_classes
				if parents /= Void then
					from
						parents.start
					until
						parents.after
					loop
						from
							idx := current_feature.rout_id_set.lower
						until
							idx > current_feature.rout_id_set.count + current_feature.rout_id_set.lower - 1
						loop
							inherited_feature := parents.item.feature_of_feature_id (current_feature.rout_id_set.item (idx))
							if inherited_feature /= Void and not used_feature_list.has (inherited_feature) then
								used_feature_list.extend (inherited_feature)
							end
							idx := idx + 1
						end
						parents.forth
					end
				end
				-- handle frames
				if Byte_server.has (a_node.body_index) then
					byte_code := Byte_server.item (a_node.body_index)
					safe_process (byte_code.use_frame)
					safe_process (byte_code.modify_frame)
				end
			end

			-- handle arguments
			Precursor (a_node)

		end

	process_attribute_b (a_node: ATTRIBUTE_B) is
		local
			used_feature: FEATURE_I
		do
			used_feature := system.class_of_id (a_node.written_in).feature_of_rout_id (a_node.routine_id)
			if Mapping_table.item (used_feature.written_class.name) = Void and then not used_feature_list.has (used_feature) then
				used_query_list.extend (used_feature)
				used_feature_list.extend (used_feature)
				all_query_list.extend (used_feature)
				if inv_byte_server.has(used_feature.written_in) then
					safe_process (inv_byte_server.item (used_feature.written_in).byte_list)
				end
				-- TODO: add precursors of feature_b, too
			end
		end


	process_routine_creation_b (a_node: ROUTINE_CREATION_B) is
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
		do
			if a_node.is_inline_agent then
					-- TODO: Check if this needs special handling
				check not_implemented: false end
			else
				l_feature := system.class_of_id (a_node.class_id).feature_of_feature_id (a_node.feature_id)
				check l_feature /= Void end

			end
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B) is
			-- Process `a_node'.
		do
			
		end

feature {NONE} -- Implementation

	record_feature (a_feature: FEATURE_I) is
			-- Record usage of `a_feature'.
		do

		end



invariant
	command_list_not_void: command_list /= Void
	query_list_not_void: query_list /= Void
	attribute_list_not_void: attribute_list /= Void
	function_list_not_void: function_list /= Void
	procedure_list_not_void: procedure_list /= Void
end
