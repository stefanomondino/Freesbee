//
//  APIManager.swift
//
//  Created by Stefano Mondino on 16/11/16.
//  Copyright © 2016 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxCocoa
import RxSwift
import Action
import Gloss
import Result
import Moya
import AlamofireImage

struct APIManager {
    
    static var provider: RxMoyaProvider<TVMaze>  = {
        let endpointClosure = { (target: TVMaze) -> Endpoint<TVMaze> in
            return MoyaProvider.defaultEndpointMapping(for:target)
        }
        
        return RxMoyaProvider<TVMaze>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true)])
    }()
    
    
    static let downloader = {return ImageDownloader()}()
    static func  downloadImage(_ string:String?) -> Observable<UIImage?> {
        return self.downloadImage(URL(string: string ?? ""))
    }
    static func  downloadImage(_ url:URL?) -> Observable<UIImage?> {
        guard let url = URL(string:url?.absoluteString.removingPercentEncoding ?? "") else {
            return .just(nil)
        }
        return Observable.create({ observer  in
            
            observer.onNext(nil)
            let urlRequest = URLRequest(url:url )
            
            let receipt = downloader.download(urlRequest, completion: { (response) in
                
                if let error =  response.result.error{
                    observer.onError(error)
                }
                if let image = response.result.value {
                    observer.onNext(image)
                    observer.onCompleted()
                }
                
            })
            return Disposables.create {
                if (receipt != nil){
                    downloader.cancelRequest(with: receipt!)
                }
            }
        })
    }
    static func query(_ query:String) -> Observable<[Show]> {
        
        return self.provider.request(.search(query))
            .mapArray(type: QueryResult.self)
            .map { queryResults in queryResults.map {$0.show}}
            .catchError({ (error) -> Observable<[Show]> in
                return .empty()
            })
    }
    static func shows() -> Observable<[Show]> {
        
        return self.provider.request(.shows)
            .mapArray(type: Show.self)
            .catchError({ (error) -> Observable<[Show]> in
                return .empty()
            })
    }
    static func detail(show:Show) -> Observable<Show>{
        return self.provider.request( .detail(identifier: String(stringInterpolationSegment:show.id)))
            .mapObject(type: Show.self)
            .catchError({ (error) -> Observable<Show> in
                return .empty()
            })
    }

    
}
