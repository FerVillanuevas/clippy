import AVFoundation
import ExpoModulesCore
import Foundation
import Photos
import SDWebImage
import UIKit
import ZLImageEditor

public class ClippyModule: Module {
    var resultImageEditModel: ZLClipStatus?

    var promise: Promise!

    public func definition() -> ModuleDefinition {
        Name("Clippy")

        AsyncFunction("open") { (path: String, promise: Promise) in
            getUIImage(url: path, completion: { image in
                DispatchQueue.main.async {
                    self.setConfiguration()
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

    private func setConfiguration() {
        ZLImageEditorConfiguration.default()
            .showClipDirectlyIfOnlyHasClipTool(true)
            .editImageTools([.clip, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
            .clipRatios([.wh1x1, .init(title: "21 : 9", whRatio: 21.0 / 9.0)])
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
