//
//  PagedViewController.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 16.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit



class PagedViewController: UIViewController, UIScrollViewDelegate {

    
    //@IBOutlet var scrollView: MyScrollView!
    var scrollView: MyScrollView?
    @IBOutlet var pageControl: UIPageControl!
    


    var packageName: String?
    var package: Package?

    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []

    let TableNumColumns = 5
    let TableNumRows = 6
    let multiplicator = 0.8

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = MyScrollView(frame: self.view.bounds)
        scrollView!.backgroundColor = UIColor.whiteColor()
        scrollView!.parent = self
        scrollView!.delegate = self
        scrollView!.pagingEnabled = true

        view.addSubview(scrollView!)
        
        
        //println("screenSze: \(screenSize), viewSize: \(view.bounds), scrollView.size: \(scrollView!.bounds)")
        scrollView!.TableNumColumns = self.TableNumColumns
        scrollView!.TableNumRows = self.TableNumRows
        
        package = Package(packageName: packageName!)
        //println("volumeCount: \(package!.getVolumeCount())")
        scrollView!.package = package
        let pageCount = package!.getVolumeCount()
        generateVolumePageImages(pageCount)
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scrollView!.frame.size
        scrollView!.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView!.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView!.addSubview(newPageView)
            scrollView!.page = page
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView!.frame.size.width
        let page = Int(floor((scrollView!.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func generateVolumePageImages(pageCount: Int) {

        let multiplicator: CGFloat = 0.9
        
        let size = self.view.bounds.size
        let origin = self.view.bounds.origin
        let vSizeWidth:CGFloat = size.width * multiplicator
        let Gap: CGFloat = vSizeWidth / CGFloat(30)
        let rectSize: CGFloat = (vSizeWidth - (CGFloat(TableNumColumns) + 1) * Gap) / CGFloat(TableNumColumns)
        
        let vSize = CGSizeMake( (rectSize + Gap) * CGFloat(TableNumColumns) + Gap,
            (rectSize + Gap) * CGFloat(TableNumRows) + Gap)
        let vOrigin = CGPointMake((size.width - vSize.width) / 2, (size.height - vSize.height) / 3)
        
        let vBounds = CGRectMake(vOrigin.x, vOrigin.y, vSize.width, vSize.height)
        
        scrollView!.vBounds = vBounds

        
        for pageNr in 0..<pageCount {
            let gameName = package?.getVolumeName(pageNr)
            
            //let image = drawCustomImage(gameName!)
            let name = "auswahl\(pageNr).png"
            let image = UIImage(named: "auswahl\(pageNr).png")
            pageImages.append(image!)
        }
    }
    
    func drawCustomImage(volumeName: NSString) -> UIImage {
        // Setup our context
        let opaque = false
        let scale: CGFloat = 0
        let multiplicator: CGFloat = 0.9
        
        let size = self.view.bounds.size
        let origin = self.view.bounds.origin
        let vSizeWidth:CGFloat = size.width * multiplicator
        let Gap: CGFloat = vSizeWidth / CGFloat(30)
        let rectSize: CGFloat = (vSizeWidth - (CGFloat(TableNumColumns) + 1) * Gap) / CGFloat(TableNumColumns)
        
        let vSize = CGSizeMake( (rectSize + Gap) * CGFloat(TableNumColumns) + Gap,
                                (rectSize + Gap) * CGFloat(TableNumRows) + Gap)
        let vOrigin = CGPointMake((size.width - vSize.width) / 2, (size.height - vSize.height) / 3)
        
        let vBounds = CGRectMake(vOrigin.x, vOrigin.y, vSize.width, vSize.height)
        
        scrollView!.vBounds = vBounds
        
        
        let fontName = "HelveticaNeue-Bold"
        let helveticaBold = UIFont(name: fontName, size: 30.0)
        
        let font = UIFont.boldSystemFontOfSize(30.0) //   preferredFontForTextStyle(UIFontTextStyleHeadline)
        let textColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        
        let attributes = [
            NSForegroundColorAttributeName : textColor,
            NSFontAttributeName : font,
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
        ]
        //let attributedString = NSAttributedString(string:  volumeName, attributes: attributes)
        
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetLineWidth(context, 2.0)

        
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextStrokeRect(context, vBounds)
        
        //CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        //CGContextStrokeRect(context, view.bounds)

        volumeName.drawInRect(CGRect(x: 15, y: 30, width: 200, height: 40), withAttributes: attributes)

        
        CGContextBeginPath(context)
        
        for column in 0..<TableNumColumns {
            for row in 0..<TableNumRows {
                
                let x = vOrigin.x + Gap + CGFloat(column) * (rectSize + Gap)
                let y = vOrigin.y + Gap + CGFloat(row) * (rectSize + Gap)
                let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
                textStyle.alignment = NSTextAlignment.Center
                
                
                let rectOrigin: CGPoint = CGPointMake(x, y)
                
                let Nr = row * TableNumColumns + column + 1
                let rectText = CGRect(
                        x: x,
                        y: y + 10,
                        width: rectSize,
                        height: rectSize
                )
                let rect = CGRect(
                    x: x,
                    y: y,
                    width:  rectSize,
                    height: rectSize
                )
                
                

                let stringNr = Nr.description
 
                let textFontAttributes = [
                    NSFontAttributeName: font,
                    NSForegroundColorAttributeName: textColor,
                    NSParagraphStyleAttributeName: textStyle
                ]
                    
                stringNr.drawInRect(rectText, withAttributes: textFontAttributes)
                //let attributedString = NSAttributedString(string:  stringNr, attributes: attributes)
                //attributedString.drawAtPoint(rectOrigin)
                //stringNr.drawAtPoint(rectOrigin, withAttributes: attributes)

                //println("column: \(column), row: \(row), Nr: \(stringNr)")
                
                CGContextStrokeRect(context, rect)
            }
        }
       
        CGContextStrokePath(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }

    func callSegue(game:Game) {
        self.view.addSubview(game)
        //performSegueWithIdentifier("GoToGameView", sender: nil)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
