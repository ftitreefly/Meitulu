//
//  Album.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/4.
//

import Foundation
import SwiftSoup
import Files

public struct Album {
    let title: String
    let count: Int
    var urls: [URL]
}

public func list(_ id: Int) {
    if let album = try? getAlbumInfo(id) {
        print(album.title)
        if album.count > 1 {
            print(album.urls.first!.absoluteString)
            print("...")
            print(album.urls.last!.absoluteString)
        } else if album.count == 1 {
            print(album.urls[0].absoluteString)
        }
        print()
    }
}

public func download(_ id: Int) {
    if let album = try? getAlbumInfo(id) {
        print(album.title)

        let path = try! Folder.home.subfolder(named: "Downloads")

        var saveFolder: Folder? = try? path.createSubfolderIfNeeded(withName: album.title)

        if saveFolder == nil {
            saveFolder = try! path.createSubfolderIfNeeded(withName: Date().description)
        }


        let tmpFile = try! Folder.temporary.createFile(named: "_tmp_\(id)")

        let tmpConent = album.urls
            .map { "\($0)\n"}
            .reduce("", +)
        try! tmpFile.append(string: tmpConent)

        _ = try! Aria2c.download(file: tmpFile.path, path: saveFolder!.path)

        
    }
}


public func getAlbumInfo(_ id: Int) throws -> Album? {

    let homeUrl = albumHomeUrl(id)

    do {
        let response = requestHtml(homeUrl)

        guard case .success(let html) = response else {
            throw MyError.netError
        }

        let document = try SwiftSoup.parse(html)

        let title = try document.title()
        //"[XIAOYU语画界] Vol.034 女神@Angela喜欢猫丝袜美腿写真[51P]_美图录"

        let count = getImagesCount(title)
        // 51

        let urls = (1...count).map { i in
            return picUrl(albumId: id, picIndex: i)
        }

        return Album(title: title, count: count, urls: urls)
    } catch {
        throw error
    }
}

private func getImagesCount(_ title: String) -> Int {
    let count = title
        .split(separator: "[")
        .filter { $0.contains("P]") }
        .compactMap { return $0.split(separator: "P").first }
        .first ?? ""

    return Int(String(count)) ?? 0
}

