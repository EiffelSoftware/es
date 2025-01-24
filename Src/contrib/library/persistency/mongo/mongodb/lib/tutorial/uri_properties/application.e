note
	description: "Example: show how to read a document"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			uri_mechanism_properties
		end

	uri_mechanism_properties
		local
		    uri: MONGODB_URI
		    props: detachable BSON
		    json: STRING_8
		do
		    	-- Create a new URI with GSSAPI authentication mechanism and properties
		 create uri.make (
        	"mongodb://user%%40DOMAIN.COM:password@localhost/?" +
        	"authMechanism=GSSAPI&" +
        	"authMechanismProperties=SERVICE_NAME:other,CANONICALIZE_HOST_NAME:true")

		    	-- Get mechanism properties
		    props := uri.auth_mechanism_properties

		    if attached props as l_props then
		       		-- Convert BSON to JSON and print it
		        json := l_props.bson_as_canonical_extended_json
		        print (json + "%N")
		    else
		        print ("No authMechanismProperties.%N")
		    end
		end

end
