//
//  ViewController.swift
//  AnimalGallery
//
//  Created by naruto kurama on 26.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var gallery = [UIImage(named: "baby_mouse"),UIImage(named: "Bird"),UIImage(named: "cat"),UIImage(named: "corgi_header_image"),UIImage(named: "cute-animals"),UIImage(named: "dog"),UIImage(named: "free-wallpaper-16"),UIImage(named: "monkey"),UIImage(named: "mouse"),UIImage(named: "OlwQ9A")]
    
    @IBOutlet weak var trashImageView: UIImageView!
    
        var nextIndex = 0
        var currentPicture: UIImageView?
        let originalSize: CGFloat = 300
        var isActive = false
        var activeSize: CGFloat {
            return originalSize + 10
     }
     override func viewDidLoad() {
         super.viewDidLoad()
         
         showNextPicture()
     }
     func showNextPicture() {
         if let newPicture = createPicture() {
                    currentPicture = newPicture
                    showPicture(newPicture)
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
                    newPicture.addGestureRecognizer(tap)
                    
                    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
                    swipe.direction = .up
                    newPicture.addGestureRecognizer(swipe)
                    
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
                    pan.delegate = self
                    newPicture.addGestureRecognizer(pan)
                } else {
                    nextIndex = 0
                    showNextPicture()
                }
     }
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
            guard let view = currentPicture, isActive else { return }
            
            switch sender.state {
            case .began, .changed:
                processPictureMovement(sender: sender, view: view)
            case .ended:
                if view.frame.intersects(trashImageView.frame) {
                    deletePicture(imageView: view)
                }
            default: break
            }
     }
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
           guard !isActive else { return }
           hidePicture(currentPicture!)
           showNextPicture()
       }
       @objc func handleTap() {
           isActive = !isActive
           
           if isActive {
               activateCurrentPicture()
           } else {
               deactivateCurrentPicture()
           }
       }
       func processPictureMovement(sender: UIPanGestureRecognizer, view: UIImageView) {
           let translation = sender.translation(in: view)
           view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
           sender.setTranslation(.zero, in: view)
           
           if view.frame.intersects(trashImageView.frame) {
               view.layer.borderColor = UIColor.red.cgColor
           } else {
               view.layer.borderColor = UIColor.green.cgColor
           }
       }
       func deletePicture(imageView: UIImageView) {
           self.gallery.remove(at: nextIndex - 1)
           isActive = false
           
           UIView.animate(withDuration: 0.4, animations: {
               imageView.alpha = 0
           }) { (_) in
               imageView.removeFromSuperview()
           }
           showNextPicture()
       }
    func activateCurrentPicture() {
           UIView.animate(withDuration: 0.3) {
               self.currentPicture?.frame.size  = CGSize(width: self.activeSize, height: self.activeSize)
               self.currentPicture?.layer.shadowOpacity = 0.5
               self.currentPicture?.layer.borderColor = UIColor.green.cgColor
           }
       }
    func deactivateCurrentPicture() {
           UIView.animate(withDuration: 0.3) {
               self.currentPicture?.frame.size  = CGSize(width: self.originalSize, height: self.originalSize)
               self.currentPicture?.layer.shadowOpacity = 0
               self.currentPicture?.layer.borderColor = UIColor.darkGray.cgColor
           }
       }
       func createPicture() -> UIImageView? {
           guard nextIndex < gallery.count else { return nil }
           let imageView = UIImageView(image: gallery[nextIndex])
           imageView.frame = CGRect(x: self.view.frame.width, y: self.view.center.y - (originalSize / 2), width: originalSize, height: originalSize)
           imageView.isUserInteractionEnabled = true
           
           imageView.layer.shadowColor = UIColor.black.cgColor
           imageView.layer.shadowOpacity = 0
           imageView.layer.shadowOffset = .zero
           imageView.layer.shadowRadius = 10
           
           imageView.layer.borderWidth = 2
           imageView.layer.borderColor = UIColor.darkGray.cgColor
           
           nextIndex += 1
           return imageView
       }
     func showPicture(_ imageView: UIImageView) {
          self.view.addSubview(imageView)
          
          UIView.animate(withDuration: 0.4) {
              imageView.center = self.view.center
          }
      }
      func hidePicture(_ imageView: UIImageView) {
          UIView.animate(withDuration: 0.4, animations: {
              self.currentPicture?.frame.origin.y = -self.originalSize
          }) { (_) in
              imageView.removeFromSuperview()
          }
      }
  }
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
