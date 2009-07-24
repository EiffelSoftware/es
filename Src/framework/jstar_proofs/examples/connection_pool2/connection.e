note
	description: "A database connection."
	author: "Stephan van Staden"
	date: "9 June 2009"
	revision: "$Revision$"

deferred class
	CONNECTION

feature

	close
		require
			--SL-- |
		deferred
		ensure
			--SL-- |
		end

end
