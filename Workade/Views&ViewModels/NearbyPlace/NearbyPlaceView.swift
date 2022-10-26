//
//  NearbyPlaceView.swift
//  Workade
//
//  Created by ryu hyunsun on 2022/10/21.
//

import UIKit

class NearbyPlaceView: UIView {
    private var introduceBottomConstraints: NSLayoutConstraint!
    private var galleryBottomConstraints: NSLayoutConstraint!
    
    let topSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentsContainer: UIView = {
        let contentsContainer = UIView()
        contentsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return contentsContainer
    }()
    
    let placeImageContainer: UIView = {
        let placeImageContainer = UIView()
        placeImageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return placeImageContainer
    }()
    
    let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.gray
        imageView.image = UIImage(named: "officeImage_test")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "제주도"
        locationLabel.font = UIFont.customFont(for: .title3)
        locationLabel.textColor = .white
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return locationLabel
    }()
    
    let placeLabel: UILabel = {
        let placeLabel = UILabel()
        placeLabel.text = "O-Peace"
        // TODO: AccentTitle1 폰트와 background_Light 컬러가 없습니다. 추후 변경할 예정입니다.
        placeLabel.font = UIFont.customFont(for: .title1)
        placeLabel.textColor = .white
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return placeLabel
    }()
    
    // TODO: 머지 이후 치콩이 작성한 dismissButton으로 수정 예정입니다.
    let dismissButton: UIButton = {
        let dismissButton = UIButton()
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22, weight: .semibold))
        var image = UIImage(systemName: "xmark", withConfiguration: configuration)
        image = image?.withTintColor(.red)
        dismissButton.setImage(image, for: .normal)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        return dismissButton
    }()
    
    lazy var mapButton: UIButton = {
        let mapButton = UIButton()
        let blur = UIVisualEffectView(effect:
                                        UIBlurEffect(style: UIBlurEffect.Style.light))
        mapButton.frame.size = CGSize(width: 48, height: 48)
        mapButton.layer.cornerRadius = mapButton.bounds.height / 2
        
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .semibold))
        var image = UIImage(systemName: "map", withConfiguration: configuration)
        image = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        mapButton.setImage(image, for: .normal)
        
        blur.frame = mapButton.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = 0.5 * mapButton.bounds.size.height
        blur.clipsToBounds = true
        mapButton.insertSubview(blur, belowSubview: mapButton.imageView!)
        
        return mapButton
    }()
    
    let mapButtonContainer: UIView = {
        let mapButtonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        mapButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return mapButtonContainer
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = CustomSegmentedControl(items: ["소개", "갤러리"])
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.theme.quaternary,
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.theme.primary,
            NSAttributedString.Key.font: UIFont.customFont(for: .headline)],
                                                for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(indexChanged(_ :)), for: UIControl.Event.valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let segmentUnderLine: UIView = {
        let segmentUnderLine = UIView()
        segmentUnderLine.backgroundColor = UIColor.theme.quaternary
        segmentUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentUnderLine
    }()
    
    let detailScrollView: UIScrollView = {
        let detailScrollView = UIScrollView()
        detailScrollView.alwaysBounceVertical = true
        detailScrollView.isScrollEnabled = false
        detailScrollView.showsVerticalScrollIndicator = false
        detailScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return detailScrollView
    }()
    
    let detailContensContainer: UIView = {
        let detailContensContainer = UIView()
        detailContensContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return detailContensContainer
    }()
    
    private let introduceView: IntroduceView = {
        let view = IntroduceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let galleryView: TempGalleryView = {
        let view = TempGalleryView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 스크롤 뷰의 영역을 컨텐츠 크기에 따라 dynamic하게 변경하기 위한 설정
        introduceBottomConstraints = introduceView.bottomAnchor.constraint(equalTo: detailContensContainer.bottomAnchor, constant: -20)
        galleryBottomConstraints = galleryView.bottomAnchor.constraint(equalTo: detailContensContainer.bottomAnchor, constant: -20)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        setupScrollViewLayout()
        setupPlaceInfoLayout()
        setupSegmentedControl()
        setupNearbyPlaceDetailLayout()
    }
    
    private func setupScrollViewLayout() {
        addSubview(scrollView)
        addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: topSafeArea + 8),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            dismissButton.widthAnchor.constraint(equalToConstant: 44),
            dismissButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let scrollViewGuide = scrollView.contentLayoutGuide
        scrollView.addSubview(contentsContainer)
        NSLayoutConstraint.activate([
            contentsContainer.topAnchor.constraint(equalTo: scrollViewGuide.topAnchor),
            contentsContainer.bottomAnchor.constraint(equalTo: scrollViewGuide.bottomAnchor),
            contentsContainer.leadingAnchor.constraint(equalTo: scrollViewGuide.leadingAnchor),
            contentsContainer.trailingAnchor.constraint(equalTo: scrollViewGuide.trailingAnchor),
            contentsContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        contentsContainer.addSubview(placeImageContainer)
        NSLayoutConstraint.activate([
            placeImageContainer.topAnchor.constraint(equalTo: contentsContainer.topAnchor),
            placeImageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeImageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeImageContainer.heightAnchor.constraint(equalToConstant: topSafeArea + 375)
        ])
        
        let placeImageViewTopConstraint = placeImageView.topAnchor.constraint(equalTo: topAnchor)
        // layout이 깨지는 것을 방지하기 위한 우선순위 설정
        placeImageViewTopConstraint.priority = .defaultHigh
        contentsContainer.addSubview(placeImageView)
        NSLayoutConstraint.activate([
            placeImageViewTopConstraint,
            placeImageView.bottomAnchor.constraint(equalTo: placeImageContainer.bottomAnchor),
            placeImageView.leadingAnchor.constraint(equalTo: placeImageContainer.leadingAnchor),
            placeImageView.trailingAnchor.constraint(equalTo: placeImageContainer.trailingAnchor),
            // heightAnchor 설정을 통해, 세로가 긴 이미지가 들어올때 이미지 영역 깨지는걸 방지.
            placeImageView.heightAnchor.constraint(greaterThanOrEqualTo: placeImageContainer.heightAnchor)
        ])
    }
    
    private func setupSegmentedControl() {
        contentsContainer.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: placeImageContainer.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        contentsContainer.addSubview(segmentUnderLine)
        NSLayoutConstraint.activate([
            segmentUnderLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            segmentUnderLine.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            segmentUnderLine.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
            segmentUnderLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupPlaceInfoLayout() {
        
        contentsContainer.addSubview(placeLabel)
        NSLayoutConstraint.activate([
            placeLabel.bottomAnchor.constraint(equalTo: placeImageContainer.bottomAnchor, constant: -20),
            placeLabel.leadingAnchor.constraint(equalTo: placeImageContainer.leadingAnchor, constant: 20)
        ])
        
        contentsContainer.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.bottomAnchor.constraint(equalTo: placeLabel.topAnchor, constant: -5),
            locationLabel.leadingAnchor.constraint(equalTo: placeImageContainer.leadingAnchor, constant: 20)
        ])
        
        contentsContainer.addSubview(mapButtonContainer)
        NSLayoutConstraint.activate([
            mapButtonContainer.trailingAnchor.constraint(equalTo: placeImageContainer.trailingAnchor, constant: -17),
            mapButtonContainer.bottomAnchor.constraint(equalTo: placeImageContainer.bottomAnchor, constant: -17)
        ])
        
        mapButtonContainer.addSubview(mapButton)
        NSLayoutConstraint.activate([
            mapButton.centerXAnchor.constraint(equalTo: mapButtonContainer.centerXAnchor),
            mapButton.centerYAnchor.constraint(equalTo: mapButtonContainer.centerYAnchor)
        ])
    }
    
    private func setupNearbyPlaceDetailLayout() {
        contentsContainer.addSubview(detailScrollView)
        detailScrollView.addSubview(detailContensContainer)
        NSLayoutConstraint.activate([
            detailScrollView.topAnchor.constraint(equalTo: segmentUnderLine.bottomAnchor),
            detailScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentsContainer.bottomAnchor.constraint(equalTo: detailContensContainer.bottomAnchor, constant: 375)
        ])
        
        let detailScrollViewGuide = detailScrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            detailContensContainer.topAnchor.constraint(equalTo: detailScrollViewGuide.topAnchor),
            detailContensContainer.bottomAnchor.constraint(equalTo: detailScrollViewGuide.bottomAnchor),
            detailContensContainer.leadingAnchor.constraint(equalTo: detailScrollViewGuide.leadingAnchor),
            detailContensContainer.trailingAnchor.constraint(equalTo: detailScrollViewGuide.trailingAnchor),
            detailContensContainer.widthAnchor.constraint(equalTo: detailScrollView.widthAnchor)
        ])
        
        detailContensContainer.addSubview(introduceView)
        NSLayoutConstraint.activate([
            introduceView.topAnchor.constraint(equalTo: detailContensContainer.topAnchor, constant: 20),
            introduceView.leadingAnchor.constraint(equalTo: detailContensContainer.leadingAnchor, constant: 20),
            introduceView.trailingAnchor.constraint(equalTo: detailContensContainer.trailingAnchor, constant: -20),
            introduceBottomConstraints
        ])
        
        detailContensContainer.addSubview(galleryView)
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: detailContensContainer.topAnchor, constant: 20),
            galleryView.leadingAnchor.constraint(equalTo: detailContensContainer.leadingAnchor, constant: 20),
            galleryView.trailingAnchor.constraint(equalTo: detailContensContainer.trailingAnchor, constant: -20)
        ])
    }
}

extension NearbyPlaceView {
    @objc
    private func indexChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            detailScrollView.isScrollEnabled = true
            detailScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            scrollView.isScrollEnabled = true
            introduceView.isHidden = false
            galleryView.isHidden = true
            galleryBottomConstraints.isActive = false
            introduceBottomConstraints.isActive = true
        case 1:
            // 갤러리 누르면 세그먼트 위치로 스크롤 이동.
            detailScrollView.isScrollEnabled = true
            detailScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            // 전체 뷰의 스크롤은 멈춰야함.
            scrollView.isScrollEnabled = false
            // 전체뷰의 스크롤 위치를 이미지가 끝나는 지점으로 맞춰줘야함
            scrollView.setContentOffset(CGPoint(x: 0, y: 315), animated: false)
            introduceView.isHidden = true
            galleryView.isHidden = false
            introduceBottomConstraints.isActive = false
            galleryBottomConstraints.isActive = true
        default:
            break
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}