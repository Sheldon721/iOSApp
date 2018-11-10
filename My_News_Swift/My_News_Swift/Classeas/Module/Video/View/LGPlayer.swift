//
//  LGPlayer.swift
//  My_News_Swift
//
//  Created by LG on 2017/11/1.
//  Copyright © 2017年 LG. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

protocol LGPlayerDelegate : NSObjectProtocol {
    func fullDidTouchUpInsise(MP4HdUrl : String ,MP4URL : String, row : Int, PlayingTime : Double, titleName : String ,isfull : Bool)
}

class LGPlayer: UIView {
    
    private var backButton = UIButton()
    
    private var playItem: AVPlayerItem?
    
    private var player: AVPlayer?
    
    private var playLayer: AVPlayerLayer?
    
    private var titleLabel = UILabel()
    
    private var playButton = UIButton()
    
    private var fullbutton = UIButton()
    
    private var link: CADisplayLink?
    
    private var slider = UISlider()
    
    private var sliding = false
    
    private var gotimelabel = UILabel()
    
    private var timeLabel = UILabel()
    
    private var currtenTime :TimeInterval?
    
    private var totalTime : TimeInterval?
    
    private var mpHdURL = String()
    
    private var mdURL = String()
    
    private var titleName = String()
    
    private var row = Int()
    
    private var isJump = Bool()
    
    private var isJumpTime = Double()
    
    var loadingView = GYHCircleLoadingView()
    
    var delegate : LGPlayerDelegate?
    
    var isDelaytheMain = false
    
    var isHiddenView = false
    
    var isFull = false
    
    var goTime = CGFloat()
    
    var overTime = CGFloat()

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = (touches as NSSet).allObjects[0] as! UITouch
        
        let point = touch.preciseLocation(in: self)
        
        self.goTime = point.x
        
        self.isHiddenView = !self.isHiddenView
        print("-------– 是否直接隐藏  全屏",self.isHiddenView, self.isFull)
        
        if self.isHiddenView == false {
            if self.isFull {
                self.backButton.isHidden = true
            }
            self.titleLabel.isHidden = true
            self.gotimelabel.isHidden = true
            self.timeLabel.isHidden = true
            self.slider.isHidden = true
            self.fullbutton.isHidden = true
            self.playButton.isHidden = true
            return
        }
        if self.isFull {
            self.backButton.isHidden = false
        }
        self.playButton.isHidden = false
        titleLabel.isHidden = false
        gotimelabel.isHidden = false
        timeLabel.isHidden = false
        slider.isHidden = false
        fullbutton.isHidden = false
        
