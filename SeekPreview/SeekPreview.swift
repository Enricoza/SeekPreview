//
//  PreviewSeekBar.swift
//  PreviewSeekBar
//
//  Created by Enrico Zannini on 14/03/2021.
//

import UIKit

/**
 * A view that can be attached to a seekbar (UISlider) to act as a Seek Preview for a video player.
 *
 * The view needs to be as wide as we want to slide the preview, it will internally resize and follow the slider thumb up to the edges.
 * The height of this view will always be taken as a limit for the preview itself, while the width of the preview will always be in 16:9 proportion.
 *
 * Position this view on top of a slider, with a little bit of vertical spacing, and take all the horizontal space you need.
 *
 * Set the delegate to handle the loading of preview images during the seek.
 *
 * N.B. This view doesn't handle the loading of preview images and doesn't suggest a method to do so.
 * We only suggest to prefetch those images ahead because the delegate calls will be made synchronously on the main thread.
 */
open class SeekPreview: UIView {
    
    private var slider: UISlider?
    private let preview = UIImageView()
    private var centerAnchor: NSLayoutConstraint!
    /// A delegate that handles the loading of preview images
    public weak var delegate: SeekPreviewDelegate?
    private let animator: SeekPreviewAnimator
    
    /**
     * Creates and returns the view.
     *
     * - parameter animator: The animator that handles appearing and disappearing of the preview
     */
    public init(animator: SeekPreviewAnimator = ScaleMoveUpAnimator(duration: 0.2)) {
        self.animator = animator
        super.init(frame: CGRect.zero)
        initSubviews()
    }
    
    required public init?(coder: NSCoder) {
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
    
    /**
     * Attaches this preview to a single slider.
     *
     * When the preview attaches to a slider, it automatically detaches from a previous slider.
     * From the attach, going forward, the preview will follow the thumb of the slider and will request new preview images on value changes.
     *
     * - parameter slider: the slider to which this preview will attach
     *
     * WARNING: the slider needs to be in the same view hierarchy as this `SeekPreview` object.
     */
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



