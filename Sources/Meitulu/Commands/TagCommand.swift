//
//  TagCommand.swift
//  Meitulu
//
//  Created by tree_fly on 2019/7/17.
//

import SwiftCLI
import MeituluKit

class TagCommand: Command {

    let name: String = "tag"
    let shortDescription: String = "CLI tools for show and download tags."

    let download = Flag("-d", "--download", description: "Download album", defaultValue: false)
    let numberOfpage = Key<Int>("-p", "--number-of-page", description: "Specify the number of page.")

    let tagString = Parameter()

    let downloadFolder = "~/Downloads/"

    func execute() throws {

        let tag = tagString.value

        let page = numberOfpage.value

        if !download.value {

            showTagPageInfo(tag, pagination: page)

        } else {

            downloadTagPage(tag, pagination: page, inFolder: downloadFolder)
        }
    }
}
