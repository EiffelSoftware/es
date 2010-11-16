/* 
Check if for HASH_TABLE.replace_key: t.replace (nk, ok), there is a test case such that in pre-state:
t.has (ok)
t.has (nk)

Result: 
(1) There are test cases such that t.has (ok) and t.has (nk)
(2) There is no test case such that ok = nk

*/

SELECT q.feature, q.content, q.qry_id, q.uuid, nk.var1, ok.var1, nk.equal_value, ok.equal_value
FROM
Queryables q, PropertyBindings1 t, PropertyBindings1 nk, PropertyBindings1 ok, PropertyBindings2 p1, PropertyBindings2 p2
WHERE

/* feature = replace_key */
q.feature = "replace_key" AND
q.class = "HASH_TABLE"

/* target t */
AND
t.qry_id = q.qry_id AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
t.position = 0 AND
t.prop_kind = 2 
AND

/* first argument new key nk */
nk.qry_id = q.qry_id AND
nk.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
nk.prop_kind = 2 AND
nk.position = 1

/* second argument new key ok */
AND
ok.qry_id = q.qry_id AND
ok.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
ok.prop_kind = 2 AND
ok.position = 2  

/* Property p1: t.has (nk) */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p1.prop_kind = 2 AND
p1.var1 = t.var1 AND
p1.var2 = nk.var1 AND
p1.value = 0 

/* Property p2: t.has (ok) */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p2.prop_kind = 2 AND
p2.var1 = t.var1 AND
p2.var2 = ok.var1 AND
p2.value = 1




