indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class TAPE_ARCHIVE

create
	make

feature {NONE}

	make
			-- TODO
		do
			create tape
			is_loaded := tape /= Void
		ensure
			tape_not_void: tape /= Void
			loaded: is_loaded
		end

feature

	tape: TAPE
			-- TODO

	is_loaded: BOOLEAN
			-- TODO

	eject
		do
			tape := Void
			is_loaded := False
		ensure
			tape = Void
			not is_loaded
		end

	store (o: ANY)
			-- TODO
		require
			o /= Void
			is_loaded
		do
			tape.save (o)
		end

invariant
	is_loaded implies tape /= Void

end
