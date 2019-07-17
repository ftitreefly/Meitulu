//
//  Urls.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/4.
//

import Foundation

func albumHomeUrl(_ id: Int) -> URL {
    return URL(string: "https://www.meitulu.com/item/\(id).html")!
}

func picUrl(albumId: Int, picIndex: Int) -> URL {
    return URL(string: "https://mtl.ttsqgs.com/images/img/\(albumId)/\(picIndex).jpg")!
}

func tagUrl(_ tag: String, _ page: Int = 1) -> URL {
    switch page {
    case 1:
        return URL(string: "https://www.meitulu.com/t/\(tag)/")!
    default:
        return URL(string: "https://www.meitulu.com/t/\(tag)/\(page).html")!
    }
}
