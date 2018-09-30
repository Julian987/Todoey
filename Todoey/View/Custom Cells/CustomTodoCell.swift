import UIKit
import SwipeCellKit

class CustomTodoCell: SwipeTableViewCell {

    
    @IBOutlet weak var cellBackround: UIView!
   
    @IBOutlet weak var cellTextLabel: UILabel!
    
    @IBOutlet weak var chekFieldButton: UIButton!
    
    var indexPath : IndexPath?
    
    var tableView : UITableView?
    
    var todoListViewContoller : TodoListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            
    }
    
    
    
    @IBAction func checkfieldButtonPressed(_ sender: Any) {
        
        if let index = self.indexPath {
            
            if let tableV = self.tableView {
                
                if let todoListVC = self.todoListViewContoller {
                    todoListVC.tableView(tableV, didSelectRowAt: index)
                }
            
            }
            
        }
        
    }
    
}
