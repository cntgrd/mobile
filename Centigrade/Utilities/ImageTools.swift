//
//  ImageTools.swift
//
//  Created by Paul Herz on 2017-11-08.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit
import AVFoundation

// [CITE] http://nshipster.com/image-resizing/
class ImageTools {
	
	private init() {}
	
	/**
	fills an image's alpha mask with a solid color.
	Based on this implementation:
	
	- parameter icon: the image whose mask you want to fill
	- parameter tintColor: the color to fill with
	*/
	static func tintIcon(_ icon: UIImage, usingColor tintColor: UIColor) -> UIImage? {
		// [CITE] https://stackoverflow.com/a/7377827/3592716
		
		UIGraphicsBeginImageContextWithOptions(icon.size, false, icon.scale)
		
		guard let ctx = UIGraphicsGetCurrentContext() else {
			print("Couldn't get context")
			return nil
		}
		
		guard let cg = icon.cgImage else {
			print("Couldn't get cgImage from icon")
			return nil
		}
		
		ctx.translateBy(x: 0, y: icon.size.height)
		ctx.scaleBy(x: 1, y: -1)
		
		let rect = CGRect(origin: .zero, size: icon.size)
		
		/* icon tinting */
		ctx.setBlendMode(.normal)
		tintColor.setFill()
		ctx.fill(rect)
		ctx.setBlendMode(.destinationIn)
		ctx.draw(cg, in: rect)
		/* end icon tinting */
		
		let tintedIcon = UIGraphicsGetImageFromCurrentImageContext()
		return tintedIcon
	}
	
	/**
	resizes an image to fit within a container shape, such that its
	longest axis is equal in length to the equivalent axis of the container.
	Maintains image aspect ratio. Compare to `background-size: contain` from CSS.
	
	- parameter image: the image to resize
	- parameter container: the dimensions of the containing box the image should fit into
	*/
	static func scale(image: UIImage, toFitInside container: CGSize) -> UIImage? {
		let aspect = AVMakeRect(
			aspectRatio: image.size,
			insideRect: CGRect(origin: .zero, size: container)
		)
		let ratio = aspect.standardized.size.width / image.size.width
		return scale(image: image, by: ratio)
	}
	
	/**
	multiplies both dimensions of an image by a scalar, then adjusting the
	image to the resulting proportional size. Maintains image aspect ratio.
	
	- parameter image: the image to resize.
	- parameter scaleFactor: the single factor by which to resize both dimensions of the image.
	*/
	static func scale(image: UIImage, by scaleFactor: CGFloat) -> UIImage? {
		let xyFactor = CGSize(width: scaleFactor, height: scaleFactor)
		return scale(image: image, by: xyFactor)
	}
	
	/**
	multiplies the two dimensions of an image by two separate scalars, then
	adjusting the image to the resulting size. If the factors are equal, image
	aspect ratio will be maintained, but usually this is used to "stretch" an image
	in one dimension or another. Use `scale(image: UIImage, by scaleFactor: CGFloat)`
	to provide a single scale factor that always mantains aspect ratio.
	*/
	static func scale(image: UIImage, by scaleFactor: CGSize) -> UIImage? {
		
		guard let cg = image.cgImage else {
			print("[ImageTools.scale(image:by:)] failed to get CGImage.")
			return nil
		}
		
		let width = Int(CGFloat(cg.width) * scaleFactor.width)
		let height = Int(CGFloat(cg.height) * scaleFactor.height)
		
		return resize(image: image, to: CGSize(width: width, height: height))
	}
	
