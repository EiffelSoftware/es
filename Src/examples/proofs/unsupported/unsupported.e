indexing
	description: "Summary description for {UNSUPPORTED}."
	date: "$Date$"
	revision: "$Revision$"

class
	UNSUPPORTED

feature

	inspect_statement
		local
			a: INTEGER
		do
			inspect a
			when 1 then

			else

			end
		end

	 assignment_attempt
	 	local
	 		a: ANY
	 		b: STRING
	 	do
	 		b ?= a
	 	end

	object_test
		local
			a: ANY
		do
			if {b: STRING} a then

			end
		end

	rescue_clause
		do
		rescue
			retry
		end

	inline_agents
		local
			a: ANY
		do
			--a := agent do end
		end

	-- TODO: add expanded types example
	-- TODO: add b: BOOLEAN, b.do_nothing example

end
