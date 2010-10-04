note
	description: "Summary description for {GENERATOR_DEF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GENERATOR_DEF

inherit
	SYMBOL_DEF

create
	make_gen

feature
	make_gen (str: STRING)
		do
			make_pred (str, 1)
		end

end