        delaytheMain()
    }
    
    
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let touch = (touches as NSSet).allObjects[0] as! UITouch
//
//        let point = touch.preciseLocation(in: self) as! CGPoint
//
//        var cTime : TimeInterval?
//        cTime = CMTimeGetSeconds((player?.currentTime())!)
//        print("点击时当前播放时间 ",formatPlayTime(secounds: cTime!))
//        if point.x - self.goTime <= 10 {
//
//
//            self.playMaskView.isHidden = false
//            cTime = cTime! + Double((point.x - self.goTime))
//
//            guard self.playLayer?.frame.width == Kwidth else {
//
//
//                return
//            }
//
//            self.playMaskView.transform = CGAffineTransform(rotationAngle:CGFloat(Double.pi / 2))
//
//
//
//            print("快进之后的时间 ",formatPlayTime(secounds: cTime!))
//        }
//
//
//        print("快进滑动时",point.x - self.goTime);
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let touch = (touches as NSSet).allObjects[0] as! UITouch
//
//        let point = touch.preciseLocation(in: self) as! CGPoint
//
//        print("结束",point.x - self.goTime);
//    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black

        self.loadingView = GYHCircleLoadingView.init(viewFrame: CGRect.init(x: Kwidth / 2 - 20, y: self.frame.size.height / 2 - 20, width: 40, height: 40))
        self.addSubview(self.loadingView)
    }
    
    
    

    
    // 延迟执行 3秒隐藏subview
    func delaytheMain() {
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute:
            {
                print("延迟执行",self.isDelaytheMain)
                if self.isDelaytheMain {
                    // 在滑动所以不隐藏
                    self.delaytheMain()
                    return
                }
                if self.isFull {
                    self.backButton.isHidden = true
                }
                self.isHiddenView = false
                self.playButton.isHidden = true
                self.titleLabel.isHidden = true
                self.gotimelabel.isHidden = true
                self.timeLabel.isHidden = true
                self.slider.isHidden = true
                self.fullbutton.isHidden = true
        })
    }

    
    // 切换横屏或者正常屏事件
   @objc func fulldidTouchUpInside(sender : UIButton) {
    
        print(self.row)
        currtenTime = CMTimeGetSeconds((player?.currentTime())!)
        guard self.playLayer?.frame.width == Kwidth else {
            // 半屏
            self.delegate?.fullDidTouchUpInsise(MP4HdUrl:self.mpHdURL, MP4URL: self.mdURL, row: self.row, PlayingTime: currtenTime!, titleName: self.titleName ,isfull: false)
            return
        }
     
         // 全屏
         self.delegate?.fullDidTouchUpInsise(MP4HdUrl: self.mpHdURL , MP4URL: self.mdURL, row: self.row, PlayingTime: currtenTime! ,titleName: self.titleName, isfull: true)
    
   
    }
    
    
    
   // play播放事件
   @objc func playDidTouchUpinside(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.player?.pause()
        } else {
            self.player?.play()
        }
    }
    
    // 切换横屏
    func playHD(MP4HdUrl : String ,MP4URL : String , currtenTime : Double , titleName : String) {
        
        self.titleName = titleName
        self.mpHdURL = MP4HdUrl
        self.mdURL = MP4URL
        self.isFull = true
        self.loadingView.stopAnimating()
        self.loadingView = GYHCircleLoadingView.init(viewFrame: CGRect.init(x: Kheight / 2 - 20 , y: Kwidth / 2 - 20, width: 40, height: 40))
        self.insertSubview(self.loadingView, at: 0)
        self.loadingView.startAnimating()

        self.isJumpTime = currtenTime
        self.isJump = currtenTime == 0 ? false : true
        
        setupPlay(url:URL.init(string: MP4HdUrl)!,type:false)
        setupUI()
   
        updateFrame()
        
        titleLabel.textAlignment = .left
        print(titleLabel,gotimelabel)
    }
    
    // 从什么时候开始播放
    func PlaySD(currtenTime : Double) {
        self.isFull = false
        self.isJumpTime = currtenTime
        self.isJump = currtenTime == 0 ? false : true
    }
    
    
    
    
    var model : VideoModel? {
        didSet{
           
            self.mpHdURL = (model?.mp4HD_url)!
            print("------- +++++",self.mpHdURL,model?.mp4HD_url!)
            self.mdURL = (model?.mp4_url)!
            self.titleName = (model?.title)!
            self.insertSubview(self.loadingView, at: 0)
            self.loadingView.startAnimating()
       
            setupPlay(url:URL.init(string: (model?.mp4_url)!)!,type: true)
            setupUI()
            titleLabel.text = model?.title
        }
    }
    
    var indexRow : Int? {
        didSet{
            self.row = indexRow!
        }
    }
    
    
//    lazy var playMaskView : FastPlayerView = {
//
//        let playMaskView = FastPlayerView()
////        playMaskView.backgroundColor = UIColor.white
//        self.addSubview(playMaskView)
//        return playMaskView
//
//
//
//    }()

   
}
//MARK: -- 事件处理

extension LGPlayer {
   
