# ToDoListApp Project - README (Phase 1)

##NOTE

When installing the project, you may encounter an error indicating that ToDoListData.xcdatamodeld is missing, causing the file to appear in red. To resolve this, remove the reference to this file from the project. Next, navigate to the "Core Data" folder in the project navigator, right-click, and select "Add Files to ToDoListApp" Locate and add the ToDoListData.xcdatamodeld file. Once added, you should be able to run the project successfully.

![Screenshot 2024-07-17 at 10 19 45](https://github.com/user-attachments/assets/4b306564-acaa-4087-a245-eef5c694b9da)
![Screenshot 2024-07-17 at 10 19 25](https://github.com/user-attachments/assets/1623baa7-4719-46e6-b9fe-df0731686bb8)

## Overview

ToDoListApp is an iOS application designed to manage daily tasks. The application comprises several view controllers, utility classes, and extensions to enhance user experience and manage tasks efficiently. This README provides a detailed explanation of the project structure and functionality.

## Splash Screen

**SplashVC** is the initial view controller that displays a splash screen with a "Get Started" button. When the button is pressed, the app navigates to the ToDoListVC, where the user can view and manage their tasks.

## Task List Management

**ToDoListVC** is the primary view controller for displaying and managing the to-do list. It supports two display types: the task list and a form to add new tasks. The tasks are displayed in a table view, which updates dynamically based on user interactions.

## Data Handling

**DBHelperModel** is a singleton class responsible for all database operations, including fetching, inserting, updating, and deleting tasks. It uses Core Data for persistent storage and manages a container named `ToDoListData` for storing task information.

## Extensions and Utilities

Several extensions and utility methods enhance the app's functionality:

1. **UIViewController Extensions**: These include methods for setting navigation bar titles, hiding the keyboard when tapped around, and enabling multiline titles for better display.
   
2. **Date Extension**: This provides a method to format the current date as a string, which is used for displaying the current date in the app.

3. **UINavigationItem Extension**: Enables multiline titles in the navigation bar.

4. **UIView Extensions**: These include properties and methods for setting corner radius, border width, border color, and shadow attributes to UIViews.

5. **UILabel Extension**: Adds a method to set strikethrough text, used to visually indicate completed tasks.

## User Interface Components

The app utilizes several UI components, including:

1. **UITableView**: Displays the list of tasks and the form for adding new tasks.
2. **UITableViewCells**: Custom cells are used to display task details and input fields for new tasks.
3. **UIButton**: Used for adding new tasks and navigating between views.

## Navigation

The app uses a navigation controller to manage the flow between different view controllers. The navigation bar is customized to display large titles and multiline titles where necessary.

## Task Operations

Users can perform various operations on tasks:

1. **Add New Task**: Users can add a new task using the input form displayed by pressing the "Add" button.
2. **Mark Task as Complete**: Tasks can be marked as complete by selecting the checkmark button next to each task.
3. **Delete Task**: Swipe-to-delete functionality allows users to delete tasks from the list.

## Error Handling

The app includes basic error handling for database operations, ensuring that any errors encountered during data fetching, insertion, updating, or deletion are logged and handled appropriately.

## Core Data Management

The **DBHelperModel** class handles all interactions with Core Data, including setting up the persistent container, fetching data, inserting new records, updating existing records, and deleting records. The entity used for storing task information is `ModelToDoList`.
