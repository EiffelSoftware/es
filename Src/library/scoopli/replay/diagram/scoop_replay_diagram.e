note
	description: "A class represents the SCOOP program structure - %
				%processors relationships (parent<-child),separate calls and locked processors."
	author: "Andrey Nikonov, Andrey Rusakov"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_REPLAY_DIAGRAM

inherit
	LINKED_LIST [ SCOOP_REPLAY_DIAGRAM_NODE ]

feature {ANY}

	add (a_proc: SCOOP_PROCESSOR)
			-- Extend processors list.
		local
			l_node : SCOOP_REPLAY_DIAGRAM_NODE
		do
			-- set processor alias
			a_proc.set_replay_diagram_number (count)
			create l_node.make (Current, a_proc)
			extend (l_node)
		end

	add_request ( caller_proc : SCOOP_PROCESSOR; routine : ROUTINE [ SCOOP_SEPARATE_TYPE, TUPLE ]; locked_proc : TUPLE [ SCOOP_PROCESSOR ] ; is_executed: BOOLEAN)
			-- Find caller processor.
			-- Save feature.
			-- Save locked processors.
		local
			l_node: SCOOP_REPLAY_DIAGRAM_NODE
			l_feature: SCOOP_REPLAY_DIAGRAM_FEATURE
			l_proc: SCOOP_PROCESSOR
			i: INTEGER
			is_routine_already_called: BOOLEAN
	do
		from
			start
		until
			after
		loop
			l_node := item
			if l_node.processor = caller_proc then
			is_routine_already_called := false
				from
					l_node.features.start
				until
					l_node.features.after
				loop
					if l_node.features.item.routine = routine then
						l_feature := l_node.features.item
						is_routine_already_called := true
					end
					l_node.features.forth
				end
				if is_routine_already_called then
					if is_executed then
						l_feature.set_executed
					end
				else
					create l_feature
					l_feature.set_pid ( caller_proc.processor_replay_diagram_number )
					l_feature.set_id ( counter )
					l_feature.set_routine ( routine )
					l_node.add ( l_feature )
					from
						i := locked_proc.lower
					until i > locked_proc.upper
					loop
						l_proc ?= locked_proc.item ( i )
						l_feature.extend ( l_proc )
						i := i + 1
					end
					counter := counter + 1
				end
			end
			forth
		end
	end

	set_profiler_information (a_prof_inf: SCOOP_PROFILER_INFORMATION)
			-- Set profile information.
		do
			profiler_information := a_prof_inf
		end

	serialize_to_dot (a_file_name: STRING)
			-- Save diagram into .dot file.
		local
			i, j, n: INTEGER
			struct: STRING
			l_feature_j, l_feature: SCOOP_REPLAY_DIAGRAM_FEATURE
			l_class_name, l_feature_name: STRING
			all_features, l_f: LINKED_LIST [SCOOP_REPLAY_DIAGRAM_FEATURE]
			foo: SCOOP_PROCESSOR
			lock_status: STRING
		do
			--io.putstring ( "Generating SCOOP program scheme...%N" )

			create file.make_open_write (a_file_name)
			create struct.make_empty
			create all_features.make
			file.put_string ( "digraph G { %N rankdir = LR %N compound = true %N ranksep = 2 %N pencolor = blue %N penwidth = 0.25	%N dpi = 96	%N node [shape = Mrecord, fontname = Arial, fontsize = 12] %N " )
			from
				start
				i := 0
			until
				after
			loop
				file.put_string ( "subgraph cluster" + i.out + "{ %N node [style=filled, color=white] %N rankdir = TB %N style = filled %N color = lightgrey %N fontsize = 16 %N	fontstyle = Arial %N" )
				file.put_string ( "label = %"Processor, p" + i.out + "%"%N" )
				struct := "struct" + i.out + " [ label = %"  "
				l_f := item.features
				from
					l_f.start
					j := 1
				until
					l_f.after
				loop
					l_feature := l_f.item
					l_class_name := class_name_of ( l_feature.routine )
					l_feature_name := feature_name_of ( l_feature.routine )
					if l_feature.is_executed then
						lock_status := "locked: "
					else
						lock_status := "try to lock: "
					end
					struct := struct + "< " + j.out + " > " + l_feature.global_id.out + ": " + l_class_name + ":" + l_feature_name + " ( " + lock_status
					l_feature.set_local_id ( j )
					from
						l_feature.start
					until
						l_feature.after
					loop
						if l_feature.item /= Void then
							struct := struct + "p" + l_feature.item.processor_replay_diagram_number.out + ", "
						end
						l_feature.forth
					end
					all_features.extend ( l_feature )
					struct.remove_tail ( 2 )
					struct := struct + " ) | "
					l_f.forth
					j := j + 1
				end
				struct.remove_tail ( 2 )
				struct := struct + "%"] %N"
				file.put_string ( struct )
				file.put_string ( "} %N%N" )
				forth
				i := i + 1
			end

			-- serialize processors relationships
			from
				start
				i := 1
			until
				after
			loop
				if item.parent /= Void and then item.parent.processor /= Void then
					file.put_string ( "    struct" + item.parent.processor.processor_replay_diagram_number.out + " -> struct" + item.processor.processor_replay_diagram_number.out )
					file.put_string ( " [ ltail = cluster" + item.parent.processor.processor_replay_diagram_number.out + " lhead = cluster" + item.processor.processor_replay_diagram_number.out + ", arrowhead = dot, style = dotted, arrowsize = 0.5 ] %N" )
				end
				forth
				i := i + 1
			end

			file.put_string ( "%N" )

			--serializing directed links for separate calls
			n := all_features.count
			from
				i := 1
			until
				i > n
			loop
				l_feature := all_features.i_th ( i )
				from
					j := 1
				until
					j > n
				loop
					l_feature_j := all_features.i_th ( j )

					if ( l_feature.global_id + 1 = l_feature_j.global_id )
						and ( l_feature.global_id < l_feature_j.global_id )
						and ( l_feature.pid /= l_feature_j.pid ) then

						file.put_string ( "struct" + l_feature.pid.out + ":" + l_feature.local_id.out + " -> struct" + l_feature_j.pid.out + ":" + l_feature_j.local_id.out )
						file.put_string (  " [ arrowhead = vee, arrowsize = 0.5 ] %N" )

					end

					j := j + 1
				end

				i := i + 1
			end

			file.put_string ( "}%N" )

			file.close
		end


