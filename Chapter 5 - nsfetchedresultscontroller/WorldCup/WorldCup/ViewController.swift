/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData


class ViewController: UIViewController {

  // MARK: - Properties
  fileprivate let teamCellIdentifier = "teamCellReuseIdentifier"
  var coreDataStack: CoreDataStack!
  
  //1
  var fetchedResultsController: NSFetchedResultsController<Team>!
 
  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // 1
    let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
    let zoneSort = NSSortDescriptor(key: #keyPath(Team.qualifyingZone), ascending: true)
    let scoreSort = NSSortDescriptor(key: #keyPath(Team.wins), ascending: false)
    let nameSort = NSSortDescriptor(key: #keyPath(Team.teamName), ascending: true)
    fetchRequest.sortDescriptors = [zoneSort,scoreSort,nameSort]

    
    // 2
    fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.managedContext,
      sectionNameKeyPath: #keyPath(Team.qualifyingZone),
      cacheName: "worldCup")
    
    do {
      try fetchedResultsController.performFetch()
    }catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
    
    fetchedResultsController.delegate = self
    
  }
  
  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      addButton.isEnabled = true
    }
  }
}

// MARK: - Internal
extension ViewController {

  func configure(cell: UITableViewCell, for indexPath: IndexPath) {

    guard let cell = cell as? TeamCell else {
      return
    }

    let team = fetchedResultsController.object(at: indexPath)
    cell.flagImageView.image = UIImage(named: team.imageName!)
    cell.teamLabel.text = team.teamName
    cell.scoreLabel.text = "Wins: \(team.wins)"
  }
  
  @IBAction func addTeam(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Secret Team", message: "Add a new team", preferredStyle: .alert)
    
    alert.addTextField(configurationHandler: { textField in
      textField.placeholder = "Team Name"
      })
    
    alert.addTextField { textFiled in
      textFiled.placeholder = "Qualifying Zone"
    }
    
    let saveAction = UIAlertAction(title: "Save", style: .default) {
      [unowned self] action in
      guard let  nametextFiled = alert.textFields?.first, let zoneTextFiled = alert.textFields?.last else {
        return
      }
      
      let team = Team(context: self.coreDataStack.managedContext)
      
      team.teamName = nametextFiled.text
      team.qualifyingZone = zoneTextFiled.text
      team.imageName = "wenderland-flag"
      self.coreDataStack.saveContext()
    }
    
    alert.addAction(saveAction)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    present(alert, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionInfo = fetchedResultsController.sections?[section]
    return sectionInfo?.name
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    return sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sectionInfo = fetchedResultsController.sections?[section] else {
      return 0
    }
    
    return sectionInfo.numberOfObjects
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: teamCellIdentifier, for: indexPath)
    configure(cell: cell, for: indexPath)

    return cell
  }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let team = fetchedResultsController.object(at: indexPath)
    team.wins += 1
    coreDataStack.saveContext()
    
    //tableView.reloadData()
  }
}

extension ViewController: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
      case .insert:
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .update:
      let cell = tableView.cellForRow(at: indexPath!) as! TeamCell
      configure(cell: cell, for: indexPath!)
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
    let indexSet = IndexSet(integer: sectionIndex)
    
    switch type {
    case .insert:
      tableView.insertSections(indexSet, with: .automatic)
    case .delete:
      tableView.deleteSections(indexSet, with: .automatic)
    default:
      break
    }
    
  }
}
