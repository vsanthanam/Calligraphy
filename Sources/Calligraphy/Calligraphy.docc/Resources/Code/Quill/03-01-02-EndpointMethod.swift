import Calligraphy
import Manuscript

struct EndpointMethod: StringComponent {

    let endpoint: Endpoint

    var body: some StringComponent {
        Line {
            "func \(endpoint.name)("
            ForEach(endpoint.pathParameters) { parameter in
                "\(parameter): String"
            }
            .joined(separator: ", ")
            ") async throws"
            if let response = endpoint.response {
                " -> \(response)"
            }
            " {"
        }
        "}"
    }

}
