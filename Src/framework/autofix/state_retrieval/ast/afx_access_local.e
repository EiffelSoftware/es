note
	description: "Summary description for {AFX_LOCAL_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ACCESS_LOCAL

inherit
	AFX_ACCESS
		redefine
			is_local,
			length,
			type
		end

	AFX_SHARED_EXPR_TYPE_CHECKER

	SHARED_NAMES_HEAP

create
	make

feature{NONE} -- Initialization

	make (a_class: like context_class; a_feature: like context_feature; a_written_class: like written_class; a_name_id: INTEGER)
			-- Initialize Current with the `a_index'-th argument in `a_feature'.
		local
			l_locals: HASH_TABLE [LOCAL_INFO, INTEGER]
		do
			make_with_class_feature (a_class, a_feature, a_written_class)
			name_id := a_name_id

			l_locals := expression_type_checker.local_info (a_class, a_feature)
			info := l_locals.item (name_id)

			type :=
				actual_type_from_formal_type (
					info.actual_type.instantiation_in (context_class.actual_type, context_class.class_id).actual_type,
					a_class)
		end

feature -- Access

	index: INTEGER
			-- 1-based local index
		do
			Result := info.position
		end

	type: TYPE_A
			-- Type of current access

	text: STRING
			-- Text of current access
		do
			Result := names_heap.item (name_id)
		end

	length: INTEGER is 1
			-- Length of current access

	name_id: INTEGER
			-- Id to lookup local names in `names_heap'

	info: LOCAL_INFO
			-- Information of Current local

feature -- Status report

	is_local: BOOLEAN is True
			-- Is current access a local?


end
