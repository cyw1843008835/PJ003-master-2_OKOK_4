//
//  SwiftUIView_Main.swift
//  SwiftUI_002
//
//  Created by XIAOFEI MA on 2019/12/27.
//  Copyright © 2019 XIAOFEI MA. All rights reserved.
//

import SwiftUI

func sysDate() ->String{
    let formatter = DateFormatter()
    // 日本語表示
    formatter.locale = Locale(identifier: "ja_JP")

    // 和暦表示
    formatter.calendar = Calendar(identifier: .japanese)
//    formatter.dateFormat = "yyyy年MM月dd日"
    formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Gy dMMM EEE", options: 0, locale: Locale(identifier: "ja_JP"))
    return formatter.string(from: Date())
}

struct SwiftUIView_Main: View {
    
    @State private var showImagePicker: Bool = false
    @State private var frombtn:Int = 0
    @State private var image:Image? = nil
    @State private var uiimage:UIImage?=nil
    @ObservedObject var store = UserList()
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    Spacer().frame(width: 10, height: 60, alignment: .topLeading)
                    TitleView(showImagePicker: self.$showImagePicker,image:self.$image,frombtn:self.$frombtn,uiimage:self.$uiimage)
                    HStack {
                        Text("　(\(sysDate()))").font(.system(size: 40))
                    }.frame(width: 1194, height: 100,alignment: .leading)
                    HStack{
                        VStack{
                            Text("入退室一覧").font(.system(size: 40))
                            ListView()
                        }.frame(width: 1000, height: 520, alignment: .topLeading)
                            .background(Color.gray)
                        ButtonForMainView(showImagePicker: self.$showImagePicker,image:self.$image,frombtn:self.$frombtn)
                    }
                }
                .frame(width: 1194, height: 834, alignment: .top)
                .background(Color.yellow)
            }.sheet(isPresented: self.$showImagePicker ){
                PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image, frombtn:self.$frombtn,uiimage: self.$uiimage)
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}
struct ListView: View{
    @ObservedObject var store = UserList()
    
    var body: some View {
        List (store.mainlist,id: \.userid) { (mainlist) in
            UserRow(mainlist: mainlist)
            
        }.background(Color.gray)
        
    }
}

struct UserRow: View {
    var mainlist: Mainlist
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: Utils.base64UrlSafeDecoding(base64String: mainlist.userimage)!)!)
                //            Image(mainlist.userid.trimmingCharacters(in: .whitespacesAndNewlines))
                .resizable().frame(width: 120.0, height: 120.0)
                .clipShape(Circle())
                .overlay(Circle()
                    .stroke(Color.gray, lineWidth: 5))
                .shadow(radius: 20)
            //                .rotationEffect(.degrees(180.0))
            VStack{
                Text(mainlist.distname).font(.system(size: 20))
                Text(mainlist.username).font(.system(size: 40))
            }.frame(width: 300, height: 100, alignment: .top)
            
            
            VStack{
                Text(String(mainlist.indate)).font(.system(size: 40))
                Text(String(mainlist.outdate)).font(.system(size: 40))
                
            }
            
            Image(String(mainlist.lastoutflg))
                .resizable().frame(width: 80.0, height: 80.0)
                .clipShape(Circle())
                .overlay(Circle()
                    .stroke(Color.gray, lineWidth: 5))
        }
    }
}
struct TitleView: View{
    @State  var isActive = false
    @Binding var showImagePicker: Bool
    @Binding var image:Image?
    @Binding var frombtn: Int
    @Binding var uiimage :UIImage?
    
    var body: some View{
        
        HStack{
            Text("    入退室管理システム１.０")
                .font(.system(size: 50)).animation(.default)
            Spacer()
            
            NavigationLink(destination: LoginView(isFirstViewActive: $isActive,showImagePicker: self.$showImagePicker, image: self.$image, uiimage: self.$uiimage), isActive: $isActive) {
                Button(action: {
                    self.isActive = true
                }, label: {
                    Text("ユーザ登録")
                }).padding()
                    .background(Color.gray)
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                
            }
            
            
        }
        
    }
}
struct ButtonForMainView: View{
    @State  var isActive = false
    @Binding  var showImagePicker: Bool
    @Binding var image:Image?
    @Binding var frombtn:Int
    @State var showExitCheckAlert: Bool = false
    var body: some View{
        VStack{
            Spacer()
            image?.resizable()
                .scaledToFit()
                .clipShape(Circle())
            Button("入場"){
                self.showImagePicker = true
                self.frombtn = 2
                
            }.padding()
                .background(Color.green)
                .font(.system(size: 40))
                .foregroundColor(Color.white)
                .cornerRadius(90)
            Spacer().frame(width: 0, height: 20)
            Button("退場"){
                self.showImagePicker = true
                self.frombtn = 3
                
            }.padding()
                .background(Color.orange)
                .font(.system(size: 40))
                .foregroundColor(Color.white)
                .cornerRadius(90)
            Spacer().frame(width: 0, height: 20)
            NavigationLink(destination: ExitView(frombtn: $frombtn, isFirstViewActive: $isActive), isActive: $isActive) {
                Button(action: {
//                    self.isActive = true
//                    self.frombtn = 4
//                    self.showImagePicker = true
                    self.showExitCheckAlert = true
                }, label: {
                    Text("最終 退場")
                }).padding()
                    .background(Color.red)
                    .font(.system(size: 40))
                    .foregroundColor(Color.white)
                    .cornerRadius(90)
                .alert(isPresented: $showExitCheckAlert) {
                    Alert(title: Text("NFC顔データ登録"), message:
                      Text("下記の項目を実施しましたか：SE席（消灯）,事務室（消灯）,会議室（消灯）,社長室（消灯）,給湯室（消灯）,ジュレッダ（切電）,電気ポット（切電）,入口施錠,エントランス消灯,鍵返却,窓,監視カメラ"),
                          primaryButton: .default(Text("確認")) {
                             self.frombtn = 4
                            self.showImagePicker = true
                                          }
                        ,secondaryButton: .default(Text("キャンセル")))
                }
            }
            Spacer().frame(width: 0, height: 60)
        }.frame(width: 150, height: 520)
    }
}
struct LoginView:View{
    @State var isActive = false
    @Binding var isFirstViewActive: Bool
    @ObservedObject var store = UserList()
    @State var userNm: String = ""
    @State var userId: String = ""
    @State var sel  = 0
    @Binding  var showImagePicker: Bool
    @Binding var image:Image?
    @Binding var uiimage:UIImage?
    @State var showingAlert : Bool = false
     @State var showingErrAlert : Bool = false
    @State var showingErrAlert1 : Bool = false
    @State var resp:Int = 0
    
