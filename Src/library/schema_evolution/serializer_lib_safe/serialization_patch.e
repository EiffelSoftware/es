indexing
	description: "Abstract Patch class"
	author: "Teseo Schneider"
	date: "5.03.2009"

class
	SERIALIZATION_PATCH

	create
		make

feature{NONE} -- Versions switch

	-- versions: DS_ARRAYED_LIST[DS_ARRAYED_LIST[DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]]
	versions: ARRAYED_LIST[ARRAYED_LIST[HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]]
		-- A matrix that contains the transformation functions to be used between 2 versions.
		-- The hash table contains the variables names as a key and a function to evaluate the new field as a value.

feature -- Creation features

	make
			-- Default creation feature
		do
			-- create versions.make_default
			create versions.make (10)
		end


feature -- Setters

	-- set_conversion_function (from_version: INTEGER; to_version: INTEGER; funct: DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]) is
	set_conversion_function (from_version: INTEGER; to_version: INTEGER; funct: HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]) is
			-- Add a function to convert the version "from" into the version "to"
		require
			funct_exists: funct/=Void
			-- for_and_to_different: from_version/=to
			for_and_to_different: from_version/=to_version
		local
			i: INTEGER
			-- tmp:DS_ARRAYED_LIST[DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]
			tmp:ARRAYED_LIST[HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]
		do
			-- if to>=versions.count then
			if to_version>=versions.count then
				-- from i:=versions.count until i>=to loop
				from i:=versions.count until i>=to_version loop
					-- versions.force_last (create {DS_ARRAYED_LIST[DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]}.make_default)
					versions.force (create {ARRAYED_LIST[HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]}.make (10))
					i:=i+1
				end
			end
			-- tmp:=versions.item (to)
			tmp:=versions.i_th (to_version)

			if from_version>=tmp.count then
				from i:=tmp.count until i>=from_version loop
					--tmp.force_last (create {DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]}.make_default)
					tmp.force (void)
					i:=i+1
				end
			end

			-- tmp.force (funct, from_version)
			tmp.put_i_th (funct, from_version)
		end

feature -- Getters

	-- patch (to, from_version: INTEGER): DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING] is
	patch (to, from_version: INTEGER): HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING] is
			-- Get the function to convert the version from into the version to
		require
			from_and_to_different: from_version/=to
		local
			-- tmp:DS_ARRAYED_LIST[DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]
			tmp:ARRAYED_LIST[HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE[LIST[ANY]],ANY]],STRING]]
		do
			-- tmp:=versions.item (to)
			tmp:=versions.i_th (to)

			-- Result:=tmp.item (from_version)
			Result:=tmp.i_th (from_version)
		ensure
			can_convert_to_for: Result/=Void
		end

invariant
	version_exists: versions /=Void
end
