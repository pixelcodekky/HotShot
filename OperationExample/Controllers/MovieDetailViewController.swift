//
//  MovieDetailViewController.swift
//  OperationExample
//
//  Created by Kyaw Kyaw Lay on 6/2/19.
//  Copyright © 2019 Kyaw Kyaw Lay. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController : UIViewController{
    
    @IBOutlet weak var nav_item: UINavigationItem!
    @IBOutlet weak var detail_img: UIImageView!
    @IBOutlet weak var detail_status: UILabel!
    @IBOutlet weak var detail_budget: UILabel!
    @IBOutlet weak var detail_overview: UILabel!
    @IBOutlet weak var detail_view: UIView!
    
    
    let urlCache = URLCache(memoryCapacity: 20*1024*1024, diskCapacity: 20*1024*1024, diskPath: nil)
    
    
    var mainImage_url : String = "https://image.tmdb.org/t/p/original/"
    var movieID : Int = 0
    //https://image.tmdb.org/t/p/original//lvjscO8wmpEbIfOEZi92Je8Ktlg.jpg
    var urlimg : URL?
    var tmpurlmovie = "https://api.themoviedb.org/3/movie/505954?api_key=4f22632184da7a2746bcc76724549a5b&language=en-US"
    let numFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numFormatter.locale = Locale.current
        numFormatter.numberStyle = .currency
        
        fetchDetail(urlpara: URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=4f22632184da7a2746bcc76724549a5b&language=en-US")!)
    }
 
    func fetchDetail(urlpara : URL){
        //prepare urlCache
        let urlrequest = URLRequest(url: urlpara)
        let cacheResponse = URLCache.shared.cachedResponse(for: urlrequest)
        
        if cacheResponse == nil {
            let task = URLSession.shared.dataTask(with: urlpara) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                }else{
                    self.populateDetail(data: data,urlrequest: urlrequest,isCached: false,cacheresponse: response)
                }
            }
            task.resume()
        }else{
            populateDetail(data: cacheResponse?.data,urlrequest: urlrequest,isCached: true)
            //print("print from cache")
        }
    }
    
    func populateDetail(data : Data?,urlrequest : URLRequest,isCached : Bool,cacheresponse : URLResponse? = nil){
        do{
            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any>{
                
                let movieDetail = MovieDetailModel(MovieDetailDictionary: jsonResult)
                
                DispatchQueue.main.async {
                    self.detail_status.text = movieDetail.status ?? ""
                    if let formattedTipAmount = self.numFormatter.string(from: movieDetail.budget! as NSNumber ) {
                        self.detail_budget.text = "\(formattedTipAmount)"
                    }
                    self.detail_overview.text = movieDetail.overview ?? ""
                }
                    let config = URLSessionConfiguration.default
                    //Enable url cache in session configuration and assign capacity
                    config.urlCache = URLCache.shared
                    config.urlCache = URLCache(memoryCapacity: 4*1024*1024, diskCapacity: 20*1024*1024, diskPath: "urlCache")
                    //create session with configration
                    let session = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: nil)
                
                    DispatchQueue.global(qos: .background).async {
                        //write background task
                        let tmpUrl = "\(self.mainImage_url)\(movieDetail.backdrop_path!)"
                        let _imgurl : URL = URL(string: tmpUrl)!
                        
                        let urlrequest = URLRequest(url: _imgurl)
                        let cacheImage = URLCache.shared.cachedResponse(for: urlrequest)
                        
                        if cacheImage == nil{
                            CommonWorker.downloadImage(withUrl: _imgurl, withSession: session , completion: { (image, response, data) in
                                if let img = image {
                                    self.detail_img.image = img
                                    self.detail_img.contentMode = .scaleAspectFill
                                    let cacheimageurlresponse = CachedURLResponse(response: response, data: data)
                                    let imgurlRequest : URLRequest = URLRequest(url: _imgurl)
                                    URLCache.shared.storeCachedResponse(cacheimageurlresponse, for: imgurlRequest)
                                }
                            })
                        }else{
                            DispatchQueue.main.async {
                                self.detail_img.image = UIImage(data: (cacheImage?.data)!)
                                self.detail_img.contentMode = .scaleAspectFill
                                
                                let cacheimageurlresponse = CachedURLResponse(response: (cacheImage?.response)!, data: (cacheImage?.data)!)
                                let imgurlRequest : URLRequest = URLRequest(url: _imgurl)
                                URLCache.shared.removeCachedResponse(for: imgurlRequest)
                                URLCache.shared.storeCachedResponse(cacheimageurlresponse, for: imgurlRequest)
                            }
                        }
                        if !isCached{
                            //URLCache.shared.removeCachedResponse(for: cacheresp)
                            let cacheurlresponse = CachedURLResponse(response: cacheresponse!, data: data!)
                            URLCache.shared.storeCachedResponse(cacheurlresponse, for: urlrequest)
                        }
                   }
            }
        }catch{
            
        }
    }
}
