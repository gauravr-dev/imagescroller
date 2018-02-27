//
//  ImageScrollView.swift
//  ForDentist
//
//  Created by Gaurav Rajput on 1/24/17.
//  Copyright © 2017 Mofluid. All rights reserved.
//

import Foundation
import UIKit

class ImageScrollView : UIScrollView, UIScrollViewDelegate {
    
    var maxPages: Int = 3
    var imageUrls: [String] = ["1.png","2.png","3.png","4.png","5.png","1.png","3.png","1.png","2.png","3.png","2.png","3.png"]
    var kPageWidth:CGFloat = 0.0
    var currentIndex = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        guard superview != nil else { return }
        
        let frame = UIScreen.main.bounds
        contentSize = CGSize(width: frame.size.width * CGFloat(3), height: frame.size.height)
        
        var newFrame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        let imageView1 = UIImageView(frame: newFrame)
        imageView1.contentMode = .scaleAspectFit
        imageView1.tag = 1
        imageView1.image = UIImage(named: imageUrls[8])
        self.addSubview(imageView1)
        
        newFrame = CGRect(x: frame.width, y: 0.0, width: frame.width, height: frame.height)
        let imageView2 = UIImageView(frame: newFrame)
        imageView2.contentMode = .scaleAspectFit
        imageView2.tag = 2
        imageView2.image = UIImage(named: imageUrls[0])
        self.addSubview(imageView2)
        
        newFrame = CGRect(x: frame.width * 2.0, y: 0.0, width: frame.width, height: frame.height)
        let imageView3 = UIImageView(frame: newFrame)
        imageView3.contentMode = .scaleAspectFit
        imageView3.tag = 3
        imageView3.image = UIImage(named: imageUrls[1])
        self.addSubview(imageView3)
        
        layoutIfNeeded()
        
        
        //        [scrollView scrollRectToVisible:CGRectMake(320,0,320,416) animated:NO];
        self.scrollRectToVisible(CGRect(x: frame.width, y: 0.0, width: frame.width, height: frame.width), animated: false)
    }
    
    // 5
    @objc internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = frame.size.width
        let currentPage = floor((contentOffset.x - (pageWidth/2)) / pageWidth) + 1
        
    }
    
    @objc internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //Goinf forward
        if self.contentOffset.x > self.bounds.size.width {
            loadPageWithId(currentIndex, onPage: 0)
            currentIndex = currentIndex >= imageUrls.count - 1 ? 0 : currentIndex + 1
            loadPageWithId(currentIndex, onPage: 1)
            let nextIndex = currentIndex >= imageUrls.count - 1 ? 0 : currentIndex + 1
            loadPageWithId(nextIndex, onPage: 2)
        }
        //Going backward
        if self.contentOffset.x > self.bounds.size.width {
            loadPageWithId(currentIndex, onPage: 2)
            currentIndex = currentIndex == 0 ? imageUrls.count - 1 : currentIndex - 1
            loadPageWithId(currentIndex, onPage: 1)
            let prevIndex = currentIndex == 0 ? imageUrls.count - 1 : currentIndex - 1
            loadPageWithId(prevIndex, onPage: 0)
        }
        self.scrollRectToVisible(CGRect(x: frame.width, y: 0.0, width: frame.width, height: frame.width), animated: false)
    }
    
    func clearScrollView() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func loadPageWithId(_ index:Int, onPage:Int) {
        switch onPage {
        case 0:let view = self.viewWithTag(1) as! UIImageView
        view.image = UIImage(named: imageUrls[index])
            break
        case 1:
            let view = self.viewWithTag(2) as! UIImageView
            view.image = UIImage(named: imageUrls[index])
            break
        case 2:
            let view = self.viewWithTag(3) as! UIImageView
            view.image = UIImage(named: imageUrls[index])
            break
        default:print("Invalid index")
        }
    }
}
