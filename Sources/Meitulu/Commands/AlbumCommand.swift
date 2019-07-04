//
//  AlbumCommand.swift
//  Meitulu
//
//  Created by tree_fly on 2019/7/4.
//

import SwiftCLI
import MeituluKit

class AlbumCommand: Command {

    let name: String = "album"
    let shortDescription: String = "tools for show and download album."

    let isDownload = Flag("--download", description: "Download album", defaultValue: false)
    let idOptional = OptionalParameter()

    let downloadFolder = "~/Downloads/"

    func execute() throws {

        guard let idValue = idOptional.value else {
            print("Error: id needed!")
            return
        }

        let id = Int(idValue)!

        if !isDownload.value {
            list(id)
        } else {
            download(id)
        }

    }
}
