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
  
  let longPress: UILongPressGestureRecognizer = {
    let recognizer = UILongPressGestureRecognizer()
    return recognizer
  }()
  
  let cities: NSMutableArray = {
    let citiesManager = CitiesManager()
    let cities = NSMutableArray()
    cities.addObjectsFromArray(citiesManager.cities)
    return cities
  }()
  
  var selectedYear = CensusYear.Year2010
  
  var sourceIndexPath: NSIndexPath? = nil
  var snapshot: UIView? = nil
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    yearControl?.selectedSegmentIndex = selectedYear.rawValue
    longPress.addTarget(self, action: "longPressGestureRecognized:")
    tableView.addGestureRecognizer(longPress)
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
    let count = cities.count
    return count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CityInformationCellIdentifier") as! UITableViewCell
    
    let city: City = cities[indexPath.row] as! City
    let census = city.censuses[selectedYear.rawValue]
    cell.textLabel?.text = city.name
    cell.detailTextLabel?.text = census.formattedPopulation
    return cell
  }
  
  // MARK: UIGestureRecognizer
  
  func longPressGestureRecognized(gesture: UILongPressGestureRecognizer) {
    let state: UIGestureRecognizerState = gesture.state;
    let location: CGPoint = gesture.locationInView(tableView)
    let indexPath: NSIndexPath? = tableView.indexPathForRowAtPoint(location)
    if indexPath == nil {
      return
    }
    
    switch (state) {
      
    case UIGestureRecognizerState.Began:
      sourceIndexPath = indexPath;
      let cell = tableView.cellForRowAtIndexPath(indexPath!)!
      snapshot = customSnapshotFromView(cell)
      
      var center = cell.center
      snapshot?.center = center
      snapshot?.alpha = 0.0
      tableView.addSubview(snapshot!)
      
      UIView.animateWithDuration(0.25, animations: { () -> Void in
        center.y = location.y
        self.snapshot?.center = center
        self.snapshot?.transform = CGAffineTransformMakeScale(1.05, 1.05)
        self.snapshot?.alpha = 0.98
        cell.alpha = 0.0
      })
      
    case UIGestureRecognizerState.Changed:
      var center: CGPoint = snapshot!.center
      center.y = location.y
      snapshot?.center = center
      
      // Is destination valid and is it different from source?
      if indexPath != sourceIndexPath {
        // ... update data source.
        cities.exchangeObjectAtIndex(indexPath!.row, withObjectAtIndex: sourceIndexPath!.row)
        // ... move the rows.
        tableView.moveRowAtIndexPath(sourceIndexPath!, toIndexPath: indexPath!)
        // ... and update source so it is in sync with UI changes.
        sourceIndexPath = indexPath;
      }
      
    default:
      // Clean up.
      let cell = tableView.cellForRowAtIndexPath(indexPath!)!
      cell.alpha = 0.0
      UIView.animateWithDuration(0.25, animations: { () -> Void in
        self.snapshot?.center = cell.center
        self.snapshot?.transform = CGAffineTransformIdentity
        self.snapshot?.alpha = 0.0
        // Undo fade out.
        cell.alpha = 1.0
        
        }, completion: { (finished) in
          
          self.sourceIndexPath = nil
          self.snapshot?.removeFromSuperview()
          self.snapshot = nil;
      })
      break
    }
  }
  
  // MARK: Helper
  
  func customSnapshotFromView(inputView: UIView) -> UIView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
    inputView.layer.renderInContext(UIGraphicsGetCurrentContext())
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    
    // Create an image view.
    let snapshot = UIImageView(image: image)
    snapshot.layer.masksToBounds = false
    snapshot.layer.cornerRadius = 0.0
    snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
    snapshot.layer.shadowRadius = 5.0
    snapshot.layer.shadowOpacity = 0.4
    
    return snapshot
  }
}