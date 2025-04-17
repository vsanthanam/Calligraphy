import ArgumentParser

@main
struct RootCommand: ParsableCommand {
    
    @Argument
    var name: String
    
    func run() throws {
        print("Hello, \(name)!")
    }
    
}
