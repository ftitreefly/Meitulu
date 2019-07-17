//
//  NetTask.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/4.
//

import Foundation

typealias RESPONSE = (Data?, URLResponse?, Error?)

func synHTTPRequest(_ url: URL, _ header: [AnyHashable: Any]? = nil) -> RESPONSE {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    let config = URLSessionConfiguration.default
    if let header = header {
        config.httpAdditionalHeaders = header
    }

    let session = URLSession(configuration: config)

    let semaphore = DispatchSemaphore(value: 0)
    session.dataTask(with: url) { sdata, sresponse, serror in
        data = sdata
        response = sresponse
        error = serror

        semaphore.signal()
        }.resume()

    _ = semaphore.wait(timeout: .distantFuture)

    return RESPONSE(data: data, response: response, error: error)
}

func requestString(_ url: URL, _ header: [AnyHashable: Any]? = nil) -> Result<String, Error> {

    let response: RESPONSE = synHTTPRequest(url, header)

    guard let data = response.0, response.2 == nil else {
        return .failure(MyError.netError)
    }

    return .success(String(data: data, encoding: String.Encoding.utf8)!)
}

func requestHtml(_ url: URL) -> Result<String, Error> {
    let header: [String: String] = [
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.1 Safari/605.1.15"
    ]
    return requestString(url, header)
}


func loadCookies(domain: URL) {
    let cstorage = HTTPCookieStorage.shared
    if let cookies = cstorage.cookies(for: domain) {
        for cookie: HTTPCookie in cookies {
            print("name：\(cookie.name)", "value：\(cookie.value)")
        }
    }
}
