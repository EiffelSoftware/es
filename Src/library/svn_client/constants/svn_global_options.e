note
	description: "Constants for Subversion global options"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_GLOBAL_OPTIONS

feature -- Global options

	username: STRING_8 do Result := "--username" end
	password: STRING_8 do Result := "--password" end
	no_authentication_cache: STRING_8 do Result := "--no-auth-cache" end
	non_interactive: STRING_8 do Result := "--non-interactive" end
	trust_server_certificates: STRING_8 do Result := "--trust-server-cert" end

end
