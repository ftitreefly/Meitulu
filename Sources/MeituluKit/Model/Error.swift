//
//  Error.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/4.
//

import Foundation

public enum MyError: Error {
    case netError
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .netError:
            return "* NET ERROR"
        }
    }
}
