import Calligraphy

struct LicenseHeader: StringModifier {

    @Environment(\.copyrightHolder)
    private var copyrightHolder

    func body(content: Content) -> some StringComponent {
        if let copyrightHolder {
            Lines {
                "Copyright (c) 2026 \(copyrightHolder)"
                "MIT License"
            }
            .prefixLines(with: "// ")
        }
        GeneratedNotice()
        Blank()
        content
    }

}

extension StringComponent {

    func licensed() -> some StringComponent {
        modifier(LicenseHeader())
    }

}
