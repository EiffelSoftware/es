/* 
Check if for HASH_TABLE.force: t.force (v, k), there is a test case such that in pre-state:
t.has (k)
t.item (k) = v

Result: Yes, there are some test cases satisfying such criteria.
*/

SELECT q.feature, q.content, q.qry_id, q.uuid, t.var1 as "t_id", v.value as "v.value", p2.value as "t.item(k)"
FROM
Queryables q, PropertyBindings1 t, PropertyBindings1 v, PropertyBindings1 k, PropertyBindings2 p1, PropertyBindings2 p2
WHERE

/* feature = merge */
q.feature = "force" AND
q.class = "HASH_TABLE"

/* target t */
AND
t.qry_id = q.qry_id AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
t.position = 0 AND
t.prop_kind = 2 

/* argument v */
AND
v.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
v.position = 1 AND
v.prop_kind = 2 

/* argument k */
AND
k.qry_id = q.qry_id AND
k.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
k.position = 2 AND
k.prop_kind = 2 

/* Property p1: t.has (k) */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p1.prop_kind = 2 AND
p1.var1 = t.var1 AND
p1.var2 = k.var1 AND
p1.value = 1

/* Property p2: t.item (k) */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.item ($)") AND
p2.prop_kind = 2 AND
p2.var1 = t.var1 AND
p2.var2 = k.var1 AND
p2.value = v.value



