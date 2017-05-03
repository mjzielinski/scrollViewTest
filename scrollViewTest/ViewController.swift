//
//  ViewController.swift
//  scrollViewTest
//
//  Created by Michael Zielinski on 5/2/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//


// Makes scrolling zoomable pictures

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    
    // outlet from Main scrollView in storyboard
    @IBOutlet weak var scrollView: UIScrollView!
    
    // outlet from button placed on Main scrollview in storyboard
    @IBOutlet weak var label: UILabel!

    // outlet from pageControl in storyboard
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    // the array of images
    var images = [UIImage]()
    
    // used to keep an array of UIImageView for zooming
    var imageViewArray = [UIImageView]()
    
    // used to calculated total content width for outer scrollView
    var contentWidth : CGFloat = 0.0
    
    // keeps track of any inner scrollView that was zoomed
    var zoomedScrollView : UIScrollView? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImages()
        
        // the outer scrollView
        scrollView.tag = 99
        
        // used to set up page control
        configurePageControl()
        
        // for each image
        for index in 0 ..< images.count {
            // create an inner scroll view for zooming
            let zoomScrollView = UIScrollView()
            zoomScrollView.frame.size = scrollView.frame.size
            zoomScrollView.frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            zoomScrollView.minimumZoomScale = 1.0
            zoomScrollView.maximumZoomScale = 3.0
            zoomScrollView.delegate = self
            zoomScrollView.tag = index
            zoomScrollView.showsVerticalScrollIndicator = false
            zoomScrollView.showsVerticalScrollIndicator = false
            zoomScrollView.clipsToBounds = true
            scrollView.addSubview(zoomScrollView)
            
            // add the imageview to the inner scroll view
            let imageView = UIImageView(image: images[index])
            imageView.frame.origin.x = 0
            imageView.frame.size = scrollView.frame.size
            imageViewArray.append(imageView)
            zoomScrollView.addSubview(imageView)
            
            // add the inner scroll view to the outer scroll view
            scrollView.addSubview(zoomScrollView)
            
            // keep track of proper width for outer scroll view
            contentWidth += imageView.frame.size.width
        }
        
        // set paging and content size for outer scroll view
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: contentWidth, height: self.scrollView.frame.size.height)
    }
    
    // configure the page control
    func configurePageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(red: 214/255.0, green: 225/255.0, blue: 239/255.0, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 86/255.0, green: 104/255.0, blue: 133/255.0, alpha: 1.0)
        
    }
    
    // used by page control to keep track of current page
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 99 {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
    
    
    // used to allow inner scrollViews to zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // kepp track of any zoomed inner scroll view
        zoomedScrollView = scrollView
        return imageViewArray[scrollView.tag]
    }
    
    // if outer scroll view scrolled, and previous inner scroll view was zoomed, reset zoomscale
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if pageControl.currentPage != zoomedScrollView?.tag {
            zoomedScrollView?.zoomScale = 1.0
        }
    }
    
    
    // sets up images for test
    func setUpImages() {
        let image1 = #imageLiteral(resourceName: "placeholder")
        let image2 = #imageLiteral(resourceName: "sample")
        let image3 = #imageLiteral(resourceName: "check")
        images.append(image1)
        images.append(image2)
        images.append(image3)
    }

    // testing page control
    @IBAction func buttonTapped(_ sender: Any) {
        label.text = "Page Number is \(pageControl.currentPage)"
    }

}

