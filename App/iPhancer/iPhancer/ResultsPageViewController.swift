//
//  ResultsPageViewController.swift
//  iPhancer
//
//  Created by Parker Thomas on 12/1/17.
//  Copyright © 2017 Parker Thomas. All rights reserved.
//

import Foundation
import UIKit

class ResultsPageViewController: UIPageViewController {
    
    
    // imagename is only the hash generated. _original, _processed and .png need to be added when checking the server
    var filename: String!
    var pollTimer: Timer!
    static var downloadedImage: UIImage!
    var originalImage: UIImage!
    var saver: ImageSaver!
    
    var apiManager: RestAPIManager!

    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "OriginalViewController"),
            self.getViewController(withIdentifier: "ProcessedViewController")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    var pageControl = UIPageControl()
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        RestAPIManager.singleton.resultsPageVC = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControl()
        
        let originalVC = pages[0] as! OriginalImageViewController
        let processedVC = pages[1] as! ProcessedImageViewController
        originalVC.imageView.image = originalImage
        
        
        pollTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ResultsPageViewController.checkStatus), userInfo: nil, repeats: true)
        
    }
    
    @objc func checkStatus() {
        let processedImageName = filename+"_processed.png"
        let originalImageName = filename+"_original.png"
        if RestAPIManager.singleton.getProcessStatus(filename: processedImageName) == "done" {
            //RestAPIManager.singleton.getProcessedPhoto(filename: processedImageName)
            
            
            pollTimer.invalidate()
            
            var originalVC = pages[0] as! OriginalImageViewController
            var processedVC = pages[1] as! ProcessedImageViewController
            
            originalVC.navigationBar.title = "Original"
            
            processedVC.makeWebView(url: "http://localhost:5000/enhanced/"+processedImageName)
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.index(of: pageContentViewController)!
    }
    
    
}

extension ResultsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
}

extension ResultsPageViewController: UIPageViewControllerDelegate { }


