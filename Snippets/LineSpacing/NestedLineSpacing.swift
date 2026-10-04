// Line spacing is inherited by nested `Lines`. Apply `lineSpacing(_:)` again to
// give a nested block a different spacing.

// snippet.hide
import Calligraphy

// snippet.show
// snippet.nested
let component = Lines {
    "foo"
    Lines {
        "bar"
        "baz"
    }
    .lineSpacing(1)
}
.lineSpacing(2)
// snippet.end

// snippet.hide
print(String(component))
