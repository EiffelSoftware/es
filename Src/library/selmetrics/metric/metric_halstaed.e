class
	METRIC_HALSTAED

inherit
	METRIC
	redefine
		make,
		evaluate,
		last_result,
		process_class,
		process_real_feature,
		process_group
	end

	QL_UTILITY

	QL_SHARED

	SHARED_SERVER

	METRIC_UTILITY

	AST_ITERATOR
	redefine
		process_assign_as,
		process_binary_as,
		process_unary_as,
		process_feature_as,
		process_type_dec_as
	end

create
	make

feature -- Creation Procedures

	make (item : QL_ITEM) is
		do
			ql_item := item
		ensure then
			ql_item_set : ql_item = item
		end

feature -- Evaluation

	evaluate is
		do
			-- reset the state of the metric (setting all fields to
			-- default values so previous computations are reset)
			reset

			-- process the item
			ql_item.process (Current)
		end

feature -- Debug

	debug_output : STRING is
		do
			Result := "HALSTAED METRIC%N"
			Result := Result + "mu_1:%T%T" + mu_1.out + "%N"
			Result := Result + "mu_2:%T%T" + mu_2.out + "%N"
			Result := Result + "N_1:%T%T" + N_1.out + "%N"
			Result := Result + "N_2:%T%T" + N_2.out + "%N"
			Result := Result + "%N"
			Result := Result + "length:%T%T" + length.out + "%N"
			Result := Result + "vocabulary:%T" + vocabulary.out + "%N"
			Result := Result + "volume:%T%T" + volume.out + "%N"
			Result := Result + "difficulty:%T" + difficulty.out + "%N"
			Result := Result + "effort:%T%T" + effort.out + "%N"
		end

feature -- Results (metrics)

	r_length_index : INTEGER is 1
	r_vocabulary_index : INTEGER is 2
	r_volume_index : INTEGER is 3
	r_difficulty_index : INTEGER is 4
	r_effort_index : INTEGER is 5

	last_result : QL_QUANTITY is
		local
			list : LIST[DOUBLE]
		do
			-- prepare result list
			create {LINKED_LIST[DOUBLE]}list.make
			list.extend (length)
			list.extend (vocabulary)
			list.extend (volume)
			list.extend (difficulty)
			list.extend (effort)

			-- prepare result and put list in it
			create Result.default_create
			Result.set_data (list)
		ensure then
			result_data_set : Result.data /= Void
		end


	length : DOUBLE is
		do
			Result := N_1 + N_2
		end

	vocabulary : DOUBLE is
		do
			Result := mu_1 + mu_2
		end

	volume : DOUBLE is
		local
			math : DOUBLE_MATH
		do
			create math
			if vocabulary = 0 then
				Result := 0
			else
				Result := length * math.log_2 (vocabulary)
			end
		end

	difficulty : DOUBLE is
		do
			Result := (mu_1 / 2) * (N_2 / 2)
		end

	effort : DOUBLE is
		do
			Result := difficulty * volume
		end

feature {NONE} -- Properties
	ql_item : QL_ITEM

	class_id : INTEGER
		-- the id of the class we are currently evaluating

feature {NONE} -- Implementation

	reset is
			-- resetting state of the metrics. this means setting the found
			-- operands and operators to zero and reinitialize the hashmap
			-- and linked list
		do
			create operators_map.make (max_num_of_operators)
			create {LINKED_LIST[STRING]}operands_list.make
			create {LINKED_LIST[STRING]}prev_locals.make

			-- we want object comparision not reference comparision
			operators_map.compare_objects
			operands_list.compare_objects
			prev_locals.compare_objects

			N_1 := 0
			N_2 := 0
		end

feature {NONE} -- Implementation (QL iterator)

	process_real_feature (l_as : QL_REAL_FEATURE) is
		local
			feature_i : FEATURE_I
		do
			feature_i := l_as.e_feature.associated_feature_i
			class_id := feature_i.access_class.class_id
			safe_process (feature_i.body)
		end

	process_class (l_as : QL_CLASS) is
		do
			-- process all features in the given class
			process_real_features_in_class (l_as)
		end

	process_group (l_as : QL_GROUP) is
		do
			-- process all classes in the given cluster
			process_classes_in_group (l_as)
		end

