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
    let shortDescription: String = "CLI tools for show and download albums."

    let isDownload = Flag("-d", "--download", description: "Download album", defaultValue: false)
    let id = Param.Required<Int>()

    let downloadFolder = "~/Downloads/"

    func execute() throws {

        let idValue = id.value

        if !isDownload.value {
            list(idValue)
        } else {
            download(idValue, inFolder: downloadFolder)
        }

    }
}
