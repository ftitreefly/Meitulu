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
