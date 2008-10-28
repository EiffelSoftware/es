indexing
	description	: "AST representation of a modify statement."
	date		: "$Date$"
	revision	: "$Revision$"

class MODIFY_AS

inherit
	ASSERT_LIST_AS
		redefine
			process
		end

create
	make

feature -- Initialization

	make (a: like assertions; k_as: KEYWORD_AS) is
			-- Create new MODIFY AST node.
		do
			initialize (a)
			if k_as /= Void then
				modify_keyword_index := k_as.index
			end
		ensure
			modify_keyword_set: k_as /= Void implies modify_keyword_index = k_as.index
		end

feature -- Visitor

	process (v: AST_VISITOR) is
			-- process current element.
		do
			v.process_modify_as (Current)
		end

feature -- Roundtrip

	modify_keyword_index: INTEGER
			-- Index of keyword "modify" accosiated with this structure.

	modify_keyword (a_list: LEAF_AS_LIST): KEYWORD_AS
			-- Keyword "modify" accosiated with this structure.
		require
			a_list_not_void: a_list /= Void
		local
			i: INTEGER
		do
			i := modify_keyword_index
			if a_list.valid_index (i) then
				Result ?= a_list.i_th (i)
			end
		end

feature -- Properties

	is_else: BOOLEAN is
			-- Is the assertion list a modify else ?
		do
			-- Do nothing
		end

feature -- Roundtrip/Location

	first_token (a_list: LEAF_AS_LIST): LEAF_AS is
		do
			if a_list = Void then
				if assertions /= Void then
					Result := assertions.first_token (a_list)
				else
					Result := Void
				end
			elseif modify_keyword_index /= 0 then
				Result := modify_keyword (a_list)
			end
		end

	last_token (a_list: LEAF_AS_LIST): LEAF_AS is
		do
			if a_list = Void then
				if assertions /= Void then
					Result := assertions.last_token (a_list)
				else
					Result := Void
				end
			else
				if full_assertion_list /= Void then
					Result := full_assertion_list.last_token (a_list)
				elseif modify_keyword_index /= 0 then
					Result := modify_keyword (a_list)
				end
			end
		end

end
