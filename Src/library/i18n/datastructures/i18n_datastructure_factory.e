indexing
	description: "Datastructures' factory used for internationalization purposes."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DATASTRUCTURE_FACTORY

create {I18N_LOCALIZATOR}
	make_with_datasource

feature {NONE} -- Initialization

	make_with_datasource(a_datasource: I18N_DATASOURCE) is
			-- Create factory with datasource.
		require
			valid_datasource: a_datasource /= Void
		do
			i18n_datasource := a_datasource
			create {I18N_BYPASS_DATASTRUCTURE} last_datastructure.make_with_datasource(i18n_datasource)
		ensure
			datasource_set: i18n_datasource = a_datasource
		end

feature -- Access
	last_datastructure: I18N_DATASTRUCTURE
		-- Reference to the last datastructure

feature -- Basic operations
	use_hash_table is
			-- Create a datastructure using an hash table.
		do
			create {I18N_HASH_TABLE} last_datastructure.make_with_datasource(i18n_datasource)
		end

	use_dummy is
			-- Create a dummy datastructure.
		do
			create {I18N_BYPASS_DATASTRUCTURE} last_datastructure.make_with_datasource(i18n_datasource)
		end


feature {NONE} -- Implementation
	i18n_datasource: I18N_DATASOURCE
		-- Reference to the actual datasource

invariant
	valid_datastructure: last_datastructure /= Void

end
