//
//  Checkitems.swift
//  SwiftUI_002
//
//  Created by yw c on 2020/02/11.
//  Copyright © 2020 XIAOFEI MA. All rights reserved.
//cyeff

import Foundation

struct Checkitems:Identifiable{
    var id = UUID()
    var title: String
    
    static func dummyData() ->[Checkitems]{
        let items = [
            "SE席（消灯）",
            "事務室（消灯）",
            "会議室（消灯）",
            "社長室（消灯）",
            "給湯室（消灯）",
            "ジュレッダ（切電）",
            "電気ポット（切電）",
            "入口施錠",
            "エントランス消灯",
            "鍵返却",
            "窓",
            "監視カメラ"
        ]
        var array = [Checkitems]()
        for title in items{
            array.append(Checkitems(title: title))
        }
        return array
    }
    
    
}
