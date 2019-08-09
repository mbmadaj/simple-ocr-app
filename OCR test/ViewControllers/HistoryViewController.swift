//
//  HistoryViewController.swift
//  OCR test
//
//  Created by Maciej Madaj on 08/08/2019.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // hides separators for empty rows
        tableView.tableFooterView = UIView(frame: .zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.shared.fetchedResultsController.delegate = self
        do {
            try DatabaseManager.shared.fetchedResultsController.performFetch()
        } catch {
            print("error when executing fetch request in viewWillAppear \(error)")
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResult" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
                let controller = segue.destination as? ResultViewController
                if let imagePath = object.imagePath, let path = StoredImagesManager.shared.getProperImagePath(imageLocation: imagePath) {
                    controller?.instantiate(image: UIImage(contentsOfFile: path.path), result: object.text)
                }
            }
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DatabaseManager.shared.fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryEntryTableViewCell
        else {
            return UITableViewCell()
        }
        let historyEntry = DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
        cell.textFragmentLabel.text = historyEntry.text

        let df = DateFormatter.cached(withFormat: "HH:mm:ss dd.MM.yy")
        cell.dateLabel.text = String.localizedStringWithFormat("created_at".localized, df.string(from: historyEntry.createdAt ?? Date()))
        if let imagePath = historyEntry.imagePath, let url = StoredImagesManager.shared.getProperImagePath(imageLocation: imagePath) {
            cell.currentImageVIew.contentMode = .scaleAspectFit
            cell.currentImageVIew.image = UIImage(contentsOfFile: url.path)
        }
        else {
            cell.currentImageVIew.image = nil
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let historyEntry = DatabaseManager.shared.fetchedResultsController.object(at: indexPath)
            DatabaseManager.shared.removeHistoryEntry(historyEntry)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else {
                return
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            break
        case .move:
            guard
                let indexPath = indexPath,
                let newIndexPath = newIndexPath
            else {
                return
            }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            break
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
