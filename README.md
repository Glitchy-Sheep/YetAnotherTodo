# Yet Another Todo 📋🚀

Welcome to "Yet Another Todo" app repo!
It's a Flutter app for making a todo list.


## Table of Contents 📝

1. [Features 🏁](#features-)
2. [For devs 💾](#for-devs-)
3. [Screenshots 📷](#screenshots-)
4. [Architecture 📦](#architecture-)
5. [Download 🚀](#download-)

## Features 🏁

The following criteria were met while doing the homework:

### Stage 1 - Ada Lovelace

 - Layout for `view` and `add` screen
 - Logger for debug mode
 - App has its own icon and splash screen
 - App has dismissible swipe to delete and done
   but these are not implemented yet (layout only)
 - The code is written in a way that respects the
   design principles of separation into layers/features

### Stage 2 - Alan Turing
 - App has add/edit/delete/check todo logic through bloc state management
 - App has a local storage (sqlite3 with drift) to store todos
 - Todos are loaded from the local storage and sync with remote server using `RefreshIndicator`
 - App has a dark and light theme based on OS
 - App has internationalization (localization)
 - Basic tests for API and local storage (to be sure everything is working fine)
 - Added shared preferences for further feature development and storage of settings (e.g. completed tasks visibility)

I tried as hard as I could to maintain readability and code consistency (using autoformatter and linter), though it's still not perfect in my opinion, I could make better decomposition, but I'm happy with the result.

## For devs 💾

0. Install Flutter
1. Clone the repo to your local machine
2. Execute `flutter pub get`
3. Rename `config.env.template` to `config.env` and replace the API token/BaseURL with yours
4. Execute `dart run build_runner build` for db/freezed/etc code generation
4.1. Optionally you can run tests before running the app with `flutter test`
5. Execute `flutter run` or start debugging in your IDE

## Screenshots 📷

Here you can see the layout that I was able to do:

<p align="center">
  <img src="screenshots/screenshots.png" width="110%">
</p>

## Architecture 📦

In this section I cover some of the core components of the app. 
So you can see how it's structured.

<p align="center">
  <img src="screenshots/arch_overview.png" width="50%">
</p>


The app has 3 root directories in the project:

**core** - Handy function and helpers which I use across the app.
  - *api* - Has all the API related stuff (interceptors and configuration)
  - *database* - Has all the database related stuff (tables, DAOs, database impl)
  - *uikit* - All the components, styles, colors used in the App
  - *tools* - Some specific tools (logger, uuid, formatters)


**feature** - The directory for all the app's modules and featuress.

  - app - The app entry point module for DI and some other stuff in the future.
  - todo - Main app feature for the todo list.

Each feature usually divided into 3 parts:

- presentation: UI
- domain: Entities and business logic
- data: Data sources and repositories
- bloc: BLoC related files, for state management (I decided to separate bloc and domain in sake of navigation simplicity)


## Download 🚀

<!-- Look, Mom, I centered the div! 😁 -->
<div align="center" style="font-size: 24px;">
    <a href="https://github.com/Glitchy-Sheep/YetAnotherTodo/releases/latest">
        Click here to download the app
    </a>
</div>