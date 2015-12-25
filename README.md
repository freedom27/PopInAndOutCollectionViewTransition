# PopInAndOutCollectionViewTransition
This small framework provide a Pop-in and Pop-out transition animation for UICollectionViews. More specifically when a cell of a collection view is touched to performe a transition the cell begin to enlarge becoming as big as the screen whilst its content fade into the destination view. 

##How to use it
First thing of all you must be sure that the UICollectionViewController managing the collection view you whant to animate conforms to the protocol **CollectionPushAndPoppable**:
```swift
protocol CollectionPushAndPoppable {
    var sourceCell: UICollectionViewCell? { get }
    var collectionView: UICollectionView? { get }
    var view: UIView! { get }
}
```
By definition any UICollectionViewController will for sure implement the view and the collectionView properties... what you have to implement is the **sourceCell** one.
The **sourceCell** property represent the cell of the collection view that should be involved in the animation (so besically is the cell you tapped).

For the proper behaviour of the animation you should set this property with the value of the tapped cell before the transition begins. I recommend to do it in the method:
```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Do your preparations
  sourceCell = sender as? UICollectionViewCell
}
```

Once your Collection view controller conforms to **CollectionPushAndPoppable** and the sourceCell property is properly set before the transition there are only a couple of other things left to do...

Define a navigation controller delegate that will provide the animator for the transition: it can be any class but I usually set the collection view controller as the delagate. In the delegate implement the method reported below to return an instance of **PopInAndOutAnimator**.
```swift
extension CollectionViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopInAndOutAnimator(operation: operation)
    }
}
```
**PopInAndOutAnimator** is the animator class (the class actually performing the animation) and comes with two initializers:
1. init(operation: UINavigationControllerOperation), which set the animation times equals to 0.4 seconds by default
2. init(operation: UINavigationControllerOperation, andDuration duration: NSTimeInterval), which let the dev to decide the duration of the animation

Once the **UINavigationControllerDelegate** method has been implemented the only thing left is to set the defined delegate as the actual **navigationController**'s delegate. This can be done with the followind line inside the viewDidLoad() method of the view controller:
```swift
self.navigationController?.delegate = self
```

Everything is now ready for animating the transitions of the collection view.

##Demo App
The project also include a demo app that shows how to use the animation library
