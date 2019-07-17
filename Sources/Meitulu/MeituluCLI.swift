import SwiftCLI
import MeituluKit

public class MeituluCLI {

    public static let name = ""
    public static let description = "Meitulu.com website resourses downloader."

    public init() {}

    public func run() -> Never {

        let cli = CLI(name: MeituluCLI.name,
                      version: MeituluKit.version,
                      description: MeituluCLI.description)

        cli.commands = [
            AlbumCommand(),
            TagCommand(),
        ]

        cli.goAndExit()
    }
}