    // Slider 滑动事件
    @objc func sliderTouchDowm(slider:UISlider) {
         sliding = true
         isDelaytheMain = true
        
        if player?.status == AVPlayerStatus.readyToPlay {
            print(slider.value)
            let duration = slider.value * Float(CMTimeGetSeconds((player?.currentItem?.duration)!))
            print("duration",duration)
            let seekTime = CMTime(value: CMTimeValue(duration), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (b) in
                self.isDelaytheMain = false
                self.player?.play()
                
            })
        }
        
    }
    
    // 记录上次播放时间
    func Playingtime(currtenTime : Double) {
        
        if player?.status == AVPlayerStatus.readyToPlay {
            
            let seekTime = CMTime(value: CMTimeValue(currtenTime), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (b) in
                self.player?.play()
            })
        }
        
    }
    
    // 线程更新播放时间
    @objc func update() {
        
        currtenTime = CMTimeGetSeconds((player?.currentTime())!)
        totalTime = TimeInterval((playItem?.duration.value)!) / TimeInterval((playItem?.duration.timescale)!)
        self.timeLabel.text = formatPlayTime(secounds: totalTime!)
        self.gotimelabel.text = formatPlayTime(secounds: currtenTime!)
        
        
        if !sliding {
            slider.value = Float(currtenTime!/totalTime!)
        }
    }
    
    
    // 监听视频播放状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "CMTime" {
            print("缓存进度")
        }else if keyPath == "status" {
            if playItem?.status == .readyToPlay {
                player?.play()
                if isJump {
                    player?.pause()
                    Playingtime(currtenTime: self.isJumpTime)
                    self.loadingView.stopAnimating()
                }
                print("xxx 正常加载")
                self.loadingView.stopAnimating()
                
            }else {
                print("加载异常")
            }
        }
    }
    
    
}

// MARK: - 视图 setupUI
extension LGPlayer {
    
