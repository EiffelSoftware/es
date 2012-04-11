indexing
	description: "[
			Installation of special translators and TypeHandlers to make db4o work with Eiffel,
		]"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_CONFIGURATION

create
	configure

feature -- Configuration

	configure is
			-- Do global configuration for db4o transactions.
		do
			install_translators
		end

   	install_translators is
   			-- Install translator for POINTER.
	    local
	    	pointer_translator: POINTER_TRANSLATOR
   		do
			create pointer_translator.make
			configuration.object_class (({POINTER}).to_cil).translate (pointer_translator)
   		end

	configuration: CONFIGURATION is
			-- Global configuration for db4o transactions
		once
			create Result.make_global
		end


end
