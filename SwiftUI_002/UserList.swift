//
//  UserList.swift
//  SwiftUI_002
//
//  Created by XIAOFEI MA on 2020/01/05.
//  Copyright © 2020 XIAOFEI MA. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import UIKit

class UserList: ObservableObject {
    @Published var mainlist: [Mainlist] = []
    @Published var distlist: [Distlist] = []
    @Published var userimg: [Userimg] = []
    @Published var userexist:[UserExist] = []
    let baseUrl :String = "http://192.168.10.6:3000"
    init() {
        //メイン画面の一覧表示初期処理
        load()
        //        post()
    }
    
    func load() {
        
        //入退場状況データ取得
        let url = URL(string: baseUrl + "/checkhstd_v")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.mainlist = try! JSONDecoder().decode([Mainlist].self, from: data!)
            }
        }.resume()
        
        
        //部門マスタデータ取得
        //        let url2 = URL(string: "http://192.168.10.7:3000/distlist_v")!
        //        URLSession.shared.dataTask(with: url2) { data, response, error in
        //            DispatchQueue.main.async {
        //                self.distlist = try! JSONDecoder().decode([Distlist].self, from: data!)
        //            }
        //        }.resume()
    }
    
    
    //ユーザマスタ存在チェック
    func checkUserM(userid:String,userimage:UIImage,username : String,distname:String,completion:@escaping(Int)->())  {
        var result: Int = 404
        let url = URL(string: baseUrl + "/usermst_v?userid=eq." + userid)!
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.userexist = try! JSONDecoder().decode([UserExist].self, from: data!)
                if self.userexist.count > 0 {
                    print("登録済ユーザです! exist:" + String(self.userexist.count))
                    completion(401)
                }else{
                    self.registRecoImage1(userId: userid, userName: username, distName: distname, img: userimage){resp in
                    result = resp
                    completion(result)
                    }
                    
                }
                
            }
        }.resume()
    }
    func post(userId:String,userName:String,distCode :String){
        let url = URL(string: baseUrl + "/user_m")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
        let urlstr = "userid=" + userId + "&username=" + userName + "&distcode=" + distCode
        //        request.httpBody = "userid=666666&username=true&distcode=8888".data(using: .utf8)
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
    //ユーザ登録(ローカルDBへ)
    //    func postAdd(userId:String,userName:String,distCode :String,img: Image){
    //            let url = URL(string: "http://192.168.10.7:3000/user_m")
    //            var request = URLRequest(url: url!)
    //            // POSTを指定
    //            request.httpMethod = "POST"
    //            // POSTするデータをBodyとして設定
    //            let urlstr = "userid=" + userId + "&username=" + userName + "&distcode=" + distCode
    //    //        request.httpBody = "userid=666666&username=true&distcode=8888".data(using: .utf8)
    //            request.httpBody = urlstr.data(using: .utf8)!
    //            let session = URLSession.shared
    //            session.dataTask(with: request) { (data, response, error) in
    //                if error == nil, let data = data, let response = response as? HTTPURLResponse {
    //                    // HTTPヘッダの取得
    //                    print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
    //                    // HTTPステータスコード
    //                    print("statusCode: \(response.statusCode)")
    //                    print(String(data: data, encoding: .utf8) ?? "")
    //                }
    //            }.resume()
    //        }
    //ローカルDBへのユーザ情報登録
    func postImg(userId:String,userName:String,distName :String,uiImage: UIImage){
        
        //        let base64ImgStr = convertImageToBase64(img)
        let imageData:NSData = uiImage.toJpegData(.min)! as NSData
        
        let base64ImgStr = Utils.base64UrlSafeEncoding(data: imageData as Data)
        
        
        let url = URL(string: baseUrl + "/USER_M")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
        let urlstr = "userid=" + userId + "&username=" + userName + "&distname=" + distName + "&userimage=" + base64ImgStr + "&updatedpgId=" + "UserList.postImg"
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("PostGresq add user statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
                
                
            }
        }.resume()
    }
    
    //ローカルDBへのユーザ情報登録
    func postAddImgUserMst(userId:String,userName:String,distName :String,uiImage: UIImage,completion:@escaping(Int)->()){
        
        //        let base64ImgStr = convertImageToBase64(img)
        let imageData:NSData = uiImage.toJpegData(.min)! as NSData
        
        let base64ImgStr = Utils.base64UrlSafeEncoding(data: imageData as Data)
        
        
        let url = URL(string: baseUrl + "/usermst")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
        let urlstr = "userid=" + userId + "&username=" + userName + "&distname=" + distName + "&userimage=" + base64ImgStr
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("PostGresq add user statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
                completion(response.statusCode)
                
            }
        }.resume()
    }
    
    
    //
    func getUpdate(userId:String){
        let url = URL(string: baseUrl + "/mainlist_v?userId=eq." + userId)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.mainlist = try! JSONDecoder().decode([Mainlist].self, from: data!)
                if self.mainlist.count > 0 {
                    // INHST_Dにすでに存在、更新を行う
                    //                    self.postUpdate(userId: <#T##String#>)
                }else{
                    // INHST_Dに未存在、追加を行う
                    //                    self.post(userId: <#T##String#>, userName: <#T##String#>, distCode: <#T##String#>)
                }
            }
        }.resume()
    }
    
    //ユーザステータス更新
    func postUpdate(userId:String){
        var inhst_d:[INHST_D] = []
        let url = URL(string: baseUrl + "/INHST_D?userid=eq." + userId )!
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                inhst_d = try! JSONDecoder().decode([INHST_D].self, from: data!)
                if inhst_d.count > 0 {
                    
                }
            }
        }.resume()
    }
    //    //テスト用　DBから画像取得
    //    func getimg()  {
    //        let url = URL(string: "http://192.168.10.6:3000/testing?userid=eq.001872")!
    //        print(url)
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            DispatchQueue.main.async {
    //                self.userimg = try! JSONDecoder().decode([Userimg].self, from: data!)
    //                let imgdata = Utils.base64UrlSafeDecoding(base64String: self.userimg[0].userimage)
    //                let img = UIImage(data: imgdata!)
    //                print(img?.size)
    //            }
    //        }.resume()
    //    }
    
    //NeoFace Cloud RESTAPI　顔認証 ユーザ登録前チェック
    func recoImageForUserAdd(userId:String,userName:String,distName :String,uiImage: UIImage,completion:@escaping(Int)->()) {
        var result: Int = 404
        let image1 = uiImage.resize(scale: 0.5)!
        
        let imageData:NSData = image1.toJpegData(.min)! as NSData
        
        let imageStr = Utils.base64UrlSafeEncoding(data: imageData as Data)
        
        let json: [String: Any] = ["paramSetId":"AUTH_1_N_M_NONE",
                                   "queryImages":imageStr]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url2 = URL(string: "https://api.cloud.nec.com/neoface/f-face-image/v1/action/auth")
        var request2 = URLRequest(url: url2!)
        request2.httpMethod = "POST"
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.addValue("l70729f43684e243309443593a69487f27", forHTTPHeaderField: "apikey")
        
        // insert json data to the request
        request2.httpBody = jsonData
        
        var status200 = false
        let task = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(data as Any)
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
                if response.statusCode == 200 {
                    status200 = true
                }
            }
            if status200 == true {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                let faceJsond = try! JSONDecoder().decode(faceJson.self, from: data)
                
                if faceJsond.statusCode == 200 {
                    print("顔データがすでに登録済です。")
                    completion(401)
                }else if faceJsond.statusCode == 444 {
                    //顔データ未登録で登録を行う
//                    self.postAddImgUserMst(userId: userId, userName: userName, distName: distName, uiImage: uiImage)
                    //NFCへ登録とローカルへの登録
                    self.registRecoImage1(userId: userId, userName: userName, distName: distName, img: uiImage){resp in
                    result = resp
                    completion(result)
                    }
                }
                //check status update
                
                //                if let responseJSON = responseJSON as? [String: Any] {
                //                    print(responseJSON["statusCode"] as Any)
                //                }
            }
        }
        
        task.resume()
        
    }
    
    //NeoFace Cloud RESTAPI　顔認証
    func recoImage(img:UIImage,status:String) {
        
        let image1 = img.resize(scale: 0.5)!
        
        let imageData:NSData = image1.toJpegData(.min)! as NSData
        
        let imageStr = Utils.base64UrlSafeEncoding(data: imageData as Data)
        
        let json: [String: Any] = ["paramSetId":"AUTH_1_N_M_NONE",
                                   "queryImages":imageStr]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url2 = URL(string: "https://api.cloud.nec.com/neoface/f-face-image/v1/action/auth")
        var request2 = URLRequest(url: url2!)
        request2.httpMethod = "POST"
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.addValue("l70729f43684e243309443593a69487f27", forHTTPHeaderField: "apikey")
        
        // insert json data to the request
        request2.httpBody = jsonData
        
        var status200 = false
        let task = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(data as Any)
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
                if response.statusCode == 200 {
                    status200 = true
                }
            }
            if status200 == true {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                let faceJsond = try! JSONDecoder().decode(faceJson.self, from: data)
                print(faceJsond.statusCode)
                
                if faceJsond.statusCode == 200 {
                    print(faceJsond.faceMatches![0].userMatches![0].matchUser?.userId as Any)
                    let userId = faceJsond.faceMatches![0].userMatches![0].matchUser?.userId
                    //check status update
                    if userId != "" {
                        if status == "0"{
                            self.postCheckHstDInsert(userId: userId!,status: status)
                        }else {
                            self.postCheckHstDUpdate(userId: userId!,status: status)
                        }
                    }
                }else{
                    print("顔データがまだ登録されていない。")
                }
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON["statusCode"] as Any)
                }
            }
        }
        
        task.resume()
        
    }
    
    
    //顔認証でデータ更新(入場)
    func postCheckHstDInsert(userId:String,status:String){
        let url = URL(string: baseUrl + "/checkhstd")
        
        let dt = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        let indate = formatter.string(from: dt)
        
        
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
        let urlstr = "userid=" + userId + "&indate=" + indate + "&outdate=" + indate + "&lastoutflg=" + status
        //        request.httpBody = "userid=666666&username=true&distcode=8888".data(using: .utf8)
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
    
    //顔認証でデータ更新(退場)
    func postCheckHstDUpdate(userId:String,status:String){
        let url = URL(string: baseUrl + "/checkhstd?userid=eq." + userId)
        
        let dt = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        let outdate = formatter.string(from: dt)
        
        
        let json: [String: Any] = ["outdate":outdate,
                                   "lastoutflg":status]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "PATCH"
        // POSTするデータをBodyとして設定
//        let urlstr = "outdate=" + outdate + "&lastoutflg=" + status
//        //        request.httpBody = "userid=666666&username=true&distcode=8888".data(using: .utf8)
//        request.httpBody = urlstr.data(using: .utf8)!
        request.httpBody = jsonData
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
    //NeoFace Cloud RESTAPI　顔認証 顔データ登録 Step1 ユーザ情報登録
    func registRecoImage1(userId:String,userName:String,distName:String,img:UIImage,completion:@escaping(Int)->()) {
        var result: Int = 404
        let json: [String: Any] = [
            "userId": userId,
            "userName": userName,
            "userState": "enabled"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url2 = URL(string: "https://api.cloud.nec.com/neoface/v1/users")
        var request2 = URLRequest(url: url2!)
        request2.httpMethod = "POST"
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.addValue("T8001220", forHTTPHeaderField: "X-NECCP-Tenant-ID")
        request2.addValue("l723a9b250150d4111935e47c9b5baf34f", forHTTPHeaderField: "apikey")
        
        // insert json data to the request
        request2.httpBody = jsonData
        
//        var status201 = false
        let task = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(data as Any)
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
                if response.statusCode == 201 {
//                    if status201 == true {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        let faceJsond = try! JSONDecoder().decode(UserOId.self, from: data)
                        print(faceJsond.userOId)
                        if let responseJSON = responseJSON as? [String: Any] {
                            print("faceregist userOId:")
                            print(responseJSON["userOId"] as Any)
                        }
                        //顔認証者対象の顔写真データを登録
                        self.registRecoImage2(userOId: faceJsond.userOId, userId: userId, userName: userName,distName: distName, img: img){resp in
                        result = resp
                        completion(result)
                        }
                        
//                    }
                }else{
                    completion(404)
                }
            }
            
        }
        
        task.resume()
        
    }
  
        
        
    
    //NeoFace Cloud RESTAPI　顔認証 顔データ登録 Step２ ユーザの顔情報登録
    func registRecoImage2(userOId:Int,userId:String,userName:String,distName: String, img:UIImage,completion:@escaping(Int)->()) {
        var result: Int = 0
        
        let image1 = img.resize(scale: 0.5)!
        
        let imageData:NSData = image1.toJpegData(.min)! as NSData
        
        let imageStr = Utils.base64UrlSafeEncoding(data: imageData as Data)
        
        let json: [String: Any] = [
            "faceImage": imageStr,
            "faceIndex": 0,
            "faceState": "enabled"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url2 = URL(string: "https://api.cloud.nec.com/neoface/v1/users/" + String(userOId) + "/faces")
        var request2 = URLRequest(url: url2!)
        request2.httpMethod = "POST"
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.addValue("T8001220", forHTTPHeaderField: "X-NECCP-Tenant-ID")
        request2.addValue("l723a9b250150d4111935e47c9b5baf34f", forHTTPHeaderField: "apikey")
        
        // insert json data to the request
        request2.httpBody = jsonData
        
       //var status201 = false
        let task = URLSession.shared.dataTask(with: request2) { data, response, error in
            print(data as Any)
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
               
                if response.statusCode == 201 {
                    
               //    if status201 == true {
                       let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                       let faceJsond = try! JSONDecoder().decode(FaceOId.self, from: data)
                       print(faceJsond.faceOId)
                       
                       if let responseJSON = responseJSON as? [String: Any] {
                           print("faceregist faceOId:")
                           print(responseJSON["faceOId"] as Any)
                       }
                       
                       //PostGresql DB ユーザ登録
                       //                self.postImg(userId: userId, userName: userName, distName: distName, uiImage: img)
                    self.postAddImgUserMst(userId: userId, userName: userName, distName: distName, uiImage: img){ resp in
                        result = resp
                        completion(result)
                    }
                   }else{
                      completion(404)
                    }
                //}
            }
            
        }
        
        task.resume()
        
    }
    
    
}

