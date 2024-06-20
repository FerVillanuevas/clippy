import AVFoundation
import ExpoModulesCore
import Foundation
import Photos
import SDWebImage
import UIKit
import ZLImageEditor


public class ZLImageClipRatioS: NSObject {
    @objc public var title: String
    
    @objc public let whRatio: CGFloat
        
    @objc public init(title: String, w: String, h: String) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle  = NumberFormatter.Style.decimal
        numberFormatter.allowsFloats = true
        let _w = numberFormatter.number(from: w)
        let _h = numberFormatter.number(from: h)
        
        self.title = title
    
        self.whRatio = CGFloat(CGFloat(_w!.floatValue) / CGFloat(_h!.floatValue))
        super.init()
    }
}


public class ClippyModule: Module {

    var resultImageEditModel: ZLEditImageModel?

    var promise: Promise!

    public func definition() -> ModuleDefinition {
        Name("Clippy")

        AsyncFunction("open") { (path: String, wide: Bool, promise: Promise) in
            getUIImage(url: path, completion: { image in
                DispatchQueue.main.async {
                    self.setConfiguration(wide: wide)
                    self.present(image: image, promise: promise)
                }
            }, reject: {
                promise.reject(Exception(file: "No image found"))
            })
        }
    }

    private func getUIImage(url: String, completion: @escaping (UIImage) -> Void, reject: @escaping () -> Void) {
        if let path = URL(string: url) {
            SDWebImageManager.shared.loadImage(with: path, options: .continueInBackground, progress: { _, _, _ in
            }, completed: { downloadedImage, _, error, _, _, _ in
                DispatchQueue.main.async {
                    if error != nil {
                        reject()
                    }
                    if downloadedImage != nil {
                        completion(downloadedImage!)
                    }
                }
            })
        } else {
            reject()
        }
    }

    private func setConfiguration(wide: Bool) {
        // Dont know how to add all clipRatios! i just need those two jaja
        let ratios = wide ? [ZLImageClipRatio(title: "21 : 9", whRatio: 21.0 / 9.0)] : [.wh1x1]
            
        ZLImageEditorConfiguration.default()
            .editImageTools([.clip])
            .showClipDirectlyIfOnlyHasClipTool(true)
            .clipRatios(
                ratios
            )
    }

    private func present(image: UIImage, promise: Promise) {
        let controller = UIApplication.shared.windows.first?.rootViewController

        ZLEditImageViewController.showEditImageVC(parentVC: controller, image: image, editModel: resultImageEditModel) { resImage, _ in
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

            let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent(String(Int64(Date().timeIntervalSince1970 * 1000)) + ".png")

            do {
                try resImage.pngData()?.write(to: destinationPath)
                promise.resolve(destinationPath.absoluteString)
            } catch {
                debugPrint("writing file error", error)
            }
        }
    }
}
