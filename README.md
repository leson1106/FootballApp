## Architecture
MVVM & Combine, separate structure into several layers which is easy to maintain and do test

- **View**: UI part, receive user's interaction and pass it to ViewModel
- **ViewModel**: Center of the entire architecture, navigate actions from View then execute on UseCase / Navigator, also has data binding mechanism with View
- **UseCase**: Execute business logic, requesting API or local database
- **Navigator**: Handle app flow and navigate between scenes

## Technical challenging 
### CoreData
- **Issue**: I am not familiar with core data in sub-module. I was encoutering this issue when loading the object from persistence. Normally, it will load from `Current Product Module`. However, if it's stored in a sub-module, the persistence was confusing to find an NSEntityDescription for those entities (since they were generated with Objective-C category style such as FootballApp+MatchEntity AFAIK). It crashed as a result. 
- **Solution**: I've changed entity module to `Global namespace` then loaded `momd extension` from module itself. I also added name spacing @objc for these entities, to map correctly with entity class name.

### Combine
- **Issue**: I frequently use Rx instead of Combine. This is the very first project I've worked with. When building this app, I ran into trouble when trying to understand the type of Combine's components. It's always nested to another when you apply any operators, such as AnyPublisher with map become AnyPublisher<AnyPublisherMap<AnyPublisher...>. Imagine if there are more operators: combineLatest, concat, etc, and how long the chain will be. I think it is quite complicated for me.
- **Approach**: After a few days dive into it, I don't think there is a solution for this issue cause that's the way Combine framework operates. So, I guess I have to get used to it.

## Third parties
- **Nuke**: Effectively fetching, caching image
- **SnapKit**: Autolayout programmatically

## Showcase GIF
![](https://github.com/leson1106/FootballApp/blob/main/showcase.gif)
