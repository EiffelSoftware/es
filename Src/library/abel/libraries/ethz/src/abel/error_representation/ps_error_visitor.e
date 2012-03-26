note
	description: "Part of the visitor pattern for errors. This class allows the users of the library to implement their own error handling mechanism, making use of polymorphism (instead of some big if-else statements)"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_ERROR_VISITOR

feature

	visit (an_error:PS_ERROR)
		do
			an_error.accept (Current)
		end


	visit_no_error (no_error:PS_NO_ERROR)
			-- When no error occured, doing nothing is a reasonable default.
		do
		end

	visit_transaction_error (transaction_error:PS_TRANSACTION_ERROR)
		deferred
		end

end
