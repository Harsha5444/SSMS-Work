/*
SQL JSON FUNCTION REFERENCE:

1. FOR JSON PATH - Converts query results to JSON format
   - WITHOUT_ARRAY_WRAPPER: Omits outer square brackets []
   - INCLUDE_NULL_VALUES: Includes NULL values in output

2. JSON_MODIFY(modifies JSON string)
   - Syntax: JSON_MODIFY(json, path, newValue)
   - '$.property': Accesses object property
   - 'append $.array': Adds element to array

3. JSON_QUERY(extracts object/array from JSON)
   - Returns JSON fragment (object/array) as NVARCHAR

4. JSON_VALUE(extracts scalar value from JSON)
   - Returns single value as NVARCHAR

5. OPENJSON(converts JSON to tabular format)
   - Can be used in FROM clause like a table
   - WITH clause defines output schema
*/

-- ========================================================================
-- 1. FOR JSON PATH EXAMPLES
-- ========================================================================

-- Basic JSON conversion (wrapped in array)
SELECT 
    'Product1' AS ProductName,
    19.99 AS Price,
    5 AS Quantity
FOR JSON PATH;
/* Result:
[{
    "ProductName": "Product1",
    "Price": 19.99,
    "Quantity": 5
}]
*/

-- WITHOUT_ARRAY_WRAPPER removes outer brackets
SELECT 
    'Product1' AS ProductName,
    19.99 AS Price,
    5 AS Quantity,
    NULL AS Sample
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
/* Result:
{
    "ProductName": "Product1",
    "Price": 19.99,
    "Quantity": 5
} 
Note: Sample is omitted because NULLs are excluded by default
*/

-- INCLUDE_NULL_VALUES shows NULL properties
SELECT 
    'Product1' AS ProductName,
    19.99 AS Price,
    5 AS Quantity,
    NULL AS Sample
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER, INCLUDE_NULL_VALUES;
/* Result:
{
    "ProductName": "Product1",
    "Price": 19.99,
    "Quantity": 5,
    "Sample": null
}
*/

-- ========================================================================
-- 2. JSON_MODIFY EXAMPLES
-- ========================================================================

DECLARE @json NVARCHAR(MAX) = '{"name":"John","age":30}';

-- Add new property (city)
SELECT JSON_MODIFY(@json, '$.city', 'New York') AS Result;
/* Result:
{
    "name": "John",
    "age": 30,
    "city": "New York"
}
*/

-- Modify existing property (age)
SELECT JSON_MODIFY(@json, '$.age', 31) AS Result;
/* Result:
{
    "name": "John",
    "age": 31
}
*/

-- Append to array (tags)
SELECT JSON_MODIFY('{"tags":["sql","database"]}', 'append $.tags', 'json') AS Result;
/* Result:
{
    "tags": ["sql", "database", "json"]
}
*/

-- This won't work because age is not an array:
-- SELECT JSON_MODIFY(@json, 'append $.age', '34') AS Result;
/* Correct approach to add multiple ages would be to first make age an array: */
SELECT JSON_MODIFY(JSON_MODIFY(@json, '$.age', JSON_QUERY('[30]')), 'append $.age', '34') AS Result;

-- ========================================================================
-- 3. JSON_QUERY EXAMPLES
-- ========================================================================

DECLARE @json_2 NVARCHAR(MAX) = '{"user":{"name":"Alice","preferences":{"theme":"dark"}}}';

-- Extract nested object (user)
SELECT JSON_QUERY(@json_2, '$.user') AS UserObject;
/* Result:
{
    "name": "Alice",
    "preferences": {
        "theme": "dark"
    }
}
*/

-- Extract array (tags)
SELECT JSON_QUERY('{"tags":["a","b"]}', '$.tags') AS TagsArray;
/* Result:
["a", "b"]
*/

-- Extract nested property
SELECT JSON_QUERY(@json_2, '$.user.preferences') AS Preferences;
/* Result:
{
    "theme": "dark"
}
*/

-- ========================================================================
-- 4. OPENJSON EXAMPLES
-- ========================================================================

DECLARE @json_3 NVARCHAR(MAX) = '[
    {"id":1, "name":"Product A"},
    {"id":2, "name":"Product B"}
]';

-- Convert JSON array to table with schema
SELECT * FROM OPENJSON(@json_3)
WITH (
    ids INT '$.id',          -- Maps JSON property id to column ids
    Names NVARCHAR(100) '$.name'  -- Maps name to Names
);
/* Result:
ids  Names
1    Product A
2    Product B
*/

-- Filter JSON array using OPENJSON
SELECT * FROM OPENJSON(@json_3)
WITH (
    id INT '$.id',
    name NVARCHAR(100) '$.name'
)
WHERE name = 'Product B';
/* Result:
id  name
2   Product B
*/

-- Alternative filtering approach (your example corrected)
SELECT * FROM OPENJSON(@json_3)
WHERE JSON_VALUE([value], '$.name') = 'Product B';
/* Result:
key  value                     type
1    {"id":2,"name":"Product B"}  5
Note: This returns the raw JSON object - less useful than the WITH approach
*/

-- ========================================================================
-- PRACTICAL EXAMPLE: COMBINING FUNCTIONS
-- ========================================================================

-- Update a JSON document to add a new filter if it doesn't exist
DECLARE @reportJson NVARCHAR(MAX) = '{
    "AdvanceFilter": [
        {"DisplayName":"Product","ColumnName":"ProductName"}
    ],
    "SubGroupColumns": []
}';

DECLARE @newFilter NVARCHAR(MAX) = '{
    "DisplayName":"Price",
    "ColumnName":"Price",
    "SortOrder":0
}';

-- Check if filter exists
IF NOT EXISTS (
    SELECT 1 FROM OPENJSON(JSON_QUERY(@reportJson, '$.AdvanceFilter'))
    WHERE JSON_VALUE([value], '$.ColumnName') = 'Price'
)
BEGIN
    -- Add the new filter
    SET @reportJson = JSON_MODIFY(@reportJson, 'append $.AdvanceFilter', JSON_QUERY(@newFilter));
END

SELECT @reportJson AS UpdatedJson;
/* Result:
{
    "AdvanceFilter": [
        {"DisplayName":"Product","ColumnName":"ProductName"},
        {"DisplayName":"Price","ColumnName":"Price","SortOrder":0}
    ],
    "SubGroupColumns": []
}
*/