note
	description: "Summary description for {PLAN_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAN_STATE

inherit
	PRINTABLE

create
	make

feature
	make
		do
			create predicates.make (10)
      create functions.make (10)
      create const_func.make (10)
      create const_pred.make (10)                  
		end

	add_function_simple (name: STRING; val: ANY)
		do
			add_function (create {CONST_EXPR}.make_const (name)
			             ,create {CONST_EXPR}.make_const (val.out)
			             )
		end

	add_predicate_simple (name: STRING; bool: BOOLEAN)
		do
			if bool then
				add_predicate (create {CONST_EXPR}.make_const (name))
			end
		end

	add_predicate (pred: EXPR)
		do
			predicates.extend (pred)
		end

	add_function (func: EXPR; val: EXPR)
		do
			functions.extend (create {BIN_EXPR}.make_bin ("=", func, val))
		end

  add_const (str: STRING; obj: ANY)
    do
      const_func.extend ([str,obj])
    end
  
	predicates: ARRAYED_LIST [EXPR]
	functions: ARRAYED_LIST [EXPR]
  const_func: ARRAYED_LIST [TUPLE [STRING, ANY]]
  const_pred: ARRAYED_LIST [TUPLE [STRING, BOOLEAN]]
  
  
	to_printer (p: PRINTER)
		do
      print_defines (p)
			p.add ("(set-initial-facts")
			print_list_ln_indent (p, predicates)
			print_list_ln_indent (p, functions)
			p.add (")")
			p.newline
		end

  print_defines (p: PRINTER)
    local
      func: TUPLE [name: STRING; obj: ANY]
      pred: TUPLE [name: STRING; bool: ANY]
    do
      from const_func.start
      until const_func.after
      loop
        func := const_func.item
        print_func (func.name, func.obj, p)
        const_func.forth
      end
    end

  print_pred (str: STRING; bool: BOOLEAN; p: PRINTER)
    do
    end
      
  
  print_func (str: STRING; obj: ANY; p: PRINTER)
    do
      p.add ("(define " + str + " " + obj.out + ")")
      p.newline
    end
  

end
