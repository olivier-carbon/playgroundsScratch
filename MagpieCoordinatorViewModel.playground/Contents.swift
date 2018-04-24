//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// Mark: Protocols

protocol MyViewControllerNavigationDelegate {
    func didSelectLevetate(failureHandler: LevitateFailureHandler)
}

protocol PropertyObserver {
    func propertyDidChange()
}

protocol LevitateFailureHandler {
    func levitationDidFail(message: String)
}

// Mark: Coordinator

class MyCoordinator {

    func levitate(failureHandler: LevitateFailureHandler) {
        print("OH NO, we failed to levitate")
        failureHandler.levitationDidFail(message: "The force is weak with you")
    }

}

extension MyCoordinator: MyViewControllerNavigationDelegate {

    func didSelectLevetate(failureHandler: LevitateFailureHandler) {
        self.levitate(failureHandler: failureHandler)
    }

}

// Mark: ViewModels

class MyViewModel {

    var observer: PropertyObserver?
    var property: String = "No Failures" {
        didSet {
            if oldValue != self.property {
                self.updateProperty()
            }
        }
    }

    func updateProperty() {
        self.observer?.propertyDidChange()
    }

}

extension MyViewModel: LevitateFailureHandler {

    func levitationDidFail(message: String) {
        self.property = message
    }

}

// Mark: ViewController

class MyViewController: UIViewController {

    var viewModel = MyViewModel()
    var navigationDelegate:MyViewControllerNavigationDelegate = MyCoordinator()
    var myLabel: UILabel?

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "I report on failures!"
        label.textColor = .black

        self.myLabel = label
        view.addSubview(label)
        self.view = view

        let button = UIButton()
        button.frame = CGRect(x:50, y:400, width: 200, height: 60)
        button.titleLabel?.text = "Levitate"
        button.backgroundColor = .black
        button.tintColor = .white
        view.addSubview(button)

        button.addTarget(self, action: #selector(self.didTapLevitate), for: UIControlEvents.touchUpInside)
    }

    func updatePropertyViews() {
        self.myLabel?.text = self.viewModel.property
    }

    @objc func didTapLevitate() {
        self.navigationDelegate.didSelectLevetate(failureHandler: self.viewModel)
    }

}

extension MyViewController: PropertyObserver {

    func propertyDidChange() {
        self.updatePropertyViews()
    }

}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

