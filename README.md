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


>由于个人原因，近期不怎么有时间去完善该项目，所以先同步上来，待有空继续去搞定它！

## 目前完成的功能
### 微信界面
1. 显示右上角的菜单
2. 显示最近联系人
3. 最近联系人信息未读数的显示

### 通讯录界面
1. 联系人的排序
2. 联系人总数显示

### 发现界面
1. 动态小红点的显示
2. 购物选项的链接跳转

### 我界面
1. 个人头像的上传与设置，及头像的保存
2. 我的二维码界面的显示及二维码的保存

### 聊天界面
1. 小视频的录制与发送
2. 小视频的播放
3. 聊天时间
4. 图片的发送与显示
5. 未发送成功的重发功能
6. 语音的录制与发送
7. 语音的播放动态效果

## 已知BUG
小视频和图片发送出去后不能立即更新显示缩略图

## 效果图
### 动态图
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/1.gif)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/2.gif)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/3.gif)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/4.gif)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/5.gif)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/6.gif)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/7.gif)

### 静态图
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170206_1.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_1.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_2.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_3.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_4.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_5.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_6.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_7.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_8.png)
![image](https://github.com/LinXunFeng/LXFWeChat/raw/master/Screenshots/Snip20170214_9.png)

