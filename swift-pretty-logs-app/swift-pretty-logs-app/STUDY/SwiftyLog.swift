//
//  SwiftyLog.swift
//  SwiftyLog
//
//  Created by Alex Nagy on 28/04/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation

enum LogDateFormatter: String {
    case MM_dd_yyyy_HH_mm_ss_SSS = "MM/dd/yyyy HH:mm:ss:SSS"
    case MM_dd_yyyy_HH_mm_ss = "MM-dd-yyyy HH:mm:ss"
    case E_d_MMM_yyyy_HH_mm_ss_Z = "E, d MMM yyyy HH:mm:ss Z"
    case MMM_d_HH_mm_ss_SSSZ = "MMM d, HH:mm:ss:SSSZ"
    case d_MMM_HH_mm_ss = "d MMM yyyy, HH:mm:ss"
}

struct LogOptions {
    static var dateFormatter = LogDateFormatter.d_MMM_HH_mm_ss
}

struct Log {
    static func stats(_ file: String = #file, function: String = #function, line: Int = #line) -> String {
        let fileString: NSString = NSString(string: file)
        
        let threadIconString = choseTheThreadIcon()
        let dateString = giveTheDateFormatted()
        let fileNameString = fileString.lastPathComponent
        let functionString = "\(function)"
        let lineString = "\(line)"
        
        let structure = """
        *{THREAD}* [*{DATE}*] [*{FILE}* -> *{FUNCTION}*, AT LINE: *{LINE}*]
        
        """
        
        let formatted = structure
            .replacingOccurrences(of: "*{THREAD}*", with: threadIconString)
            .replacingOccurrences(of: "*{DATE}*", with: dateString)
            .replacingOccurrences(of: "*{FILE}*", with: fileNameString)
            .replacingOccurrences(of: "*{FUNCTION}*", with: functionString)
            .replacingOccurrences(of: "*{LINE}*", with: lineString)
        
        return formatted
        
    }
    
    private static func giveTheDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = LogOptions.dateFormatter.rawValue
        return dateFormatter.string(from: Foundation.Date())
    }
    
    private static func choseTheThreadIcon() -> String {
        let isMainThreadExecuting = Thread.isMainThread
        return "[\(isMainThreadExecuting ? "M" : "!=M")]"
    }
}

enum log {
    case ln(_: String)
    case success(_: String)
    case warning(_: String)
    case error(_: String)
    case todo(_: String)
    case url(_: String)
}

postfix operator /

postfix func / (target: log?) {
    guard let target = target else { return }
    
    func log<T>(_ emoji: String, _ object: T) {
        // To enable logs only in Debug mode:
        // 1. Go to Buld Settings -> Other C Flags
        // 2. Enter `-D DEBUG` fot the Debug flag
        // 3. Comment out the `#if #endif` lines
        // 4. Celebrate. Your logs will not print in Release, thus saving on memory
        //#if DEBUG
        print(emoji + " " + String(describing: object))
        //#endif
    }
    
    switch target {
    case .ln(let line):
        log("✏️", line)
    case .success(let success):
        log("✅", success)
    case .warning(let warning):
        log("⚠️", warning)
    case .error(let error):
        log("🛑", error)
    case .todo(let todo):
        log("👨🏼‍💻", todo)
    case .url(let url):
        log("🌏", url)
    }
}
