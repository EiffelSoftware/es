note
	description: "Blackboard data for a feature."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_FEATURE_DATA

inherit

	EBB_CHILD_ELEMENT [EBB_CLASS_DATA, EBB_FEATURE_DATA]

	EBB_FEATURE_ASSOCIATION

	SHARED_WORKBENCH
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_feature: attached FEATURE_I)
			-- Initialize empty feature data associated to `a_feature'.
		do
			make_with_feature (a_feature)

			create tool_results.make
		ensure
			consistent: system.class_of_id (class_id) = a_feature.written_class
			consistent2: associated_feature.rout_id_set ~ a_feature.rout_id_set
		end

feature -- Access

	verification_score: REAL
			-- Combined verification score.
		local
			l_static: REAL
			l_dynamic: REAL
		do
			l_static := static_score
			l_dynamic := dynamic_score
			if l_static = {EBB_VERIFICATION_SCORE}.not_verified and l_dynamic = {EBB_VERIFICATION_SCORE}.not_verified then
				Result := {EBB_VERIFICATION_SCORE}.not_verified
			elseif l_dynamic = {EBB_VERIFICATION_SCORE}.not_verified then
				if l_static = {EBB_VERIFICATION_SCORE}.failed then
					Result := {EBB_VERIFICATION_SCORE}.failed
				else
					Result := l_static * 0.5
				end
			elseif l_static = {EBB_VERIFICATION_SCORE}.not_verified then
				if l_dynamic = {EBB_VERIFICATION_SCORE}.failed then
					Result := {EBB_VERIFICATION_SCORE}.failed
				else
					Result := l_dynamic * 0.5
				end
			else
				if l_dynamic = {EBB_VERIFICATION_SCORE}.failed then
					Result := {EBB_VERIFICATION_SCORE}.failed
				elseif l_static = {EBB_VERIFICATION_SCORE}.failed then
					Result := l_dynamic * 0.5
				else
					Result := (l_dynamic + l_static) * 0.5
				end
			end


--			if l_static < 0.0 and l_dynamic < 0.0 then
--				Result := -1.0
--			elseif l_static < 0.0 then
--				Result := l_dynamic * 0.5
--			elseif l_dynamic < 0.0 then
--				Result := l_static * 0.5
--			else
--				if l_static = 0.0 or l_dynamic = 0.0 then
--					Result := 0.0
--				else
--					Result := (l_static + l_dynamic) * 0.5
--				end
--			end
		end

	static_score: REAL
			-- Score of static verification tools.
		local
			l_tool: EBB_TOOL
			l_done: BOOLEAN
		do
			Result := {EBB_VERIFICATION_SCORE}.not_verified
			from
				tool_results.start
			until
				tool_results.after or l_done
			loop
				l_tool := tool_results.item.tool
				if l_tool.category = {EBB_TOOL_CATEGORY}.static_verification then
					Result := tool_results.item.score
					l_done := True
				end
				tool_results.forth
			end
		end

	dynamic_score: REAL
			-- Score of dynamic verification tools.
		local
			l_tool: EBB_TOOL
			l_done: BOOLEAN
		do
			Result := {EBB_VERIFICATION_SCORE}.not_verified
			from
				tool_results.start
			until
				tool_results.after or l_done
			loop
				l_tool := tool_results.item.tool_configuration.tool
				if l_tool.category = {EBB_TOOL_CATEGORY}.dynamic_verification then
					Result := tool_results.item.score
					l_done := True
				end
				tool_results.forth
			end
		end

	message: STRING
			-- Latest message to be displayed.
		do
			if tool_results.is_empty then
				Result := ""
			else
				Result := tool_results.first.message
			end
		end

	tool_results: LINKED_LIST [EBB_VERIFICATION_RESULT]
			-- List of tool results.

feature -- Status report

	has_verification_score: BOOLEAN
			-- Is a verification score set?
		do
			Result := verification_score >= 0.0
		end

	is_stale: BOOLEAN
			-- Is data stale?
		do
			if static_score >= 0 then
				Result := is_static_score_stale
			end
			if not Result and dynamic_score >= 0 then
				Result := is_dynamic_score_stale
			end
		end

	is_dynamic_score_stale: BOOLEAN
			-- Is dynamic score stale?

	is_static_score_stale: BOOLEAN
			-- Is static score stale?

feature -- Element change

	add_tool_result (a_result: EBB_VERIFICATION_RESULT)
			-- TODO
		do
			tool_results.put_front (a_result)
			if a_result.tool.category = {EBB_TOOL_CATEGORY}.static_verification then
				is_static_score_stale := False
			elseif a_result.tool.category = {EBB_TOOL_CATEGORY}.dynamic_verification then
				is_dynamic_score_stale := False
			end
		end

feature -- Basic operations

	append_message (a_text_formatter: TEXT_FORMATTER)
			-- Append message to `a_text_formatter'.
		do
			if not tool_results.is_empty then
				a_text_formatter.add (tool_results.first.tool.name + ": ")
				tool_results.first.single_line_message (a_text_formatter)
			end
		end

	set_stale
			-- <Precursor>
		do
			is_dynamic_score_stale := True
			is_static_score_stale := True
		end

end
