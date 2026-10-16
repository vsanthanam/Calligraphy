import Calligraphy
import Manuscript

struct PackageManifest: StringComponent {

    let service: Service

    var body: some StringComponent {
        "// swift-tools-version: 6.0"
        "import PackageDescription"
        Blank()
        "let package = Package("
        Lines {
            "name: " + Quote(service.name) + ","
            "platforms: [.macOS(.v13)],"
            "targets: ["
            Lines {
                ".target(name: " + Quote(service.name) + ")"
            }
            .tabbed()
            "]"
        }
        .tabbed()
        ")"
    }

}
