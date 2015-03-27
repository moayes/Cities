//
//  CitiesTableViewController.swift
//  Cities
//
//  Created by Soheil M. Azarpour on 3/25/15.
//  Copyright (c) 2015 Soheil Moayedi Azarpour. All rights reserved.
//

import UIKit

enum CensusYear: Int {
  case Year2010 = 0
  case Year2011 = 1
  case Year2012 = 2
  case Year2013 = 3
}

class CitiesTableViewController: UITableViewController {
  
  @IBOutlet var yearControl: UISegmentedControl?
  
  let citiesManager = CitiesManager()
  var selectedYear = CensusYear.Year2010
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    yearControl?.selectedSegmentIndex = selectedYear.rawValue
    super.viewDidLoad()
  }
  
  // MARK: IBActions
  
  @IBAction func unwindAttributionsController(segue: UIStoryboardSegue) {
  }
  
  @IBAction func yearControlValueDidChange(sender: UISegmentedControl) {
    selectedYear = CensusYear(rawValue: sender.selectedSegmentIndex)!
    tableView.reloadData()
  }
  
  // MARK: UITableViewDelegate and UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = citiesManager.cities.count
    return count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CityInformationCellIdentifier") as! UITableViewCell
    
    let city: City = citiesManager.cities[indexPath.row]
    let census = city.censuses[selectedYear.rawValue]
    cell.textLabel?.text = city.name
    cell.detailTextLabel?.text = census.formattedPopulation
    return cell
  }
}