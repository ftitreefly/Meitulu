//
//  Error.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/4.
//

import Foundation

public enum MyError: Error {
    case netError
    case tagNotExist
    case pageError
    case createFolderFailed(String)
    case updateAlbumFailed
    case downloadFailed

    case error(String)
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        let sign = "[ERROR] * ".red.bold
        switch self {
        case .netError:
            return sign + "HTTP REQUEST NET ERROR!".red
        case .tagNotExist:
            return sign + "TAG NOT EXIST, TAG MAYBE ERROR, CHECK AGAIN!".red
        case .pageError:
            return sign + "PAGINATION NUMBER ERROR!".red
        case .createFolderFailed(let name):
            return sign + "CREATE FOLDER FAILD WITH NAME:\(name).".red
        case .updateAlbumFailed:
            return sign + "UPDATE ALBUM URLS INFORMATION FAILD.".red
        case .downloadFailed:
            return sign + "DOWNLOAD FAILD. UNKONWN REASON.".red
        case .error(let error):
            return sign + "\(error)".red
        }
    }
}
