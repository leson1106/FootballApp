## Architecture
MVVM & Combine, seperate structure into several layers which is easy to maintain and do test

- **View**: UI part, receive user's interaction and pass it to ViewModel
- **ViewModel**: Center of the entire architecture, navigate actions from View then execute on UseCase / Navigator, also has data binding mechanism with View
- **UseCase**: Execute business logic, requesting API or local database
- **Navigator**: Handle app flow and navigate between scenes

## Technical challenging 

## Third parties
- **Nuke**: Effectively fetching, caching image
- **SnapKit**: Autolayout programmatically
