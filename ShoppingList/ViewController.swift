//
//  ViewController.swift
//  ShoppingList
//
//  Created by Igor Chernyshov on 26.06.2021.
//

import UIKit

final class ViewController: UITableViewController {

	// MARK: - Properties
	private var products: [String] = []

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		let clearBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearListDidTap))
		let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareDidTap))
		let leftBarButtonItems = [clearBarButton, shareBarButton]
		navigationItem.leftBarButtonItems = leftBarButtonItems
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductDidTap))
	}

	// MARK: - Selectors
	@objc private func clearListDidTap() {
		products.removeAll()
		tableView.reloadData()
	}

	@objc private func shareDidTap() {
		guard !products.isEmpty else { return }
		let shoppingList = products.joined(separator: "\n")
		let activityController = UIActivityViewController(activityItems: [shoppingList], applicationActivities: nil)
		present(activityController, animated: true)
	}

	@objc private func addProductDidTap() {
		let alertController = UIAlertController(title: "New product", message: nil, preferredStyle: .alert)
		alertController.addTextField()

		let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] _ in
			guard let product = alertController?.textFields?[0].text else { return }
			self?.add(product: product)
		}
		alertController.addAction(addAction)
		present(alertController, animated: true)
	}

	private func add(product: String) {
		products.append(product)
		tableView.insertRows(at: [IndexPath(row: products.count - 1, section: 0)], with: .automatic)
	}
}

// MARK: - UITableViewDataSource
extension ViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		products.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
		cell.textLabel?.text = products[indexPath.row]
		return cell
	}
}
