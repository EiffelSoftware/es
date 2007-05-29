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

	register_object(object: OBSERVABLE; entity: NON_BASIC_ENTITY) is
			-- Register `object' in the object lookup table.
		require
			object_not_void: object /= Void
			entity_not_void: entity /= Void
			no_different_object_for_same_id: entities[entity.id] /= Void implies object = entities[entity.id]
		do
			if entities[entity.id] = Void then
				entities[entity.id] := object
				object.set_object_id(entity.id)
			end
		ensure
			entity_registered: entities[entity.id] = object
		end

	visit_basic_entity(basic: BASIC_ENTITY): ANY is
				-- Resolve `basic' to an object representing a basic type.
			do
				--hmm... do some magic ;)
				if basic.type.is_equal ("REAL_32") then
					Result := basic.value.to_real
				elseif basic.type.is_equal("INTEGER_32") then
					Result := basic.value.to_integer
				elseif basic.type.is_equal("BOOLEAN") then
					Result := basic.value.to_boolean
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
				-- this  is not possible until ANY contains 'observable's' functionality
				-- object_id_mathes: non_basic.id = Result.object_id
			end

	create_entity(non_basic: NON_BASIC_ENTITY)
			-- Create an object representing `non_basic'
		require
			non_basic_not_void: non_basic /= Void
		local
			observable: OBSERVABLE
		do
			 observable ?= new_instance_of(dynamic_type_from_string(non_basic.type))
			 entities[non_basic.id] := observable
			check
				--this is an observable, otherwise it would not be possible to have an object Id during capturing.
				resolved_entity_is_obserable: entities[non_basic.id] /= Void
			end
			entities[non_basic.id].set_object_id (non_basic.id)
		end

	entities: ARRAY[OBSERVABLE]

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

invariant
	invariant_clause: True -- Your invariant here

end
