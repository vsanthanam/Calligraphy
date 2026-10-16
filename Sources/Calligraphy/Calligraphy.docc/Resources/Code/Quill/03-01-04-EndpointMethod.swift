import Calligraphy
import Manuscript

struct EndpointMethod: StringComponent {

    let endpoint: Endpoint

    private var interpolatedPath: String {
        endpoint.path
            .replacingOccurrences(of: "{", with: "\\(")
            .replacingOccurrences(of: "}", with: ")")
    }

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
        Lines {
            Line {
                "let url = baseURL.appending(path: "
                Quote(interpolatedPath)
                ")"
            }
            "let (data, _) = try await session.data(from: url)"
            if let response = endpoint.response {
                "return try JSONDecoder().decode(\(response).self, from: data)"
            }
        }
        .tabbed()
        "}"
    }

}
