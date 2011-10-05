note
  description: "Summary description for {SSA_PRINTER}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_PRINTER

inherit
  AST_ROUNDTRIP_PRINTER_VISITOR
    redefine
      process_class_as,
      process_parent_list_as,
      process_feature_as,
      process_do_as,
      process_ensure_as,
      process_tagged_as
    end

  SSA_SHARED

  SSA_GET_SUPPLIERS
  
  SHARED_SERVER

create
  make_for_ssa

feature
  name: STRING

  make_for_ssa
    do
      make_with_default_context
      setup (class_c.ast,
             match_list_server.item (class_c.class_id),
             True,
             False)
    end

  process
    do
      safe_process (class_c.ast)
    end


feature {NONE}
  process_this: BOOLEAN
  idx: INTEGER
  processed_inherit: BOOLEAN

  process_class_as (l_as: CLASS_AS)
    -- Copied and modified from AST_ROUNDTRIP_ITERATOR
    local
      s: STRING_AS
    do
      safe_process (l_as.internal_top_indexes)
      safe_process (l_as.frozen_keyword (match_list))
      safe_process (l_as.deferred_keyword (match_list))
      safe_process (l_as.expanded_keyword (match_list))
      safe_process (l_as.separate_keyword (match_list))
      safe_process (l_as.external_keyword (match_list))
      safe_process (l_as.class_keyword (match_list))
      safe_process (l_as.class_name)
      safe_process (l_as.internal_generics)
      safe_process (l_as.alias_keyword (match_list))
      s ?= l_as.external_class_name
      safe_process (s)
      safe_process (l_as.obsolete_keyword (match_list))
      safe_process (l_as.obsolete_message)

      -- Modified here to add the inherit clause when there is not an
      -- existing inherit clause.
      if not attached l_as.internal_conforming_parents and
        not attached l_as.internal_non_conforming_parents
       then
        context.add_string ("%Ninherit PLAN_UTILITIES EXTRA_INSTR")
      end

      safe_process (l_as.internal_conforming_parents)
      safe_process (l_as.internal_non_conforming_parents)
      safe_process (l_as.creators)
      safe_process (l_as.convertors)
      safe_process (l_as.features)
      safe_process (l_as.internal_invariant)
      safe_process (l_as.internal_bottom_indexes)
      safe_process (l_as.end_keyword)
    end

  process_parent_list_as (l_as: PARENT_LIST_AS)
    do
      Precursor (l_as)
      if not processed_inherit then
        context.add_string ("%N EXTRA_INSTR")
        context.add_string ("%N PLAN_UTILITIES")
        processed_inherit := True
      end
    end

  locals: LIST [TYPE_DEC_AS]
  
  process_feature_as (l_as: FEATURE_AS)
    -- Process only the selected feature.
    do
      if l_as.feature_name.name_32.is_equal (feature_i.feature_name_32) then
        idx := l_as.body.as_routine.end_keyword.last_token (match_list).index

        locals := l_as.body.as_routine.locals
        process_this := True
        Precursor (l_as)
        process_this := False
        locals := Void
      else
        Precursor (l_as)
      end
    end

  process_do_as (l_as: DO_AS)
    local
      ssa_printer: SSA_FEATURE_PRINTER
    do
      if process_this then
        safe_process (l_as.do_keyword (match_list))

        create ssa_printer.make (fetch_suppliers (class_c), locals)
        
        l_as.process (ssa_printer)
        last_index := idx
        context.add_string (ssa_printer.context + "%N")
      else
        Precursor (l_as)
      end
    end

  process_ensure: BOOLEAN


  -- Flag the ensure clause
  process_ensure_as (l_as: ENSURE_AS)
    do
      if process_this then
        process_ensure := True
        safe_process (l_as.full_assertion_list)
        process_ensure := False
      else
        Precursor (l_as)
      end
    end

  -- Remove the ensure clause of the routine to be processed
  process_tagged_as (l_as: TAGGED_AS)
    do
      if process_this and process_ensure then
        last_index := idx
      else
        Precursor (l_as)
      end
    end
  
end
