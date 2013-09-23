note
	description: "Summary description for {JSON_DOCUMENT_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_DOCUMENT_CONVERTER


inherit
    JSON_CONVERTER

create
    make

feature {NONE} -- Initialization

    make
        local
            ucs: STRING_32
        do
            create ucs.make_from_string ("")
            create object
            create value.make -- void safety addition
        end

feature -- Access

    value: JSON_OBJECT

    object: DOCUMENT

feature -- Conversion

    from_json (j: like value): like object
        local
            jkeys : ARRAY[JSON_STRING]
            i:INTEGER
            parser : JSON_PARSER
            a_data : STRING
            -- removed obsolete ucs which was used for reverse assignment
        do
            jkeys := j.current_keys
            create Result
            from
            	i := 1
            until
            	i > jkeys.count
            loop
            	if (jkeys.item (i).is_equal (id_key)) then
            		 if attached {STRING_32} json.object (j.item (id_key), Void) as ucs then -- removed obsolete ?=
            		 	Result.set_id (ucs)
            		 end
         		elseif (jkeys.item (i).is_equal (revision_key)) then
         			if attached {STRING_32} json.object (j.item (revision_key), Void) as ucs then -- removed obsolete ?=
             			Result.set_revision (ucs)
         			end
         		else
         			if attached {STRING_32} json.object (j.item (jkeys.item (i)), Void) as ucs then -- removed obsolete ?=
         				a_data :="{"+ jkeys.item (i).representation + ":%""+ ucs.out+"%"}"
         				create parser.make_parser (a_data)
         				if attached parser.parse as json_data then -- void safety addition - data not required for a document
         					Result.set_data (json_data)
         				end
         			end
         		end
         		i := i + 1
            end
        end

    to_json (o: like object): like value
        local
        	jkeys : ARRAY[JSON_STRING]
        	i : INTEGER
        	-- removed obsolete jo and a_value which were used for reverse assignment
        do
            create Result.make
            Result.put (json.value (o.id), id_key)
            Result.put (json.value (o.revision),revision_key)

            if attached {JSON_OBJECT} o.data as jo then -- removed obsolete ?=
            	jkeys := jo.current_keys
            	from
            		i := 1
            	until
            		i > jkeys.count
            	loop
            		if attached {JSON_STRING} jo.item (jkeys.at (i)) as a_value then -- removed obsolete ?=
						Result.put (a_value,jkeys.at (i))
					end
					i := i + 1
            	end
            end
        end

feature    {NONE} -- Implementation

    id_key: JSON_STRING
        once
            create Result.make_json ("_id")
        end

	revision_key: JSON_STRING
        once
            create Result.make_json ("_rev")
        end

end -- class JSON_DOCUMENT_CONVERTER
