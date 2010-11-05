note
	description: "Summary description for {SSA_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_PRINTER

inherit
	AST_ROUNDTRIP_PRINTER_VISITOR
		redefine
			process_feature_as,
			process_do_as
		end

	SSA_SHARED

	SHARED_SERVER

create
	make_for_ssa

feature
	name: STRING

	make_for_ssa
		do
			make_with_default_context
			setup (class_c.ast, match_list_server.item (class_c.class_id), True, False)
		end

	process
		do
			safe_process (class_c.ast)
		end


feature {NONE}
	process_this: BOOLEAN
	idx: INTEGER

	process_feature_as (l_as: FEATURE_AS)
			-- Process only the selected feature.
		do
			if l_as.feature_name.name_32.is_equal (feature_i.feature_name_32) then
				process_this := True
				idx := l_as.body.as_routine.end_keyword.last_token (match_list).index
				Precursor (l_as)
				process_this := False
			else
				Precursor (l_as)
			end
		end

	process_do_as (l_as: DO_AS)
		local
			ssa_printer: SSA_FEATURE_PRINTER
		do
			if process_this then
				safe_process (l_as.do_keyword (match_list))
				create ssa_printer.make
				l_as.process (ssa_printer)  -- ssa_printer.process_ast_node (l_as)
				last_index := idx
				context.add_string (ssa_printer.context + "%N")
			else
				Precursor (l_as)
			end

		end

end
