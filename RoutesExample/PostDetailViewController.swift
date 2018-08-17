import UIKit


class PostDetailViewController: UIViewController, RoutedViewController {
	@IBOutlet weak var detailsLabel: UILabel!
	
	func present(url: URL, parameters: [String : String]) {
		loadViewIfNeeded()
		
		self.detailsLabel.text = "Post: " + (parameters["postID"] ?? "")
	}
}
