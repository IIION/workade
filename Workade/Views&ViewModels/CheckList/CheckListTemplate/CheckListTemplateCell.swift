//
//  CheckListTemplateCell.swift
//  Workade
//
//  Created by 김예훈 on 2022/10/26.
//

import UIKit
import SwiftUI

class CheckListTemplateCell: UICollectionViewCell {
    
    let model: CheckListTemplateModel = CheckListTemplateModel.sample
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        let xmarkImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        blur.isUserInteractionEnabled = false
        blur.clipsToBounds = true
        blur.layer.cornerRadius = 16
        
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .theme.primary
        button.layer.cornerRadius = 16
        button.insertSubview(blur, at: 0)
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        blur.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
        
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: model.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.numberOfLines = 0
        label.font = .customFont(for: .subHeadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedStr = NSMutableAttributedString(string: model.title)
        attributedStr.addAttribute(.foregroundColor, value: model.color, range: (model.title as NSString).range(of: model.partialText))
        label.attributedText = attributedStr
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(plusButton)
        
        self.contentView.backgroundColor = .theme.background
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 32),
            plusButton.heightAnchor.constraint(equalToConstant: 32),
            plusButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            plusButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
        ])
    }
    
    @objc
    private func add() { }
}

struct CheckListTemplateCellRepresentable: UIViewRepresentable {
    typealias UIViewType = CheckListTemplateCell
    
    func makeUIView(context: Context) -> CheckListTemplateCell {
        return CheckListTemplateCell()
    }
    
    func updateUIView(_ uiView: CheckListTemplateCell, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CheckListTemplateCellPreview: PreviewProvider {
    static var previews: some View {
        CheckListTemplateCellRepresentable()
            .ignoresSafeArea()
            .frame(width: 240, height: 140)
            .padding(20)
            .background(.black)
            .previewLayout(.sizeThatFits)
    }
}