feature {NONE} -- Implementation (AST iterator)

	match_list : LEAF_AS_LIST is
		do
			Result := match_list_server.item(class_id)
		end

	found_operator (an_operator: STRING) is
			-- puts the operator in the operator hashmap if it wasn't
			-- there before, thus ensuring that the operator only
			-- occurs once in this hashmap. we then increase the number
			-- of overall found operators by 1.
		require
			an_operator_set : an_operator /= Void
			operator_map_set : operators_map /= Void
		do
			if not operators_map.has (an_operator) then
				operators_map.put (an_operator, an_operator)
			end
			N_1 := N_1 + 1
		ensure
			only_once : operators_map.occurrences (an_operator) = 1
			occurence_increased : N_1 = old N_1 + 1
		end

	found_operand (an_operand: STRING) is
			-- puts the operand in the operand list if it wasn't there
			-- before, thus ensuring the the operand only occurs once
			-- in this list. we then increase the number of overall
			-- found operands by 1.
		require
			an_operand_set : an_operand /= Void
			operands_list_set : operands_list /= Void
		do
			if not operands_list.has (an_operand) then
				operands_list.extend (an_operand)
				mu_2 := mu_2 + 1
			end
			N_2 := N_2 + 1
		ensure
			only_once : operands_list.occurrences (an_operand) = 1
			occurence_increased : N_2 = old N_2 + 1
		end

	is_operator_expression (an_expression : EXPR_AS) : BOOLEAN is
			-- this checks if the expression given is an operator expression.
			-- this means if it's a binary, unary or a parantheses expression.
		require
			an_expression_set : an_expression /= Void
		local
			binary : BINARY_AS
			unary : UNARY_AS
			bracket : PARAN_AS
		do
			binary ?= an_expression
			unary ?= an_expression
			bracket ?= an_expression
			Result := binary /= Void or unary /= Void or bracket /= Void
		end

	is_atomic_expression (an_expression : EXPR_AS) : BOOLEAN is
			-- this checks if the expression given is an atomic expression.
			-- this means we do not want string, integer etc. constants.
		require
			an_expression_set : an_expression /= Void
		local
			atomic : ATOMIC_AS
		do
			atomic ?= an_expression
			Result := atomic /= Void
		end

	process_assign_as (l_as : ASSIGN_AS) is
			-- process an assignment node in the AST
			--
			-- eg. target := source
 		do
			-- we have found an operator ':=' or '?='
			if l_as.assignment_symbol (match_list).is_accept then
				found_operator ("?=")
			else
				found_operator (":=")
			end

			-- we check if the source expression contains an operator
			-- expression we have to evaluate this one too. if not then
			-- the source might be an operand (if it's not an atomic
			-- expression).
			if not is_operator_expression (l_as.source) and then not is_atomic_expression (l_as.source) then
				found_operand (l_as.source.text (match_list))
			else
				l_as.source.process (Current)
			end

			-- the target is automatically always an operand so we
			-- put it into our list
			found_operand (l_as.target.text (match_list))
		end

	process_binary_as (l_as : BINARY_AS) is
			-- process a binary node in the AST
			--
			-- eg. left + right
		do
			-- we found a new operator so store it
			found_operator (l_as.operator_ast.name)

			-- the left handside of the expression could contain an operator
			-- expression or could be an operand.
			if not is_operator_expression (l_as.left) and then not is_atomic_expression (l_as.left) then
				found_operand (l_as.left.text (match_list))
			else
				l_as.left.process (Current)
			end

			-- the right handside of the expression could contain an operator
			-- expression or could be an operand
			if not is_operator_expression (l_as.right) and then not is_atomic_expression (l_as.right) then
				found_operand (l_as.right.text (match_list))
			else
				l_as.right.process (Current)
			end
		end

	process_unary_as (l_as : UNARY_AS) is
			-- process an unary node in the AST
			--
			-- eg. -expression
		do
			-- we found a new operator so store it
			found_operator (l_as.operator_ast.name)

			-- the expression could be an operand or it could contain
			-- some operator expression.
			if not is_operator_expression (l_as.expr) and then not is_atomic_expression (l_as.expr) then
				found_operand (l_as.expr.text (match_list))
			else
				l_as.expr.process (Current)
			end
		end

	process_feature_as (l_as: FEATURE_AS) is
			-- process a feature node in the AST
			--
			-- this removes all local variables from the previous
			-- feature before continuing parsing this feature
		local
			index : INTEGER
		do
			-- remove all found local variables as operands from the
			-- operands list so that they could get counted again
			if not prev_locals.is_empty then
				from
					prev_locals.start
				until
					prev_locals.after
				loop
					index := operands_list.index_of (prev_locals.item, 1)

					-- only remove if the local variable was really used as
					-- an operand
					if index /= 0 then
						operands_list.go_i_th (index)
						operands_list.remove
					end

					prev_locals.forth
				end

				-- wipe out the list
				prev_locals.wipe_out
			end

			-- do the rest
			Precursor (l_as)
		end

	process_type_dec_as (l_as: TYPE_DEC_AS) is
			-- process a type declaration AST
			--
			-- this only gets called in feature, so this means, we
			-- report here local variables and parameters
		do
			if not prev_locals.has (l_as.item_name (1)) then
				prev_locals.extend (l_as.item_name (1))
			end
		ensure then
			local_added : prev_locals.occurrences (l_as.item_name (1)) = 1
		end


feature {NONE} -- Properties

	max_num_of_operators : INTEGER is 32

	prev_locals : LIST[STRING]
			-- a list of local variables from the previous feature

	operators_map : HASH_TABLE[STRING,STRING]
			-- hash map to store which operators we already have
			-- seen (to get unique set of operators)

	operands_list : LIST[STRING]
			-- list of all seen operands. this list only contains
			-- unique elements

	mu_1 : DOUBLE is
			-- number of unique operators
		require
			operators_map_set: operators_map /= Void
		do
			Result := operators_map.count
		end

	mu_2 : DOUBLE
			-- number of unique operands

	N_1 : DOUBLE
			-- total occurences of operators

	N_2 : DOUBLE
			-- total occurences of operands

invariant
	ql_item_set : ql_item /= Void

end
