//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Артем Сергеев on 06.09.2022.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    private var raitingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44, height: 44) {
        didSet {
            setUpButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setUpButtons()
        }
    }
    
    var raiting = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    //MARK: Actions
    
    @objc private func raitingButtonTapped(button: UIButton) {
        
        guard let index = raitingButtons.firstIndex(of: button) else { return }
        
        // Calculate the raiting of the selected button
        let selectedRiting = index + 1
        
        if selectedRiting == raiting {
            raiting = 0
        } else {
            raiting = selectedRiting
        }
    }
    
    //MARK: Private methods
    private func setUpButtons() {
        
        for button in raitingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        raitingButtons.removeAll()
        
        // Load button image
        let bundle = Bundle(for: type(of: self))
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundle,
                                      compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            // Create button
            let button = UIButton()
            
            // Set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constrains for button
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Set up button action
            button.addTarget(self, action: #selector(raitingButtonTapped(button:) ), for: .touchUpInside)
            
            //Add button on stack
            addArrangedSubview(button)
            
            // Add the new button on the raiting button array
            raitingButtons.append(button)
        }
        
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in raitingButtons.enumerated() {
            button.isSelected = index < raiting
        }
    }
    
}
