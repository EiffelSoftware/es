note
	description: "Summary description for {TEST_RED_A}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_RED_A
create
	make

feature {NONE} -- Initialization

	make
		do
			g := 2
		end
feature
	f : attached STRING
		do
			Result := "A.f"
		end

	g : INTEGER
end
