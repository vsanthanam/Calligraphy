import Calligraphy
import Manuscript

struct GeneratedPackage: Directory {

    let service: Service
    let specFileName: String

    var name: String {
        service.name
    }

    var body: some DirectoryContent {
        File("Package.swift") {
            PackageManifest(service: service)
        }
        File("README.md") {
            Readme(service: service)
        }
        File("regenerate.sh", permissions: #filePermissions("rwxr-xr-x")) {
            "#!/bin/sh"
            "quill ../\(specFileName) --output .. --force"
        }
        Folder("Sources") {
            Folder(service.name) {
                ClientFile(service: service)
                Folder("Models") {
                    ForEach(service.types) { type in
                        File(type.name, fileExtension: "swift") {
                            TypeDeclaration(type: type).licensed()
                        }
                    }
                }
            }
        }
    }

}
