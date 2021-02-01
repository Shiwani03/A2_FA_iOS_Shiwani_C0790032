
//
//  Created by Shiwani on 2/1/21.
//

import UIKit
import CoreData

class ProductTV: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayProducts = [Product]()
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
    func addProducts(){
        if arrayProducts.count == 0{
            
            for i in 0...9{
                let provider = Provider(context: context)
                if i < 5 {
                    provider.provider = "Honda"
                }
                else{
                    provider.provider = "Audi"
                }
                
                let product = Product(context: context)
                product.product_desc = "No \(i+1) car in the world"
                product.product_id = "\(i+1)"
                if i < 5 {
                    product.product_name = "H \(i+1)"
                }
                else{
                    product.product_name = "A \(i+1)"
                }
                product.product_price = "\(i+1)0000"
               product.providerToProduct = provider

            }
         
            try! context.save()
            getProducts()
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return arrayProducts.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =
            arrayProducts[indexPath.row].product_name
        cell.detailTextLabel?.text = arrayProducts[indexPath.row].providerToProduct?.provider
        
        return cell
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
