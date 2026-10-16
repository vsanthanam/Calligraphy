import Calligraphy
import Manuscript

struct ClientFile: TextFile {

    let service: Service

    var name: String {
        "\(service.name)Client.swift"
    }

    var body: some StringComponent {
        ClientDeclaration(service: service).licensed()
    }

}
