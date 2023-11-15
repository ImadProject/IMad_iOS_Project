//
//  CommunityViewModel.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/10/14.
//

import Foundation
import Combine

class CommunityViewModel:ObservableObject{
    
    
    @Published var currentPage = 1
    @Published var maxPage = 1
    
    @Published var community:CommunityResponse?
    @Published var communityList:[CommunityDetailsListResponse] = []
//    @Published var communityListResponse:CommunityDetailsList? = nil
    
   
//    @Published var addedComment:CommentResponse? = nil
    
//    var modifyComment = PassthroughSubject<(Int,Int),Never>()
    var refreschTokenExpired = PassthroughSubject<(),Never>()
    var wrtiesuccess = PassthroughSubject<Int,Never>()
    var success = PassthroughSubject<(),Never>()
//
//    var modifySuccess = PassthroughSubject<(),Never>()
//    var deleteSuccess = PassthroughSubject<(),Never>()
////    var commentDeleteSuccess = PassthroughSubject<CommentResponse,Never>()
//    var tokenExpired = PassthroughSubject<String,Never>()
//
//
    var cancelable = Set<AnyCancellable>()

    
    init(community: CommunityResponse?, communityList: [CommunityDetailsListResponse]) {
        self.community = community
        self.communityList = communityList
    }
    
    func writeCommunity(contentsId:Int,title:String,content:String,category:Int,spoiler:Bool){
        CommunityApiService.writeCommunity(contentsId: contentsId, title: title, content: content, category: category, spoiler: spoiler)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self.refreschTokenExpired.send()
                case .finished:
                    print(completion)
                }
            } receiveValue: { [weak self] data in
                guard let postingId = data.data?.postingID else {return}
                self?.wrtiesuccess.send(postingId)
//                switch response.status{
//                case 200...300:
//                    self?.posting = response
//                    self?.success.send()
//                case 401:
////                    AuthApiService.getToken()
//                    self?.tokenExpired.send(response.message)
//                default:
//                    break
//                }
            }.store(in: &cancelable)

    }
    func readCommunityList(page:Int,category:Int){
        CommunityApiService.readAllCommunityList(page: page,category:category)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self.refreschTokenExpired.send()
                case .finished:
                    print(completion)
                }
                self.currentPage = page
            } receiveValue: { [weak self] response in
                if let data = response.data{
                    self?.communityList.append(contentsOf: data.postingDetailsResponseList)
                    self?.maxPage = data.totalPages
                }
//                switch response.status{
//                case 200...300:
//                    self?.communityListResponse = response.data
//                    guard let list = response.data?.postingDetailsResponseList else {return}
//                    self?.communityList.append(contentsOf: list)
//                case 401:
////                    AuthApiService.getToken()
//                    self?.tokenExpired.send(response.message)
//                default:
//                    break
//                }
            }.store(in: &cancelable)

    }
    func readListConditionsAll(searchType:Int,query:String,page:Int,sort:String,order:Int){
        CommunityApiService.readListConditionsAll(searchType:searchType,query:query,page:page,sort:sort,order:order)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self.refreschTokenExpired.send()
                case .finished:
                    print(completion)
                }
                self.currentPage = page
            } receiveValue: { [weak self] response in
                if let data = response.data{
                    self?.communityList.append(contentsOf: data.postingDetailsResponseList)
                    self?.maxPage = data.totalPages
                }
//                switch response.status{
//                case 200...300:
//                    self?.communityListResponse = response.data
//                    guard let list = response.data?.postingDetailsResponseList else {return}
//                    print(list)
//                    self?.communityList.append(contentsOf: list)
//                case 401:
////                    AuthApiService.getToken()
//                    self?.tokenExpired.send(response.message)
//                default:
//                    break
//                }
            }.store(in: &cancelable)
    }
    func readDetailCommunity(postingId:Int){
        CommunityApiService.readPosting(postingId: postingId)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self.refreschTokenExpired.send()
                case .finished:
                    print(completion)
                }
//                self.success.send()
            } receiveValue: { [weak self] response in
                self?.community = response.data
//                switch response.status{
//                case 200...300:
//                    self?.communityDetail = response.data
//                    guard let data = response.data?.commentListResponse else {return}
////                    self?.replys.append(contentsOf: data.commentDetailsResponseList)
//                case 401:
////                    AuthApiService.getToken()
//                    self?.tokenExpired.send(response.message)
//                default:
//                    break
//                }
            }.store(in: &cancelable)
    }
    func like(postingId:Int,status:Int){
        CommunityApiService.postingLike(postingId: postingId, status: status)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self.refreschTokenExpired.send()
                case .finished:
                    print(completion)
                }
            } receiveValue: { _ in
                self.success.send()
//                switch response.status{
//                case 401:
////                    AuthApiService.getToken()
//                    self?.tokenExpired.send(response.message)
//                default:
//                    break
//                }
            }.store(in: &cancelable)
    }
    func modifyCommunity(postingId:Int,title:String,content:String,category:Int,spoiler:Bool){
        CommunityApiService.modifyCommunity(postingId: postingId, title: title, content: content, category: category, spoiler: spoiler)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self.refreschTokenExpired.send()
                case .finished:
                    print(completion)
                }
            } receiveValue: { _ in
                self.success.send()
//                switch response.status{
//                case 200...300:
//                    self?.posting = response
//                    self?.success.send()
//                case 401:
////                    AuthApiService.getToken()
//                    self?.tokenExpired.send(response.message)
//                default:
//                    break
//                }
            }.store(in: &cancelable)

    }
    func deleteCommunity(postingId:Int){
        CommunityApiService.deletePosting(postingId: postingId)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error.localizedDescription)
                    self.refreschTokenExpired.send()
                case .finished:
                    print(completion)
                }
            } receiveValue: { _ in
                self.success.send()
//                switch response.status{
//                case 200...300:
//                    self?.deleteSuccess.send()
//                case 401:
////                    AuthApiService.getToken()
//                    self?.tokenExpired.send(response.message)
//                default:
//                    break
//                }
            }.store(in: &cancelable)
    }
}
