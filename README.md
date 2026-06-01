# iOSApp1 - Tim Hortons Ordering App Prototype

First assignment project for iOS Development.

This repository contains a SwiftUI prototype app for tracking daily Tim Hortons team orders.

## Core Features Implemented

- Add a team member and their Tim Hortons order
- Edit and delete existing orders
- Mark/unmark reusable favorite orders
- Repeat an order quickly from favorites or current list
- Store and display all orders for the day
- View estimated cost per order and run total
- Complete a run and save snapshot history locally
- Coffee run countdown timer (creative variation)

## Source Structure

- `TimHortonsRun/Models`: app data models (`Order`, `TeamOrder`)
- `TimHortonsRun/ViewModels`: app state, timer logic, and run-history flow (`OrderListViewModel`)
- `TimHortonsRun/Views`: SwiftUI UI components
- `TimHortonsRun/Services`: local persistence (`OrderStore`)

## Notes

- The code is intentionally commented around non-obvious logic to support coursework readability.
- This project includes `project.yml`; regenerate project files with `xcodegen generate` if you add new source files.
