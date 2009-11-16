indexing
	description: "CONCURRENCY encapsulates facility routines for SCOOP."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

deferred class
	SCOOP_CONCURRENCY

inherit
	THREAD_CONTROL

--feature {NONE} -- Help routines for wrapping agents		
--		
--	agent_wrapper (an_object: ANY): FUNCTION [ANY, TUPLE, like an_object] is
--			-- Agent associated with feature `same'.
--		do
--			Result := agent same_wrapper (an_object)
--		end
--		
--	same_wrapper (an_object: ANY): like an_object is
--			-- Function returning object itself.
--		do
--			Result := an_object
--		end		

end -- class CONCURRENCY
