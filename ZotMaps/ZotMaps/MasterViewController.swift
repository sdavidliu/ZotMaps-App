/*
 * Copyright (c) 2015 Razeware LLC
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

class MasterViewController: UITableViewController {
    
    // MARK: - Properties
    var destinations = AppDelegate.Database.destinations.sorted(by: {(d1: Destination, d2: Destination) -> Bool in return d1.name < d2.name})
    var filteredDestinations = [Destination]()
    let searchController = UISearchController(searchResultsController: nil)
    let lightBlue = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 164.0/255.0, alpha: 1.0)
    let darkBlue = UIColor(red: 27.0/255.0, green: 61.0/255.0, blue: 109.0/255.0, alpha: 1.0)
    let yellow = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up navigation bar
        //self.navigationController?.navigationBar.barTintColor = darkBlue
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: yellow]
        
        
        UISearchBar.appearance().barTintColor = lightBlue
        UISearchBar.appearance().tintColor = UIColor.white
        if #available(iOS 9.0, *) {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = self.view.tintColor
        } else {
            // Fallback on earlier versions
        }
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.searchBar.showsScopeBar = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Classrooms", "Offices", "Other"]
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredDestinations.count
        }
        return destinations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let destination: Destination
        if searchController.isActive{
            destination = filteredDestinations[indexPath.row]
        } else {
            destination = destinations[indexPath.row]
        }
        cell.textLabel!.text = destination.name
        cell.detailTextLabel!.text = destination.category
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination: Destination
        if searchController.isActive{
            destination = filteredDestinations[indexPath.row]
        } else {
            destination = destinations[indexPath.row]
        }
        print(destination.name)
        UserDefaults.standard.set(destination.lat, forKey: "Lat")
        UserDefaults.standard.set(destination.long, forKey: "Long")
        UserDefaults.standard.set(destination.name, forKey: "Name")
        UserDefaults.standard.synchronize()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDestinations = destinations.filter({( destination : Destination) -> Bool in
            let categoryMatch = (scope == "All") || (destination.category == scope)
            if searchText.isEmpty {
                return categoryMatch
            }
            return categoryMatch && destination.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}

extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
