//
//  ImadRecommend.swift
//  IMAD_Project
//
//  Created by 유영웅 on 6/24/24.
//

import Foundation

struct ImadRecommend:Codable{
    var popularRecommendationTv: RecommendList?
    var popularRecommendationMovie: RecommendList?
    var topRatedRecommendationTv: RecommendList?
    var topRatedRecommendationMovie: RecommendList?
    
    enum CodingKeys: String, CodingKey {
        case popularRecommendationTv = "popular_recommendation_tv"
        case popularRecommendationMovie = "popular_recommendation_movie"
        case topRatedRecommendationTv = "top_rated_recommendation_tv"
        case topRatedRecommendationMovie = "top_rated_recommendation_movie"
    }
}