    func setupUI(){
        // 标题
        titleLabel = makeCreateLabel(fontSizes: 15)
        titleLabel.text = titleName
        // 总时间
        timeLabel = makeCreateLabel(fontSizes: 13)
        // 当前时间
        gotimelabel = makeCreateLabel(fontSizes: 13)
        
        playButton = makeCteateButton(imageNamed: "FullPause_60x60_", selectImge: "FullPlay_60x60_")
        
        playButton.addTarget(self, action: #selector(playDidTouchUpinside(sender:)), for: .touchUpInside)
        
        fullbutton = makeCteateButton(imageNamed: "sc_video_play_ns_enter_fs_btn", selectImge: "")
        fullbutton.addTarget(self, action: #selector(fulldidTouchUpInside(sender:)), for: .touchUpInside)
        
        slider = makeCreateSlider()
        
        backButton = makeCteateButton(imageNamed: "leftbackicon_sdk_login_16x16_", selectImge: "leftbackicon_sdk_login_16x16_")
        backButton.layer.cornerRadius = 16
        backButton.layer.masksToBounds = true
        backButton.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        backButton.addTarget(self, action: #selector(fulldidTouchUpInside(sender:)), for: .touchUpInside)
        
        addConstraints()
    }
    
    
    func setupPlay(url: URL , type : Bool) {
        
        playItem = AVPlayerItem.init(url:url)
        
        playItem?.addObserver(self, forKeyPath: "loadTimeRanges", options: .new, context: nil)
        
        playItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        player = AVPlayer.init(playerItem: playItem)
        
        player?.rate = 2
        
        playLayer = AVPlayerLayer(player: player)
        
        playLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        playLayer?.contentsScale = UIScreen.main.scale
        if type {
            playLayer?.frame = CGRect.init(x: 0, y: 0, width: 375, height: 217.5)
        }else{
            playLayer?.frame = CGRect.init(x: 0, y: 0, width: Kheight, height: Kwidth)
        }
        
        self.layer.addSublayer(self.playLayer!)
        
        link = CADisplayLink(target: self, selector: #selector(update))
        
        link?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        
    }
    
    
}

// MARK: - 创建小标签 addConstraints
extension LGPlayer {
    
    func makeCreateSlider()  -> UISlider {
        let sider  = UISlider()
        sider.isHidden = true
        sider.minimumValue = 0
        sider.maximumValue = 1
        sider.value = 0
        sider.maximumTrackTintColor = UIColor.init(white: 1, alpha: 0.5)
        sider.minimumTrackTintColor = UIColor.red
        //albumoriginal_selected_12x12_
        sider.setThumbImage(UIImage(named:"WechatIMG19"), for: .normal)

        sider.addTarget(self, action: #selector(sliderTouchDowm(slider:)), for: .touchDown)
        sider.addTarget(self, action: #selector(sliderTouchDowm(slider:)), for: .touchUpOutside)
        sider.addTarget(self, action: #selector(sliderTouchDowm(slider:)), for: .touchUpInside)
        sider.addTarget(self, action: #selector(sliderTouchDowm(slider:)), for: .touchCancel)
        
        self.addSubview(sider)
        
        return sider
        
    }
    
    func makeCreateLabel(fontSizes : Int) -> UILabel {
        let label = UILabel()
        label.font = fontSize(key: fontSizes)
        label.isHidden = true
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }

    func removePlayer() {
        if (super.superview != nil){
            self.player?.pause()
            self.player?.currentItem?.cancelPendingSeeks()
            self.player?.currentItem?.asset.cancelLoading()
            self.playItem?.removeObserver(self, forKeyPath: "status")
            self.playItem?.removeObserver(self, forKeyPath: "loadTimeRanges")
            NotificationCenter.default.removeObserver(self)
            self.removeFromSuperview()
        }
    }
    
    func makeCteateButton(imageNamed: String , selectImge : String) -> UIButton {
        
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named:imageNamed), for: .normal)
        button.setImage(UIImage(named:selectImge), for: .selected)
        self.addSubview(button)
        return button
    }
    
    func formatPlayTime(secounds : TimeInterval) -> String {
        
        if secounds.isNaN {
            return "00:00"
        }
        let minit = Int(secounds/60)
        let sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d", minit, sec)
    }
    
    func addConstraints() {
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-7)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(20)
        }
        
        gotimelabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(217 - 30)
            make.size.equalTo(CGSize.init(width: 50, height: 20))
        }
        
        fullbutton.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(4)
            make.centerY.equalTo(self.gotimelabel)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(fullbutton.snp_left).offset(10)
            make.size.equalTo(self.gotimelabel)
            make.top.equalTo(self.gotimelabel)
        }
        
        
        slider.snp_makeConstraints { (make) in
            make.left.equalTo(self.gotimelabel.snp_right).offset(10)
            make.centerY.equalTo(self.gotimelabel)
            make.right.equalTo(self.timeLabel.snp_left).offset(-5)
            make.height.equalTo(25)
        }
        
        backButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
//            make.top.equalTo(self).offset(7)
            make.centerY.equalTo(self.titleLabel)
        }
        
        playButton.snp_makeConstraints { (make) in
            
            make.left.equalTo(self).offset(Kwidth / 2 - 30)
            make.top.equalTo(self).offset(217 / 2 - 30)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
//        playMaskView.snp_makeConstraints { (make) in
//            make.top.equalTo(self).offset((217 / 2 - 50))
//            make.size.equalTo(CGSize.init(width: Kwidth / 2, height: 100))
//            make.left.equalTo(self).offset(Kwidth / 2 - (Kwidth / 4))
//        }
        
    }
    
    func updateFrame() {
        
        gotimelabel.snp_updateConstraints { ( make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(Kwidth - 30)
        }
        
        titleLabel.snp_updateConstraints { (make) in
            make.left.equalTo(self).offset(62)
        }
        
        playButton.snp_updateConstraints { (make) in
//            if !Platform.isSimulator {
                make.left.equalTo(self).offset(Kheight / 2 - 30)
                make.top.equalTo(self).offset(Kwidth / 2 - 30)
//            }
        }

//        playMaskView.snp_updateConstraints { (make) in
//            make.top.equalTo(self).offset(Kwidth / 2 - 50)
//   
//            make.left.equalTo(self).offset(Kheight / 2 - (Kwidth / 4))
//        }
//        
        fullbutton.snp_updateConstraints { (make) in
            if !Platform.isSimulator {
                make.right.equalTo(self).offset(Kheight - 375)
             }
        }
    }
}

