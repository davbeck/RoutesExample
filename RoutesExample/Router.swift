import Foundation


class Router<Destination> {
	struct Match {
		var destination: Destination
		var parameters: Dictionary<String, String>
	}
	
	struct Route {
		enum Component {
			case constant(String)
			case parameter(String)
		}
		
		var components: Array<Component>
		var destination: Destination
		
		init(pattern: String, destination: Destination) {
			self.components = pattern
				.components(separatedBy: "/")
				.map({ part -> Component in
					if part.first == ":" {
						return .parameter(String(part.dropFirst()))
					} else {
						return .constant(part)
					}
				})
			self.destination = destination
		}
		
		func matches(_ pathComponents: Array<String>) -> Match? {
			guard components.count == pathComponents.count else { return nil }
			
			var parameters: Dictionary<String, String> = [:]
			for (component, input) in zip(components, pathComponents) {
				switch component {
				case .constant(let value):
					guard input == value else { return nil }
				case .parameter(let name):
					parameters[name] = input
				}
			}
			
			return Match(destination: self.destination, parameters: parameters)
		}
	}
	
	var routes: Array<Route> = []
	
	func register(_ pattern: String, destination: Destination) {
		routes.append(Route(pattern: pattern, destination: destination))
	}
	
	func match(for url: URL) -> Match? {
		// url.pathComponents produces a slightly different result that doesn't match our pattern
		let pathComponents = url.path.components(separatedBy: "/")
		for route in routes {
			if let match = route.matches(pathComponents) {
				return match
			}
		}
		
		return nil
	}
	
	public init() {
		
	}
}
