//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// Mark: Utilities

class Utils {

    class func runOnMainAfterDelay(_ delay: Double, block: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }

}

class Observable<T> {

    typealias Listener = (T) -> Void
    var listeners: [Listener] = []

    var value: T {
        didSet {
            self.emit()
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func observe(listener: @escaping Listener) {
        self.listeners.append(listener)
        listener(self.value)
    }

    func emit() {
        for listener in self.listeners {
            listener(self.value)
        }
    }

}

// Mark: Protocols

protocol LevitationServiceProtocol {
    func attemptToLevitate ()
}

protocol LevitationModelProtocol {
    var state: Observable<Bool?> { get }
    func attemptToLevitate ()
}

protocol LevitationViewControllerDelegate {
    func didSelectLevitate()
}

// Mark: Service

class LevitationService: LevitationServiceProtocol {

    var levitationResult: Observable<Bool?> = Observable(nil)

    func attemptToLevitate () {
        print("service is attempting to levitate")
        self.levitateApiCall { (result:Bool?) in
            self.levitationResult.value = result
        }
    }

    func levitateApiCall (_ completionHandler: @escaping (_:Bool?) -> Void){
        print("wait for it")
        Utils.runOnMainAfterDelay(1, block: {
            completionHandler(false)
        })
    }

}

// Mark: Model

class LevitationModel: LevitationModelProtocol {

    var state: Observable<Bool?> = Observable(nil)
    private var levitationService: LevitationService = LevitationService()

    func attemptToLevitate() {
        self.levitationService.levitateApiCall { (result: Bool?) in
            print("BOOOM")
            var newValue = false
            if let currentValue = self.state.value {
                newValue = !currentValue
            }
            self.state.value = newValue
        }
    }
}

// Mark: Coordinator

class MyCoordinator {

    var levitationModel: LevitationModel = LevitationModel()

    func levitate() {
        print("Here we go, levitation incoming")
        self.levitationModel.attemptToLevitate()
    }

    func start() -> LevitationViewController {
        // Then construct the initial view controller and model
        let viewModel = LevitationViewModel(levitationModel: self.levitationModel)
        return LevitationViewController.getInstance(viewModel: viewModel, delegate: self)
    }

}

extension MyCoordinator: LevitationViewControllerDelegate {
    func didSelectLevitate() {
        print("Selected to Levitate")
        self.levitate()
    }
}

class LevitationViewModel {
    // Need to figure out how we deal with complex state
    var levitationMessage: Observable<String> = Observable("I report on Levitation State, of which there is none")
    private var levitationModel: LevitationModel!

    init (levitationModel: LevitationModel) {
        self.levitationModel = levitationModel
        levitationService.state.observe(listener: { (result:Bool?) in
            self.setMessage(levitationState: result)
        })
    }

    private func setMessage (levitationState:Bool?) {
        var message = "I report on Levitation State, of which there is none"
        if let levitationState = levitationState {
            message = levitationState ? "Up Up and AWAY" : "You done the bad levetating"
        }
        self.levitationMessage.value = message
    }
}


// Mark: ViewController

class LevitationViewController: UIViewController {

    var viewModel: LevitationViewModel!
    var delegate: LevitationViewControllerDelegate!
    var myLabel: UILabel?

    class func getInstance (viewModel: LevitationViewModel, delegate: LevitationViewControllerDelegate) -> LevitationViewController {
        let instanceOfMe = LevitationViewController()
        instanceOfMe.viewModel = viewModel
        instanceOfMe.delegate = delegate
        return instanceOfMe
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 0, y: 200, width: 375, height: 100)
        label.text = "I report on failures!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black

        self.myLabel = label
        view.addSubview(label)
        self.view = view

        let button = UIButton()
        button.frame = CGRect(x:62, y:400, width: 250, height: 60)
        button.backgroundColor = .black
        button.setTitle("LEVITATE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.titleLabel?.textColor = .white
        view.addSubview(button)

        button.addTarget(self, action: #selector(self.didTapLevitate), for: UIControlEvents.touchUpInside)
        self.viewModel.levitationMessage.observe(listener: { _ in
            self.updatePropertyViews()
        })
    }

    func updatePropertyViews() {
        UIView.animate(withDuration: 0.5, animations: {
            self.myLabel?.alpha = 0
        }) { _ in
            self.myLabel?.text = self.viewModel.levitationMessage.value
            UIView.animate(withDuration: 1, animations: {
                self.myLabel?.alpha = 1
            })
        }
    }

    func didSelectLevitate() {
        self.delegate.didSelectLevitate()
    }

    @objc func didTapLevitate() {
        self.didSelectLevitate()
    }

}

// Present the view controller in the Live View window

let redundantCoordinator = MyCoordinator()

PlaygroundPage.current.liveView = redundantCoordinator.start()

