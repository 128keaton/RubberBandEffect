//
//  SecondViewController.swift
//  FrictionCurves
//
//  Created by Victor Baro on 3/5/15.
//  Copyright (c) 2015 Produkt. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    let verticalLimit : CGFloat = -200
    var totalTranslation : CGFloat = -200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func viewDragged(sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
        
        if (topViewConstraint.hasExceeded(verticalLimit: verticalLimit)){
            totalTranslation += yTranslation
            topViewConstraint.constant = logConstraintValueForYPosition(yPosition: totalTranslation)
            if(sender.state == UIGestureRecognizer.State.ended ){
                animateViewBackToLimit()
            }
        } else {
            topViewConstraint.constant += yTranslation
        }
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func logConstraintValueForYPosition(yPosition : CGFloat) -> CGFloat {
        return verticalLimit * (1 + log10(yPosition/verticalLimit))
    }
    func animateViewBackToLimit() {
        self.topViewConstraint.constant = self.verticalLimit
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.totalTranslation = -200
            }, completion: nil)
    }
}

private extension NSLayoutConstraint {
    func hasExceeded(verticalLimit: CGFloat) -> Bool {
        return self.constant < verticalLimit
    }
}
