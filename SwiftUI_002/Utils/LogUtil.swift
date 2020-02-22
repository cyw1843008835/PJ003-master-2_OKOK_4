import Foundation

func LOG_DEBUG(message: String, file: String = #file, function: String = #function, line: Int32 = #line) {
    #if true // デバッグログ
        print((file.components(separatedBy: "/").last ?? "Unknown") + " " + function, "L:", line, message)
    #else
    #endif
}

func LOG_FN_BEGIN(message: String = "begin.", file: String = #file, function: String = #function, line: Int32 = #line) {
    #if true // デバッグログ
        print((file.components(separatedBy: "/").last ?? "Unknown") + " " + function, "L:", line, message)
    #else
    #endif
}

func LOG_FN_END(message: String = "end.", file: String = #file, function: String = #function, line: Int32 = #line) {
    #if true // デバッグログ
        print((file.components(separatedBy: "/").last ?? "Unknown") + " " + function, "L:", line, message)
    #else
    #endif
}

func LOG_ERROR(message: String, file: String = #file, function: String = #function, line: Int32 = #line) {
    #if true // デバッグログ
        print((file.components(separatedBy: "/").last ?? "Unknown") + " " + function, "L:", line, "   ERROR", message)
    #else
        print((file.components(separatedBy: "/").last ?? "Unknown") + " " + function, "L:", line, "   ERROR", message)
    #endif
}
