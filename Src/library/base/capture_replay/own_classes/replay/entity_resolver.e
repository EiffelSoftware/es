indexing
	description: "Object that's responsible for resolving entities to objects"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY_RESOLVER

inherit
	INTERNAL

	ENTITY_VISITOR

create
	make

feature	 -- Initialization

	make is
			-- Create an entity resolver
		do
			create entities.make (0, 128)
			-- the Object with id 0 is defined to be Void.
			entities[0] := Void
		end

feature -- Access

	resolve_entity(entity: ENTITY): ANY
			-- Resolve `entity' to a real object. Create the
			-- object if necessary.
		require
			entity_not_void: entity /= Void
		do
			Result := entity.resolve(Current)
		ensure
			only_void_entities_resolved_to_void: (Result = Void) implies represents_void(entity)
		end

	resolve_entities (arguments: DS_LIST[ENTITY]): DS_LIST[ANY] is
			-- Resolve all entities from `arguments'.
		require
			arguments_not_void: arguments /= Void
		local
			i: INTEGER
		do
			from
				create {DS_ARRAYED_LIST[ANY]}Result.make(arguments.count)
				i := 1
			until
				i >arguments.count
			loop
				Result.put_last (resolve_entity(arguments @ i))
				i := i + 1
			end
		end

	register_object(object: ANY; entity: NON_BASIC_ENTITY) is
			-- Register `object' in the object lookup table.
		require
			object_not_void: object /= Void
			entity_not_void: entity /= Void
			no_different_object_for_same_id: entities[entity.id] /= Void implies object = entities[entity.id]
		do
			if entities[entity.id] = Void then
				entities[entity.id] := object
				object.cr_set_object_id(entity.id)
			end
		ensure
			entity_registered: entities[entity.id] = object
		end

	visit_basic_entity(basic: BASIC_ENTITY): ANY is
				-- Resolve `basic' to an object representing a basic type.
			local
				special_size: INTEGER
			do
				--hmm... do some magic ;)
				if basic.type.is_equal ("REAL_32") then
					Result := basic.value.to_real
				elseif basic.type.is_equal("INTEGER_32") then
					Result := basic.value.to_integer
				elseif basic.type.is_equal("BOOLEAN") then
					Result := basic.value.to_boolean
				elseif basic.type.substring_index("SPECIAL",1) = 1 then
					-- There's no need to register this SPECIAL, because it's only used as
					-- manifest type --> no references will be passed beyond the border.
					Result := create_special_entity (basic)
				--TODO: load the values into the special.
				else
					check False end --not implemented yet.
				end
			ensure then
				result_not_void: Result /= Void
			end

	visit_non_basic_entity(non_basic: NON_BASIC_ENTITY): ANY is
			-- Resolve `non_basic' to an object representing a non basic type.
			do
				if entities.upper < non_basic.id then
					entities.resize (0, non_basic.id * 2)
				end

				if entities[non_basic.id] = Void then
					create_entity(non_basic)
				end

				Result := entities[non_basic.id]
			ensure then
				non_void_entity_resolved: (non_basic.id /= 0) implies (Result /= Void)
				object_id_matches: non_basic.id = Result.cr_object_id
			end

	create_entity(non_basic: NON_BASIC_ENTITY)
			-- Create an object representing `non_basic'
		require
			non_basic_not_void: non_basic /= Void
		local
			new_object: ANY
			dtype: INTEGER
			special_element_count: INTEGER
		do
			dtype := dynamic_type_from_string(non_basic.type)
			if not is_special_type (dtype) then
				new_object := new_instance_of(dtype)
				entities[non_basic.id] := new_object
				entities[non_basic.id].cr_set_object_id (non_basic.id)
			else
				-- XXX not implemented yet. how can the size of the special
				-- be determined???
--				special_element_count =
--				new_special_any_instance (dtype, count: INTEGER_32)
			end
		ensure
			entity_created: entities[non_basic.id] /= Void
			correct_type_created: entities[non_basic.id].generating_type.is_equal (non_basic.type)
		end

	entities: ARRAY[ANY]

	represents_void(entity: ENTITY): BOOLEAN
			-- Does `entity' represent a Void?
		require
			entity_not_void: entity /= Void
		local
			non_basic: NON_BASIC_ENTITY
		do
			non_basic ?= entity
			if non_basic /= Void then
				Result := non_basic.id = 0
			else
				Result := False
			end
		end

feature -- Internal (this routines _should_ belong to the INTERNAL class)

	create_special_entity(basic: BASIC_ENTITY): SPECIAL[ANY] is
			--
		local
			type:STRING
			dtype: INTEGER
			special_size: INTEGER
			item_type: STRING
			item_dtype: INTEGER
		do
			dtype := dynamic_type_from_string(basic.type)

			if is_special_type(dtype) then
				special_size := basic.value.occurrences (',') + 1

				if is_special_any_type(dtype) then
					Result := new_special_any_instance (dtype, special_size)
				else
					type := basic.type
						-- It's safe to assume that there's only 1 pair of '[]', because the item type is a basic type.
					item_type := type.substring (type.index_of ('[', 1) + 1, type.index_of(']',1) -1)
					item_dtype := dynamic_type_from_string(item_type)
					inspect item_dtype
					when character_8_type then
						Result := create {SPECIAL [CHARACTER_8]}.make (special_size)
					else
						-- XXX implement this for all basic types.
					end
				end
			else
				-- TODO: report error
			end
		end

invariant
	invariant_clause: True -- Your invariant here

end
