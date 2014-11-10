class
	CAT_USELESS_CONTRACT

feature {NONE} -- Test

	preconditions (a_int: detachable CAT_USELESS_CONTRACT; a_string1, a_string2: attached CAT_UNUSED_ARGUMENT)
		require
			void_check: a_int /= Void
			a_string1 /= Void
			check_void: a_string2 /= Void
		do
			do_nothing
		end

end