//struct User: Decodable, Identifiable {
struct Mainlist: Decodable {
    var userimage :String
    var userid: String
    var username: String
//    var distcode: String
    
    var distname: String
    var indate: String
    var lastoutflg: Int
    var outdate: String
    
    
}

struct Distlist: Decodable {
    var i: Int
    var distcode: String
    var distname: String
    
}



struct faceJson:Decodable{
    var  statusCode: Int
    var  faceMatches:[FaceMatches]?
}

struct FaceMatches:Decodable {
    var faceMatchIndex :Int?
    var userMatches:[UserMatches]?
}
struct UserMatches:Decodable  {
    var score : String?
    var matchUser:MatchUser?
}

struct MatchUser:Decodable {
    var userOId:Int?
    var userId:String?
    var userName:String?
    
}

struct Userimg:Decodable{
    var userid : String
    var userimage : String
}

struct UserOId:Decodable{
    var userOId : Int
}


struct FaceOId:Decodable{
    var faceOId : Int
}


//
struct UserExist:Decodable{
    var userid : String
    var cnt : Int
}


//INHST_D struct
struct INHST_D: Decodable{
    var userid : String
    var username : String
    var distcode: String
    var distname:String
    var indate:Date
    var lastoutflg:Int
    var outdate:Date
}


struct STATUSLIST: Decodable{
    var userid : String
    var username : String
    var distname:String
    var indate:Date
    var lastoutflg:Int
    var outdate:Date
}

