//
//  SJParallaxCell.swift
//  SJParallaxCell
//
//  Created by Saurabh Jain on 5/10/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

public class SJParallaxCell: UITableViewCell {

    var sj_parallaxImage: UIImage? {
        didSet {
            if let sj_parallaxImage = sj_parallaxImage {
                sj_imgView.image = sj_parallaxImage
            }
        }
    }

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
    
    private let kKeyPath = "contentOffset"

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
        // important
        clipsToBounds = true
        
        // Set up the image view
        sj_imgView = UIImageView(frame: bounds)
        sj_imgView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        sj_imgView.contentMode = .ScaleAspectFill
        contentView.addSubview(sj_imgView)
        
        parallaxRatio = 1.5
    }
    
    
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
    
    // The parallax ratio
    var parallaxRatio: CGFloat = 1.5 {
        didSet {
            var rect = sj_imgView.frame
            rect.size.height *= parallaxRatio
            sj_imgView.frame = rect
        }
    }
    
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
    
    // Set up the key value observing
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

