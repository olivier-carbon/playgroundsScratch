//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class UIConversationController: UIViewController {
    var master: UIViewController? = nil {
        didSet {
            guard let master = self.master else {
                return
            }
            self.addChildViewController(master)
            self.view.addSubview(master.view)
        }
    }
    
    var detail: UIViewController? = nil {
        didSet {
            guard let detail = self.master else {
                return
            }
            self.addChildViewController(detail)
            detail.view.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
            self.view.addSubview(detail.view)
        }
    }
    
    override func loadView() {
        let view = UIView()
        self.view = view
        self.master = MasterViewController()
        self.detail = DetailViewController()
        self.master?.view.frame = CGRect(x: 0, y: 200, width: 300, height: 300)
        print (self.detail?.view.frame)
        self.master?.view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let margins = self.view.layoutMarginsGuide
        
        //        master.view.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        //        master.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        //        master.view.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        //        master.view.leadingAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
    }
}

class MasterViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 50, y: 50, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}

class DetailViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .green
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "I'm here to help!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UIConversationController()
