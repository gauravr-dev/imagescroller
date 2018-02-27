//
//  ImageScrollView.swift
//  ForDentist
//
//  Created by Gaurav Rajput on 1/24/17.
//  Copyright © 2017 Mofluid. All rights reserved.
//

import Foundation
import UIKit

//
//  BannersTableCell.swift
//  Mannlake
//
//  Created by Gaurav Rajput on 2/6/18.
//  Copyright © 2018 Mofluid. All rights reserved.
//

import UIKit

//TODO: Change collectionview to ScrollView to smooth the animation.


protocol BannersTableCellDataSource
{
    
    func numberOfBanners(cell: BannersTableCell) -> Int
    
    func bannerSize(cell: BannersTableCell, for index: Int) -> CGSize
    
    func bannerImage(cell: BannersTableCell, at index: Int) -> String
    
}

protocol BannersTableCellDelegate
{
    func bannerDidSelected(cell: BannersTableCell, bannerIndex: Int)
}

class BannersTableCell: UITableViewCell, UIScrollViewDelegate {
    
    var delegate:BannersTableCellDelegate?
    var datasource:BannersTableCellDataSource?
    
    @IBOutlet weak var imgCollectionView:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    
    let cellIdentifier = "ImageCollectionCell"
    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(10)
    var itemHeight = CGFloat(200)
    var itemWidth = CGFloat(0)
    private var timer: Timer?
    var maxBanners = 0
    
    var shouldAutoRotate: Bool {
        set {
            if newValue {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollItem), userInfo: nil, repeats: true)
            }else{
                self.timer?.invalidate()
                self.timer = nil
            }
        }
        get{
            return false
        }
    }
    
    // public vars
    var shouldReload:Bool {
        set {
            if newValue {
                self.imgCollectionView.reloadData()
            }
        }
        get {return false}
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        self.imgCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemWidth =  self.bounds.width
        if maxBanners > 1 {
            itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        }
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        
        self.imgCollectionView?.collectionViewLayout.invalidateLayout()
        self.imgCollectionView?.collectionViewLayout = layout
        self.imgCollectionView?.decelerationRate = UIScrollViewDecelerationRateNormal
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
        shouldReload = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        maxBanners = 0
        self.timer?.invalidate()
        delegate = nil
        datasource = nil
        self.imgCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setup() {
        maxBanners = datasource?.numberOfBanners(cell: self) ?? 0
        self.pageControl.numberOfPages = maxBanners
        self.itemHeight = self.bounds.size.height
        
        if maxBanners <= 1 {
            self.imgCollectionView.isScrollEnabled = false
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func scrollItem() {
        if self.maxBanners <= 0 {
            return
        }
        
        let pageWidth = Float(itemWidth + itemSpacing)
        var currentPage = self.pageControl.currentPage
        if currentPage < self.maxBanners - 1
        {
            currentPage += 1
        }
        else
        {
            currentPage = 0
            self.pageControl.currentPage = currentPage
            self.imgCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            return
        }
        
        self.pageControl.currentPage = currentPage
        
        UIView.animate(withDuration: 1.2, animations: {
            self.imgCollectionView.setContentOffset(CGPoint(x:  currentPage * Int(pageWidth), y: 0), animated: false)
        }, completion: { _ in
            
        })
    }
    
}

extension BannersTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxBanners
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! ImageCollectionViewCell
        // Configure the cell
        let imageString = datasource?.bannerImage(cell: self, at: indexPath.row)
        UIImageCache.setImage(cell.imgBanner, image: imageString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        itemWidth =  self.bounds.width
        if maxBanners > 1 {
            itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        }
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if maxBanners == 1 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionMargin, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if maxBanners == 1 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionMargin, height: 0)
    }
    
    // MARK: - UIScrollViewDelegate protocol
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(imgCollectionView!.contentSize.width  )
        var newPage = Float(self.pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}





//TODO: Place it in separate file
//MARK: TextBanner class

protocol TextBannerTableCellDataSource {
    func numberOfTextBanners() -> Int
    
    func bannerText(at index:Int) -> String
    
}

class TextBannerTableCell: UITableViewCell {
    
    @IBOutlet weak var bannerTextLabel:UILabel!
    
    private var timer: Timer?
    private var visibleBannerIndex = 0
    private var maxBanners = 0
    
    var datasource: TextBannerTableCellDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black
        self.bannerTextLabel.textColor = MannlakeColor.color(hexcode: .yellow)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shouldReload = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var shouldReload:Bool {
        set{
            if newValue {
                maxBanners = (datasource?.numberOfTextBanners()) ?? 0
                if maxBanners > 1 {
                    visibleBannerIndex = 0
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeText), userInfo: nil, repeats: true)
                    self.timer?.fire()
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
        get {return false}
    }
    
    // public vars
    var bannerText:String {
        set{
            if newValue != "" {
                // Fade out to set the text
                UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.bannerTextLabel.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    let string = "<center>" + newValue + "</center>"
                    let encodedData = string.data(using: String.Encoding.utf8)!
                    let attributedOptions = [
                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                    ]
                    do {
                        let attributedString = try NSMutableAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.bannerTextLabel.text = attributedString.string
                    } catch _ {
                        print("Cannot create attributed String")
                    }
                    
                    // Fade in
                    UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        self.bannerTextLabel.alpha = 1.0
                    }, completion: nil)
                })
            }
        }
        get {
            return bannerTextLabel.text ?? ""
        }
    }
    
    func changeText() {
        if maxBanners > 0 {
            if visibleBannerIndex >= maxBanners {
                visibleBannerIndex = 0
            }
            if visibleBannerIndex >= 0 {
                bannerText = (datasource?.bannerText(at: visibleBannerIndex)) ?? ""
                visibleBannerIndex += 1
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bannerTextLabel.text = ""
        visibleBannerIndex = -1
        self.timer?.invalidate()
    }
    
}






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
