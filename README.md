# 앱 스토어 앱 만들기

## 구현

### 1) 구현 기능

- UICollectionView 를 사용하여 화면 개발
  - Storyboard 사용하지 않고 코드로만
  - SnapKit (AutoLayout), KingFisher
- ShareSheet 로 공유하기

### 2) 기본 개념

#### (1) main.storyboard 사용하지 않고 화면그리기 기본

1. main.storyboard 를 채택하고 있는 설정 삭제하기 (info.plist)
2. SceneDelegate func willConnectTo 에서 window property initialize 하기
  2-1. UIWindow(windowScene:)
  2-2. Root view 적용
  2-3. makeKeyAndVisible()

#### (2) UITabBarController

##### Managing the View Controller

- var viewControllers: [UIViewController]?
An array of the root view controllers displayed by the tab bar interface.

##### sub item

- UITabBarItem(title:, image:, tag:)
UITabBarController의 viewControllers.tabBarItem 으로 달아준다.


#### (3) UICollectionView

##### 기본 구성 요소

- header: UICollectionReusableView
- cell: UICollectionViewCell
  - 구성하는 UIView를 property로 가진다
  - private config method를 만들어 기본 설정을 한다 (constraints)
- viewController: UICollectionViewController
  - UICollectionViewDataSource (required)
  - UICollectionViewDelegateFlowLayout

  1. cell register
  2. header register : cell 과는 다른 메서드 사용함 (forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
  3. collectionView.collectionViewLayout 설정
  4. datasource : numberOfItemsInSection, cellForItemAt, viewForSupplementaryElementOfKind 
  5. *UICollectionDelegateFlowLayout*
    .sizeForItemAt
    .referenceSizeForHeaderInSection
    .insetForSectionAt
    .didSelectItemAt

##### private lazy var collectionView

```swift
private lazy var collectionView: UICollectionView = {
  //1. 레이아웃 설정
  let layout = UICollectionViewFlowLayout()
  layout.scrollDirection = .horizontal

  //2. 컬렉션 뷰 객체 생성
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

  //3. 컬렉션 뷰의 딜리게이트 설정
  collectionView.delegate = self
  collectionView.dataSource = self

  //4. 컬렉션 뷰에 커스텀 셀 등록
  collectionView.register(Cell.self, forCellWithReuseIdentifier: "myCell")

  return collectionView
}()

extension test: UICollectionViewDataSource {
  func collectionView(_ collectionView:, numberOfItemsInSection section:)
  func collectionView(_ collectionView:, cellForItemAt indexPath:)
}

extension text: UICollectionViewDelegateFlowLayout {

}
```

#### (4) UINavigationController

1. UITabBarController의 controllers 중 하나인 UINavigaitonController(rootViewController:)
2. root UIViewController 지정하기
3. 기본적으로 UIViewController 는 var *navigationController*, *navigationItem* interface를 가지고 있다. : the nearest ancestor in the view controller hierarchy and the navigation item used to represent the view controller in a parent's navigation bar

#### (5) UIActivityViewController

<https://developer.apple.com/documentation/uikit/uiactivityviewcontroller>

A view Controller that you use to offer standard services from your app, such as copying items to the pasteboard, posting content to social media sites, sending items via email or SMS, and more. 

on iPad, you must present the view controller in a popover. On iPhone and iPod touch, you must present it modally.

```swift
init(activityItems: [Any], applicationActivities: [UIActivity]?)
```

- activityItems : The array of data objects on which to perform the activity. the type of objects in the array is variable and dependent on the data your application manages. Instead of actual data objects, the objects in this array can be objects that adopt the *UIActivityItemSource* protocol, such as UIActivityItemProvider objects.
- applicationActivities : An array of UIActivity objects representing the custom services that your application supports.

```swift

private let shareButton: UIButton = {
  let button = UIButton()
  button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
  return button
}()

extension {
  @objc func didTapShareButton () {
    let activityItems: [Any] = [today.title, today.desc]
    let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    present(activityViewController, animation: true, completion: nil)
  }
}

```

### 3) 새롭게 알게 된 것

#### ViewController 를 객체화하기

1) Storyboard 에서 추출할 때

```swift
let storyboard = UIStoryBoard(name:"Main", bundle: .main)
guard let vc = storyboard.instantiateViewController(identifier:"DetailViewController") as? DetailViewController else { return }
```

2) Storyboard 없이 코드로만 작성할 때

```swift
let root = ViewController()
let rootNavigationController = UINavigationController(rootViewController: root)
```

#### private lazy var

A lazy stored property is a property whose initial value is not calculated until the first time it is used. you must always declare a lazy property as a variable, because its initial value might not be retrieved until after instance initialization completes.

