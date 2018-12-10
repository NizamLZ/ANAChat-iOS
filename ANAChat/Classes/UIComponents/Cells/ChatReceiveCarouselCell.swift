//
//  ChatReceiveCarouselCell.swift
//

import UIKit

class ChatReceiveCarouselCell: UITableViewCell ,ChatCarouselCollectionCellDelegate {

    @IBOutlet weak var collectionview: UICollectionView!
    var messageObject : Carousel!
    var sortedItems : [Any]?
    var delegate: InputCellProtocolDelegate?
    var showOptions : Bool?
    var previousMessageTimeStamp = NSDate()

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib.init(nibName: "ChatCarouselCollectionCell", bundle: CommonUtility.getFrameworkBundle()), forCellWithReuseIdentifier: "ChatCarouselCollectionCell")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func configureView(_ messageObject:Message , showArrow : Bool){
        if let carousel = messageObject as? Carousel{
            self.showOptions = showArrow
            self.messageObject = carousel
            let sortDescriptor = NSSortDescriptor(key: Constants.kIndexKey, ascending: true)
            self.sortedItems = carousel.items?.sortedArray(using: [sortDescriptor])
            self.collectionview.reloadData()
            self.collectionview.scrollRectToVisible(CGRect.zero, animated: false)
        }
        if (self.sortedItems?.count)! > 0 , self.previousMessageTimeStamp != self.messageObject.timestamp{
            self.previousMessageTimeStamp = self.messageObject.timestamp!
            self.collectionview.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        }
    }
    
    func didTappedOnOptionsObject(_ inputDict:[String: Any]){
        self.delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
    }
    
    func didTappedOnOpenUrl(_ url: String) {
        self.delegate?.didTappedOnOpenUrl?(url)
    }
    
    func didTappedOnPlayButton(_ url: String) {
        self.delegate?.didTappedOnPlayButton?(url)
    }
}

extension ChatReceiveCarouselCell:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sortedItems != nil{
            return (self.sortedItems?.count)!
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCarouselCollectionCell", for: indexPath as IndexPath) as! ChatCarouselCollectionCell
        cell.delegate = self
        cell.configureCell(self.sortedItems?[indexPath.row] as! CarouselItem,showOptions: self.showOptions!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if let carousel = self.messageObject{
            if carousel.items != nil{
                var cellHeight = CGFloat()
                var loopIndex = 0
                for (_, element) in (carousel.items?.enumerated())! {
                    var rowHeight = CGFloat()
                    loopIndex = loopIndex + 1
                    if let carouselItem = element as? CarouselItem{
                        if let desc = carouselItem.desc {
                            rowHeight = CommonUtility.carouselDescriptionCellHeight(with: desc)
                        }
                        if carouselItem.options != nil{
                            rowHeight = rowHeight + CGFloat(((carouselItem.options?.count)!*CellHeights.carouselOptionsViewHeight))
                        }
                        if loopIndex == (carousel.items?.count)! {
                            if  carouselItem.mediaUrl != nil && carouselItem.mediaUrl != ""{
                                rowHeight = rowHeight + 160
                                
                            }
                            cellHeight = max(cellHeight, rowHeight)
                        }
                        
                    }
                }
                return  CGSize(width: 280, height: 105 + cellHeight)
            }
        }
        return CGSize(width: 0, height: 0)
    }
}

