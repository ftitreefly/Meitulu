//
//  Ari2c.swift
//  MeituluKit
//
//  Created by tree_fly on 2019/7/4.
//

import Foundation
import SwiftCLI

struct Aria2c {

    static let header: [String: String] = [
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.1 Safari/605.1.15",
        "referer": "https://www.meitulu.com"
    ]

    static func download(file: String, path: String) throws -> String {

        var aria2cArgs: [String] = []
        let agent = [#"--user-agent="\#(header["User-Agent"]!)""#]
        let more = ["--referer=\(header["referer"]!)",
            "--dir=\(path)",
            "-x5",
            "-j10",
            "-c",
            "--input-file=\(file)"]

        aria2cArgs.append(contentsOf: agent)
        aria2cArgs.append(contentsOf: more)

        #if DEBUG
        aria2cArgs.append("--quiet=false")
        #else
        aria2cArgs.append("--quiet=true")
        #endif

        return runAria2c(args: aria2cArgs, directory: path)
    }

    private static func runAria2c(args: [String], directory: String) -> String {
        let stdout = CaptureStream()
        let stderr = CaptureStream()

        let task = Task(executable: "/usr/local/bin/aria2c", arguments: args, directory: directory, stdout: stdout, stderr: stderr)
        _ = task.runAsync()

        showProgressBar(10, task)

        return stderr.readAll().isEmpty ? stdout.readAll() : stderr.readAll()
    }
}

func showProgressBar(_ interval: TimeInterval, _ task: Task) {

    let output = FileHandle.standardOutput

    var startDate = Date()
    //let endDate = startDate.addingTimeInterval(interval)
    let stringLength: Int = 60
    //let sleepTime = UInt32(interval / Double(stringLength) / 2)
    let progress = Progress(totalUnitCount: Int64(interval * 1000))
    progress.completedUnitCount = 0

    while task.isRunning {
        let elapsedTime = Date().timeIntervalSince(startDate)
        progress.completedUnitCount = Int64(elapsedTime * 1000)

        let completedChars = Int(progress.fractionCompleted * Double(stringLength))
        var remainingChars = stringLength - completedChars

        if remainingChars <= 0 {
            remainingChars = 0
            startDate = Date()
        }

        let completedString = String(repeatElement("#", count: completedChars))
        let remainingString = String(repeatElement(".", count: remainingChars))
        output.write("   [\(completedString)\(remainingString)]\r".data(using: .utf8)!)

        sleep(UInt32(1.0))
    }
}

func showMessage(_ msg: String, _ space: Int = 3) {
    let output = FileHandle.standardOutput
    let stringLength: Int = space + 60
    let blackString = String(repeating: " ", count: stringLength)
    output.write("\(blackString)\r".data(using: .utf8)!)
    output.write("\(msg)\n".data(using: String.Encoding.utf8)!)
}
