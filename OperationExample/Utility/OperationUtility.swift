//
//  OperationUtility.swift
//  OperationExample
//
//  Created by Kyaw Kyaw Lay on 4/2/19.
//  Copyright © 2019 Kyaw Kyaw Lay. All rights reserved.
//

import Foundation
import UIKit

enum downloadState {
    case new,downloaded,failed
}

class ImageInfo{
    let url : URL
    var state = downloadState.new
    var image : UIImage?
    
    init(url : URL) {
        self.url = url
    }
}

class MainOperations{
    lazy var downloadInProgress : [IndexPath : Operation] = [:]
    lazy var operationQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "MainOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class downloadImage : Operation {
    
    let imageInfo : ImageInfo
    
    init(imgInfo : ImageInfo) {
        self.imageInfo = imgInfo
    }
    
    override func main(){
        if isCancelled {
            return
        }
        
        guard let downloadedimage = try? Data(contentsOf: imageInfo.url) else {fatalError("Error request image url")}
        
        if isCancelled { return }
        
        if !downloadedimage.isEmpty{
            imageInfo.image = UIImage(data: downloadedimage)
            imageInfo.state = .downloaded
        }else{
            imageInfo.image = nil
            imageInfo.state = .failed
        }
    }
}
