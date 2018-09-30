import UIKit
import SwipeCellKit

class CustomCategoryCell: SwipeTableViewCell {

    
    
    @IBOutlet weak var cellBackround: UIView!
    @IBOutlet weak var cellTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
