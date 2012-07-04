note
	description: "Calls the appropriate features on the backend to insert objects"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_WRITE_EXECUTOR

inherit PS_EIFFELSTORE_EXPORT

create make

feature

	perform_operations (operation_plan:LIST[PS_OBJECT_GRAPH_PART];  transaction:PS_TRANSACTION)
		-- Performs the operations
		do
			across operation_plan as op_cursor  loop

				if attached{PS_SINGLE_OBJECT_PART} op_cursor.item as obj then

					if obj.write_operation = obj.write_operation.insert then
						backend.insert (obj, transaction)
					elseif obj.write_operation = obj.write_operation.update then
						backend.update (obj, transaction)
					elseif obj.write_operation = obj.write_operation.delete then
						backend.delete (obj, transaction)
					end

				elseif attached{PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]} op_cursor.item as coll then

					if coll.write_operation = coll.write_operation.insert then
						backend.insert_objectoriented_collection (coll, transaction)
					elseif coll.write_operation = coll.write_operation.update then
						check false end
					elseif coll.write_operation = coll.write_operation.delete then
						backend.delete_objectoriented_collection (coll, transaction)
					end
				elseif attached{PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]} op_cursor.item as coll then

					if coll.write_operation = coll.write_operation.insert then
						backend.insert_relational_collection (coll, transaction)
					elseif coll.write_operation = coll.write_operation.update then
						check false end
					elseif coll.write_operation = coll.write_operation.delete then
						backend.delete_relational_collection (coll, transaction)
					end

				end
			end
		end


	backend: PS_BACKEND_STRATEGY

	make (a_backend: PS_BACKEND_STRATEGY)
		do
			backend:= a_backend
		end


end