Lazy properties are also usefule when the initial value for a property requires complex or computationally expensive setyp that shoud't be performed unless or until it's needed.

```swift
private lazy var todayViewController: UIViewController = {
  let viewController = UIViewController()
  return viewController
}()
```

처음 사용할 때 메모리에 값을 올리고 그 이후 부터는 계속해서 메모리에 올린 값을 사용한다
(따라서 때마다 연산을 하는 computed property 에는 lazy var 사용할 수 없다)
lazy var 에 특별한 연산을 통해 값을 넣어주기 위해서는 closure 를 사용한다
class 나 struct 의 다른 프로퍼티의 값을 lazy 변수에서 사용하기 위해서는 closure 내부에서 self를 통해 접근한다
(원래 메모리 누수 문제로 closure 에서 클래스 객체를 self 로 참조하지 않으나 () 즉시 실행 하고 끝나기 때문에 메모리 누수의 걱정은 없다)

<https://docs.swift.org/swift-book/LanguageGuide/Properties.html>
<https://abhimuralidharan.medium.com/lazy-var-in-ios-swift-96c75cb8a13a>
<https://www.hackingwithswift.com/example-code/language/what-are-lazy-variables>


#### Decode

- json decode

(1) response

```swift
guard let url = URL(string:) else { return }
var request = URLRequest(url: url)
request.httpMethod = "GET"

let dataTask = URLSession.shared.dataTask(with: request) {
  [weak self] data, response, error in 
  guard error == nil,
        let self = self,
        let response = response as? HTTPURLResponse,
        let data = data,
        let datalist = try? JSONDecoder().decode(T.self, from data) else { return }
}
```

(2) file

```swift
guard let file = Bundle.main.url(forResource: filename, withExtension: nil),
      let data = try? Data(contentsOf: file) else { return }
let decoder = JsonDecoder()
let result = try? decoder.decode(T.self, from data)
```

- property list decode

```swift
guard let path = Bundle.main.path(forResource: "filename", ofType: "plist"),
      let file = FileManager.default.contents(atPath: path),
      let data = try? PropertyListDecoder().decode([Object].self, from:file) else { return }
```

*Bundle.main*

#### layoutSubviews 의 호출 시점은 언제일까?
<https://soulpark.wordpress.com/tag/layoutsubviews-%ED%98%B8%EC%B6%9C%EC%8B%9C%EC%A0%90/>

add subview within layoutsubviews is not a great idea, 
<https://stackoverflow.com/questions/34301366/call-addsubview-within-layoutsubviews>
*layoutSubviews* is meant for laying out subviews, not creating them, and it can be called at more or less any time for a whole host of reasons. 
Create subviews in your initializer, or lazily as you need them elsewhere,
and keep your layoutSubviews as light as possible

#### UIImageView 의 다양한 속성들

- contentMode = .scaleAspectFill
- clipsToBounds = bool
- layer.corderRadius
- backgroundColor

#### Crash Message

> uicollectionview must be initialized with a non-nil layout parameter
나는 강의 자료와는 달리, TodayViewController 를 UICollectionViewController 로 만들었기 때문에 
보통의 그냥 UIViewController 에서 UIcollectionView를 생성하여, (layout과 함께) addSubview 하는 과정을 생략했으므로, TabBarController에서 TodayViewController 를 initialize 할 때, collectionViewLayout 을 parameter 로 넘겨야 했다. (layout이 없이 만들면 무조건 crash)

<https://developer.apple.com/documentation/uikit/uicollectionviewcontroller>

```swift
private lazy var todayViewController: UIViewController = {
        let layout = UICollectionViewFlowLayout()
        //수정 전
        let viewController = TodayViewController() => 에러 발생
        // 수정 후
        let viewController = TodayViewController(collectionViewLayout: layout)
        let tabBarItem = UITabBarItem(
            title: "today",
            image: UIImage(systemName: "mail"),
            tag: 0)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
```

#### view.safeAreaLayoutGuide

The layout guide representing the portion of your view that is unobscured by bars and other content. when the view is visible onscreen, this guide reflects the portion of the view that is not covered by navigation bars, tab bars, toolbars, and other ancestor views. 
<https://developer.apple.com/documentation/uikit/uiview/2891102-safearealayoutguide>

#### add arranged subview vs add subview

arrangedSubviews which is the list of views arranged *by the stack view*
the stack view ensures that the arrangedSubviews array is always a subset of its subviews arrray. Therefore, whenever the addArrangedSubview method is called, the stack view adds the view as a subview, if it is not already.
<https://developer.apple.com/documentation/uikit/uistackview/1616232-arrangedsubviews>

