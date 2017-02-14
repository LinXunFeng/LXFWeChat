# LXFWeChat
Swift 3.0 高仿微信

## 模仿微信的导航栏
在navigationBar底部添加一个添加了渐变层的view
```swift
let blurBackView = UIView()
blurBackView.frame = CGRect(x: 0, y: -20, width: kScreenW, height: 64)
let gradintLayer = CAGradientLayer()
gradintLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 64)
gradintLayer.colors = [
    UIColor.hexInt(0x040012).withAlphaComponent(0.76).cgColor,
    UIColor.hexInt(0x040012).withAlphaComponent(0.28).cgColor
]
gradintLayer.startPoint = CGPoint(x: 0, y: 0)
gradintLayer.endPoint = CGPoint(x: 0, y: 1.0)
blurBackView.layer.addSublayer(gradintLayer)
blurBackView.isUserInteractionEnabled = false
blurBackView.alpha = 0.5

// 设置导航栏样式
navigationBar.barStyle = .black
navigationBar.insertSubview(blurBackView, at: 0)
```

## 表情面板和更多面板
遇到的问题总结了一下，可以参考下以下总结的文章

[《iOS - Swift UICollectionView横向分页滚动，cell左右排版》](http://www.jianshu.com/p/18d7d0f5e3e2)

[《iOS - Swift UICollectionView横向分页的问题》](http://www.jianshu.com/p/60da3b52d64c)

## 聊天界面
[《iOS - Swift 仿微信聊天图片显示》](http://www.jianshu.com/p/4c570cd79bd3)

[《iOS - Swift UITableView的scrollToRow的"坑"》](http://www.jianshu.com/p/aa139463eb4b)

[《iOS - Swift UIButton中ImageView的animationImages动画执行完毕后，图标变暗》](http://www.jianshu.com/p/412a2e23b5b6)


## 首页
[《iOS - Swift 仿微信小红点(无数字)》](http://www.jianshu.com/p/807cddad469a)
