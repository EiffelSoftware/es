indexing
	description: "Objects that represent separate proxies for%
		%objects based on class RUNTIME_METHOD_HANDLE"
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

class SCOOP_SEPARATE__RUNTIME_METHOD_HANDLE 

inherit
	SCOOP_SEPARATE__ANY
	rename implementation_ as any_implementation_, make_from_local as any_make_from_local end

create
	make_from_local, set_processor_

convert
	make_from_local ({RUNTIME_METHOD_HANDLE})

feature -- Separateness
	implementation_: RUNTIME_METHOD_HANDLE

	default_create_scoop_separate_runtime_method_handle (a_caller_: SCOOP_SEPARATE_CLIENT) is
			-- Wrapper for creation procedure `default_create'.
		
		do
			scoop_asynchronous_execute (a_caller_, agent effective_default_create_scoop_separate_runtime_method_handle)
		end

	effective_default_create_scoop_separate_runtime_method_handle is
			-- Wrapper for creation procedure `default_create'.
		do
			create implementation_
		end

	make_from_local (l: like implementation_) is
			-- Convert from local object.
			-- Note that `processor_' will be void unless `l' is a separate client and its processor is set.
		local
			a_separate_client: SCOOP_SEPARATE_CLIENT
		do
			implementation_ := l
			a_separate_client ?= l
			if a_separate_client /= void then
				processor_ := a_separate_client.processor_
			else
				processor_ := void			
			end
		ensure
			implementation_ = l
		end
end