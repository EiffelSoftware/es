indexing
	description: "Objects that provide a simple encryption engine"
	author: "CSARDAS TEAM"
	date: "May 2007"
	revision: "$1.0$"

class
	ENIGMA
inherit
	ENCRYPTOR

create
	make

feature {NONE}  -- attributes

char_to:HASH_TABLE[CHARACTER,CHARACTER]
char_from:HASH_TABLE[CHARACTER,CHARACTER]
key:INTEGER

feature  -- creation

	make(k:INTEGER) is
			-- Initialize `Current'.
		require else
			k >-1 and k < 10
		do
			--The key cannot be too large or it will generate char that are not propriate for network transmission

			key:=k\\3 -- mod 3 safe meassure

		 	create char_to.make (40)
		 	create char_from.make (40)
		 	char_to.put  ('a', 'q')
		 	char_from.put('q', 'a')
		 	char_to.put  ('b', 'w')
		 	char_from.put('w', 'b')
		 	char_to.put  ('c', 'e')
		 	char_from.put('e', 'c')
		 	char_to.put  ('d', 'r')
		 	char_from.put('r', 'd')
		 	char_to.put  ('e', 't')
		 	char_from.put('t', 'e')
		 	char_to.put  ('f', 'y')
		 	char_from.put('y', 'f')
		 	char_to.put  ('g', 'u')
		 	char_from.put('u', 'g')
		 	char_to.put  ('h', 'i')
		 	char_from.put('i', 'h')
		 	char_to.put  ('i', 'o')
		 	char_from.put('o', 'i')
		 	char_to.put  ('j', 'p')
		 	char_from.put('p', 'j')
		 	char_to.put  ('k', 'a')
		 	char_from.put('a', 'k')
		 	char_to.put  ('l', 's')
		 	char_from.put('s', 'l')
		 	char_to.put  ('m', 'd')
		 	char_from.put('d', 'm')
		 	char_to.put  ('n', 'f')
		 	char_from.put('f', 'n')
		 	char_to.put  ('o', 'g')
		 	char_from.put('g', 'o')
		 	char_to.put  ('p', 'h')
		 	char_from.put('h', 'p')
		 	char_to.put  ('q', 'j')
		 	char_from.put('j', 'q')
		 	char_to.put  ('r', 'k')
		 	char_from.put('k', 'r')
		 	char_to.put  ('s', 'l')
		 	char_from.put('l', 's')
		 	char_to.put  ('t', 'z')
		 	char_from.put('z', 't')
		 	char_to.put  ('u', 'x')
		 	char_from.put('x', 'u')
		 	char_to.put  ('v', 'c')
		 	char_from.put('c', 'v')
		 	char_to.put  ('x', 'v')
		 	char_from.put('v', 'x')
		 	char_to.put  ('w', 'b')
		 	char_from.put('b', 'w')
		 	char_to.put  ('y', 'n')
		 	char_from.put('n', 'y')
		 	char_to.put  ('z', 'm')
		 	char_from.put('m', 'z')
		 	char_to.put  ('!', '@')
		 	char_from.put('@', '!')
		 	char_to.put  ('%%', '.')
		 	char_from.put('.', '%%')
		 	char_to.put  ('^', ' ')
		 	char_from.put(' ', '^')



		end

feature  -- operation

encrypt(str:STRING):STRING is
		-- IT ONLY STORE LOWER CASE STRING
  require else
  	str/=void
  local
	size:INTEGER
	i:INTEGER
	e_str:STRING
  do
	create e_str.make_from_string (str)
	e_str.to_lower
	size:=e_str.count
	create result.make_empty

	from i:=1 until i > size loop

		if char_to.has (e_str.item (i)) then
			result.append_character (char_to.item (e_str.item (i))+key)

		else
			result.append_character (e_str.item (i))
		end
 		i:= i + 1
   end
end


decrypt(str:STRING):STRING is
		--
  require else
  	str/=void
  local
	size:INTEGER
	i:INTEGER
	e_str:STRING

  do
	create e_str.make_from_string (str)
	e_str.to_lower
	size:=e_str.count
	create result.make_empty

	from i:=1 until i > size loop

		if char_from.has (e_str.item (i)-key) then
			result.append_character (char_from.item (e_str.item (i)-key))
		else
			result.append_character (e_str.item (i))
		end
 		i:= i + 1
   end
end


end
