## 项目说明
### 一堆没什么用的代码，纯粹浪费时间。。。。

## HOW TO INSTALL

```
# 更新IOS依赖
cd ./IOS/iosComponents
pod install
./build.sh
```

```
# 更新OSX依赖
cd ./OSX/osxComponents
pod install
./build.sh
```

```
# 编译IOS/OSX静态库
./build.sh
```

build 完成后`build/ios`|`build/osx` 为对应静态库

* `./IOS/iosComponents/build/iosFramework.framework`
* `./OSX/osxComponents/build/osxFramework.framework`
* 为对应平台依赖库(可选, 在`build settings`关闭功能块后无依赖, 本人不喜欢使用POD, 因而把POD转化为依赖库管理)

## ETC
### 略懂 IOS/OSX/Linux/Windows, 喜欢被大神糟蹋, 欢迎来虐 `udf.q@qq.com`