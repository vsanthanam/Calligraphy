import Calligraphy
import Manuscript

struct GeneratedPackage: Directory {

    let service: Service

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
        Folder("Sources") {
            Folder(service.name) {
                ClientFile(service: service)
                Folder("Models") {
                    ForEach(service.types) { type in
                        File(type.name, fileExtension: "swift") {
                            TypeDeclaration(type: type)
                        }
                    }
                }
            }
        }
    }

}
