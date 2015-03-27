//
//  CitiesManager.swift
//  Cities
//
//  Created by Soheil M. Azarpour on 3/25/15.
//  Copyright (c) 2015 Soheil Moayedi Azarpour. All rights reserved.
//

import Foundation

class CitiesManager {
  
  let cities: Array<City> = {
    
    // Structure of the census data:
    //    "GC_RANK.display-label" = Geography;
    //    "GC_RANK.rank-label" = Rank;
    //    "GC_RANK.target-geo-id" = "Target Geo Id";
    //    "GC_RANK.target-geo-id2" = "Target Geo Id2";
    //    "GEO.display-label" = Geography;
    //    "GEO.id" = Id;
    //    "GEO.id2" = Id2;
    //    resbase42010 = "April 1, 2010 - Estimates Base";
    //    rescensus42010 = "April 1, 2010 - Census";
    //    respop72010 = "Population Estimate (as of July 1) - 2010";
    //    respop72011 = "Population Estimate (as of July 1) - 2011";
    //    respop72012 = "Population Estimate (as of July 1) - 2012";
    //    respop72013 = "Population Estimate (as of July 1) - 2013";
    
    let formatter = NSNumberFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US")
    formatter.maximumFractionDigits = 0
    formatter.usesGroupingSeparator = true
    formatter.groupingSeparator = ","
    formatter.groupingSize = 3
    formatter.nilSymbol = "n/a"
    formatter.zeroSymbol = "None"
    
    let dataURL = NSBundle.mainBundle().URLForResource("CensusData", withExtension: "plist")!
    let citiesData = NSArray(contentsOfURL: dataURL)
    
    var cities: Array<City> = []
    citiesData?.enumerateObjectsUsingBlock({ (cityData: AnyObject!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
      let city = City()
      if cityData is NSDictionary {
        let dictionary = cityData as! NSDictionary
        city.name = dictionary["GC_RANK.display-label"] as! String
        
        var population = dictionary["respop72010"] as! Int
        var formattedPopulation = formatter.stringForObjectValue(population)!
        
        let census10 = Census(year: 2010, population: population, formattedPopulation: formattedPopulation)
        
        population = dictionary["respop72011"] as! Int
        formattedPopulation = formatter.stringForObjectValue(population)!
        let census11 = Census(year: 2011, population: population, formattedPopulation: formattedPopulation)
        
        population = dictionary["respop72012"] as! Int
        formattedPopulation = formatter.stringForObjectValue(population)!
        let census12 = Census(year: 2012, population: population, formattedPopulation: formattedPopulation)
        
        population = dictionary["respop72013"] as! Int
        formattedPopulation = formatter.stringForObjectValue(population)!
        let census13 = Census(year: 2013, population: population, formattedPopulation: formattedPopulation)
        
        city.censuses = [census10, census11, census12, census13]
      }
      cities.append(city)
    })
    
    return cities
    }()
}