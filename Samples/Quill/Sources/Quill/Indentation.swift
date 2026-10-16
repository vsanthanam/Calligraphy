import ArgumentParser
import Calligraphy

struct Indentation: ExpressibleByArgument {

    let tabDefinition: TabDefinition

    init(tabDefinition: TabDefinition) {
        self.tabDefinition = tabDefinition
    }

    init?(argument: String) {
        if argument == "tab" {
            tabDefinition = .tab
        } else if let count = Int(argument), count > 0 {
            tabDefinition = .spaces(count)
        } else {
            return nil
        }
    }

}
