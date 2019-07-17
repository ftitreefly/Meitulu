//
//  Album.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/4.
//

import Foundation
import SwiftSoup
import Files

private let FOLDER_PARENT_ALBUM_NAME = "Meitulu_Albums" // swiftlint:disable:this identifier_name
private let FOLDER_PARENT_TAG_NAME = "Meitulu_Tags" // swiftlint:disable:this identifier_name

public struct Album {
    let id: Int
    let title: String
    let count: Int
    var model: String
    var tags: [String]

    init(id: Int, title: String, count: Int, model: String = "", tags: [String] = []) {
        self.id = id
        self.title = title
        self.count = count
        self.model = model
        self.tags = tags
    }

    var urls: [URL] {
        return ( 1...count ).map { index -> URL in
            return picUrl(albumId: id, picIndex: index)
        }
    }
}

public func list(_ id: Int) {
    if let album = try? getAlbumInfo(id) {
        print("\(album.id)".red, album.title.cyan)
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

public func download(_ id: Int, inFolder folder: String) {

    if let album = try? getAlbumInfo(id) {

        print("\(album.id)".red, "\(album.title)".cyan)

        do {
            let path = try Folder(path: folder)
            let albumsFolder: Folder = try path.createSubfolderIfNeeded(withName: FOLDER_PARENT_ALBUM_NAME)

            let albumName = "\(album.id) - \(album.title)"
            let albumFolder: Folder = try albumsFolder.createSubfolderIfNeeded(withName: albumName)

            guard albumsFolder.contains(albumFolder) else {
                print(MyError.createFolderFailed(albumName))
                return
            }

            let tmpFile = try Folder.temporary.createFile(named: "_tmp_\(id)")

            let tmpConent = album.urls
                .map { "\($0)\n"}
                .reduce("", +)
            try tmpFile.append(string: tmpConent)

            _ = try Aria2c.download(file: tmpFile.path, path: albumFolder.path)

        } catch {
            print(MyError.downloadFailed.localizedDescription)
        }
    }
}

public func downloadAlbums(_ albums: [Album], subFolder tag: String, folder: String) {

    do {
        let path = try Folder(path: folder).createSubfolderIfNeeded(withName: FOLDER_PARENT_TAG_NAME)

        let tagFolderName = "TAG_" + tag
        let tagFolder: Folder = try path.createSubfolderIfNeeded(withName: tagFolderName)

        guard path.contains(tagFolder) else {
            print(MyError.createFolderFailed(tagFolderName).localizedDescription)
            return
        }

        for album in albums {

            print("\(album.id)".red, "\(album.title)".cyan)

            let albumName = "\(album.id) - \(album.title)"
            let albumFolder: Folder = try tagFolder.createSubfolderIfNeeded(withName: albumName)

            guard tagFolder.contains(albumFolder) else {
                print(MyError.createFolderFailed(albumName))
                return
            }

            let tmpFile = try Folder.temporary.createFile(named: "_tmp_\(album.id)")

            let tmpConent = album.urls
                .map { "\($0)\n"}
                .reduce("", +)
            try tmpFile.append(string: tmpConent)

            _ = try Aria2c.download(file: tmpFile.path, path: albumFolder.path)

        }
    } catch  {

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

        return Album(id: id, title: title, count: count)
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

