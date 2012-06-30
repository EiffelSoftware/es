note
	description: "This error indicates that some operation didn't meet the ACID requireents for transactions and therefore it has been aborted"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TRANSACTION_CONFLICT
inherit
	PS_ERROR

feature

	description:STRING = "Transaction error"

	accept (a_visitor: PS_ERROR_VISITOR)
		do
			a_visitor.visit_transaction_error (Current)
		end


end
