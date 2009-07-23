note
	description: "A database connection pool."
	author: "Stephan van Staden"
	date: "9 June 2009"
	revision: "$Revision$"
	sl_predicate: "[
	DBPool(x, {type=t}) = t = sql(_dm,_url,_user,_password) | x.<CONNECTION_POOL.driver_manager> |-> _dm * x.<CONNECTION_POOL.url> |-> _url * x.<CONNECTION_POOL.user> |-> _user * x.<CONNECTION_POOL.password> |-> _password * x.<CONNECTION_POOL.conns> |-> _y * list(_y, Void, _R) * DBSet(setof(_R), t)
	]"
	js_logic: "connection_pool.logic"
	js_abstraction: "connection_pool.abs"

class
	CONNECTION_POOL

create
	init

feature

	conns: L_LIST [CONNECTION]

	url: STRING

	user: STRING

	password: STRING

	init (l: L_LIST [CONNECTION]; dm: DRIVER_MANAGER; ur: STRING; un: STRING; p: STRING)
		require
			--SL-- | list(l, Void, empty())
		do
			conns := l
			driver_manager := dm
			url := ur
			user := un
			password := p
		ensure
			--SL-- | DBPool$(Current, {type=sql(dm, ur, un, p)}) * Current.<CONNECTION_POOL.last_connection> |-> _x
		end

	generate_connection
		require
			--SL-- | DBPool$(Current, {type=_t}) * Current.<CONNECTION_POOL.last_connection> |-> _x
		do
			if conns.size = 0 then
				driver_manager.generate_connection (url, user, password)
				last_connection := driver_manager.last_connection
			else
				conns.remove_first
				last_connection := conns.removed_item
			end
		ensure
			--SL-- | DBPool$(Current, {type=_t}) * Current.<CONNECTION_POOL.last_connection> |-> _y * DBConnection(_y, {connection=_t})
		end

	last_connection: CONNECTION

	free_connection (c: CONNECTION)
		require
			--SL-- | DBConnection(c, {connection=_t}) * DBPool$(Current, {type=_t})
		do
			if conns.size >= 20 then
				c.close
			else
				conns.add (c);
			end
		ensure
			--SL-- | DBPool$(Current, {type=_t})
		end

	driver_manager: DRIVER_MANAGER

end
