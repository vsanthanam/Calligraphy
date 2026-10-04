// Control how a `@StringBuilder` joins its children using `Line`, `Lines`, and `joined(separator:)`.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.line
let line = Line {
    "foo"
    "bar"
    "baz"
}
// snippet.end

// snippet.lines
let lines = Lines {
    "foo"
    "bar"
    "baz"
}
.lineSpacing(2)
// snippet.end

// snippet.joined
let joined = StringGroup {
    "Apple"
    "Banana"
    "Pear"
}
.joined(separator: ", ")
// snippet.end

// snippet.hide
print(String(line))
print(String(lines))
print(String(joined))
