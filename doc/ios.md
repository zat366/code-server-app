# 在使用cordova6.0的过程中，编译好的APP运行在IOS7+系统上默认是与状态栏重叠的，而运行在IOS6及老版本中时是于状态栏分离的。
## 解决办法：把文件 platforms/ios/CodeServerApp/Classes/MainViewController.m 中的方法viewWillAppear进行相关修改如下。 作用是更改view的边界，使其下移20px，刚好是状态栏的高度。

```
- (void)viewWillAppear:(BOOL)animated
{
    if([[[UIDevice currentDevice]systemVersion ] floatValue]>=7)
    {
        CGRect viewBounds=[self.webView  bounds];
        viewBounds.origin.y=20;
        viewBounds.size.height=viewBounds.size.height-20;
        self.webView.frame=viewBounds;
    }
    [super viewWillAppear:animated];
}
```


## 保证苹果开发证书正常可用。打开工程之后，如果没有加入苹果ID，则加入，加入后，下载全部证书，随后在工程里面设置“Automatically manage signing”，随后选对“team”。
![xcode-project-sign](./xcode-team-sign.png)
### build.json放置到根目录
```
{
    "ios": {
      "debug": {
        "codeSignIdentity": "iPhone Development",
        "developmentTeam": "teamID",
        "packageType": "development",
        "automaticProvisioning": true,
        "buildFlag": [
          "EMBEDDED_CONTENT_CONTAINS_SWIFT = YES",
          "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO",
          "LD_RUNPATH_SEARCH_PATHS = \"@executable_path/Frameworks\"",
           "-UseModernBuildSystem=0"
      ]
      },
      "release": {
        "codeSignIdentity": "iPhone Development",
        "developmentTeam": "teamID",
        "packageType": "app-store",
        "automaticProvisioning": true,
        "buildFlag": [
          "EMBEDDED_CONTENT_CONTAINS_SWIFT = YES",
          "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO",
          "LD_RUNPATH_SEARCH_PATHS = \"@executable_path/Frameworks\"",
           "-UseModernBuildSystem=0"
      ]
      }
    }
  }
```
## 修改编译选项：把“Build System”修改成“Legacy Build System”。
![xcode-project-sttings](./xcode-project-setting.png)