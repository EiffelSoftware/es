indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ENIGMA
create
	make
feature -- Access

feature -- Measurement
make is
		--
	local
		e:ENIGMA
		val:STRING
		en:STRING
		de:STRING
		my:HASH_TABLE[CHARACTER,CHARACTER]
	do
		create e.make(20)
		val:="lssilva@gmail.com"
		en:= e.encrypt (val)
		io.put_string("en value= " + en +"%N")

		de:= e.decrypt (en)
		io.put_string("en value= " + de +"%N")


	end

feature -- Status report


feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
