note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_FACTORY

inherit
    AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER

create
    default_create

feature -- factory methods

	get_simple_extractor: AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR
			-- make a simple extractor
		require
		    manager_not_void: boolean_state_outline_manager /= Void
		local
		    l_manager: like boolean_state_outline_manager
		    l_extractors: DS_BILINEAR[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I]
		    l_extractor_cell: CELL[detachable AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR]
		    l_tbl: DS_HASH_TABLE [AFX_BOOLEAN_STATE_OUTLINE, INTEGER]
		do
		    l_manager := boolean_state_outline_manager
		    l_extractors := l_manager.keys

				-- search for the same type in the registered extractors
		    create l_extractor_cell.put (Void)
		    l_extractors.do_if (
		    		agent (an_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I; an_cell: CELL[detachable AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR])
		    				do
		    					if attached {AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR} an_extractor as l_extractor then an_cell.put (l_extractor) end
		    				end (?, l_extractor_cell),
		    		agent (an_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I): BOOLEAN
		    				do if an_extractor.id = {AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR}.id then Result := True end end)

		    if attached l_extractor_cell.item as l_extractor then
		        	-- already exist
		        Result := l_extractor
		    else
		        	-- create and register
		        create Result
		        create l_tbl.make_default
		        l_manager.force (l_tbl, Result)
		    end
		end
end
