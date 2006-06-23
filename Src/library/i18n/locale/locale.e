indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOCALE
inherit
	SHARED_LOCALE_FACTORY

feature

	find_locale is
			-- find infos about locale of the user/os
		local
			locale: I18N_LOCALE_FACTORY
		do
--			locale := factory.get_locale
--				Error code: VKCN(3)
--				Type error: procedure call used as expression.
--				What to do: call a function or attribute rather than a procedure, or keep the procedure but use the call as instruction, not expression.
		ensure
		end
		



invariant
	invariant_clause: True -- Your invariant here

end -- class LOCALE