    //    @Binding var frombtn:Int
    
    //    @Binding var frombtn: Int
    var dists = ["社長室","経営企画部", "事業推進部", "システム開発事業部","第１シス開発部", "第２シス開発部"]
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    Text("　ユーザ登録　　　")
                        .font(.system(size: 50)).animation(.default)
                }.frame(width: 1194, height: 150,alignment: .leading)
                HStack{
                    VStack{
                        image?.resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                        Button("撮影"){
                            self.showImagePicker = true
                            //                            self.frombtn = 1
                            
                        }.padding()
                            .background(Color.green)
                            .font(.system(size: 40))
                            .foregroundColor(Color.white)
                            .cornerRadius(90)
                        Spacer().frame(width: 0, height: 20)
                        
                        
                        
                        
                        
                        
                    }.frame(width: 400, height: 600)
                    VStack{
                        HStack{
                            Text("ID:") .font(.title)
                            TextField("009999", text: $userId) .font(.title)
                            
                        }
                        HStack{
                            Text("氏名:") .font(.title)
                            TextField("NCJタロウ", text: $userNm) .font(.title)
                            
                        }
                        HStack{
                            Picker(selection: $sel, label: Text("所属:").font(.title)) {
                                ForEach(0 ..< dists.count) {
                                    Text(self.dists[$0])
                                }.font(.largeTitle)
                                
                            }
                        }
                    }.frame(width: 550, height: 600, alignment: .leading)
                    VStack{
                        Spacer()
                        Button(action: {
                            // UserList().post(userId: "99999", userName: self.userNm, distCode: self.store.distlist[self.sel].distcode)
                            //登録済であるかどうかチェック
                            //                            UserList().checkUserM(userid: self.userId,userimage: self.uiimage!,username: self.userNm,distname: self.dists[self.sel])
                            UserList().recoImageForUserAdd(userId: self.userId, userName: self.userNm, distName: self.dists[self.sel], uiImage: self.uiimage!){response in
                            self.resp = response
                            
                            if self.resp == 201{
                                self.showingAlert = true
                            }else if self.resp == 401{
                                self.showingErrAlert1 = true
                            }
                            else{
                                self.showingErrAlert = true
                                }
                                
                            }
                        }) {
                            Text("確　　定")
                        }
                        .padding()
                        .background(Color.green)
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .cornerRadius(90)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("NFC顔データ登録"), message: Text("顔データ登録が成功しました！顔解析のため、約３０秒後に入退場を試してください！！！！"), dismissButton: .default(Text("了解")))
                        }
                        .alert(isPresented: $showingErrAlert) {
                                                   Alert(title: Text("NFC顔データ登録"), message: Text("顔データ登録が失敗しました！"), dismissButton: .default(Text("了解")))
                                               }
                        .alert(isPresented: $showingErrAlert1) {
                            Alert(title: Text("NFC顔データ登録"), message: Text("顔データの重複登録はできません！"), dismissButton: .default(Text("了解")))
                        }
                        Spacer().frame(width: 0, height: 60, alignment: .topLeading)
                        
                    }.frame(width: 200, height: 600)
                }
            }
            .background(Color.gray)
            
        }
    }
}
struct ExitView:View{
    @Binding var frombtn:Int
    @ObservedObject var store = UserList()
    @State var isActive = false
    @Binding var isFirstViewActive: Bool
    var checkitems = Checkitems.dummyData()
    @State var selectedRows = Set<UUID>()
    
    var body: some View {
        VStack{
            NavigationView{
                List(checkitems, selection: $selectedRows){ item in
                    MultiSelectedRow(checkitems: item,selectedItems: self.$selectedRows)
                }
                .navigationBarTitle(Text("NCJ最終退場チェックリスト"))
            }.navigationViewStyle(StackNavigationViewStyle())
            Button(action: {
                self.frombtn = 4
                
            }) {
                Text("確認")
                    .fontWeight(.semibold)
                    .font(.title)
                    
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(selectedRows.count == 12 ? Color.green : Color.gray)
                    .cornerRadius(40)
            }.disabled(selectedRows.count == 12 ? false : true)
        }
        
    }
}

struct MultiSelectedRow: View{
    
    var checkitems: Checkitems
    @Binding var selectedItems: Set<UUID>
    var isSelected: Bool{
        selectedItems.contains(checkitems.id)
    }
    var body: some View{
        HStack{
            Text(self.checkitems.title)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark").foregroundColor(Color.green)
            }
            
        }
        .onTapGesture {
            if self.isSelected{
                self.selectedItems.remove(self.checkitems.id)
            }else{
                self.selectedItems.insert(self.checkitems.id)
            }
        }
    }
}


struct SwiftUIView_Main_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView_Main().previewLayout(.fixed(width: 1194, height: 834))
        
        
    }
}

