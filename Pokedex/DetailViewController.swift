//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Robin Somlette on 21-02-2016.
//  Copyright © 2016 Robin Somlette. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bioStackView: UIStackView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
        self.title = pokemon.name.capitalizedString
        let attrs = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "PokemonSolidNormal", size: 20)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        self.mainImage.image = UIImage(named: "\(pokemon.pokedexID)")
        self.idLabel.text = String(pokemon.pokedexID)
        self.currentEvoImage.image = UIImage(named: "\(pokemon.pokedexID)")
        
        self.pokemon.downloadPokemonDetails { () -> () in
            // execute code once data downloaded
            self.updateUI()
            
            self.activityIndicator.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Update UI
    func updateUI() {
        self.typeLabel.text = self.pokemon.type
        self.defenseLabel.text = self.pokemon.defense
        self.heightLabel.text = self.pokemon.height
        self.weightLabel.text = self.pokemon.weight
        self.baseAttackLabel.text = self.pokemon.attack
        self.descriptionLabel.text = self.pokemon.description
        
        if self.pokemon.nextEvolutionID == "" {
            self.evolutionLabel.text = "No Evolutions"
            self.nextEvoImage.hidden = true
        } else {
            nextEvoImage.hidden = false
            nextEvoImage.image = UIImage(named: self.pokemon.nextEvolutionID)
            var str = "Next Evolution: \(self.pokemon.nextEvolutionName)"
            
            if pokemon.nextEvolutionLevel != "" {
                str += " - Lvl \(self.pokemon.nextEvolutionLevel)"
            }
            
            self.evolutionLabel.text = str
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
