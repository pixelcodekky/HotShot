//
//  CommonWorker.swift
//  OperationExample
//
//  Created by Kyaw Kyaw Lay on 12/2/19.
//  Copyright © 2019 Kyaw Kyaw Lay. All rights reserved.
//

import Foundation
import UIKit

class CommonWorker{
    
    //Common image download function
    static func downloadImage(withUrl url: URL,withSession session: URLSession, completion: @escaping (_ image:UIImage?,_ paraResponse : URLResponse,_ data:Data)->()){
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            var downloadedImage:UIImage?
            if let data = data {
                downloadedImage = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(downloadedImage,response!,data)
                }
            }
        }
        dataTask.resume()
    }
}
