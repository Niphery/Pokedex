//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Robin Somlette on 21-02-2016.
//  Copyright © 2016 Robin Somlette. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var bioStackView: UIStackView!
//    @IBOutlet weak var evolutionUIView: UIView!
//    @IBOutlet weak var evosStackView: UIStackView!
    
    
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

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
//    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
//        scrollView.contentSize = CGSize(width: tableView.bounds.width, height: tableView.bounds.height)
        if pokemon == nil {
            pokemon = Pokemon(name: "Bulbasaur", pokedexID: 1)
        }
        
        self.title = pokemon.name.capitalizedString
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Bio Setup
        self.mainImage.image = UIImage(named: "\(pokemon.pokedexID)")
        self.idLabel.text = String(pokemon.pokedexID)
        self.currentEvoImage.image = UIImage(named: "\(pokemon.pokedexID)")
        
        
        self.pokemon.downloadPokemonDetails { () -> () in
            // execute code once data downloaded
            self.updateUI()
            //            print(self.pokemon.moves)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        self.tableView.hidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }
    
    override func viewDidLayoutSubviews() {
//        print(tableView.bounds.width)
//        print(tableView.bounds.height)
//        scrollView.contentSize = CGSize(width: tableView.frame.size.width, height: tableView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentButtonPressed(sender: AnyObject) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            //Hide Moves
            tableView.hidden = true
            
            scrollView.hidden = false
//            bioStackView.hidden = false
//            evolutionUIView.hidden = false
//            evosStackView.hidden = false
        } else {
            //Hide Bio
            tableView.hidden = false
            
            scrollView.hidden = true
//            bioStackView.hidden = true
//            evolutionUIView.hidden = true
//            evosStackView.hidden = true
        }
    }

    //MARK: - Update Bio UI
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


}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MoveCell
        
        let move = pokemon.moves[indexPath.row]
        cell.configureCell(move)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.moves.count
    }
}
