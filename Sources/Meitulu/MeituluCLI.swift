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

    public func check() -> Bool {

        // check aria2c

        guard (try? Task.capture(bash: "which aria2c")) != nil  else {
            print("""
* ERROR: 'aria2c' command does not exist.
* Aria2 is a lightweight multi-protocol & multi-source command-line download utility.
* Please download it from site: https://aria2.github.io. After installation, ensure that the file PATH has been in the system PATH.
""".red)
            return false
        }

        return true
    }
}
