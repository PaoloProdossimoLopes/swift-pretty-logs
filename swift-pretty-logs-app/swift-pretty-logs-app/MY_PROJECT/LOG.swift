//
//  LOG.swift
//  swift-pretty-logs-app
//
//  Created by Paolo Prodossimo Lopes on 03/04/22.
//

import Foundation

struct LOG {
    static func DEBUG(
        _ situation: LOG.LOGTypes = .ln(""),
        describe: String = "",
        option: LOG.LOGOptions = .abreviate,
        structure: LOGStructs = .REPORT, file: String = #file,
        function: String = #function, line: Int = #line
    ) {
        DEBUGPrint(
            target: situation, describe: describe, option: option, structure: structure,
            file: file, function: function, line: line
        )
    }
}

//MARK: - Helpers
extension LOG {
    
    private static func DEBUGPrint(
        target: LOGTypes, describe: String, option: LOG.LOGOptions = .abreviate,
        structure: LOGStructs, file: String, function: String, line: Int
    ) {
        
        //Header
        if option == .complete {
            let sts = stats(file: file, function: function, line: line, structString: structure)
            log("", describe, sts, showDEBUG: false)
        }
        
        //Body
        switch target {
        case .ln(let line):
            let middle = describe.isEmpty ? "" : describe
            log("", middle, line)
        case .SUCCESS(let success):
            let middle = describe.isEmpty ? "(SUCCESS)" : "\(describe)"
            log("✅", middle, success)
        case .WARNING(let warning):
            let middle = describe.isEmpty ? "(WARNING)" : "\(describe)"
            log("⚠️", middle, warning)
        case .ERROR(let error):
            let middle = describe.isEmpty ? "(ERROR)" : "\(describe)"
            log("🛑", middle, error)
        case .TO_DO(let todo):
            let middle = describe.isEmpty ? "(TO-DO)" : "\(describe)"
            log("✏️", middle, todo)
        case .API(let url):
            let middle = describe.isEmpty ? "(API)" : "\(describe)"
            log("🌐", middle, url)
        }
    }
    
    private static func log<T>(_ emoji: String, _ describe: String, _ object: T, showDEBUG: Bool = true) {
        let placeholder = showDEBUG ? "DEBUG(*{DESCRIBE}*):" : ""
        let space = (emoji.isEmpty ? "\(placeholder) " : " \(placeholder) ")
        let middle = space
            .replacingOccurrences(of: LOGKeysReplaced.DESCRIBE.rawValue, with: describe)
        print(emoji + middle + String(describing: object))
    }
    
    private static func stats(
        file: String, function: String, line: Int, structString: LOGStructs
    ) -> String {
        let fileString: NSString = NSString(string: file)
        
        let threadIconString = choseTheThreadIcon()
        let dateString = giveTheDateFormatted()
        let fileNameString = fileString.lastPathComponent
        let functionString = "\(function)"
        let lineString = "\(line)"
        
        let structure = structString.structString
        
        let formatted = structure
            .replacingOccurrences(of: LOGKeysReplaced.THREAD.rawValue, with: threadIconString)
            .replacingOccurrences(of: LOGKeysReplaced.DATE.rawValue, with: dateString)
            .replacingOccurrences(of: LOGKeysReplaced.FILE.rawValue, with: fileNameString)
            .replacingOccurrences(of: LOGKeysReplaced.FUNCTION.rawValue, with: functionString)
            .replacingOccurrences(of: LOGKeysReplaced.LINE.rawValue, with: lineString)
        
        return formatted
    }
    
    private static func giveTheDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = LogOptions.dateFormatter.rawValue
        return dateFormatter.string(from: Foundation.Date())
    }
    
    private static func choseTheThreadIcon() -> String {
        let isMainThreadExecuting = Thread.isMainThread
        return "[\(isMainThreadExecuting ? "MAIN" : "NOT MAIN")]"
    }
}

//MARK: - Types

extension LOG {
    enum LOGTypes {
        case ln(String)
        case SUCCESS(String)
        case WARNING(String)
        case ERROR(String)
        case TO_DO(String)
        case API(String)
    }
    
    enum LOGOptions {
        case `abreviate`
        case complete
    }
}

//MARK: - Constants
extension LOG {
    
    enum LOGKeysReplaced: String {
        case THREAD = "*{THREAD}*"
        case DATE = "*{DATE}*"
        case FILE = "*{FILE}*"
        case FUNCTION = "*{FUNCTION}*"
        case LINE = "*{LINE}*"
        case DESCRIBE = "(*{DESCRIBE}*)"
    }
    
    enum LOGStructs {
        case `STATUS_INFO_V1`
        case REPORT
        
        var structString: String {
            switch self {
            case .STATUS_INFO_V1:
                return """
                *{THREAD}* [*{DATE}*] [*{FILE}* -> *{FUNCTION}*, AT LINE: *{LINE}*]
                """
            case .REPORT:
                return """
                
                ▶︎ DEBUG INFO:
                ▶︎ THREAD: *{THREAD}*
                ▶︎ DATE: *{DATE}*
                ▶︎ FILE: *{FILE}*
                ▶︎ FUNCTION: *{FUNCTION}*
                ▶︎ LINE: *{LINE}*
                
                """
            }
        }
    }
}

