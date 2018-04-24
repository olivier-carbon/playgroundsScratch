//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    var labelView: UILabel = UILabel(frame: CGRect(x: 100, y: 200, width: 150, height: 40))
    var hasMovedState: Bool = false
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .darkGray
        self.labelView.text = "Hello Sun!"
        self.labelView.textColor = .orange
        self.labelView.backgroundColor = .white
        self.labelView.textAlignment = .center
        
        view.addSubview(self.labelView)
        self.view = view
        
        let moveButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        moveButton.backgroundColor = .orange
        moveButton.addTarget(self, action: #selector(MyViewController.transform), for: UIControlEvents.allTouchEvents)
        view.addSubview(moveButton)
    }
    
    @objc func transform() {
        let shiftDownTransform = CGAffineTransform(translationX: 0, y: 200)
        let rotateTransform = CGAffineTransform(rotationAngle: 0.5)
        
        UIView.animate(withDuration: 1, animations: {
            self.labelView.transform = self.hasMovedState ? .identity : rotateTransform.inverted().concatenating(shiftDownTransform.concatenating(rotateTransform))
        }){ _ in
            self.hasMovedState = !self.hasMovedState
        }
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
