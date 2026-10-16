import Calligraphy
import Manuscript

struct ClientDeclaration: StringComponent {

    let service: Service

    @AccessModifier
    private var access

    var body: some StringComponent {
        "import Foundation"
        Blank()
        "\(access)struct \(service.name)Client {"
        Lines {
            Lines {
                "\(access)let baseURL: URL"
                "\(access)var session: URLSession = .shared"
            }
            .lineSpacing(1)
            ForEach(service.endpoints) { endpoint in
                EndpointMethod(endpoint: endpoint)
            }
        }
        .lineSpacing(2)
        .tabbed()
        "}"
    }

}
