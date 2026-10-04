// Construct `FilePermissions` from an octal integer literal with `#filePermissions(_:)`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.octal
// Read/write for user, read-only for group and others: rw-r--r--
let permissions = #filePermissions(0o644)

// Common executable: rwxr-xr-x
let exec = #filePermissions(0o755)

// setuid + 755
let setuidExec = #filePermissions(0o4755)
// snippet.end

// snippet.hide
print(permissions)
print(exec)
print(setuidExec)
