note
	description: "Class to collect all paths from an AST node"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_PATH_COLLECTOR

inherit
	EPA_AST_ITERATOR_WITH_HOOKS
		redefine
			pre_process_elseif_as,
			pre_process_assign_as,
			pre_process_case_as,
			pre_process_creation_as,
			pre_process_debug_as,
			pre_process_guard_as,
			pre_process_if_as,
			pre_process_inspect_as,
			pre_process_loop_as,
			pre_process_reverse_as,
			pre_process_check_as
		end

feature -- Access

	last_paths: HASH_TABLE [AST_EIFFEL, AST_PATH]
			-- Paths from last `collect'
			-- Keys are AST paths, values are AST nodes associated with those paths

feature -- Basic operations

	collect (a_ast: AST_EIFFEL)
			-- Collect paths from `a_ast' and make result available in `last_paths'.
			-- `a_ast' is assumed to already have its AST paths initialized.
		do
			create last_paths.make (30)
			last_paths.compare_objects
			a_ast.process (Current)
		end

feature{NONE} -- Implementation

	register_path (a_ast: AST_EIFFEL)
			-- Register `a_ast' as well as its path into `last_paths'.
		do
			if a_ast /= Void and then a_ast.path /= Void then
				last_paths.force (a_ast, a_ast.path)
			end
		end

feature {AST_EIFFEL} -- Instructions visitors

	pre_process_elseif_as (l_as: ELSIF_AS)
		do
			register_path (l_as)
		end

	pre_process_assign_as (l_as: ASSIGN_AS)
		do
			register_path (l_as)
		end

	pre_process_case_as (l_as: CASE_AS)
		do
			register_path (l_as)
		end

	pre_process_check_as (l_as: CHECK_AS)
		do
			register_path (l_as)
		end

	pre_process_creation_as (l_as: CREATION_AS)
		do
			register_path (l_as)
		end

	pre_process_debug_as (l_as: DEBUG_AS)
		do
			register_path (l_as)
		end

	pre_process_guard_as (l_as: GUARD_AS)
		do
			register_path (l_as)
		end

	pre_process_if_as (l_as: IF_AS)
		do
			register_path (l_as)
		end

	pre_process_inspect_as (l_as: INSPECT_AS)
		do
			register_path (l_as)
		end
		
	pre_process_loop_as (l_as: LOOP_AS)
		do
			register_path (l_as)
		end

	pre_process_reverse_as (l_as: REVERSE_AS)
		do
			register_path (l_as)
		end

end
