

//  Created by Shiwani on 2/2/21.
//

import UIKit
import CoreData

class ProductTV: UITableViewController {
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayProducts = [Product]()
    var arrayProvider : [Provider] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getProducts()
        addProducts()
        tableView.reloadData()
        
    }
    func getProducts(){
        arrayProducts.removeAll()
        arrayProducts = try! context.fetch(Product.fetchRequest())
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        change(self)
    }

    func addProducts(){
        if arrayProducts.count == 0{
            let provider = Provider(context: context)
            provider.provider = "Honda"
            let provider2 = Provider(context: context)
            provider2.provider = "Audi"
            for i in 0...9{
                
                if i < 5 {
                    
                   
                    
                    let product = Product(context: context)
                    product.product_desc = "No \(i+1) car in the world"
                    product.product_id = "\(i+1)"
                    product.product_name = "H \(i+1)"
                    product.product_price = "\(i+1)0000"
                   product.providerToProduct = provider
                }
                else{
                    try! context.save()
                    let product = Product(context: context)
                    product.product_desc = "No \(i+1) car in the world"
                    product.product_name = "A \(i+1)"
                    product.product_id = "\(i+1)"
                    product.product_price = "\(i+1)0000"
                   product.providerToProduct = provider2
                }
                

            }
         
            try! context.save()
            getProducts()
        }
    }
    @IBAction func change(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            getProducts()
            searchBar.isHidden = false
        }
        else{
            getProvider()
            searchBar.isHidden = true
        }
    }
    @IBAction func add(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: self)
        }
        else{
            performSegue(withIdentifier: "addProvider", sender: self)
        }
    }
    func getProvider(){
        arrayProvider.removeAll()
        arrayProvider = try! context.fetch(Provider.fetchRequest())
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? String{
            if segment.selectedSegmentIndex == 0{
                let vc = segue.destination as! InsertProductTV
                vc.selectedProduct = arrayProducts[tableView.indexPathForSelectedRow!.row]
            }
            else{
                let vc = segue.destination as! GetProductsTVController
                vc.selectedProvider = arrayProvider[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if segment.selectedSegmentIndex == 0{
            return arrayProducts.count
        }
        else{
            return arrayProvider.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if segment.selectedSegmentIndex == 0{
            cell.textLabel?.text =
                arrayProducts[indexPath.row].product_name
            cell.detailTextLabel?.text = arrayProducts[indexPath.row].providerToProduct?.provider
        }
        else{
            cell.textLabel?.text =
                arrayProvider[indexPath.row].provider
            let req : NSFetchRequest<Product> = Product.fetchRequest()
            //req.predicate =  NSPredicate(format: "provider = '\(provider[indexPath.row].provider!)'")
            let productz = try! context.fetch(req)
            var count = 0
            for pro in productz{
                if pro.providerToProduct?.provider == arrayProvider[indexPath.row].provider{
                    count = count + 1
                }
            }
            cell.detailTextLabel?.text = count.description
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: "me")
        }
        else{
            performSegue(withIdentifier: "getProduct", sender: "me")
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if segment.selectedSegmentIndex == 0{
                let pro = arrayProducts[indexPath.row]
                context.delete(pro)
            }
            else{
                for prod in arrayProducts{
                    if prod.providerToProduct == arrayProvider[indexPath.row]{
                        context.delete(prod)
                    }
                }
                let pro = arrayProvider[indexPath.row]
                context.delete(pro)
                
            }
            try! context.save()
            change(self)
            
        }
    }
}
extension ProductTV : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "product_name contains[c] '\(searchText)' || product_desc contains[c] '\(searchText)'")
            let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                arrayProducts = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        else{
            getProducts()
            
        }
        tableView.reloadData()
    }
}
