# OnTopPoke
OnTopPoke is an app that helps users look up the evolution chain of Pokémon.

<img src="https://github.com/lfarah/onTopPoke/assets/6511079/34c84fe5-d986-4d9f-bd56-b1f2e1d99063" width="300" height="300">

| List | Detail |
| --- | --- |
<img src="https://github.com/lfarah/onTopPoke/assets/6511079/b080641c-6746-494e-96a4-0dab33f25f64" width="200" height="400"> | <img src="https://github.com/lfarah/onTopPoke/assets/6511079/ba9acf62-5971-407e-abd5-732f33f45e7c" width="200" height="400">




- [x] List of Pokemon species with name and image
- [x] Detail page with evolution chain
- [x] Pokemon description
- [x] Error handling
- [x] UI Components
- [x] Pagination
- [x] Pull to refresh
- [x] Linter
- [x] Unit tests
- [x] UI Tests

### How to run the app
The external libraries are installed in the project with SPM, so just pressing play should run the project correctly.

### Architecture
This app was made in MVVM. In MVVM, we are able to have a clean ViewController by maintaining it's logic in a ViewModel, which sends streams of information back to the ViewController by completion handlers.' The architecture follows the following Layers:
* Model (```Species```, ```SpeciesDetails```, ```EvolutionChain```)
* View (```DetailsViewController```,```ListViewController```, ```EvolutionInfoView```)
* ViewModel (```DetailsViewModel```,```ListViewModel```)
* Network (```RequestHandler```)

### Dependencies
* [Swiftlint](https://github.com/realm/SwiftLint): tool to enforce Swift style and conventions. Helps devs with small styleguide conventions that are usually forgotten.
* [Alamofire](https://github.com/Alamofire/Alamofire): Networking made easier than using URLSession
* [Kingfisher](https://github.com/onevcat/Kingfisher): Image loading/caching with 1 line of code. It also has placeholder features.

### What would I have done if I had more time?
* Repository Layer: It's job is to know where to fetch information from: Cache or Backend, for example
* Coordinator: it's job is to coordinate VC's presentation.
* Custom Swiftlint rules
* Better Pagination
* Nicer Error handling
* Remove hardcoded values

### Why did I change the project?
The project given wasn't finding simulators for some reason. After a few StackOverflow failed attempts, I decided to create a new project and move all the files to a new one. I don't think I changed much of the organization, besides creating the ViewModels, making the models Codable and creating a tableview extension.
