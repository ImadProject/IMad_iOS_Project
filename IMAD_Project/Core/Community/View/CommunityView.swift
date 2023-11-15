//
//  CommunityView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/04/06.
//

import SwiftUI
import Kingfisher

struct CommunityView: View {
    
    @State var searchView = false
    @State var search = false
    
    @State var goWork = false
    @State var workInfo:CommunityDetailsListResponse?
    
    @StateObject var tab = CommunityTabManager()
    @StateObject var vm = CommunityViewModel(community: nil, communityList: [])
    @EnvironmentObject var vmAuth:AuthViewModel
    
    
//    var list:[CommunityDetailsListResponse]{
//        switch tab.communityTab{
//        case .all:
//            return vm.communityList
//        case .free:
//            return vm.communityList.filter({$0.category == 1})
//        case .question:
//            return vm.communityList.filter({$0.category == 2})
//        case .debate:
//            return vm.communityList.filter({$0.category == 3})
//        }
//    }
    
    var body: some View {
        NavigationView{
                VStack(spacing: 0) {
                    Section(header:header){
                        ScrollView{
                            listView
                        }
                    }
                }
                .background(Color.white)
                .ignoresSafeArea()
               
                .onChange(of: tab.communityTab){ newValue in
//                    if tab.communityTab == .all{
//                        vm.page = 1
//                        vm.communityList = []
//                        vm.readCommunityList(page: vm.page)
//                        //전체리스트 조회
//                    }else{
//                        vm.communityList = []
//                        vm.page = 1
//                        vm.readListConditionsAll(searchType: 0, query: "", page: vm.page, sort: "createdDate", order: 0)
//                        //특정 필터 리스트 조회
//                    }
                   listUpdate()
                }
        }
        .onAppear{
            print("나타남")
            listUpdate()
//            vm.readCommunityList(page: vm.currentPage,category:0)
        }
        .navigationDestination(isPresented: $goWork) {
            if let workInfo{
                CommunityPostView(postingId: workInfo.postingID, back: $goWork)
                    .navigationBarBackButtonHidden()
                    .environmentObject(vmAuth)
            }
        }
        .navigationDestination(isPresented: $search){
            SearchView(postingMode: true, back: $search)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $searchView) {
            CommunitySearchView()
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        .onReceive(vm.refreschTokenExpired){
            vmAuth.logout(tokenExpired: true)
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CommunityView(vm: CommunityViewModel(community:CustomData.instance.community, communityList: CustomData.instance.communityList))
                .environmentObject(AuthViewModel(user:UserInfo(status: 1,data: CustomData.instance.user, message: "")))
        }
       
    }
}

extension CommunityView{
    
    var header:some View{
        VStack{
            HStack{
                Text("커뮤니티")
                    .font(.title2)
                    .bold()
                    .padding(.leading)
                    
                Spacer()
                Button {
                    searchView = true
                } label: {
                    Image(systemName:"magnifyingglass")
                        .font(.title3).bold()
                }.padding(.trailing)
                Button {
                    search = true
                } label: {
                    Image(systemName:"plus.viewfinder")
                        .font(.title3).bold()
                }.padding(.trailing)
            }
            category
        }
        .foregroundColor(.customIndigo)
        .padding(.vertical)
        .padding(.top,30)
        .background{
            Color.white
        }
       
        
    }
    var category:some View{
        GeometryReader{ geo in
            let width = geo.size.width/1.5
            HStack{
                ForEach(CommunityFilter.allCases,id:\.self){ item in
                    Button {
                        withAnimation(.easeIn(duration: 0.2)){
                            tab.communityTab = item
                        }
                    } label: {
                        Text(item.name)
                            .font(.callout)
                            .bold()
                            
                    }
                    Spacer()
                }
                
            }
            .frame(width: width)
            
            .overlay(alignment:.leading){
                Capsule()
                    .frame(width: 42.5,height: 3)
                    .offset(x:tab.indicatorOffset(width: width)-1)
                    .padding(.top,45)
            }.padding(.leading)
            
        }
        .frame(maxHeight: 20)
        
        
            
    }
    var listView:some View{
        ForEach(vm.communityList,id:\.self){ community in
            Button {
                workInfo = community
                goWork = true
            } label: {
                CommunityListRowView(community: community)
                    .padding(5)
            }
          
            if vm.communityList.last == community,vm.maxPage > vm.currentPage{
                    ProgressView()
                        .onAppear{
                            vm.readCommunityList(page: vm.currentPage + 1,category:0)
                        }
                
            }
        }
    }
    func listUpdate(){
        vm.currentPage = 1
        vm.communityList.removeAll()
        vm.readCommunityList(page: vm.currentPage,category:0)
    }
//    func communityList() -> some View{
//        ScrollView(showsIndicators: false){
//            ForEach(CustomData.instance.reviewList.shuffled(),id: \.self){ item in
//                NavigationLink {
//                    CommunityPostView(review: post)
//                } label: {
//                    CommunityListRowView(title:item.title, image: item.thumbnail,community: CustomData.instance.community).padding()
//
//                }
//                Divider().padding(.horizontal)
//            }
//            .tag(CommunityFilter.all)
//        }.padding(.bottom,40).background(Color.white)
//    }

}
