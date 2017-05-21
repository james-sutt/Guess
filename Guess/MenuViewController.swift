//
//  MenuViewController.swift
//  Guess
//
//  Created by Javy on 2017-05-20.
//  Copyright © 2017 supajavy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let movieWords = ["Harry Potter", "Guardian of the Galaxy", "Passenger", "Caption America", "Beauty and the Beast", "Spider-Man", "Batman", "The Fast & Furious", "Deadpool"]
    let songWords = ["Shape of You", "Hello", "Happy", "7 Years", "Closer", "Sugar", "Empire State Of Mind", "Cool Kids"]
    let nationWords = ["Canada 🇨🇦", "Japan 🇯🇵", "Thailand 🇹🇭", "USA 🇺🇸", "Vietnam 🇻🇳", "Malaysia 🇲🇾", "Singapore 🇸🇬", "United Kingdom 🇬🇧", "China 🇨🇳"]

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! GameViewController
        if segue.identifier == "Movies" {
            controller.words = movieWords
        } else if segue.identifier == "Songs" {
            controller.words = songWords
        } else if segue.identifier == "Nations" {
            controller.words = nationWords
        }
    }

}
