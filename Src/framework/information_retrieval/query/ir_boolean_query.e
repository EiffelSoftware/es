note
	description: "Class that represents a boolean query, which consists a list of terms"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_BOOLEAN_QUERY

inherit
	IR_QUERY

	IR_SHARED_EQUALITY_TESTERS

	DEBUG_OUTPUT

create
	make


feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create terms.make (10)
			terms.set_equality_tester (ir_term_equality_tester)
		end

feature -- Access

	terms: EPA_HASH_SET [IR_TERM]
			-- Terms that specify searching criteria

feature -- Process

	process (a_visitor: IR_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_boolean_query (Current)
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

	text: STRING
			-- String representation of Current
		local
			l_cursor: like terms.new_cursor
			l_fcursor: like returned_fields.new_cursor
		do
			create Result.make (1024)

				-- Print searchable terms.
			Result.append (once "%NSearchable terms:%N")
			from
				l_cursor := terms.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append_character ('%T')
				Result.append (l_cursor.item.full_text)
				Result.append_character ('%N')
				l_cursor.forth
			end

				-- Print returned fields.
			Result.append (once "%NReturned fields:%N")
			from
				l_fcursor := returned_fields.new_cursor
				l_fcursor.start
			until
				l_fcursor.after
			loop
				Result.append_character ('%T')
				Result.append (l_fcursor.item)
				Result.append_character ('%N')
				l_fcursor.forth
			end

				-- Print meta fields.
			if not meta.is_empty then
				Result.append (once "%NMeta:%N")
				across meta as l_meta loop
					Result.append_character ('%T')
					Result.append (l_meta.key)
					Result.append ({EPA_CONSTANTS}.query_value_separator)
					Result.append (l_meta.item)
					Result.append_character ('%N')
				end
			end
		end

end
