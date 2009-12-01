note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_OUTLINE_MANAGER

inherit
    DS_HASH_TABLE [ DS_HASH_TABLE [AFX_BOOLEAN_STATE_OUTLINE, INTEGER], AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I]

    AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER
    	undefine
    	    is_equal, copy
    	end

create
    make, make_default

feature -- boolean outline query

	boolean_class_outline (a_class: CLASS_C; an_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I): AFX_BOOLEAN_STATE_OUTLINE
			-- query the boolean outline for `a_class'
		require
		    state_outline_registered: State_outline_manager.is_registered (a_class.class_id)
		    extractor_registered: has (an_extractor)
		local
			l_manager: AFX_QUERY_STATE_OUTLINE_MANAGER
			l_tbl: DS_HASH_TABLE [AFX_BOOLEAN_STATE_OUTLINE, INTEGER]
			l_id: INTEGER
		do
		    l_id := a_class.class_id
	        if attached item (an_extractor) as l_table then
	        	if l_table.has (l_id) then
	        	    	-- return the registered boolean outline for `a_class'
    	            Result := l_table.item (l_id)
    	            check Result /= Void end
    	        else
    	            	-- extract new boolean outline for `a_class' and register it
					Result := an_extractor.extract_boolean_class_outline (a_class)
					l_table.force (Result, l_id)
				end
			else
					-- extractor should always have been registered
			    check False end
	        end
		end

--feature -- operations

--feature{NONE} --implementation

--	register (a_state: AFX_MODEL_STATE)
--			-- register/update the outline for each component `AFX_STATE'
--		local
--		    l_state: AFX_STATE
--		    l_class: CLASS_C
--		    l_id: INTEGER
--		do
--		    from a_state.start
--		    until a_state.after
--		    loop
--		        l_state := a_state.item_for_iteration

--		        if not l_state.is_chaos then
--		            l_class := l_state.class_
--		            l_id := l_class.class_id
--        		    if is_registered (l_id) then
--        		        found_outline.accommodate (l_state)
--        		    else
--        		        register_new (l_state)
--        		    end
--		        end

--		        a_state.forth
--		    end
--		end

--	register_new (a_state: AFX_STATE)
--			-- register an outline for `a_state'
--		require
--		    not_registered: not is_registered (a_state.class_.class_id)
--		local
--		    l_outline: like found_outline
--		do
--		    create l_outline.make_for_state (a_state)
--		    put (l_outline, a_state.class_.class_id)
--		ensure
--		    registered: is_registered (a_state.class_.class_id)
--		end

end
