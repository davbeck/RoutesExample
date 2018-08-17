import UIKit

class FirstViewController: UIViewController {
	@IBAction func showPosts(_ sender: Any) {
		self.route(to: URL(string: "/posts")!)
	}
}

