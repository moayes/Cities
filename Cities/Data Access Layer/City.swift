//
//  City.swift
//  Cities
//
//  Created by Soheil M. Azarpour on 3/25/15.
//  Copyright (c) 2015 Soheil Moayedi Azarpour. All rights reserved.
//

import Foundation

/// Census data.
struct Census {
  
  init(year: Int, population: Int, formattedPopulation: String) {
    self.year = year
    self.population = population
    self.formattedPopulation = formattedPopulation
  }
  
  /// Population of the receiver.
  var population: Int = 0
  
  /// Formatted population.
  var formattedPopulation: String = "0"
  
  /// Estimated population for the year.
  var year: Int = 1900
}

/// City data.
class City {
  
  /// Name of the receiver.
  var name = String()
  
  /// Censuses.
  var censuses: Array<Census> = []
  
}