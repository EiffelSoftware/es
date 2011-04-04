note
	description: "Iterator to mark information relevant AST nodes for further snippet extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_MARKER

inherit
	AST_ITERATOR
		redefine
			process_assign_as,
			process_creation_as,
			process_if_as,
			process_instr_call_as,
			process_loop_as
		end

	EXT_SHARED_ANNOTATIONS
		export {NONE} all end

	EXT_SHARED_VARIABLE_CONTEXT
		export {NONE} all end

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
		end

feature {NONE} -- Implementation

	process_assign_as (l_as: ASSIGN_AS)
		require else
			l_as_path_not_void: attached l_as.path
		local
			l_variable_usage: LINKED_SET [STRING]
			l_variable_usage_finder: EXT_VARIABLE_USAGE_CALLBACK_SERVICE
		do
				-- Set up callback to track variable usage in arguments.
			create l_variable_usage.make
			l_variable_usage_finder := create_basic_variable_usage_finder (l_variable_usage)

				-- Process
			l_as.target.process (l_variable_usage_finder)
			l_as.source.process (l_variable_usage_finder)

			if l_variable_usage.is_empty then
					-- prune it: no variables of interest used in call
				add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_creation_as (l_as: CREATION_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_variable_of_interest (l_as.target.access_name_8) then
				if attached l_as.call as l_call_as then
					fixme ("Check call arguments.")
					fixme ("Do replace 'other' identifiers?")
				end
			else
				if attached l_as.call as l_call_as then
						-- check call arguments
					if not is_using_variable_of_interest (l_call_as) then
							-- prune it: no variables of interest used in call
						add_annotation (l_as.path, annotation_factory.new_ann_prune)
					else
							-- make hole: variables of interest used in call
						fixme ("Hole It!")
					end
				else
						-- prune it: no call attached
					add_annotation (l_as.path, annotation_factory.new_ann_prune)
				end
			end
		end

	process_if_as (l_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
		do
				-- Process
			l_use_cond := is_using_variable_of_interest (l_as.condition)

				-- Scan and annotate true branch
			if attached l_as.compound then
				l_use_branch_true := is_using_variable_of_interest (l_as.compound)

				if not l_use_branch_true then
						-- prune it: no variables of interest used
					add_annotation (l_as.compound.path, annotation_factory.new_ann_prune)
				end
			end

				-- Scan and annotate elseif list
			if attached l_as.elsif_list then
					-- process all individual `{ELSIF_AS}' from list
				across l_as.elsif_list as l_elsif_list loop
					if is_using_variable_of_interest (l_elsif_list.item) then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
					else
							-- prune it: no variables of interest used
						add_annotation (l_elsif_list.item.path, annotation_factory.new_ann_prune)
					end
				end

					-- process `{ELSIF_AS}' list
				if not l_use_elsif_list then
						-- prune it: no variables of interest used
					add_annotation (l_as.elsif_list.path, annotation_factory.new_ann_prune)
				end
			end

				-- Scan and annotate false branch
			if attached l_as.else_part then
				l_use_branch_false := is_using_variable_of_interest (l_as.else_part)

				if not l_use_branch_false then
						-- prune it: no variables of interest used
					add_annotation (l_as.else_part.path, annotation_factory.new_ann_prune)
				end
			end

				-- Based on structural information w.r.t. the subtrees, annotate `{IF_AS}'.
			if not (l_use_cond or l_use_branch_true or l_use_elsif_list or l_use_branch_false) then
					-- prune it: no variables of interest used at all in if statement
				add_annotation (l_as.path, annotation_factory.new_ann_prune)

			elseif not l_use_cond and l_use_branch_true and not l_use_elsif_list and not l_use_branch_false then
				add_annotation (l_as.path, annotation_factory.new_ann_flatten_retain_if)

			elseif not l_use_cond and not l_use_branch_true and not l_use_elsif_list and l_use_branch_false then
				add_annotation (l_as.path, annotation_factory.new_ann_flatten_retain_else)

			end

			fixme ("Handle 'elsif' simplification?!")
			fixme ("When retaining else and if statement -> neg expression?!")

			Precursor (l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			if attached {NESTED_AS} l_as.call as l_call_as then
				processing_instr_call_nested_as (l_call_as)
			else
				Precursor (l_as)
			end
		end

	process_loop_as (l_as: LOOP_AS)
		do
			Precursor (l_as)
		end

feature {NONE} -- Implementation (Helper)

	processing_instr_call_nested_as (l_as: NESTED_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_variable_of_interest (l_as.target.access_name_8) then
				if attached l_as.message as l_call_as then
					fixme ("Check call arguments.")
					fixme ("Do replace 'other' identifiers?")
				end
			else
				if attached l_as.message as l_call_as then
						-- check call arguments
					if not is_using_variable_of_interest (l_call_as) then
							-- prune it: no variables of interest used in call
						add_annotation (l_as.path, annotation_factory.new_ann_prune)
					else
							-- make hole: variables of interest used in call
						fixme ("Hole It!")
					end
				else
						-- prune it: no call attached
					add_annotation (l_as.path, annotation_factory.new_ann_prune)
				end
			end
		end

feature {NONE} -- Helper

	create_basic_variable_usage_finder (a_variable_usage: LINKED_SET [STRING]): EXT_VARIABLE_USAGE_CALLBACK_SERVICE
			-- Variable finder that stores all used variable of interest indentifiers in `a_variable_usage'.
		require
			a_variable_usage_not_void: attached a_variable_usage
		do
				-- Set up callback to track variable usage in arguments.
			create Result
			Result.set_is_mode_disjoint (False)
			Result.set_on_access_identifier (
				agent add_if_variable_of_interest(?, a_variable_usage)
			)
		end

	add_if_variable_of_interest (a_as: ACCESS_AS; a_variable_usage: LINKED_SET [STRING])
			-- Agent that adds an indentifier name to a given set `a_variable_usage_set'
			-- if it's contained in the list of variables of interest.
		do
			if is_variable_of_interest (a_as.access_name_8) then
				a_variable_usage.force (a_as.access_name_8)
			end
		end

	is_using_variable_of_interest (a_as: AST_EIFFEL): BOOLEAN
			-- AST terator processing `a_as' answering if a varialbe of interest is used in that AST.
		local
			l_variable_usage: LINKED_SET [STRING]
			l_variable_usage_finder: EXT_VARIABLE_USAGE_CALLBACK_SERVICE
		do
				-- Set up callback to track variable usage in arguments.
			create l_variable_usage.make
			l_variable_usage_finder := create_basic_variable_usage_finder (l_variable_usage)

			a_as.process (l_variable_usage_finder)

			Result := not l_variable_usage.is_empty
		end

end
