//
//  ViewController.swift
//  OperationExample
//
//  Created by Kyaw Kyaw Lay on 4/2/19.
//  Copyright © 2019 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var image_url : String = "https://image.tmdb.org/t/p/original/"
    var image_url : String = "https://image.tmdb.org/t/p/w500/"
    
    var movies : [MovieModel] = []
    var imgInfo : [ImageInfo] = []
    let mainOpera = MainOperations()
    let configuration = URLSessionConfiguration.default
    var session : URLSession?
    var isConnected : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check connection
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        configuration.timeoutIntervalForResource = 300
        configuration.waitsForConnectivity = true
        session = URLSession(configuration: configuration, delegate: self as URLSessionDelegate, delegateQueue: nil)
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "moviecell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

    //MARK : tableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviecell", for: indexPath) as! MovieTableViewCell
        
        //cell.cell_image.contentMode = .scaleAspectFit
        cell.cell_label.text = movies[indexPath.row].original_title
        
        
        let iminfo = imgInfo[indexPath.row]
        //print(iminfo.url)
        cell.cell_image.image = iminfo.image
        
        if isConnected {
            switch iminfo.state {
            case .new,.downloaded:
                if !tableView.isDragging && !tableView.isDecelerating{
                    startOperations(imgInfo: iminfo, at: indexPath)
                }
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetailseg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //set data to Detail page
        let destinationVC = segue.destination as! MovieDetailViewController
        if let index = tableView.indexPathForSelectedRow{
            destinationVC.nav_item.title = self.movies[index.row].title
            destinationVC.urlimg = URL(string: "\(self.image_url)\(self.movies[index.row].backdrop_path!)")
            destinationVC.movieID = self.movies[index.row].id!
        }
    }
    
    //MARK : local methods
    func startFetching(){
        fetchMovies(urlpara: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=4f22632184da7a2746bcc76724549a5b&language=en-US&page=1")!)
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        if userInfo!["Status"] as! String != "Offline" && userInfo!["Status"] as! String != "Unknow" {
            //do somethings
            isConnected = true
            if movies.count == 0 {
                startFetching()
            }
        }else{
            isConnected = false
        }
    }
    
    func fetchMovies(urlpara : URL){
        //url session
        let task = session!.dataTask(with: urlpara) { (data, response, error) in
            if error != nil {
                print(error as Any)
            }else{
                do{
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any>{
                        let result = jsonResult["results"] as! NSArray
                        self.setMoviesList(result: result)
                    }
                }catch{
                    
                }
            }
        }
        task.resume()
        
    }
    
    func setMoviesList(result list : NSArray){
        for i in list{
            let finalres = i as! Dictionary<String,Any>
            let movietmp = MovieModel(MovieDictionary: finalres)
            movies.append(movietmp)
        }
        fetchImage()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchImage(){
        if !self.movies.isEmpty{
            for movie in self.movies {
                let imagerec = ImageInfo(url: URL(string: self.image_url + movie.backdrop_path!)!)
                imgInfo.append(imagerec)
            }
        }
    }
    
    func startOperations(imgInfo : ImageInfo,at indexpath: IndexPath ){
        switch (imgInfo.state) {
        case .new:
            startDownload(image_info: imgInfo, at: indexpath)
        case .downloaded:
            break
        case .failed:
            NSLog("Photo Download Fail.")
            break
        }
    }
    
    func startDownload(image_info: ImageInfo, at indexpath : IndexPath ){
        guard mainOpera.downloadInProgress[indexpath] == nil  else{
            return
        }
        let tmpDownloadInfo = downloadImage(imgInfo: image_info)
        
        tmpDownloadInfo.completionBlock = {
            //write something after finish operation for execution
            //example update to UI or assign to something
            if tmpDownloadInfo.isCancelled{
                return
            }
            
            DispatchQueue.main.async {
                self.mainOpera.downloadInProgress.removeValue(forKey: indexpath)
                self.tableView.reloadRows(at: [indexpath], with: .fade)
                //print("complete donwload \(image_info.url)")
                
            }
        }
        mainOpera.downloadInProgress[indexpath] = tmpDownloadInfo
        mainOpera.operationQueue.addOperation(tmpDownloadInfo)
    }

}

extension ViewController : URLSessionTaskDelegate{
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        if task.error != nil{
            print(task.error?.localizedDescription as Any)
        }else{
            print(task.response as Any)
        }
        
    }
}

extension ViewController : UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if isConnected {
            for indexpath in indexPaths{
                var cell = MovieTableViewCell()
                cell = tableView.dequeueReusableCell(withIdentifier: "moviecell", for: indexpath) as! MovieTableViewCell
                cell.cell_label.text = movies[indexpath.row].original_title
                let iminfo = imgInfo[indexpath.row]
                //print(iminfo.url)
                cell.cell_image.image = iminfo.image
                
                if isConnected {
                    switch iminfo.state {
                    case .new,.downloaded:
                        startOperations(imgInfo: iminfo, at: indexpath)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //print(indexPaths)
//        for indexpath in indexPaths{
//            guard mainOpera.downloadInProgress[indexpath] == nil  else{
//                return
//            }
//            DispatchQueue.main.async {
//                self.mainOpera.downloadInProgress.removeValue(forKey: indexpath)
//                self.tableView.reloadRows(at: [indexpath], with: .fade)
//                //print("complete donwload \(image_info.url)")
//
//            }
//        }
    }
}

