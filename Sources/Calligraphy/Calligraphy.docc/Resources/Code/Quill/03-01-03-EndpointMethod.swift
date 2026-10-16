import Calligraphy
import Manuscript

struct EndpointMethod: StringComponent {

    let endpoint: Endpoint

    var body: some StringComponent {
        Line {
            "func \(endpoint.name)("
            Group {
                ForEach(endpoint.pathParameters) { parameter in
                    "\(parameter): String"
                }
                if let request = endpoint.request {
                    "body: \(request)"
                }
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
