// Construct `FilePermissions` from a symbolic string literal with `#filePermissions(_:)`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.symbolic
// Read/write for user, read-only for group and others: rw-r--r--
let permissions = #filePermissions("rw-r--r--")

// Common executable: rwxr-xr-x
let exec = #filePermissions("rwxr-xr-x")

// With leading file-type character (ignored): -rwxr-xr-x
let typed = #filePermissions("-rwxr-xr-x")

// setuid executable for user: rwSr-xr-x (uppercase S = setuid without x)
let setuidNoExecUser = #filePermissions("rwSr-xr-x")

// Whitespace tolerated:
let spaced = #filePermissions("rwx r-x r-x")
// snippet.end

// snippet.hide
print(permissions)
print(exec)
print(typed)
print(setuidNoExecUser)
print(spaced)
