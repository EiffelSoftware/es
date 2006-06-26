indexing
	description: "Datastructures' factory used for internationalization purposes."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DATASTRUCTURE_FACTORY

create

	make

feature {NONE} -- Initialization

	make is
			-- Create factory.
		do
			create {I18N_BYPASS_DATASTRUCTURE} last_datastructure.make
		end

feature -- Access

	last_datastructure: I18N_DATASTRUCTURE
		-- Reference to the last datastructure

feature -- Basic operations

	use_hash_table is
			-- Create a datastructure using an hash table.
		do
			create {I18N_HASH_TABLE} last_datastructure.make
		end

	use_binary_search is
			-- Create a datastructure that uses binary search.
		do
			create {I18N_BINARY_SEARCH} last_datastructure.make
		end


	use_dummy is
			-- Create a dummy datastructure.
		do
			create {I18N_BYPASS_DATASTRUCTURE} last_datastructure.make
		end


feature {NONE} -- Implementation

invariant

end
