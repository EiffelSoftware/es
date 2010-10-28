note
	description: "Abstract schema evolution handler class"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.2009"

class
	SCHEMA_EVOLUTION_HANDLER

	create
		make

feature{NONE} -- Versions matrix

	versions: DS_ARRAYED_LIST [DS_ARRAYED_LIST [DS_HASH_TABLE [TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]], STRING]]]
		-- A matrix that contains the transformation functions to be used between 2 versions.
		-- The hash table contains the variables names as a key and a function to evaluate the new field as a value.

feature -- Creation features

	make
			-- Default creation feature
		do
			create versions.make_default
		end


feature -- Basic operations

	set_conversion_function (from_v, to_v: INTEGER; funct: DS_HASH_TABLE [TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]], STRING])
			-- Add a function to convert version `from_v' to version `to_v'.
		require
			funct_exists: funct /= Void
			from_and_to_different: from_v /= to_v
		local
			i: INTEGER
			tmp: DS_ARRAYED_LIST [DS_HASH_TABLE [TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]], STRING]]
		do
			if to_v >= versions.count then
				from i := versions.count until i >= to_v loop
					versions.force_last (create {DS_ARRAYED_LIST [DS_HASH_TABLE [TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]], STRING]]}.make_default)
					i := i + 1
				end
			end
			tmp := versions.item (to_v)
			if from_v >= tmp.count then
				from i := tmp.count until i >= from_v loop
					--tmp.force_last (create {DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]}.make_default)
					tmp.force_last (void)
					i := i + 1
				end
			end
			tmp.force (funct, from_v)
		end

	create_schema_evolution_handler (to_v, from_v: INTEGER): DS_HASH_TABLE [TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]], STRING] 
			-- Returns the function to convert the version `from_v' to the version `to_v'.
		require
			from_and_to_different: from_v /= to_v
		local
			tmp: DS_ARRAYED_LIST[DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]
		do
			tmp := versions.item (to_v)
			Result := tmp.item (from_v)
		ensure
			can_convert_between_two_versions: Result /= Void
		end

invariant
	version_exists: versions /= Void
end
