note
	description: "Instruction without effect on the alias relation, prints out the alias relation."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

class
	PRINTOUT

inherit
	SIMPLE

create
	make

feature -- Initialization

	make (t: STRING)
			-- Build with tag `t'.
		require
				tag_exists: t /= Void
		do
			tag := t
		end

feature -- Basic operations
	update (a: ALIAS_RELATION)
			-- DO not change `a' , but print it.
		local
			title: STRING
		do
			title := "%NIntermediate printout"
			if not tag.is_empty then
				title := title + ", "+ tag
			end
			a.printout (title)
		end

feature -- Access

	tag: STRING
			-- Indication to be printed before alias relation.
			-- Nothing printed if empty.


feature -- Input and output

	out: STRING
			-- Produce printable representation of printout instruction.
		local
			args: STRING
		do
			args := ""
			if not tag.is_empty then
				args := "("+ tag + ")"
			end
			Result := tabs + "printout" + args + New_line
		end

invariant
	tag_exists: tag /= Void
end
