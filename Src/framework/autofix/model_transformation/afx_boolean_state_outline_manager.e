note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_OUTLINE_MANAGER

inherit
    DS_HASH_TABLE [ DS_HASH_TABLE [AFX_BOOLEAN_STATE_OUTLINE, INTEGER], AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I]
    	rename
    	    make as make_hash_table,
    	    make_default as make_default_hash_table
    	end

    AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER
    	undefine
    	    is_equal, copy
    	end

    AFX_SHARED_SESSION
    	undefine
    	    is_equal, copy
    	end

create
    make, make_default

feature -- Initialization

	make (a_count: INTEGER)
			-- <Precursor>
		local
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		do
		    make_hash_table (a_count)
		    register_outline_extractors
		    l_extractor := extractor_of_type ({AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR})
		    set_effective_extractor (l_extractor)
		end

	make_default
			-- <Precursor>
		do
		    make (default_capacity)
		end

feature -- Access

	effective_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I assign set_effective_extractor
			-- Extractor currently effective.

feature -- Setting

	set_effective_extractor (a_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I)
			-- Set `effective_extractor' to be `a_extractor'.
		do
		    effective_extractor := a_extractor
		end

feature -- Query

	registered_classes: DS_LINEAR[CLASS_C]
			-- All classes with outlines extracted using `a_extractor'.
		local
		    l_list: DS_ARRAYED_LIST[CLASS_C]
		    l_class_ids: DS_BILINEAR[INTEGER]
		    l_system: SYSTEM_I
		do
		    l_system := autofix_config.eiffel_system
		    create l_list.make_default

		    if attached value (effective_extractor) as lt_table then
		        l_class_ids := lt_table.keys
		        from l_class_ids.start
		        until l_class_ids.after
		        loop
		            if attached l_system.class_of_id (l_class_ids.item_for_iteration) as lt_class then
						l_list.force_last (lt_class)
		            end
		            l_class_ids.forth
		        end
		    end

		    Result := l_list
		end

	boolean_class_outline (a_class: CLASS_C): detachable AFX_BOOLEAN_STATE_OUTLINE
			-- Query the boolean outline for `a_class', extracted using `a_extractor'.
		local
			l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			l_tbl: detachable DS_HASH_TABLE [AFX_BOOLEAN_STATE_OUTLINE, INTEGER]
			l_id: INTEGER
		do
		    l_id := a_class.class_id
		    l_extractor := effective_extractor
			l_tbl := value (l_extractor)
			check l_tbl /= Void end
        	if l_tbl.has (l_id) then
        	    	-- return the registered boolean outline for `a_class'
        	    Result := l_tbl.item (l_id)
	        else
	            	-- extract new boolean outline for `a_class' and register it
				Result := l_extractor.extract_boolean_class_outline (a_class)
				if Result /= Void then
    				l_tbl.force (Result, l_id)
				end
			end
		end

	extractor_of_type (a_type: TYPE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I]): AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			-- Extractor of type `a_type'.
		local
		    l_extractors: DS_BILINEAR[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I]
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		do
		    l_extractors := keys

				-- search for the same type in the registered extractors
		    from l_extractors.start
		    until l_extractors.after or else Result /= Void
		    loop
		        l_extractor := l_extractors.item_for_iteration
		        if attached a_type.attempt (l_extractor) as lt_extractor then
		            Result := lt_extractor
		        end
		        l_extractors.forth
		    end
		ensure
		    all_extractor_registered: Result /= Void
		end

	extractor_of_id (a_id: INTEGER): AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			-- Extractor of with id `a_id'.
		local
		    l_extractors: DS_BILINEAR[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I]
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		do
		    l_extractors := keys

				-- search for the same type in the registered extractors
		    from l_extractors.start
		    until l_extractors.after or else Result /= Void
		    loop
		        l_extractor := l_extractors.item_for_iteration
		        if l_extractor.id = a_id then
		            Result := l_extractor
		        end
		        l_extractors.forth
		    end
		ensure
		    all_extractor_registered: Result /= Void
		end

feature{NONE} -- Implementation

	register_outline_extractors
			-- Register all possible outline extractors.
		require
		    manager_empty: is_empty
		local
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		    l_outline_table: DS_HASH_TABLE [AFX_BOOLEAN_STATE_OUTLINE, INTEGER]
		do
	        create {AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR}l_extractor
	        create l_outline_table.make_default
	        force (l_outline_table, l_extractor)
		end
end
