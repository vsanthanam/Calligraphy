import Calligraphy
import Manuscript

struct ClientDeclaration: StringComponent {

    let service: Service

    var body: some StringComponent {
        "import Foundation"
        Blank()
        "struct \(service.name)Client {"
        Lines {
            Lines {
                "let baseURL: URL"
                "var session: URLSession = .shared"
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
