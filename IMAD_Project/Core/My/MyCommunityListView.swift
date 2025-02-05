//
//  MyCommunityListView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/11/29.
//

import SwiftUI

struct MyCommunityListView: View {
    let writeType:WriteTypeFilter
    
    @State var community:PostingResponse? = nil
    @State var goPosting = false
    @State var like = true
    @StateObject var user = UserInfoManager.instance
    @StateObject var vm = CommunityViewModel(community: nil, communityList: [])
    @Environment(\.dismiss) var dismiss
    
    
    func profileMode(next:Bool)->(){
        switch writeType{
        case .myself:
            return vm.myCommunity(page: next ? vm.currentPage + 1 : vm.currentPage)
        case .myselfLike:
            return vm.myLikeCommunity(page: next ? vm.currentPage + 1 : vm.currentPage, likeStatus: like ? 1 : -1)
        }
    }
    var communityList:[PostingResponse]{
        switch writeType{
        case .myself:
            return vm.communityList
        case .myselfLike:
            if like{
                return vm.communityList.filter({$0.likeStatus == 1})
            }else{
                return vm.communityList.filter({$0.likeStatus == -1})
            }
        }
    }
    
    var body: some View {
        VStack(spacing:0){
            header
            item
        }
        .foregroundColor(.black)
        .background(Color.white)
        .onAppear{
            profileMode(next: false)
        }
        .onDisappear{
            vm.currentPage = 1
            vm.communityList.removeAll()
        }
        .navigationDestination(isPresented: $goPosting){
            PostingDetailsView(reported: community?.reported ?? false, postingId: community?.postingID ?? 0, back: $goPosting)
               
                .navigationBarBackButtonHidden()
        }
    }
}

struct MyCommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        MyCommunityListView(writeType: .myselfLike,vm: CommunityViewModel(community:CustomData.community,communityList: CustomData.communityList))
           
    }
}

extension MyCommunityListView{
    var header:some View{
        VStack{
            HeaderView(backIcon: "chevron.left", text: writeType == .myself ? "내 게시물" : "내 게시물 반응"){
                dismiss()
            }
            if writeType == .myselfLike{
                HStack{
                    filterButton(like: true)
                    filterButton(like: false)
                    Spacer()
                }
            }
            Divider()
        }.padding([.leading,.top],10)
    }
    
    var item:some View{
        VStack{
            if vm.communityList.isEmpty{
                emptyView
            }else{
                ScrollView{
                    ForEach(communityList,id: \.self) { community in
                        VStack{
                            communityListRowView(community: community)
                            if vm.communityList.last == community,vm.maxPage > vm.currentPage{
                                ProgressView()
                                    .environment(\.colorScheme, .light)
                                    .onAppear{
                                        profileMode(next: true)
                                    }
                            }
                        }
                    }
                }
                .background(Color.gray.opacity(0.1))
            }
        }
    }
    func filterButton(like:Bool) -> some View{
        Button {
            withAnimation {
                self.like = like
                vm.communityList.removeAll()
                profileMode(next: false)
            }
        } label: {
            HStack{
                Image(systemName: like ? "arrowshape.up.fill" : "arrowshape.down.fill")
                    .foregroundColor(.customIndigo.opacity(0.7))
                Text(like ? "추천":"비추천")
                    .font(.GmarketSansTTFMedium(15))
            }
            .padding(5)
            .padding(.horizontal)
            .background(Color.white)
            .overlay {
                if self.like != like{
                    Color.white.opacity(0.8)
                }
            }
            .cornerRadius(100)
            .shadow(radius: 1)
        }
    }
    var emptyView:some View{
        VStack{
            Spacer()
            if writeType == .myself{
                Image(systemName: "text.badge.xmark")
                    .font(.GmarketSansTTFMedium(50))
                    .foregroundColor(.customIndigo.opacity(0.5))
                    .padding(.bottom,10)
                Text("작성한 게시물이 없습니다")
                    .font(.GmarketSansTTFMedium(15))
            }else{
                Image(systemName: like ? "arrowshape.up" : "arrowshape.down")
                    .font(.GmarketSansTTFMedium(50))
                    .foregroundColor(.customIndigo.opacity(0.5))
                    .padding(.bottom,10)
                Text(like ? "추천한 게시물이 없습니다" : "비추천한 게시물이 없습니다")
                    .font(.GmarketSansTTFMedium(15))
            }
            Spacer()
        }
    }
    func communityListRowView(community:PostingResponse) -> some View{
        Button {
            self.community = community
            self.goPosting = true
        } label: {
            CommunityListRowView(community: community)
        }
    }
}
