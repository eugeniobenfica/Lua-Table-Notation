# Lua-Table-Notation
Lua Table Notation converts Lua tables directly to text and vice versa, an alternative to JSON tailored for Lua.

# Basic Usage

```lua
local ltn = require('ltn.serializer')
```

## Working with files

**Load table from ltn file:**
```lua
local exampleTable = ltn.load("example.ltn")
print(exampleTable)
-- table: 000000000065d660
```

**Save ltn file from table:
```lua
local exampleTable = {"Hello", "World"}
ltn.dump(exampleTable, "example.ltn")
```
## Working with strings

**Decode string for table**
```lua
local exampleTable = "{'Hello', 'World'}"
exampleTable = ltn.decode(exampleTable)
print(exampleTable)
-- table: 0000000000dcd7e0
```

**Encode table for string**
```lua
local exampleTable = {"Hello", "World"}
exampleTable = ltn.encode(exampleTable)
```
