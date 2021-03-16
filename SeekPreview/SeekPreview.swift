//
//  PreviewSeekBar.swift
//  PreviewSeekBar
//
//  Created by Enrico Zannini on 14/03/2021.
//

import UIKit

public class SeekPreview: UIView {
    
    private var slider: UISlider?
    private let preview = UIImageView()
    private var centerAnchor: NSLayoutConstraint!
    public weak var delegate: SeekPreviewDelegate?
    private let animator: SeekPreviewAnimator
    
    public init(animator: SeekPreviewAnimator = ScaleMoveUpAnimator(duration: 0.2)) {
        self.animator = animator
        super.init(frame: CGRect.zero)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        self.animator = ScalePreviewAnimator(duration: 0.2)
        super.init(coder: coder)
        initSubviews()
    }
    
    private func initSubviews() {
        self.addSubview(preview)
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.heightAnchor.constraint(equalTo: preview.widthAnchor, multiplier: 9/16).isActive = true
        preview.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor).isActive = true
        preview.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor).isActive = true
        preview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        preview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        animator.hidePreview(preview, animated: false)
    }
    
    public func attachToSlider(slider: UISlider) {
        self.slider?.removeTarget(self, action: nil, for: [.valueChanged, .touchUpInside, .touchUpOutside, .touchDown])
        self.slider = slider
        
        slider.addTarget(self, action: #selector(onTouchDrag(sender:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(onTouchUp(sender:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(onTouchUp(sender:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(onTouchDown(sender:)), for: .touchDown)
        
        if let anchor = self.centerAnchor {
            preview.removeConstraint(anchor)
        }
        centerAnchor = preview.centerXAnchor.constraint(equalTo: self.leftAnchor, constant: previewCenterForSlider(slider: slider))
        centerAnchor.priority = UILayoutPriority(900)
        centerAnchor.isActive = true
    }
    
    @objc private func onTouchDown(sender: UISlider) {
        animator.showPreview(self.preview, animated: true)
    }
    
    @objc private func onTouchUp(sender: UISlider) {
        animator.hidePreview(self.preview, animated: true)
    }
    
    @objc private func onTouchDrag(sender: UISlider) {
        centerAnchor.constant = previewCenterForSlider(slider: sender)
        preview.image = delegate?.getSeekPreview(value: sender.value)
    }

    private func previewCenterForSlider(slider: UISlider) -> CGFloat {
        let trackRect = slider.trackRect(forBounds: slider.bounds)
        let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: slider.value)
        let sliderPercentage = (slider.value - slider.minimumValue)/(slider.maximumValue - slider.minimumValue)
        return CGFloat(sliderPercentage) * (slider.frame.width - thumbRect.width) + thumbRect.width/2 + self.convert(slider.frame.origin, to: self).x - self.frame.origin.x
    }
}



