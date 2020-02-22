import Foundation

class Setting {
    static let authThresholdList: [(threshold: String, value: String)]! = [
        ("低", "low"),
        ("中", "middle"),
        ("高", "high")
    ]
    // 1:N認証のパラメータのみ
    static let authParamDictLivenssOff: Dictionary<String, String>! = [
        "low": "AUTH_1_N_L_NONE",
        "middle": "AUTH_1_N_M_NONE",
        "high": "AUTH_1_N_L_NONE",
    ]
    static let authParamDictLivenssOn: Dictionary<String, String>! = [
        "low": "auth_70_02_0082",
        "middle": "auth_70_02_0083",
        "high": "auth_70_02_0084",
    ]
    static let authParamDict: Dictionary<Bool, Dictionary<String, String>>! = [
        false: authParamDictLivenssOff,
        true: authParamDictLivenssOn
    ]

    static func setInitialDefault() {
        UserDefaults.standard.register(defaults: [
            "TenantID": "",
            "AuthApiKey": "",
            "AuthThreshold": "middle",
            "Livenss": false,
            "DispalyList": true,
            "CameraID": "",
            "CameraSize": "640x480",
            "SnipFace": false,
            "JpegQuality": 80,
            "ResizeEnable": false,
            "ResizeRate": 1.0,
            "OidcClientID": "",
            "OidcSecretKey": ""
        ])
    }

    static func getTenantID() -> String {
        return UserDefaults.standard.string(forKey: "TenantID")!
    }

    static func getAuthApiKey() -> String {
        return UserDefaults.standard.string(forKey: "AuthApiKey")!
    }

    static func getAuthParam() -> String {
        let threshold = UserDefaults.standard.string(forKey: "AuthThreshold")!
        let liveness = UserDefaults.standard.bool(forKey: "Liveness")
        return authParamDict![liveness]![threshold]!
    }

    static func getCameraID() -> String {
        return UserDefaults.standard.string(forKey: "CameraID")!
    }

    static func setCameraID(id: String) {
        UserDefaults.standard.set(id, forKey: "CameraID")
    }

    static func getCameraSize() -> String {
        return UserDefaults.standard.string(forKey: "CameraSize")!
    }

    static func getOidcClientID() -> String {
        return UserDefaults.standard.string(forKey: "OidcClientID")!
    }

    static func getOidcSecretKey() -> String {
        return UserDefaults.standard.string(forKey: "OidcSecretKey")!
    }

    static func getDisplayList() -> Bool {
        return UserDefaults.standard.bool(forKey: "DispalyList")
    }

    static func getSnipFace() -> Bool {
        return UserDefaults.standard.bool(forKey: "SnipFace")
    }

    static func getJpegQuality() -> Int {
        return UserDefaults.standard.integer(forKey: "JpegQuality")
    }

    static func getResizeEnable() -> Bool {
        return UserDefaults.standard.bool(forKey: "ResizeEnable")
    }

    static func getResizeRate() -> Float {
        return UserDefaults.standard.float(forKey: "ResizeRate")
    }

    static var accessToken = ""

    static func getAccessToken() -> String {
        return accessToken
    }

    static func setAccessToken(token: String) {
        accessToken = token
    }
}
