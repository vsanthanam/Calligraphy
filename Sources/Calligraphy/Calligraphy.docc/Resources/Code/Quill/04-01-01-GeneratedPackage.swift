import Calligraphy
import Manuscript

struct GeneratedPackage: Directory {

    let service: Service

    var name: String {
        service.name
    }

    var body: some DirectoryContent {
        File("README.md") {
            Readme(service: service)
        }
    }

}
