//
//  CitiesManager.swift
//  Cities
//
//  Created by Soheil M. Azarpour on 3/25/15.
//  Copyright (c) 2015 Soheil Moayedi Azarpour
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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