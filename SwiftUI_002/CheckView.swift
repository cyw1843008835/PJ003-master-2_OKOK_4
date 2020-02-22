//
//  CheckView.swift
//  SwiftUI_002
//
//  Created by IMAC NCJ on 2020/01/14.
//  Copyright © 2020 XIAOFEI MA. All rights reserved.
//

import SwiftUI

struct CheckView: View {
    @State var isChecked:Bool = false
    var title:String
    func toggle(){isChecked = !isChecked}
    var body: some View {
        HStack{
            Button(action: toggle) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
            }
            Text(title)
        }
    }
}

#if DEBUG
struct CheckView_Previews: PreviewProvider {
    static var previews: some View {
        CheckView(title:"Title")
    }
}
#endif
