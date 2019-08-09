//
//  ScanViewController.swift
//  OCR test
//
//  Created by Maciej Madaj on 07/08/2019.
//

import UIKit
import Firebase

class ScanViewController: UIViewController {

    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!

    private var activityIndicator: LoadingIndicator?

    override func viewDidLoad() {
        super.viewDidLoad()

        galleryButton.style()
        cameraButton.style()

        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            cameraButton.removeFromSuperview()
        }

        activityIndicator = LoadingIndicator(frame: .zero)
        if let activityIndicator = activityIndicator {
            view.addSubview(activityIndicator)
            activityIndicator.setConstrainsFor(size: CGSize(width: 80, height: 80))
            activityIndicator.centerInSuperview()
        }
    }

    @IBAction func galleryButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.cameraFlashMode = .auto
        picker.delegate = self
        present(picker, animated: true)
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResult" {
            guard
                let data = sender as? [String: Any],
                let image = data["image"] as? UIImage,
                let result = data["result"] as? String
            else {
                return
            }
            let controller = segue.destination as? ResultViewController
            controller?.instantiate(image: image, result: result)
            if !result.isEmpty {
                let _ = DatabaseManager.shared.insertHistoryEntry(name: "project-\(DatabaseManager.shared.fetchedResultsController.fetchedObjects?.count ?? 0)", text: result, imageData: image.pngData())
            }
        }
        super.prepare(for: segue, sender: sender)
    }
}

// MARK: UIImagePickerControllerDelegate
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let selectedImage = info[.originalImage] as? UIImage,
            let image = selectedImage.fixOrientation()
        else {
            return
        }

        picker.dismiss(animated: true)
        activityIndicator?.startAnimating()

        let vi = VisionImage(image: image)
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        textRecognizer.process(vi, completion: { [weak self] result, error in
            self?.activityIndicator?.stopAnimating()

            if let error = error {
                performOnMainThread {[weak self] in
                    let alertVC = UIAlertController(title: "error_alert_title".localized, message: error.localizedDescription, preferredStyle: .alert)
                    self?.present(alertVC, animated: true)
                }
                return
            }

            DispatchQueue.main.async {[weak self] in
                self?.performSegue(withIdentifier: "ShowResult", sender: [
                    "image": image,
                    "result": result?.text ?? ""
                ])
            }
        })
    }
}
