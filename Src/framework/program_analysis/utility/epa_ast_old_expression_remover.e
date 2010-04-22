note
	description: "Printer to remove all old expressions of an AST"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_AST_OLD_EXPRESSION_REMOVER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_un_old_as
		end

create
	make_with_output

feature{NONE} -- Process

	process_un_old_as (l_as: UN_OLD_AS)
		do
			process_child (l_as.expr, l_as, 2)
		end

end
