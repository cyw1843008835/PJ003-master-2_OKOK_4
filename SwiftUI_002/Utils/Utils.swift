import Foundation

class Utils {
    static func base64UrlSafeEncoding(data: Data?, padding: Bool = true) -> String {
        guard let targetData = data else {
            LOG_ERROR(message: "convertTarget DATA is nil.")
            return ""
        }

        var base64String: String = targetData.base64EncodedString()
        base64String = base64String.replacingOccurrences(of: "+", with: "-")
        base64String = base64String.replacingOccurrences(of: "/", with: "_")

        if !padding {
            base64String = base64String.replacingOccurrences(of: "=", with: "")
        }

        return base64String
    }

    static func base64UrlSafeDecoding(base64String: String) -> Data? {
        var str = base64String.padding(toLength: ((base64String.count + 3) / 4) * 4,
                                       withPad: "=",
                                       startingAt: 0)
        str = str.replacingOccurrences(of: "-", with: "+")
        str = str.replacingOccurrences(of: "_", with: "/")
        return Data(base64Encoded: str, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
    }

    static func base64UrlSafeDecodeString(base64String: String) -> String {
        guard let data: Data = base64UrlSafeDecoding(base64String: base64String) else {
            return ""
        }
        return String(data: data, encoding: .utf8)!
    }

    static func regexReplace(str: String, pattern: String, with: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            return regex.stringByReplacingMatches(in: str, range: NSRange(location: 0, length: str.count), withTemplate: with)
        } catch let error as NSError {
            LOG_ERROR(message: "Failed to NSRegularExpression for \(error)")
            return str
        }
    }
}
