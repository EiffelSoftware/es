indexing
	description: "Datasources' factory used for internationalization purposes."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DATASOURCE_FACTORY

create
	make

feature {NONE} -- Initialization

	make is
			-- Creation procedure.
		do
			create {I18N_EMPTY_DATASOURCE} last_datasource.make_empty
		ensure
			valid_datasource: last_datasource /= Void
		end

feature -- Access

	last_datasource: I18N_DATASOURCE
		-- Reference to the last datasource

feature -- Basic operations

	use_mo_file (a_path: STRING) is
			-- Create a datasource using an MO file.
			-- last_datasource will be Void if the file is not a valid MO
		require
			valid_path: a_path /= Void
			not_empty_path: not a_path.is_empty
		local
			l_mo_parser: I18N_MO_PARSER
				-- Temporary parser
		do
			create l_mo_parser.make_with_path(a_path)
			if l_mo_parser.is_ready then
				last_datasource := l_mo_parser
			else
				last_datasource := Void
			end
		end

	use_empty_source is
			-- Create an empty datasource.
		do
			create {I18N_EMPTY_DATASOURCE} last_datasource.make_empty
		ensure
			valid_datasource: last_datasource /= Void
		end


feature {NONE} -- Implementation

invariant

	last_datasource /= Void implies last_datasource.is_ready

end