	static func resize(image: UIImage, to size: CGSize) -> UIImage? {
		guard let cgImage = image.cgImage else {
			return nil
		}
		guard let ctx = CGContext(
			data: nil,
			width: Int(ceil(size.width)),
			height: Int(ceil(size.height)),
			bitsPerComponent: cgImage.bitsPerComponent,
			bytesPerRow: cgImage.bytesPerRow,
			space: cgImage.colorSpace!,
			bitmapInfo: cgImage.bitmapInfo.rawValue
		) else { return nil }
		
		ctx.interpolationQuality = .high
		ctx.draw(cgImage, in: CGRect(origin: .zero, size: size))
		
		return ctx.makeImage().flatMap { UIImage(cgImage: $0) }
	}
	
	static func convertAlpha(image: UIImage, toMatte matte: UIColor) -> UIImage? {
		
		guard let (ctx, cgImage) = duplicateContext(of: image) else { return nil }
		
		ctx.interpolationQuality = .high
		ctx.setFillColor(matte.cgColor)
		
		let bounds = CGRect(origin: .zero, size: CGSize(width: cgImage.width, height: cgImage.height))
		ctx.fill(bounds)
		ctx.draw(cgImage, in: bounds)
		
		return ctx.makeImage().flatMap { UIImage(cgImage: $0) }
	}
	
	static func convertToGrayscale(image: UIImage) -> UIImage? {
		guard let cg = image.cgImage else {
			print("[ImageTools.convertToGrayscale(image:)] failed to get CGImage.")
			return nil
		}
		
		let rect = CGRect(origin: .zero, size: CGSize(width: cg.width, height: cg.height))
		let grayscale = CGColorSpace(name: CGColorSpace.linearGray)!
		
		let bytesPerComponent = 1
		guard let ctx = CGContext(
			data: nil,
			width: cg.width,
			height: cg.height,
			bitsPerComponent: bytesPerComponent*8,
			bytesPerRow: 0,
			space: grayscale,
			bitmapInfo: CGImageAlphaInfo.none.rawValue
		) else {
			print("[ImageTools.scale(image:toExactly:)] could not initialize CGContext.")
			return nil
		}
		
		ctx.draw(cg, in: rect)
		
		return ctx.makeImage().flatMap { UIImage(cgImage: $0) }
	}
	
	static func duplicateContext(of image: UIImage) -> (CGContext, CGImage)? {
		
		guard let cgImage = image.cgImage else {
			print("[ImageTools.duplicateContext(of image:)] failed to get CGImage.")
			return nil
		}
		
		guard let ctx = CGContext(
			data: nil,
			width: cgImage.width,
			height: cgImage.height,
			bitsPerComponent: cgImage.bitsPerComponent,
			bytesPerRow: cgImage.bytesPerRow,
			space: cgImage.colorSpace!,
			bitmapInfo: cgImage.bitmapInfo.rawValue
		) else {
			print("[ImageTools.duplicateContext(of image:)] could not initialize CGContext.")
			return nil
		}
		
		return (ctx, cgImage)
	}
	
	// Doesn't quite work yet
	
//	static func makeBitmapArray(from image: UIImage) -> [UInt8]? {
//		let grayscale = CGColorSpace(name: CGColorSpace.linearGray)!
//
//		guard image.cgImage?.colorSpace == grayscale else {
//			print("makeBitmapArray(from image:) only supports grayscale colorspace right now.")
//			print("Colorspace \(image.cgImage?.colorSpace.flatMap { String(describing: $0) } ?? "nil")")
//			return nil
//		}
//		guard let data = image.cgImage?.dataProvider?.data as Data? else {
//			print("Could not derive underlying data from UIImage")
//			return nil
//		}
//		let bytes = data.count / MemoryLayout<UInt8>.size
//		print("DataCount: \(data.count)")
//		print("UInt8.size: \(MemoryLayout<UInt8>.size)")
//		print("Bytes: \(bytes)")
//		var bitmapArray = [UInt8](repeating: 0, count: bytes)
//		let _ = bitmapArray.withUnsafeMutableBufferPointer { mutableBuffer in
//			data.copyBytes(to: mutableBuffer)
//		}
//		return bitmapArray
//	}
}

