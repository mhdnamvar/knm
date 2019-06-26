//
//  DeckTableViewController.swift
//  KNM
//
//  Created by Mohammad Namvar on 03/03/2019.
//  Copyright © 2019 Mohammad Namvar. All rights reserved.
//

import UIKit
import CoreData

class DeckTableViewController: UITableViewController {

    let cellId = "cellId"
    let titleFont = UIFont.systemFont(ofSize: 28, weight: .bold)
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateCards))
         navigationItem.rightBarButtonItem?.isEnabled = false
//        updateCards()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLargeTitle()
    }

    func setLargeTitle(){
        self.title = "KNM"
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    @objc func updateCards() -> Void {
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        deleteCards()
        fetchCards()
        activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func deleteCards(){
        let request: NSFetchRequest<FlashCards> = FlashCards.fetchRequest()
        do {
            let cards = try FlashCardsService.context.fetch(request)
            for card in cards {
                FlashCardsService.context.delete(card)
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func fetchCards() {
        guard let endpointUrl = URL(string: "https://flashcards.dev.kalatag.com/cards") else {
            return
        }
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, err in
            guard let data = data else { return }
            do {
                let registerResponse = try JSONDecoder().decode([GetFlashCardResponse].self, from: data)
                for card in registerResponse {
//                    print(card.id, card.name, card.category)
                    let flashCard = FlashCards(context: FlashCardsService.context)
                    flashCard.category = Category.from(text: card.category).rawValue
                    flashCard.question = card.name
                    flashCard.answer = card.description
                    FlashCardsService.saveContext()
                }
            } catch let err {
                print(err)
            }
        }).resume()
    }
    
    func exportCards(){
        //        let filename = getDocumentsDirectory().appendingPathComponent("knm-cards.txt").absoluteString
        //        print(filename)
        
        do {
            let request: NSFetchRequest<FlashCards> = FlashCards.fetchRequest()
            let deck = try FlashCardsService.context.fetch(request)
            
            for (i, card) in deck.enumerated() {
                if let q = card.question, let a = card.answer {
                    print("insert into flashcards_deck values(\(i+1),'\(q)','\(a)',\(card.category+1))")
                }
            }
            
            //            // create file
            //            let file: FileHandle? = FileHandle(forReadingAtPath: filename)
            //            file?.closeFile()
            //
            //            // Write to file
            //            if let fileHandle = FileHandle(forWritingAtPath: filename) {
            //                fileHandle.seekToEndOfFile()
            //                for card in deck {
            //                    if let text = card.question, let data = text.data(using: .utf8) {
            //                        fileHandle.write(data)
            //                    }
            //                    if let text = card.answer, let data = text.data(using: .utf8) {
            //                        fileHandle.write(data)
            //                    }
            //                }
            //                fileHandle.closeFile()
            //            }
            
        } catch let err {
            print(err)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func setupTitle(text: String){
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = UIColor.black
        titleLabel.font = titleFont
        navigationItem.titleView = titleLabel
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        
        switch Int16(indexPath.row) {
        case Category.nederland.rawValue:
            cell.backgroundColor = Category.nederland.getColor()
            cell.textLabel?.text = Category.nederland.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Nederland leren kennen"
            break
        case Category.gezondheid.rawValue:
            cell.backgroundColor = Category.gezondheid.getColor()
            cell.textLabel?.text = Category.gezondheid.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Gezondheid en gezondheidzorg in Nederland"
            break
        case Category.mensen.rawValue:
            cell.backgroundColor = Category.mensen.getColor()
            cell.textLabel?.text = Category.mensen.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "De mensen in Nederland"
            break
        case Category.wonen.rawValue:
            cell.backgroundColor = Category.wonen.getColor()
            cell.textLabel?.text = Category.wonen.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Wonen in Nederland"
            break
        case Category.dienstverlening.rawValue:
            cell.backgroundColor = Category.dienstverlening.getColor()
            cell.textLabel?.text = Category.dienstverlening.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Dienstverlening in Nederland"
            break
        case Category.opvoedingEnOnderwijs.rawValue:
            cell.backgroundColor = Category.opvoedingEnOnderwijs.getColor()
            cell.textLabel?.text = Category.opvoedingEnOnderwijs.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Opvoeding en Onderwijs in Nederland"
            break
        case Category.werken.rawValue:
            cell.backgroundColor = Category.werken.getColor()
            cell.textLabel?.text = Category.werken.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Werken in Nederland"
            break
        case Category.samenLeven.rawValue:
            cell.backgroundColor = Category.samenLeven.getColor()
            cell.textLabel?.text = Category.samenLeven.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Samenleven in Nederland"
            break
        case Category.geschiedenis.rawValue:
            cell.backgroundColor = Category.geschiedenis.getColor()
            cell.textLabel?.text = Category.geschiedenis.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "De geschidenis van Nederland"
            break
        case Category.politiek.rawValue:
            cell.backgroundColor = Category.politiek.getColor()
            cell.textLabel?.text = Category.politiek.getText()
            cell.textLabel?.font = titleFont
            cell.detailTextLabel?.text = "Politiek in Nederland"
            break
        default:
            cell.textLabel?.backgroundColor = .clear
            cell.textLabel?.textColor = .black
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = KnmViewController()
        viewController.category = Category(rawValue: Int16(indexPath.row))
        navigationController?.pushViewController(viewController, animated: true)
//        present(viewController, animated: true, completion: nil)
    }
}
