# ``Calligraphy/Tabbed``

You can use a tabbed stroke to add tabs as line prefixes to multline children, for example:

```swift
let example = Lines {
    "{"
    Tabbed {
        Strokes {
            "apple"
            "pear"
            "banana"
        }
        .joined {
            Line {
                NewLine()
                ","
            }
        }
    }
    "}"
}
```

This example would yield the following multi-line string:

```
{
    apple,
    pear,
    banana
}
```
