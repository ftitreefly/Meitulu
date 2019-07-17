//
//  Tag.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/17.
//

import Foundation
import SwiftSoup
import Files
import Rainbow

public typealias TagHomePageData = (albums: [Album], pageMax: Int)

public func showTagPageInfo(_ tag: String, pagination: Int? = 1) {
    let page = pagination ?? 1

    switch page {
    case 1:
        tagHomePageInfo(tag)
    default:
        tagPageInfo(tag, pagination: page)
    }
}

public func downloadTagPage(_ tag: String, pagination: Int? = 1, inFolder parentFolder: String = "~/Downloads/") {
    let page = pagination ?? 1

    switch page {
    case 1:
        downloadHomePageAlbums(tag, inFolder: parentFolder)
    default:
        downloadTagPageAlbums(tag, page: page, inFolder: parentFolder)
    }
}

private func downloadTagPageAlbums(_ tag: String, page: Int, inFolder parentFolder: String) {

    guard let homePage = getTagHomePage(tag) else { return }
    let pageMax = homePage.pageMax

    guard page > 0 && page <= pageMax else {
        print(MyError.pageError.localizedDescription, "ALL \(pageMax) PAGE(S)".red)
        return
    }

    let albums = getTagPage(tag, page: page)

    downloadAlbums(albums, subFolder: tag, folder: parentFolder)
}

private func downloadHomePageAlbums(_ tag: String, inFolder parentFolder: String) {
    guard let homePage = getTagHomePage(tag) else { return }

    let albums = homePage.albums

    downloadAlbums(albums, subFolder: tag, folder: parentFolder)
}

fileprivate func printAlbumsInfo(_ albums: [Album]) {
    albums.forEach { album in
        print("\(album.id)".red, album.title.cyan)
    }
}

private func tagPageInfo(_ tag: String, pagination: Int) {

    guard let homePage = getTagHomePage(tag) else { return }
    let pageMax = homePage.pageMax

    guard pagination > 0 && pagination <= pageMax else {
        print(MyError.pageError.localizedDescription, "ALL \(pageMax) PAGE(S)".red)
        return
    }

    let albums = getTagPage(tag, page: pagination)

    printAlbumsInfo(albums)

    print("TAG：\(tag). PAGE: \(pagination)/\(homePage.pageMax). WITH '-p <Int>' FOR MORE.".red.bold)
}

private func tagHomePageInfo(_ tag: String) {

    guard let homePage = getTagHomePage(tag) else { return }

    printAlbumsInfo(homePage.albums)

    print("TAG：\(tag). PAGE: \(1)/\(homePage.pageMax). WITH '-p <Int>' FOR MORE.".red.bold)
}

// func

private func getTagPage(_ tag: String, page: Int = 1) -> [Album] {

    let url = tagUrl(tag, page)

    var albums: [Album] = []

    do {
        let response = requestHtml(url)

        guard case .success(let html) = response else {
            throw MyError.netError
        }

        let document = try SwiftSoup.parse(html)

        let albumItems = try document.select("div.boxs > ul > li").array()

        guard albumItems.count > 0 else {
            return albums
        }

        for item in albumItems {
            let html = try item.select("a[href$=html]").get(0).attr("href")
            let id = Int(html.split(separator: "/").last!.split(separator: ".").first!)!

            let tags = try item.children().get(4).text().split(separator: " ").dropFirst().map {String($0)}

            let count = Int(try item.children().get(1).text().split(separator: " ")[1])!

            let title = try item.children().get(5).text()

            let model = String(try item.children().get(3).text().split(separator: "：")[1])

            let album = Album(id: id, title: title, count: count, model: model, tags: tags)

            albums.append(album)
        }

    } catch { print("ERROR:", error) }

    return albums
}

private func getTagHomePage(_ tag: String) -> TagHomePageData? {

    var pageMax = 1

    do {
        let response = requestHtml(tagUrl(tag))

        guard case .success(let html) = response else {
            throw MyError.netError
        }

        // get pageMax Count

        let document = try SwiftSoup.parse(html)
        let pageElement = try document.getElementById("pages")?.select("a")

        guard let page = pageElement else {
            print(MyError.tagNotExist.localizedDescription)
            return nil
        }

        let aTagCount = page.count

        guard aTagCount == 0 || aTagCount > 3 else {
            print(MyError.error("PAGE NAV ERROR.").localizedDescription)
            return nil
        }

        pageMax = aTagCount == 0 ? 1 : Int(try page.array()[aTagCount - 2].text())!

    } catch {
        print(MyError.error(error.localizedDescription).localizedDescription)
    }

    let albums: [Album] = getTagPage(tag)

    return (albums, pageMax)
}
