//
//  ViewController.swift
//  Pokedex
//
//  Created by Robin Somlette on 21-02-2016.
//  Copyright © 2016 Robin Somlette. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var animateBackgroundView: UIView!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false

    
    @IBOutlet weak var testdaf: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.Done
        
        
        // Configure Navigation Bar Title
//        initiateNavController()
        
        // Add button Navigation Bar
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 32, 32)
        button.setImage(UIImage(named: "music"), forState: .Normal)
        button.addTarget(self, action: "musicButtonPressed:", forControlEvents: .TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
//        barButton.customView = button
        self.navigationItem.rightBarButtonItem = barButton
        
        
//        for name in UIFont.familyNames() {
//            print(name)
//            if let nameString = name as? String
//            {
//                print(UIFont.fontNamesForFamilyName(nameString))
//            }
//        }
        
        initAudio()
        parsePokemonCSV()
        createCoolClouds()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height:  37))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "pokedexlogo")
        imageView.image = image
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.redColor().CGColor
        
        navigationItem.titleView = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK - Music Button
    func musicButtonPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1
        }
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
//            musicPlayer.play()
        } catch {
            print(error)
        }
    }

    //MARK - Utilities
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
//            print(rows)
            for pokemon in rows {
                let pokeId = Int(pokemon["id"]!)!
                let name = pokemon["identifier"]!
                
                let newPokemon = Pokemon(name: name, pokedexID: pokeId)
                self.pokemons.append(newPokemon)
                
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    //Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "showDetailSegue" {
            
//            let indexPath = self.collectionView.indexPathForCell(self) as NSIndexPath
            
            let nav = segue.destinationViewController as! UINavigationController
            
            if let detailVC = nav.viewControllers[0] as? DetailViewController {
            
//            if let detailVC = segue.destinationViewController as? DetailViewController {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
            }
//            self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
    }
    
    func createCoolClouds() {
        var duration: NSTimeInterval!
        for _ in 0...5 {
//      for i in 0...5 {
            let cloud = UIImageView()
            
            // set background color to blue
            cloud.image = UIImage(named: "cloud1")
            
            // set frame (position and size) of the square
            // iOS coordinate system starts at the top left of the screen
            // so this square will be at top left of screen, 50x50pt
            // CG in CGRect stands for Core Graphics
            let size : CGFloat = CGFloat( arc4random_uniform(40)) + 30
            
            // set yPosition to be a random number between 20.0 and 220.0
            let yPosition : CGFloat = CGFloat( arc4random_uniform(150))+20
            let xPos = arc4random_uniform(2)
            
            
            //        cloud.frame = CGRect(x: 0 - 50, y: 120, width: 50, height: 50)
            if xPos == 0 {
                cloud.frame = CGRectMake(0 - size, yPosition, size, size)
            } else {
                cloud.frame = CGRect(x: self.view.bounds.width + size, y: yPosition, width: size, height: size)
            }
            
            cloud.contentMode = .ScaleAspectFit
            
            // finally, add the square to the screen
            self.animateBackgroundView.addSubview(cloud)
            
            duration = NSTimeInterval(arc4random_uniform(30) + 10)
            let delay = 0.0
            //        UIView.animateWithDuration(duration, animations: { () -> Void in
            //            cloud.frame = CGRect(x: self.view.bounds.width + 50, y: 120, width: 50, height: 50)
            //            }) { (finished) -> Void in
            //                cloud.removeFromSuperview()
            //        }
            UIView.animateWithDuration(duration, delay: delay, options: [.CurveLinear, .Autoreverse], animations: { () -> Void in
                //
                if xPos == 0 {
                    cloud.frame = CGRect(x: self.view.bounds.width + size, y: yPosition, width: size, height: size)
                } else {
                    cloud.frame = CGRectMake(0 - size, yPosition, size, size)
                }
                
                }) { (finished) -> Void in
                    //
                    cloud.removeFromSuperview()
            }
            
        }
        let newCloudDuration = NSTimeInterval(arc4random_uniform(30) + 10)
        NSTimer.scheduledTimerWithTimeInterval(newCloudDuration, target: self, selector: #selector(ViewController.createCoolClouds), userInfo: nil, repeats: false)
        
    }
    
    func initiateNavController() {
        self.title = "Pokedex"
        
        let attrs = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "PokemonSolidNormal", size: 24)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
    }
}


//Collection View
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PokeCell
        
        if self.inSearchMode {
            cell.configureCell(filteredPokemons[indexPath.item])
        } else {
            cell.configureCell(pokemons[indexPath.item])
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var poke: Pokemon!
        if self.inSearchMode {
            poke = filteredPokemons[indexPath.item]
        } else {
            poke = pokemons[indexPath.item]
        }
        performSegueWithIdentifier("showDetailSegue", sender: poke)
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.inSearchMode {
            return filteredPokemons.count
        } else {
            return pokemons.count
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
}

// Search Bar
extension ViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.collectionView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemons = pokemons.filter({
                $0.name.rangeOfString(lower) != nil
            })
            self.collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

//SplitView
extension ViewController: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}














