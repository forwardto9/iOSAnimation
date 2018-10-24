//
//  MasterViewController.swift
//  AnimationDemo
//
//  Created by uwei on 28/10/2016.
//  Copyright © 2016 Tencent. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String:[String]]]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 1.Geometry Properties
        let geometryProperties = ["geometryProperties":["bounds", "position", "frame", "anchorPoint", "cornerRadius", "transform", "zPosition"]]
        
        // 2.Background Properties：
        let backgroundProperties = ["backgroundProperties":["backgroundColor", "backgroundFilters"]]
        
        // 3.Layer Content 
        let layerContent = ["layerContent":["contents", "contentsGravity", "masksToBounds"]]
        
        // 4.Sublayers Content
        let sublayersContent = ["sublayersContent":[/*"sublayers", "masksToBounds", */"sublayerTransform"]]
        
        // 5.Border Attributes
        let borderAttributes = ["borderAttributes":["borderColor", "borderWidth"]]
        
        // 6.Filters Property
        let filtersProperty = ["filtersProperty":["filter", "compositingFilter"]]
        
        // 7.Shadow Properties
        let shadowProperties = ["shadowProperties":["shadowColor", "shadowOffset", "shadowOpacity", "shadowRadius", "shadowPath"]]
        
        // 8.Opacity Property
        let opacityProperty = ["opacityProperty":["opacity"]]
        
        // 9.Spring
        let springAniamtion = ["springAnimation":["spring"]]
        
        // 10.Dynamic Animator
        let dynamicAnimator = ["dynamicAnimator":["gravity", "collision", "attachment", "snap", "push", "field"]]
        
        // 11.CATransaction, CATransition, UIView.animation
        let otherAnimationMethod = ["Other Animtion Method":["CATransaction", "CATransition", "UIView"]]
        
        // 12. Other Layer Type
        let otherLayerTypes = ["Advanced Layer":["CAReplicatorLayer", "CATransformLayer", "CAEmitterLayer", "CATiledLayer", "CAScrollLayer"]];
        
        
        objects.append(geometryProperties)
        objects.append(backgroundProperties)
        objects.append(layerContent)
        objects.append(sublayersContent)
        objects.append(borderAttributes)
        objects.append(filtersProperty)
        objects.append(shadowProperties)
        objects.append(opacityProperty)
        objects.append(springAniamtion)
        objects.append(dynamicAnimator)
        objects.append(otherAnimationMethod)
        objects.append(otherLayerTypes)
        self.tableView.reloadData()
        
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let datas = objects[indexPath.section].map {$0.1}

                let object = datas[0][indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        print(objects.count)
        return self.objects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let datas = objects[section].map {$0.1}
            let numberOfRows = datas[0].count
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let datas = objects[indexPath.section].map {$0.1}
        cell.textLabel!.text = datas[0][indexPath.row]
        
        return cell
    }

//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

    
    //override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      //  <#code#>
    //}
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objects[section].keys.first
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: - how to delete
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

