indexing
	description: "Object to access windows' registry."
	author: "Ilinca Ciupa"
	date: "$Date$"
	revision: "$Revision$"

    class
    	AUT_REGISTRY
    
    inherit
    	WEL_REGISTRY_ACCESS_MODE
    	export
    		{NONE} all
    	end

feature -- Access

	string_value (key_name: STRING): STRING is
			-- Given a `key_name' with path returns the value of the key.
       local
           registry: WEL_REGISTRY
           key_value: WEL_REGISTRY_KEY_VALUE
           last_index_of_slash: INTEGER
           key_path, key_value_name: STRING
       do
           create registry
           last_index_of_slash := key_name.last_index_of ('\', key_name.count)
           if
               last_index_of_slash > 1 and
               key_name.count > last_index_of_slash
           then
               key_path := key_name.substring (1, last_index_of_slash - 1)
               key_value_name := key_name.substring (last_index_of_slash + 1, key_name.count)
               key_value := registry.open_key_value (key_path, key_value_name)
               if key_value /= Void then
                   Result := key_value.string_value
                   registry.close_key (key_value.data.item)
               end
           end
       end

feature -- Status report

   is_available: BOOLEAN is True

end