feature {NONE} -- Implementation

	feature_name_of (a_feature: ROUTINE [ANY, TUPLE]): STRING
			-- What's the name of `a_feature`?
		require
			feature_not_void: a_feature /= Void
		local
			l_class : SCOOP_PROFILER_CLASS_INFORMATION
			l_feature : SCOOP_PROFILER_FEATURE_INFORMATION
		do
			l_class := profiler_information.classes.item (class_id_of (a_feature))
			if l_class /= Void then
				l_feature := l_class.features.item (feature_id_of (a_feature))
				if l_feature /= Void then
					Result := l_feature.name
				else
					Result := {SCOOP_LIBRARY_CONSTANTS}.default_feature_name + a_feature.feature_id.out
				end
			else
				Result := {SCOOP_LIBRARY_CONSTANTS}.default_feature_name + a_feature.feature_id.out
			end
		ensure
			result_valid: Result /= Void and then not Result.is_empty
		end

	feature_id_of (a_feature: ROUTINE [ANY, TUPLE]): INTEGER
			-- What's the id of `a_feature`?
		require
			a_feature /= Void
		do
			Result := a_feature.feature_id
		ensure
			result_positive: Result > 0
		end

	class_name_of (a_feature: ROUTINE [ANY, TUPLE]): STRING
			-- What's the class name of `a_object`?
		require
			feature_not_void: a_feature /= Void
		local
			l_res : SCOOP_PROFILER_CLASS_INFORMATION
		do
			l_res := profiler_information.classes.item ( class_id_of (a_feature))
			if l_res /= Void then
				Result := l_res.name
			else
				Result := {SCOOP_LIBRARY_CONSTANTS}.default_class_name + a_feature.class_id.out
			end
		ensure
			result_valid: Result /= Void and then not Result.is_empty
		end

	class_id_of (a_feature: ROUTINE [ANY, TUPLE]): INTEGER
			-- What's the class id of `a_object`?
		require
			feature_not_void: a_feature /= Void
		do
			Result := a_feature.class_id + 1
		ensure
			result_positive: Result > 0
		end


	file: PLAIN_TEXT_FILE
		-- Output text format .dot file

	counter: INTEGER
		-- Global counter for all separate calls

	profiler_information: SCOOP_PROFILER_INFORMATION
		-- Table of class and feature names


end
