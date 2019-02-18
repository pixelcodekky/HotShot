//
//  MovieModel.swift
//  OperationExample
//
//  Created by Kyaw Kyaw Lay on 4/2/19.
//  Copyright © 2019 Kyaw Kyaw Lay. All rights reserved.
//

import Foundation

class MovieModel {
    
    struct MovieDictionaryKeys {
        static let vote_count = "vote_count"
        static let id = "id"
        static let video = "video"
        static let vote_average = "vote_average"
        static let title = "title"
        static let popularity = "popularity"
        static let poster_path = "poster_path"
        static let original_language = "original_language"
        static let original_title = "original_title"
        static let backdrop_path = "backdrop_path"
        static let adult = "adult"
        static let overview = "overview"
        static let release_date = "release_date"
        static let genre_ids = "genre_ids"
    }
    
    var vote_count : Int?
    var id : Int?
    var video : Bool?
    var vote_average : Double?
    var title : String?
    var popularity : Double?
    var poster_path : String?
    var original_language : String?
    var original_title : String?
    var backdrop_path : String?
    var adult : Bool?
    var overview : String?
    var release_date : Date?
    var genre_ids : [Int]?
    
    init(MovieDictionary : [String : Any]) {
        vote_count = MovieDictionary[MovieDictionaryKeys.vote_count] as? Int
        id = MovieDictionary[MovieDictionaryKeys.id] as? Int
        video = MovieDictionary[MovieDictionaryKeys.video] as? Bool
        vote_average = MovieDictionary[MovieDictionaryKeys.vote_average] as? Double
        title = MovieDictionary[MovieDictionaryKeys.title] as? String
        popularity = MovieDictionary[MovieDictionaryKeys.popularity] as? Double
        poster_path = MovieDictionary[MovieDictionaryKeys.poster_path] as? String
        original_language = MovieDictionary[MovieDictionaryKeys.original_language] as? String
        original_title = MovieDictionary[MovieDictionaryKeys.original_title] as? String
        backdrop_path = MovieDictionary[MovieDictionaryKeys.backdrop_path] as? String
        adult = MovieDictionary[MovieDictionaryKeys.adult] as? Bool
        overview = MovieDictionary[MovieDictionaryKeys.overview] as? String
        release_date = MovieDictionary[MovieDictionaryKeys.release_date] as? Date
        genre_ids = MovieDictionary[MovieDictionaryKeys.genre_ids] as? [Int]
    }
}

class MovieDetailModel{
    struct MovieDetailDictionaryKeys {
        static let backdrop_path = "backdrop_path"
        static let budget = "budget"
        static let original_title = "original_title"
        static let release_date = "release_date"
        static let revenue = "revenue"
        static let status = "status"
        static let title = "title"
        static let overview = "overview"
    }
    
    var backdrop_path : String?
    var budget : Int?
    var original_title : String?
    var release_date : String?
    var revenue : Int?
    var status : String?
    var title : String?
    var overview : String?
    
    init(MovieDetailDictionary : [String : Any]){
        backdrop_path = MovieDetailDictionary[MovieDetailDictionaryKeys.backdrop_path] as? String
        budget = MovieDetailDictionary[MovieDetailDictionaryKeys.budget] as? Int
        original_title = MovieDetailDictionary[MovieDetailDictionaryKeys.original_title] as? String
        release_date = MovieDetailDictionary[MovieDetailDictionaryKeys.release_date] as? String
        revenue = MovieDetailDictionary[MovieDetailDictionaryKeys.revenue] as? Int
        status = MovieDetailDictionary[MovieDetailDictionaryKeys.status] as? String
        title = MovieDetailDictionary[MovieDetailDictionaryKeys.title] as? String
        overview = MovieDetailDictionary[MovieDetailDictionaryKeys.overview] as? String
    }
}

class GenresModel {
    
    struct GenresDictionaryKey{
        static let id = "id"
        static let name = "name"
    }
    
    var id : Int?
    var name : String?
    
    init(GenresDictionary : [String:Any]) {
        id = GenresDictionary[GenresDictionaryKey.id] as? Int
        name = GenresDictionary[GenresDictionaryKey.name] as? String
    }
}

class ProductionCompany{
    
    struct ProductionDictionaryKey{
        
    }
    
}
