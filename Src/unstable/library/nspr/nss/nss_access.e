note
	description: "{NSS_ACCESS} povides access to the NSS object."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NSS_ACCESS

feature
	nss: separate NSS
		once
			create Result.make
		end
end
