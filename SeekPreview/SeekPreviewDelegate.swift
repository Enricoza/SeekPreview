//
//  SeekPreviewDelegate.swift
//  SeekPreview
//
//  Created by Enrico Zannini on 14/03/2021.
//

import Foundation

public protocol SeekPreviewDelegate: class {
    func getSeekPreview(value: Float) -> UIImage?
}
