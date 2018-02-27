//
//  ViewController.swift
//  ImageScroller
//
//  Created by Gaurav Rajput on 1/24/17.
//  Copyright © 2017 Spring Sprout. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageUrls = ["1.png","2.png","3.png","4.png","5.png","1.png","3.png","1.png","2.png","3.png","2.png","3.png"]
        
        //        // 1
        //        let view1 = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        //        view1.backgroundColor = .redColor()
        //        view1.image = UIImage(named: imageUrls[0])
        //        let view2 = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        //        view2.backgroundColor = .greenColor()
        //        view2.image = UIImage(named: imageUrls[1])
        //        
        //        let view3 = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        //        view3.backgroundColor = .blueColor()
        //        view3.image = UIImage(named: imageUrls[2])
        //        // 2
        //        scrollView.imageUrls = imageUrls
        //        scrollView?.numPages = 3
        //        scrollView?.viewObjects = [view1, view2, view3]
        //        
        //        // 3
        //        scrollView?.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

/**
 
 import Foundation
 import UIKit
 
 class ImageScrollView : UIScrollView, UIScrollViewDelegate {
 
 // 1
 var viewObjects: [UIView]?
 var imageUrls: [String]?
 var numPages: Int = 0
 
 // 2
 required init?(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 
 pagingEnabled = true
 showsHorizontalScrollIndicator = false
 showsVerticalScrollIndicator = false
 scrollsToTop = false
 delegate = self
 }
 
 // 3
 func setup() {
 guard let parent = superview else { return }
 
 contentSize = CGSize(width: (frame.size.width * (CGFloat(numPages) + 2)), height: frame.size.height)
 
 loadScrollViewWithPage(0)
 loadScrollViewWithPage(1)
 loadScrollViewWithPage(2)
 
 var newFrame = frame
 newFrame.origin.x = newFrame.size.width
 newFrame.origin.y = 0
 scrollRectToVisible(newFrame, animated: false)
 
 layoutIfNeeded()
 }
 
 // 4
 private func loadScrollViewWithPage(page: Int) {
 if page < 0 { return }
 if page >= numPages + 2 { return }
 
 var index = 0
 
 if page == 0 {
 index = numPages - 1
 } else if page == numPages + 1 {
 index = 0
 } else {
 index = page - 1
 }
 
 let view = viewObjects?[index]
 
 var newFrame = frame
 newFrame.origin.x = frame.size.width * CGFloat(page)
 newFrame.origin.y = 0
 view?.frame = newFrame
 
 if view?.superview == nil {
 addSubview(view!)
 }
 
 layoutIfNeeded()
 }
 
 // 5
 @objc internal func scrollViewDidScroll(scrollView: UIScrollView) {
 let pageWidth = frame.size.width
 let page = floor((contentOffset.x - (pageWidth/2)) / pageWidth) + 1
 
 loadScrollViewWithPage(Int(page - 1))
 loadScrollViewWithPage(Int(page))
 loadScrollViewWithPage(Int(page + 1))
 }
 
 // 6
 @objc internal func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
 let pageWidth = frame.size.width
 let page : Int = Int(floor((contentOffset.x - (pageWidth/2)) / pageWidth) + 1)
 
 if page == 0 {
 contentOffset = CGPoint(x: pageWidth*(CGFloat(numPages)), y: 0)
 } else if page == numPages+1 {
 contentOffset = CGPoint(x: pageWidth, y: 0)
 }
 }
 
 }
 **/
 
