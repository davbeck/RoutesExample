import UIKit


class PostsViewController: UITableViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.route(to: URL(string: "/posts/\(indexPath.row + 1)")!)
	}
}
