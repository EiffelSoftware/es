note
	description: "Iterator to mark information relevant AST nodes for further snippet extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_MARKER

inherit
	AST_ITERATOR
		redefine
			process_access_feat_as,
			process_access_id_as,
			process_address_result_as,
			process_create_creation_as,
			process_result_as
		end

create
	make_from_variable

feature {NONE} -- Initialization

	make_from_variable (a_variable_type: TYPE_A; a_variable_name: STRING)
			-- Initialization with variable type and name relevant for block search.
		do
			create marked_ast_paths.make (20)
		end

feature -- Access

feature {NONE} -- Implementation

	variable_type: TYPE_A
		-- Type of the variable at which we are looking at.

	variable_name: STRING
		-- Name of the variable at which we are looking at.

	marked_ast_paths: HASH_TABLE[AST_EIFFEL, AST_PATH]
		-- Data structure mentioning all AST path strings that must not be removed.

	print_ast_path_prefix (l_as: AST_EIFFEL)
		do
			if attached l_as.path as l_path then
				io.put_string ("[" + l_path.as_string + "]        ")
			else
				io.put_string ("[UNKNOWN_AST_PATH]        ")
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			print_ast_path_prefix (l_as)
			io.put_string ("process_access_feat_as: " + l_as.access_name_8 + "%N")
			Precursor (l_as)
		end

	process_address_result_as (l_as: ADDRESS_RESULT_AS)
		do
			print_ast_path_prefix (l_as)
			io.put_string ("process_address_result_as: " + "%N")
			Precursor (l_as)
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			print_ast_path_prefix (l_as)
			io.put_string ("process_create_creation_as: " + l_as.target.access_name_8 + "." + l_as.call.access_name_8 + "%N")

			marked_ast_paths.force (l_as, l_as.path)
			Precursor (l_as)
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			print_ast_path_prefix (l_as)
			io.put_string ("process_access_id_as: " + l_as.access_name_8 + "%N")
			Precursor (l_as)
		end

	process_result_as (l_as: RESULT_AS)
		do
			print_ast_path_prefix (l_as)
			io.put_string ("process_result_as: " + l_as.access_name_8 + "%N")
			Precursor (l_as)
		end

end
