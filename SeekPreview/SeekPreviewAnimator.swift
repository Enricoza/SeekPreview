//
//  SeekPreviewAnimator.swift
//  SeekPreview
//
//  Created by Enrico Zannini on 14/03/2021.
//

import UIKit


public protocol SeekPreviewAnimator {
    func showPreview(_ preview: UIView, animated: Bool)
    func hidePreview(_ preview: UIView, animated: Bool)
}

class ScaleMoveUpAnimator: ScalePreviewAnimator {
    
    override func smallTransform(view: UIView) -> CGAffineTransform {
        return super.smallTransform(view: view)
            .concatenating(CGAffineTransform(translationX: 0, y: view.frame.height/3))
    }
}

class ScalePreviewAnimator: BaseAnimator, SeekPreviewAnimator {
    func showPreview(_ preview: UIView, animated: Bool) {
        self.animate(animated: animated) {
            preview.transform = CGAffineTransform.identity
            preview.alpha = 1
        }
    }
    
    func hidePreview(_ preview: UIView, animated: Bool) {
        self.animate(animated: animated) {
            preview.transform = self.smallTransform(view: preview)
            preview.alpha = 0
        }
    }
    
    func smallTransform(view: UIView) -> CGAffineTransform {
        return CGAffineTransform(scaleX: 0.3, y: 0.3)
    }
}


class FadePreviewAnimator: BaseAnimator, SeekPreviewAnimator {
    
    func showPreview(_ preview: UIView, animated: Bool) {
        fade(view: preview, alpha: 1, animated: animated)
    }
    
    func hidePreview(_ preview: UIView, animated: Bool) {
        fade(view: preview, alpha: 0, animated: animated)
    }
    
    private func fade(view: UIView, alpha: CGFloat, animated: Bool) {
        self.animate(animated: animated) {
            view.alpha = alpha
        }
    }
}

class BaseAnimator {
    
    let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func animate(animated: Bool, block: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: self.duration, animations: block)
        } else {
            block()
        }
    }
    
    
}
