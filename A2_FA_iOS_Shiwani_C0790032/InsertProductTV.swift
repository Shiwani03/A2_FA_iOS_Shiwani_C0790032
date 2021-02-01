
//  Created by Shiwani on 01/02/21.
//

import UIKit
import CoreData
class InsertProductTV: UITableViewController {
    let context =
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var product_name: UITextField!
    @IBOutlet weak var product_desc: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var txtProviderName: UITextField!
    var selectedProduct : Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pro = selectedProduct{
            id.text = pro.product_id
            product_name.text = pro.product_name
            product_desc.text = pro.product_desc
            price.text = pro.product_price
            txtProviderName.text = pro.product_name
        }

    }

    @IBAction func save(_ sender: Any) {
        let req : NSFetchRequest<Provider> = Provider.fetchRequest()
        req.predicate = NSPredicate(format: "provider = '\(txtProviderName.text!)'")
        let storeProvider = try! context.fetch(req)
        var provider : Provider!
        if storeProvider.count == 0{
             provider = Provider(context: context)
             provider.provider = txtProviderName.text
        }
        else{
             provider = storeProvider[0]
        }
        if let pro = selectedProduct{
            pro.product_desc = product_desc.text
            pro.product_id = id.text
            pro.product_name = product_name.text
            pro.product_price = price.text
            pro.providerToProduct = provider
        }
        else{
            let product = Product(context: context)
            product.product_desc = product_desc.text
            product.product_id = id.text
            product.product_name = product_name.text
            product.product_price = price.text
            product.providerToProduct = provider
        }
        try! context.save()
        id.text = nil
        product_desc.text = nil
        product_name.text = nil
        price.text = nil
        txtProviderName.text = nil
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


}
