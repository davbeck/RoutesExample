import Foundation
import UIKit


protocol RoutedViewController {
	func present(url: URL, parameters: [String: String])
}

struct NavigationDestination {
	enum Transition {
		case push
		case modal(UIModalPresentationStyle)
	}
	var transition: Transition
	var storyboardIdentifier: String
	
	init(storyboardIdentifier: String, transition: Transition = .push) {
		self.storyboardIdentifier = storyboardIdentifier
		self.transition = transition
	}
}

class NavigationRouter: Router<NavigationDestination> {
	static var shared: NavigationRouter?
	
	let storyboard: UIStoryboard
	init(storyboard: UIStoryboard) {
		self.storyboard = storyboard
	}
	
	func register(_ pattern: String, storyboardIdentifier: String, transition: NavigationDestination.Transition = .push) {
		self.register(pattern, destination: NavigationDestination(storyboardIdentifier: storyboardIdentifier, transition: transition))
	}
	
	@discardableResult
	func route(to url: URL, from: UIViewController) -> UIViewController? {
		guard let match = self.match(for: url) else { return nil }
		let viewController = storyboard.instantiateViewController(withIdentifier: match.destination.storyboardIdentifier)
		
		if let viewController = viewController as? RoutedViewController {
			viewController.present(url: url, parameters: match.parameters)
		}
		
		from.show(viewController, using: match.destination.transition)
		
		return viewController
	}
}

extension UIViewController {
	@discardableResult
	func route(to url: URL) -> UIViewController? {
		return NavigationRouter.shared?.route(to: url, from: self)
	}
	
	func show(_ viewController: UIViewController, using transition: NavigationDestination.Transition) {
		switch transition {
		case .push:
			if let navigationController = self.navigationController {
				navigationController.pushViewController(viewController, animated: true)
			} else {
				// if we aren't in a navigation controller, fallback to a modal presentation style
				let navigationController = UINavigationController(rootViewController: viewController)
				viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
				
				self.present(navigationController, animated: true, completion: nil)
			}
		case .modal(let style):
			viewController.modalPresentationStyle = style
			self.present(viewController, animated: true, completion: nil)
		}
	}
	
	@IBAction func cancel() {
		self.presentingViewController?.dismiss(animated: true, completion: nil)
	}
}
