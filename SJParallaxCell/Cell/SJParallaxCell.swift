//
//  SJParallaxCell.swift
//  SJParallaxCell
//
//  Created by Saurabh Jain on 5/10/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public class SJParallaxCell: UITableViewCell {
    
    // Parallax Image view
    private var sj_imgView: UIImageView!
    
    // The parent table view
    private var parentTableView: UITableView? {
        didSet {
            if let parentTableView = parentTableView {
                setUpObserving()
            }
        }
    }
    
    // KVO key path
    private let kKeyPath = "contentOffset"
    
    // The image from the table view
    var sj_parallaxImage: UIImage? {
        didSet {
            if let sj_parallaxImage = sj_parallaxImage {
                sj_imgView.image = sj_parallaxImage
            }
        }
    }
    
    // The parallax ratio
    var parallaxRatio: CGFloat = 1.5 {
        didSet {
            var rect = sj_imgView.frame
            rect.size.height *= parallaxRatio
            sj_imgView.frame = rect
        }
    }
    
    // MARK: Init
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    deinit {
        parentTableView?.removeObserver(self, forKeyPath: kKeyPath)
    }

    private func initialSetup() {
        // Important
        clipsToBounds = true
        
        // Set up the image view
        sj_imgView = UIImageView(frame: bounds)
        sj_imgView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        sj_imgView.contentMode = .ScaleAspectFill
        contentView.addSubview(sj_imgView)
        
        // Set the parallax ratio
        parallaxRatio = 1.5
    }
    
    // Set the parent table view
    override public func willMoveToSuperview(var newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        while(newSuperview != nil) {
            if newSuperview!.isKindOfClass(UITableView.self) {
                parentTableView = newSuperview as? UITableView
                break
            }
            newSuperview = newSuperview?.superview
        }
    }
    
    // Parallax Effect
    private func update() {
        
        if let parentTableView = parentTableView {
            let contentOffset = parentTableView.contentOffset.y
            let cellOffset = frame.origin.y - contentOffset
            let percent: CGFloat = (cellOffset + frame.size.height) / (parentTableView.frame.size.height + frame.size.height)
            let extraHeight: CGFloat = frame.size.height * (parallaxRatio - 1.0)
            
            var rect = sj_imgView.frame
            rect.origin.y = -extraHeight * percent
            sj_imgView.frame = rect
        }
    }
}

// MARK: KVO
extension SJParallaxCell {
    
    private func setUpObserving() {
        parentTableView?.addObserver(self, forKeyPath: kKeyPath, options: .Old | .New, context: nil)
    }
    
    override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if keyPath == kKeyPath {
            if let cells = parentTableView?.visibleCells() as? [UITableViewCell] {
                if contains(cells, self) {
                    update()
                }
            }
        }
    }
}
