## GourmetApp iOS版
### 前提(という名の言い訳)
- 基本とりあえず書きながら勉強する、で書いているので基礎がなっていない部分が多々あります。
- RxSwiftを勉強のために入れているが、iOSでどうRxを使うのか？を深く勉強できてはいないので、使い方が微妙な面があるかも。
- UIの勉強はそれほどしてないので画面の作りおかしい(特に詳細)かも＆時間の都合上、UIの細かい調整はしてないです。

JavaとちょっとだけKotlin触っている人が突貫で書いたコードだと思って、  
暖かい目でみてください。

### アーキテクチャ
MVVM + Clean Architecture  
※ ただし、パッケージ構成やiOSで導入した時の命名が沿ってはいないかも。  
※ DIをどうするか？まで調査しきれなかったのでDIの仕方も微妙・・・。

### 構造


### パッケージ構成
```
GourmetApp
  ┗ Presentation
      ┗ Navigator ： 画面遷移をするsegueの呼び出し
      ┗ ViewController ： 画面のStoryboardとViewController
      ┗ Common ： View層で共通利用するRxの変換関数など
      ┗ View ： CellなどのUI部品のxib, UIクラス
      ┗ ViewModel ： 各画面のViewControllerで利用するViewModel
  ┗ Data
      ┗ DS ： Realmを操作するDao
      ┗ NW ： APIへのアクセスをするManager
      ┗ Repository ： データ操作を行うRepositoryの具象クラス
  ┗ Domain
      ┗ UseCase ： 各画面のユースケース
      ┗ Repository ： UseCaseから呼びだすデータ操作のInterface
      ┗ Models ： データ構造
```

### ライブラリ
```
# Pods for GourmetApp
pod 'SwiftLint'
pod 'RxSwift', '~> 4.0'
pod 'RxCocoa', '~> 4.0'
pod 'R.swift', '~> 4.0.0'
pod 'RealmSwift'
pod 'SDWebImage', '~> 4.0'
pod 'RxDataSources', '~> 3.0'
pod 'MaterialComponents'

target 'GourmetAppTests' do
  inherit! :search_paths
  # Pods for testing
  pod 'RxBlocking', '~> 4.0'
  pod 'RxTest',     '~> 4.0'
  pod 'Mockingjay'
end
```


- SDWebImage
- RealmSwift
- Codable protocol
