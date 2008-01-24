indexing
	description	: "An example test class"
	date: "$Date$"
	revision: "$Revision$"

class
	MY_TEST_02

inherit
	CDD_TEST_CASE

feature -- Initialization

	test_windows2 is
			-- Lets test Explorer on Windows.
		indexing
			tag: "Win32.Explorer"
			tag: "Win32.xp"
		require
			really_weird: False
		do
		end

	test_linux is
			-- Lets test Gnome on Linux.
		indexing
			tag: "Linux.Gnome"
			tag: "covers.ROOT_CLASS.bar"
		do
			io.put_string ("Linux can be buggy...%N")
		ensure
			is_buggy: False
		end

	test_linux2 is
			-- Lets test Gnome on Linux.
		indexing
			tag: "Linux.Gnome"
			tag: "covers.ROOT_CLASS.bar"
		do
			io.put_string ("This one works...%N")
		ensure
			not_buggy: False
		end

	test_macos is
			-- Lets test iTunes on the new Leopard.
		indexing
			tag: "MacOS.Leopard.iTunes"
			tag: "covers.ROOT_CLASS.foo"
		require
			is_a_mac: True
		do
			io.put_string ("Everything works fine on Mac...%N")
		end

end
