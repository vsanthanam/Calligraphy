import Calligraphy
import Manuscript

struct EndpointMethod: StringComponent {

    let endpoint: Endpoint

    var body: some StringComponent {
        Line {
            "func \(endpoint.name)() async throws"
            if let response = endpoint.response {
                " -> \(response)"
            }
            " {"
        }
        "}"
    }

}
