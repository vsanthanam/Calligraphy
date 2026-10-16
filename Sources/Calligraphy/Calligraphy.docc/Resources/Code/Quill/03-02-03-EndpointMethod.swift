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
        Lines {
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
                switch endpoint.method {
                case .get:
                    "let (data, _) = try await session.data(from: url)"
                default:
                    "var request = URLRequest(url: url)"
                    "request.httpMethod = " + Quote(endpoint.method.rawValue.uppercased())
                    if endpoint.request != nil {
                        "request.httpBody = try JSONEncoder().encode(body)"
                    }
                    "let (data, _) = try await session.data(for: request)"
                }
                if let response = endpoint.response {
                    "return try JSONDecoder().decode(\(response).self, from: data)"
                }
            }
            .tabbed()
            "}"
        }
        .lineSpacing(1)
    }

}
