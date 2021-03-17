//
//  ViewController.swift
//  SeekPreview
//
//  Created by Enrico Zannini on 13/03/2021.
//  Copyright © 2021 Enrico Zannini. All rights reserved.
//

import UIKit
import AVKit
import SeekPreview

let url = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

class ViewController: UIViewController, SeekPreviewDelegate {

    let preview = SeekPreview()
    let asset = AVAsset(url: URL(string: url)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preview.delegate = self
        view.backgroundColor = .white

        
        view.addSubview(preview)
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        preview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        preview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        preview.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let slider = UISlider()
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 8).isActive = true
        slider.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        preview.attachToSlider(slider: slider)
        
        preview.borderColor = UIColor.black
        preview.borderWidth = 1
        preview.cornerRadius = 5
        
        slider.addTarget(self, action: #selector(onValueChange(slider:)), for: .valueChanged)
        generateImages()
    }
    
    @objc func onValueChange(slider: UISlider) {
        
        
    }
    
    func getSeekPreview(value: Float) -> UIImage? {
        let times = images.keys
        if times.count == 0 {
            return nil
        }
        let seconds = Double(value) * asset.duration.seconds
        let closest = times.enumerated().min( by: { abs($0.1 - seconds) < abs($1.1 - seconds) } )!
        let image = images[closest.element]
        return image
    }
    

    var images: [ Double : UIImage ] = [:]
    
    func generateImages() {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = CGSize(width: 150, height: 80)
        let seconds = asset.duration.seconds
        
        
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: Array(1...99).map{ NSValue(time:CMTimeMake($0 * Int64(seconds), 100))  }) { (requestedTime, cgImage, actualTime, result, error) in
            if let image = cgImage {
                DispatchQueue.main.async {
                    self.images[actualTime.seconds] = UIImage(cgImage: image)
                }
            }
        }
        
    }
    
    
}

