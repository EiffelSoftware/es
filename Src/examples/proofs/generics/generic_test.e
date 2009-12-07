indexing
	description: "Summary description for {GENERIC_TEST}."
	date: "$Date$"
	revision: "$Revision$"

class
	GENERIC_TEST

create
	make

feature

	make is
			--
		indexing
--		proof: False
		local
			any_cell: GENERIC_CELL [ANY]
			integer_cell: GENERIC_CELL [INTEGER]
		do
			create any_cell.set_item (Current)
			create integer_cell.set_item (7)

			check
				any_cell.item = Current
				integer_cell.item = 7
			end
		end


end
